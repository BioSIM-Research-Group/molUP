package provide editStructure 1.0

#### Table Editor
proc gaussianVMD::oniomLayer {tbl row col text} {
    set w [$tbl editwinpath]
    set values {"H" "M" "L"}
    $w configure -values $values -state readonly
}

proc gaussianVMD::oniomLayerEnd {} {
    set highLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer searchcolumn 4 "H" -all]
    mol modselect 2 top index [gaussianVMD::optimizeIndexList $highLayerIndex]

    set mediumLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer searchcolumn 4 "M" -all]
    mol modselect 3 top index [gaussianVMD::optimizeIndexList $mediumLayerIndex]

    set lowLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer searchcolumn 4 "L" -all]
    mol modselect 4 top index [gaussianVMD::optimizeIndexList $lowLayerIndex]
}

proc gaussianVMD::freezeEnd {} {
    set highLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer searchcolumn 4 "0" -all]
    mol modselect 8 top index [gaussianVMD::optimizeIndexList $highLayerIndex]

    set mediumLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer searchcolumn 4 "-1" -all]
    append mediumLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer searchcolumn 4 "-2" -all]
    append mediumLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer searchcolumn 4 "-3" -all]
    mol modselect 9 top index [gaussianVMD::optimizeIndexList $mediumLayerIndex]

}


proc gaussianVMD::onOffRepresentation {repIndex} {
    set molExists [mol list]

    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No structure was loaded. Please, load a structure before try to visualize it." -type ok -icon error]

    } else {
            set actualOnOffStatus [mol showrep top $repIndex]

            if {$actualOnOffStatus == 0} {
            mol showrep top $repIndex 1
        } else {
            mol showrep top $repIndex 0
        }

        #display resetview
    }

}

proc gaussianVMD::addSelectionRep {} {
    #### Change atom colors
    color Name C green3


    #### Representation of the atoms selected on the tablelist
    mol selection none
	mol color ColorID 4
    mol material Diffuse
	mol representation VDW 0.300000 1.000000
	mol addrep top

    #### Representantion of High layer
    set highLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer searchcolumn 4 "H" -all]
    mol selection index [gaussianVMD::optimizeIndexList $highLayerIndex]
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.300000 12.000000 12.000000
    mol addrep top
    mol showrep top 2 $gaussianVMD::HLrep

    #### Representantion of Medium layer
    set mediumLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer searchcolumn 4 "M" -all]
    mol selection index [gaussianVMD::optimizeIndexList $mediumLayerIndex]
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 12.000000 12.000000
    mol addrep top
    mol showrep top 3 $gaussianVMD::MLrep

    #### Representantion of Low layer
    set lowLayerIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer searchcolumn 4 "L" -all]
    mol selection index [gaussianVMD::optimizeIndexList $lowLayerIndex]
    mol color Name
    mol material Diffuse
    mol representation Lines 1.000000
    mol addrep top
    mol showrep top 4 $gaussianVMD::LLrep

    #### Representantion Protein
    mol selection protein
    mol color Name
    mol material Diffuse
    mol representation NewCartoon 0.300000 10.000000 4.100000
    mol addrep top
    mol showrep top 5 $gaussianVMD::proteinRep

    #### Representantion Non-Protein
    mol selection all and not (protein or water)
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 12.000000 12.000000
    mol addrep top
    mol showrep top 6 $gaussianVMD::nonproteinRep

    #### Representantion Water
    mol selection water
    mol color Name
    mol material Diffuse
    mol representation VDW 0.300000 1.000000
    mol addrep top
    mol showrep top 7 $gaussianVMD::waterRep

    #### Representantion Unfreeze
    set unfreezeAtomIndex [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer searchcolumn 4 "0" -all]
    
    mol selection index [gaussianVMD::optimizeIndexList $unfreezeAtomIndex]
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.200000 12.000000 12.000000
    mol addrep top
    mol showrep top 8 $gaussianVMD::unfreezeRep

    #### Representantion Freeze
    mol selection all and not index [gaussianVMD::optimizeIndexList $unfreezeAtomIndex]
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 12.000000 12.000000
    mol addrep top
    mol showrep top 9 $gaussianVMD::freezeRep

    #### Representantion all
    mol showrep top 0 $gaussianVMD::allRep

}

#### Representantion of current selection
proc gaussianVMD::changeRepCurSelection {option} {

    set evaluateLoadedMol [mol list]

    if {$evaluateLoadedMol == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No structure was loaded." -type ok -icon error]
    } else {
        if {$option == "charges"} {
            set indexSelectedAtoms [$gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
        
        } elseif {$option == "oniom"} {
            set indexSelectedAtoms [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
            set gaussianVMD::atomSelectionONIOM "index $indexSelectedAtoms"
        
        } elseif {$option == "freeze"} {
            set indexSelectedAtoms [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
            set gaussianVMD::atomSelectionFreeze "index $indexSelectedAtoms"
        } else {
            
        }
    }
}

#### Apply selection to structure 
proc gaussianVMD::applyToStructure {option} {
    if {$option == "oniom"} {
        set listIndexAtoms [[atomselect top $gaussianVMD::atomSelectionONIOM] get {index}]
        foreach atom $listIndexAtoms {
            $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer configcells [subst $atom],4 -text [subst $gaussianVMD::selectionModificationValueOniom]
        }
        gaussianVMD::oniomLayerEnd

    } elseif {$option == "freeze"} {
       set listIndexAtoms [[atomselect top $gaussianVMD::atomSelectionFreeze] get {index}]
        foreach atom $listIndexAtoms {
            $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer configcells [subst $atom],4 -text [subst $gaussianVMD::selectionModificationValueFreeze]
        }
        gaussianVMD::freezeEnd

    } else {
        
    }
}

#### Clear selection
proc gaussianVMD::clearSelection {option} {
    if {$option == "charges"} {
        mol modselect 1 top none

    } elseif {$option == "oniom"} {
        mol modselect 1 top none
        set gaussianVMD::atomSelectionONIOM ""

    } elseif {$option == "freeze"} {
        mol modselect 1 top none
        set gaussianVMD::atomSelectionFreeze ""
    } else {
        
    }

}


#### Delete All Labels
proc gaussianVMD::deleteAllLabels {} {
    label delete Atoms All
    label delete Bonds All
    label delete Angles All
    label delete Dihedrals All
    label delete Springs All
}

#### Optimize index list on VMD Representantion
proc gaussianVMD::optimizeIndexList {list} {
    set outputVariable  ""

    for {set index 0} { $index < [llength $list] } { incr index } {
        if {$index == 0} {
            append outputVariable [lindex $list $index] " "
        } else {
            if {[lindex $list $index] == [expr [lindex $list [expr $index + 1]] - 1]} {
                
            } else {
                append outputVariable "to " [lindex $list $index] " "
                append outputVariable [lindex $list [expr $index + 1]] " "
                incr index
            }
        }

    }

    return $outputVariable
}