package provide modify 1.0

#### Initial procedute BondGui
proc gaussianVMD::guiBondModifInitialProc {} {
    ## Clear the pickedAtoms variable
	set gaussianVMD::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w gaussianVMD::atomPicked
	## Activate atom pick
	mouse mode pick

}

#### Run this everytime an atom is picked
proc gaussianVMD::atomPicked {args} {
    global vmd_pick_atom
    global vmd_pick_shift_state

    set numberPickedAtoms [llength $gaussianVMD::pickedAtoms]
    set gaussianVMD::BondDistance "0.00"

    if {$numberPickedAtoms > 1 } {
        set gaussianVMD::pickedAtoms {}

        lappend gaussianVMD::pickedAtoms $vmd_pick_atom

        mol modselect 10 top index $gaussianVMD::pickedAtoms

        set gaussianVMD::atom1BondSel [lindex $gaussianVMD::pickedAtoms 0]
        set gaussianVMD::atom2BondSel [lindex $gaussianVMD::pickedAtoms 1]
        set gaussianVMD::BondDistance [measure bond [list [list $gaussianVMD::atom1BondSel 0] [list $gaussianVMD::atom2BondSel 0]]]
        set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance
    
    } else {
        
        lappend gaussianVMD::pickedAtoms $vmd_pick_atom

        mol modselect 10 top index $gaussianVMD::pickedAtoms

        set gaussianVMD::atom1BondSel [lindex $gaussianVMD::pickedAtoms 0]
        set gaussianVMD::atom2BondSel [lindex $gaussianVMD::pickedAtoms 1]
        set gaussianVMD::BondDistance [measure bond [list [list $gaussianVMD::atom1BondSel 0] [list $gaussianVMD::atom2BondSel 0]]]
        set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance
    }


}

proc gaussianVMD::calcBondDistance {bondlength} {

    if {$gaussianVMD::atom2BondSel != 0} {

        set atomsToBeMoved1 100
        set atomsToBeMoved2 1

        ## Set the selections for the desired atoms
        set selection1 [atomselect top "index $gaussianVMD::atom1BondSel"]
        set selection2 [atomselect top "index $gaussianVMD::atom2BondSel"]

        ## Get atom coordinates
        set pos1 [join [$selection1 get {x y z}]]
        set pos2 [join [$selection2 get {x y z}]]
        $selection1 delete
        $selection2 delete

        ## Set vectors
        set dir    [vecnorm [vecsub $pos1 $pos2]]
        set curval [veclength [vecsub $pos2 $pos1]]

        ## Atoms to be moved
        set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel -maxdepth $atomsToBeMoved1]]
        set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel -maxdepth $atomsToBeMoved2]]
        set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
        set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]

        ## Move atoms according to distance
        $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
        $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
        $selection1 delete
        $selection2 delete
        

    } else {
        
    }

    set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance
}