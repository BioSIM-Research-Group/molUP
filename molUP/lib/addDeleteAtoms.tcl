package provide addDeleteAtoms 1.5.1

##### DELETE ATOMS
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

    if {[llength $indexes] != 0} {
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
        molUP::updateStructuresFromOtherSource

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

    } else {
        molUP::deleteAtomsGuiCloseSave
    }

}


##### ADD ATOMS

proc molUP::addAtomElement {element} {
    # Destroy the periodic Table
    destroy $::molUP::periodicTable

    # Store the element information
    set molUP::addAtomElement "$element"

    # Trace pick atom variable
    trace variable ::vmd_pick_atom w molUP::addAtomToPickedAtom

    # Mouse mode pick
    mouse mode pick
}

proc molUP::addAtomToPickedAtom {args} {
    # Get molecule ID
    variable addAtomMolID $::vmd_pick_mol

    # Add the Atom
    set freeAtoms [atomselect top "occupancy 0"]
    set index [lindex [$freeAtoms get index] 0]
    $freeAtoms delete
    set atomAdded [atomselect top "index $index"]

    # Selection of thhe anchor atom
    set anchorAtom [atomselect $::vmd_pick_mol "index $::vmd_pick_atom"]

    # Make the atom Visible
    $atomAdded set occupancy 1

    # Set informations about the atom
    $atomAdded set element "$molUP::addAtomElement"
    $atomAdded set name "$molUP::addAtomElement"
    $atomAdded set type "$molUP::addAtomElement"
    $atomAdded set charge "0.00000"
    $atomAdded set resname [$anchorAtom get resname]
    $atomAdded set resid [$anchorAtom get resid]
    $atomAdded set user [$anchorAtom get user]
    $atomAdded set altloc [$anchorAtom get altloc]
    
    # Put the atom near the anchor atom
    # Set the selections for the desired atoms
    set posAdded [join [$atomAdded get {x y z}]]
    set posAnchor [join [$anchorAtom get {x y z}]]

    # Set vectors
    set dir    [vecnorm [vecsub $posAdded $posAnchor]]
    set curval [veclength [vecsub $posAnchor $posAdded]]

    # Move atom
    $atomAdded moveby [vecscale [expr -1*($curval-1)] $dir]
    set molUP::addAtomR 1.0

    # Add Atom to the list
    set newLineTable [list [$atomAdded get index] [$atomAdded get element] [$atomAdded get name] [$atomAdded get type] [$atomAdded get resname] [$atomAdded get resid] [format %.6f [$atomAdded get charge]] [$atomAdded get altloc] [format %.0f [$atomAdded get user]] $::vmd_pick_atom $::vmd_pick_mol]
    $molUP::addAtoms.frame0.frame.table insert end $newLineTable

    # Select atom on the tablelist
    $molUP::addAtoms.frame0.frame.table selection clear anchor end
    $molUP::addAtoms.frame0.frame.table selection set end
    catch {molUP::addAtomMove}

    # Delete selection to free up the memory
    $anchorAtom delete
    $atomAdded delete

    # Remove the variable trace
    trace remove variable ::vmd_pick_atom write molUP::addAtomToPickedAtom

    # Call back the rotate mouse mode
    mouse mode rotate


}

proc molUP::geom_center {selection} {
        ##### Get the geom center of a selection
        ##### This code was copied from "VMD User's Guide"
        ##### http://www.ks.uiuc.edu/Research/vmd/vmd-1.7.1/ug/node181.html

        # set the geometrical center to 0
        set gc [veczero]
        # [$selection get {x y z}] returns a list of {x y z} 
        #    values (one per atoms) so get each term one by one
        foreach coord [$selection get {x y z}] {
           # sum up the coordinates
           set gc [vecadd $gc $coord]
        }
        # and scale by the inverse of the number of atoms
        return [vecscale [expr 1.0 /[$selection num]] $gc]
}

proc molUP::addAtomMove {} {
    # Proc to move the atom when they are being added 
    # index1 is the atom that must be moved
    # index2 is the anchor atom that must be fixed during the procedure

    # Get tablelist ID
    set tablelistID [$molUP::addAtoms.frame0.frame.table curselection]
    set indexes1 {}
    foreach id $tablelistID {
        set index [lindex [$molUP::addAtoms.frame0.frame.table get $id] 0]
        lappend indexes1 $index
    }
    
    set index2 [lindex [$molUP::addAtoms.frame0.frame.table get [lindex $tablelistID 0]] end-1]
    variable mol2 [lindex [$molUP::addAtoms.frame0.frame.table get [lindex $tablelistID 0]] end]

    # Enable all the GUI elements
    $molUP::addAtoms.frame0.frame.radius configure -state normal
    $molUP::addAtoms.frame0.frame.angleA configure -state normal
    $molUP::addAtoms.frame0.frame.angleB configure -state normal
    $molUP::addAtoms.frame0.frame.angleARot configure -state normal
    $molUP::addAtoms.frame0.frame.angleBRot configure -state normal
    $molUP::addAtoms.frame0.frame.deleteAtom configure -state normal

    # Update the variables that have the index of the involved atoms
    variable addAtomIndex "$indexes1"
    variable anchorAtomIndex "$index2"

    # Create selections to get the coords
    set selection1 [atomselect top "index $molUP::addAtomIndex"]
    set selection1Pos [molUP::geom_center $selection1]
    set selection2 [atomselect $molUP::mol2 "index $molUP::anchorAtomIndex"]

    # Get the coords
    set molUP::moveAtomPosRectInitial $selection1Pos
    set moveAtomPos $selection1Pos
    set anchorAtomPos [list [$selection2 get x] [$selection2 get y] [$selection2 get z]]

    # Update the Gui with the spherical coords
    molUP::convertToSphericalCoords $anchorAtomPos $moveAtomPos

    # Delete the Coords 
    $selection1 delete
    $selection2 delete

    # Set rotation variables
    variable addAtomAngleARotation 0
    variable addAtomAngleBRotation 0

}

proc molUP::convertToSphericalCoords {anchorAtomPos moveAtomPos} {
    # Set the coordinates for the moveAtom relatively to the anchorAtom
    set x [expr [lindex $moveAtomPos 0] - [lindex $anchorAtomPos 0]]
    set y [expr [lindex $moveAtomPos 1] - [lindex $anchorAtomPos 1]]
    set z [expr [lindex $moveAtomPos 2] - [lindex $anchorAtomPos 2]]
    
    # Convert to Spherical Coords
    set pos [list [set rad [expr {hypot($x, hypot($y, $z))}]] [expr {atan2($y,$x)}] [expr {acos($z/($rad+1.0e-20))}]]
    
    # Update information in the Gui
    set molUP::addAtomR [lindex $pos 0]
    set molUP::addAtomAngleA [expr [lindex $pos 1] * 57.295779513]
    set molUP::addAtomAngleB [expr [lindex $pos 2] * 57.295779513]
}

proc molUP::convertToRectCoords {anchorAtomPos moveAtomPosSpherical} {
    # Get the Speherical coords (radians)
    set rad [lindex $moveAtomPosSpherical 0]
    set phi [expr [lindex $moveAtomPosSpherical 1] / 57.295779513]
    set theta [expr [lindex $moveAtomPosSpherical 2] / 57.295779513]

    # Convert to Rectangular Coords
    set pos [list [expr {$rad * cos($phi) * sin($theta)}] [expr {$rad * sin($phi) * sin($theta)}] [expr {$rad * cos($theta)}]]
    set pos [list [expr [lindex $anchorAtomPos 0] + [lindex $pos 0]] [expr [lindex $anchorAtomPos 1] + [lindex $pos 1]] [expr [lindex $anchorAtomPos 2] + [lindex $pos 2]]]

    return $pos
}

proc molUP::addAtomMoveCommand {args} {
    ## Proc that is called every time the translation scales are triggered
    catch {
        # Get the rectangular coords of the anchor atom
        set selection [atomselect $molUP::mol2 "index $molUP::anchorAtomIndex"]
        set selPos [list [$selection get x] [$selection get y] [$selection get z]]
        $selection delete

        # Get the spherical coords of the move atom
        set moveAtomPos [list $molUP::addAtomR $molUP::addAtomAngleA $molUP::addAtomAngleB]

        # Convert the spherical coords of the move atom to the rectangular coords
        set moveAtomPosRect [molUP::convertToRectCoords $selPos $moveAtomPos]

        # Move atom to a certain position
        foreach atom $molUP::addAtomIndex {
            set selection [atomselect top "index $atom"]
            set vectorDifference [vecsub $moveAtomPosRect $molUP::moveAtomPosRectInitial]
            $selection moveby $vectorDifference
            $selection delete
        }

        set molUP::moveAtomPosRectInitial $moveAtomPosRect
    }
}

proc molUP::addAtomRotateCommand {axis value} {
    ## Proc that is called every time the rotation scales are triggered
    catch {
        set sel [atomselect top "index $molUP::addAtomIndex"]

        set com [measure center $sel]
        if {$axis == "x"} {
            set matrix [transaxis $axis [expr $value - $molUP::addAtomAngleARotation]] 
        } elseif {$axis == "y"} {
            set matrix [transaxis $axis [expr $value - $molUP::addAtomAngleBRotation]] 
        }
        $sel moveby [vecscale -1.0 $com] 
        $sel move $matrix 
        $sel moveby $com 

        $sel delete

        if {$axis == "x"} {
            set molUP::addAtomAngleARotation $value
        } elseif {$axis == "y"} {
            set molUP::addAtomAngleBRotation $value
        }
    }
}

proc molUP::addAtomDelete {} {
    # Get current selected rows
    set tableRowsSelected [$molUP::addAtoms.frame0.frame.table curselection]

    set atomIndexes {}
    foreach id $tableRowsSelected {
        set index [lindex [$molUP::addAtoms.frame0.frame.table get $id] 0]
        lappend atomIndexes $index
    }

    # Set atoms occupancy 0
    catch {set selection [atomselect top "index $atomIndexes"]}
    catch {$selection set occupancy 0}

    # Delete the row from the tablelist
    $molUP::addAtoms.frame0.frame.table delete $tableRowsSelected
}

proc molUP::applyAddAtomModification {args} {
    # Get the index
    set index [lindex [$molUP::addAtoms.frame0.frame.table get [lindex $args 1]] 0]
    set selection [atomselect top "index $index"]

    set field [lindex $args 2]
    set value [lindex $args 3]

    catch {
        if {$field == 1} {
            $selection set element $value
        } elseif {$field == 2} {
            $selection set name $value
        } elseif {$field == 3} {
            $selection set type $value
        } elseif {$field == 4} {    
            $selection set resname $value
        } elseif {$field == 5} {
            $selection set resid $value
        } elseif {$field == 6} {
            $selection set charge $value
        } elseif {$field == 7} {
            $selection set altloc $value
        } elseif {$field == 8} {
            $selection set user $value
        }
    }

    $selection delete

    return $value
}

##### MERGE MOLECULES

proc molUP::mergeMolecules {sellist} {
	# This code was copied from the TopoTools plugin. 
	# Axel Kohlmeyer, (2017). TopoTools DOI: 10.5281/zenodo.545655
	# The code was adapated.

    # compute total number of atoms and collect
    # offsets and number of atoms of each piece.

    set viewPoint [molinfo top get {center_matrix rotate_matrix scale_matrix global_matrix}]

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
	    molinfo top set {center_matrix rotate_matrix scale_matrix global_matrix} $viewPoint
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