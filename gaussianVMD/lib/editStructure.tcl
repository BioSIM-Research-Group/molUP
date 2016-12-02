package provide editStructure 1.0

#### Table Editor
proc gaussianVMD::oniomLayer {tbl row col text} {
    set w [$tbl editwinpath]
    set values {"H" "M" "L"}
    $w configure -values $values -state readonly
}


proc gaussianVMD::addSelectionRep {} {
    mol selection none
	mol color ColorID 4
    mol material Diffuse
	mol representation VDW 0.300000 1.000000
	mol addrep top
}

#### Representantion of current selection
proc gaussianVMD::changeRepCurSelection {} {
    set indexSelectedAtoms [$gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer curselection]
    
    mol modselect 1 top index $indexSelectedAtoms
}