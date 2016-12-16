package provide modify 1.0

proc gaussianVMD::calcBondDistance {selection1 selection2} {
    ## Get atom coordinates Atom 1
    set atom1X [[lindex $selection1 0] get x]
    set atom1Y [[lindex $selection1 0] get y]
    set atom1Z [[lindex $selection1 0] get z]

    ## Get atom coordinates Atom 2
    set atom2X [[lindex $selection2 0] get x]
    set atom2Y [[lindex $selection2 0] get y]
    set atom2Z [[lindex $selection2 0] get z]

    set gaussianVMD::BondDistance [expr sqrt(($atom2X-atom1X)*($atom2X-atom1X)+($atom2Y-atom1Y)*($atom2Y-atom1Y)+($atom2Z-atom1Z)*($atom2Z-atom1Z))]

}