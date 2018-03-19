package provide addAtom 1.0

proc molUP::pickAtomsToDelete {args} {
	# Get informations about the picked atom
	set index $::vmd_pick_atom
	set selection [atomselect top "index $index"]
	set name [$selection get name]
	set resname [$selection get resname]
	set resid [$selection get resid]
	set x [$selection get x]
	set y [$selection get y]
	set z [$selection get z]

	set currentSelected [$molUP::deleteAtoms.frame0.frame.table getcolumns 0]

	# Check if the atom is already in the list
	if {[lsearch $currentSelected $index] == -1} {
		# Add the atom to the list
		$molUP::deleteAtoms.frame0.frame.table insert end [list "$index" "$name" "$resname" "$resid"]
	} else {
		# Remove the atom from the list
		set id [$molUP::deleteAtoms.frame0.frame.table search 0 "$index"]
		$molUP::deleteAtoms.frame0.frame.table delete $id
	}

	# Update representation
	if {[$molUP::deleteAtoms.frame0.frame.table getcolumns 0] != ""} {
		mol modselect 9 top "index [$molUP::deleteAtoms.frame0.frame.table getcolumns 0]"
	} else {
		mol modselect 9 top "none"
	}
}

proc molUP::deleteAtomProcess {} {
	# Get indexes of the atoms that must be deleted
	set indexes [$molUP::deleteAtoms.frame0.frame.table getcolumns 0]

	# Get the ID of the top molecule
	set molID [molinfo top]

	# Get the name of the top molecule
	set molName [molinfo top get name]
	
	# Atom selection of all system without the deleted atom
	set allWithoutAtom [atomselect top "all and not index $indexes"]

	# Stop Tracing
	trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource

	# Create a new molecule with the new information
	set mol [molUP::mergeMolecules $allWithoutAtom]

	# Delete the atomselection to free memory
	$allWithoutAtom delete

    # Get Parameters
    set parameters [.molUP.frame0.major.mol$molID.tabs.tabInput.param get 1.0 end]

	# Update structures 
	molUP::updateStructures

    # Apply Parameters
    set molIDnew [molinfo top]
    .molUP.frame0.major.mol$molIDnew.tabs.tabInput.param insert end $parameters

	# Re-Activate tracing
	trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource

	# Rename de molecule to the initial name
	mol rename top "[subst $molName]"

	# Delete the originary molecule
	mol delete $molID

	# Stop picking trace
	trace remove variable ::vmd_pick_atom write molUP::deleteAtomProcess

	# Close Gui
	molUP::deleteAtomsGuiCloseSave
}

proc molUP::mergeMolecules {sellist} {
	# This code was copied from the TopoTools plugin. 
	# Axel Kohlmeyer, (2017). TopoTools DOI: 10.5281/zenodo.545655
	# The code was adapated.

    # compute total number of atoms and collect
    # offsets and number of atoms of each piece.
    set ntotal 0
    set offset {}
    set numlist {}
    foreach s $sellist {
        if {[catch {$s num} natoms]} {
            vmdcon -err "selection access error: $natoms"
            return -1
        } else {
            # record number of atoms and offsets for later use.
            lappend offset $ntotal
            lappend numlist $natoms
            incr ntotal $natoms
        }
    }

    if {!$ntotal} {
        vmdcon -err "selections2mol: combined molecule has no atoms."
        return -1
    }

    # create new molecule to hold data.
    set mol -1
    if {[catch {mol new atoms $ntotal} mol]} {
        vmdcon -err "selection2mol: could not create new molecule: $mol"
        return -1
    } else {
        animate dup $mol
    }

    # copy data over piece by piece
    set bondlist {}
    set anglelist {}
    set dihedrallist {}
    set improperlist {}
    set ctermlist {}
    foreach sel $sellist off $offset num $numlist {
        set newsel [atomselect $mol "index $off to [expr {$off+$num-1}]"]

        # per atom props
        set cpylist {name type mass charge radius element x y z \
                         resname resid chain segname altloc user}
        $newsel set $cpylist [$sel get $cpylist]

        # get atom index map for this selection
        set atomidmap [$sel get index]

        # assign structure data. we need to renumber indices
        set list [topo getbondlist both -sel $sel]
        foreach l $list {
            lassign $l a b t o
            set anew [expr [lsearch -sorted -integer $atomidmap $a] + $off]
            set bnew [expr [lsearch -sorted -integer $atomidmap $b] + $off]
            lappend bondlist [list $anew $bnew $t $o]
        }

        set list [topo getanglelist -sel $sel]
        foreach l $list {
            lassign $l t a b c
            set anew [expr [lsearch -sorted -integer $atomidmap $a] + $off]
            set bnew [expr [lsearch -sorted -integer $atomidmap $b] + $off]
            set cnew [expr [lsearch -sorted -integer $atomidmap $c] + $off]
            lappend anglelist [list $t $anew $bnew $cnew]
        }

        set list [topo getdihedrallist -sel $sel]
        foreach l $list {
            lassign $l t a b c d
            set anew [expr [lsearch -sorted -integer $atomidmap $a] + $off]
            set bnew [expr [lsearch -sorted -integer $atomidmap $b] + $off]
            set cnew [expr [lsearch -sorted -integer $atomidmap $c] + $off]
            set dnew [expr [lsearch -sorted -integer $atomidmap $d] + $off]
            lappend dihedrallist [list $t  $anew $bnew $cnew $dnew]
        }
        set list [topo getimproperlist -sel $sel]
        foreach l $list {
            lassign $l t a b c d
            set anew [expr [lsearch -sorted -integer $atomidmap $a] + $off]
            set bnew [expr [lsearch -sorted -integer $atomidmap $b] + $off]
            set cnew [expr [lsearch -sorted -integer $atomidmap $c] + $off]
            set dnew [expr [lsearch -sorted -integer $atomidmap $d] + $off]
            lappend improperlist [list $t  $anew $bnew $cnew $dnew]
        }

        set list [topo getcrosstermlist -sel $sel]
        foreach l $list {
            lassign $l a b c d e f g h
            set anew [expr [lsearch -sorted -integer $atomidmap $a] + $off]
            set bnew [expr [lsearch -sorted -integer $atomidmap $b] + $off]
            set cnew [expr [lsearch -sorted -integer $atomidmap $c] + $off]
            set dnew [expr [lsearch -sorted -integer $atomidmap $d] + $off]
            set enew [expr [lsearch -sorted -integer $atomidmap $e] + $off]
            set fnew [expr [lsearch -sorted -integer $atomidmap $f] + $off]
            set gnew [expr [lsearch -sorted -integer $atomidmap $g] + $off]
            set hnew [expr [lsearch -sorted -integer $atomidmap $h] + $off]
            lappend ctermlist [list $anew $bnew $cnew $dnew $enew $fnew $gnew $hnew]
        }
        $newsel delete
    }

    # apply structure info
    topo setbondlist both -molid $mol $bondlist
    topo setanglelist -molid $mol $anglelist
    topo setdihedrallist -molid $mol $dihedrallist
    topo setimproperlist -molid $mol $improperlist
    topo setcrosstermlist -molid $mol $ctermlist
    # set box to be largest of the available boxes
    set amax 0.0
    set bmax 0.0
    set cmax 0.0
    foreach sel $sellist {
        lassign [molinfo [$sel molid] get {a b c}] a b c
        if {$a > $amax} {set amax $a}
        if {$b > $bmax} {set bmax $b}
        if {$c > $cmax} {set cmax $c}
    }
    molinfo $mol set {a b c} [list $amax $bmax $cmax]

    return $mol
}