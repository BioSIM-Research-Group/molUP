package provide editStructure 1.0

#### Table Editor
proc gaussianVMD::oniomLayer {tbl row col text} {
    set w [$tbl editwinpath]
    set values {"H" "M" "L"}
    $w configure -values $values -state readonly
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

    }

}

proc gaussianVMD::addSelectionRep {} {
    #### Change atom colors
    color Name C green3

    mol selection "all"
    mol color Name
    mol material Diffuse
    mol representation Lines 1.000000
    mol addrep top
    mol showrep top 0 0

    #### Representation of the atoms selected on the tablelist
    mol selection "none"
	mol color ColorID 4
    mol material Diffuse
	mol representation VDW 0.300000 1.000000
	mol addrep top
    
    #### Representantion of High layer
    mol selection "altloc H"
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.300000 15.000000 15.000000
    mol addrep top
    mol showrep top 2 $gaussianVMD::HLrep

    #### Representantion of Medium layer
    mol selection "altloc M"
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 15.000000 15.000000
    mol addrep top
    mol showrep top 3 $gaussianVMD::MLrep

    #### Representantion of Low layer
    mol selection "altloc L"
    mol color Name
    mol material Diffuse
    mol representation Lines 1.000000
    mol addrep top
    mol showrep top 4 $gaussianVMD::LLrep

    #### Representantion Protein
    mol selection "protein"
    mol color Name
    mol material Diffuse
    mol representation NewCartoon 0.300000 10.000000 4.100000
    mol addrep top
    mol showrep top 5 $gaussianVMD::proteinRep

    #### Representantion Non-Protein
    mol selection "all and not (protein or water)"
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 15.000000 15.000000
    mol addrep top
    mol showrep top 6 $gaussianVMD::nonproteinRep

    #### Representantion Water
    mol selection "water"
    mol color Name
    mol material Diffuse
    mol representation VDW 0.300000 1.000000
    mol addrep top
    mol showrep top 7 $gaussianVMD::waterRep

    #### Representantion Unfreeze
    mol selection "user 0"
    mol color Name
    mol material Diffuse
    mol representation Lines 2.000000
    mol addrep top
    mol showrep top 8 $gaussianVMD::unfreezeRep

    #### Representantion Freeze
    mol selection "user \"-1\" \"-2\" \"-3\""
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 15.000000 15.000000
    mol addrep top
    mol showrep top 9 $gaussianVMD::freezeRep

    #### Representantion Selected atoms
    mol selection "none"
	mol color ColorID 4
    mol material Transparent
	mol representation VDW 0.400000 50.000000
	mol addrep top

    #### Representantion of positive and negative residues
    # Positive
    mol selection "none"
	mol color ColorID 0
    mol material Transparent
	mol representation QuickSurf 0.500000 0.500000 0.250000 2.000000
	mol addrep top
    mol showrep top 11 $gaussianVMD::showPosChargedResidues

    # Negative
    mol selection "none"
	mol color ColorID 1
    mol material Transparent
	mol representation QuickSurf 0.500000 0.500000 0.250000 2.000000
	mol addrep top
    mol showrep top 12 $gaussianVMD::showNegChargedResidues


    # Set lines to default
    mol representation Lines 1.000000
    
    mol showrep top 13 $gaussianVMD::allRep

}

#### Representantion of current selection
proc gaussianVMD::changeRepCurSelection {option} {

    set evaluateLoadedMol [mol list]

    if {$evaluateLoadedMol == "ERROR) No molecules loaded."} {
        gaussianVMD::guiError "No structure was loaded."
    } else {
        if {$option == "charges"} {
            set indexSelectedAtoms [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
        
        } elseif {$option == "oniom"} {
            set indexSelectedAtoms [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
            set gaussianVMD::atomSelectionONIOM "index $indexSelectedAtoms"
        
        } elseif {$option == "freeze"} {
            set indexSelectedAtoms [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
            set gaussianVMD::atomSelectionFreeze "index $indexSelectedAtoms"
        } else {
            
        }
    }
}

#### Apply selection to structure 
proc gaussianVMD::applyToStructure {option} {
    if {$option == "oniom"} {
        [atomselect top "$gaussianVMD::atomSelectionONIOM"] set altloc $gaussianVMD::selectionModificationValueOniom
        gaussianVMD::activateMolecule

    } elseif {$option == "freeze"} {
        [atomselect top "$gaussianVMD::atomSelectionFreeze"] set altloc $gaussianVMD::selectionModificationValueFreeze
        gaussianVMD::activateMolecule
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