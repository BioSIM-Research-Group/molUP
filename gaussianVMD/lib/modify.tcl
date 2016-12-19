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

proc gaussianVMD::calcBondDistance {value} {

    if {$gaussianVMD::atom2BondSel != 0} {
        ## Set the selections for the desired atoms
        set selection1 [atomselect top "index $gaussianVMD::atom1BondSel"]
        set selection2 [atomselect top "index $gaussianVMD::atom2BondSel"]

        ## Get atom coordinates Atom 1
        set atom1X [[lindex $selection1 0] get x]
        set atom1Y [[lindex $selection1 0] get y]
        set atom1Z [[lindex $selection1 0] get z]

        ## Get atom coordinates Atom 2
        set atom2X [[lindex $selection2 0] get x]
        set atom2Y [[lindex $selection2 0] get y]
        set atom2Z [[lindex $selection2 0] get z]

        ## Move atom
        set factor [expr $gaussianVMD::BondDistance / $gaussianVMD::initialBondDistance]

        ## Calculate the coordinates of the vector
        set vectorX [expr ($atom2X - $atom1X) * $factor]
        set vectorY [expr ($atom2Y - $atom1Y) * $factor]
        set vectorZ [expr ($atom2Z - $atom1Z) * $factor]

        puts "[list $vectorX $vectorY $vectorZ]"

        $selection2 moveby [list $vectorX $vectorY $vectorZ]

        


    } else {
        
    }

    set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance
}