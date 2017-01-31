package provide editStructure 1.0

#### Table Editor
proc molUP::oniomLayer {tbl row col text} {
    set w [$tbl editwinpath]
    set values {"H" "M" "L"}
    $w configure -values $values -state readonly
}

proc molUP::onOffRepresentation {repIndex} {
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

proc molUP::addSelectionRep {} {
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
    mol showrep top 2 $molUP::HLrep

    #### Representantion of Medium layer
    mol selection "altloc M"
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 15.000000 15.000000
    mol addrep top
    mol showrep top 3 $molUP::MLrep

    #### Representantion of Low layer
    mol selection "altloc L"
    mol color Name
    mol material Diffuse
    mol representation Lines 1.000000
    mol addrep top
    mol showrep top 4 $molUP::LLrep

    #### Representantion Protein
    mol selection "protein"
    mol color Name
    mol material Diffuse
    mol representation NewCartoon 0.300000 10.000000 4.100000
    mol addrep top
    mol showrep top 5 $molUP::proteinRep

    #### Representantion Non-Protein
    mol selection "all and not (protein or water)"
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 15.000000 15.000000
    mol addrep top
    mol showrep top 6 $molUP::nonproteinRep

    #### Representantion Water
    mol selection "water"
    mol color Name
    mol material Diffuse
    mol representation VDW 0.300000 1.000000
    mol addrep top
    mol showrep top 7 $molUP::waterRep

    #### Representantion Unfreeze
    mol selection "user 0"
    mol color Name
    mol material Diffuse
    mol representation Lines 2.000000
    mol addrep top
    mol showrep top 8 $molUP::unfreezeRep

    #### Representantion Freeze
    mol selection "user \"-1\" \"-2\" \"-3\""
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 15.000000 15.000000
    mol addrep top
    mol showrep top 9 $molUP::freezeRep

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
    mol showrep top 11 $molUP::showPosChargedResidues

    # Negative
    mol selection "none"
	mol color ColorID 1
    mol material Transparent
	mol representation QuickSurf 0.500000 0.500000 0.250000 2.000000
	mol addrep top
    mol showrep top 12 $molUP::showNegChargedResidues


    # Set lines to default
    mol representation Lines 1.000000
    
    mol showrep top 13 $molUP::allRep

}

#### Representantion of current selection
proc molUP::changeRepCurSelection {option} {

    set evaluateLoadedMol [mol list]

    if {$evaluateLoadedMol == "ERROR) No molecules loaded."} {
        molUP::guiError "No structure was loaded."
    } else {
        if {$option == "charges"} {
            set indexSelectedAtoms [$molUP::tableCharges curselection]
            mol modselect 1 top index $indexSelectedAtoms
        
        } elseif {$option == "oniom"} {
            set indexSelectedAtoms [$molUP::tableLayer curselection]
            mol modselect 1 top index $indexSelectedAtoms
            set molUP::atomSelectionONIOM "index $indexSelectedAtoms"
        
        } elseif {$option == "freeze"} {
            set indexSelectedAtoms [$molUP::tableFreeze curselection]
            mol modselect 1 top index $indexSelectedAtoms
            set molUP::atomSelectionFreeze "index $indexSelectedAtoms"
        } else {
            
        }
    }
}

#### Apply selection to structure 
proc molUP::applyToStructure {option} {
    if {$option == "oniom"} {
        [atomselect top "$molUP::atomSelectionONIOM"] set altloc $molUP::selectionModificationValueOniom
        molUP::activateMolecule

    } elseif {$option == "freeze"} {
        [atomselect top "$molUP::atomSelectionFreeze"] set altloc $molUP::selectionModificationValueFreeze
        molUP::activateMolecule
    } else {
        
    }
}

#### Clear selection
proc molUP::clearSelection {option} {
    if {$option == "charges"} {
        mol modselect 1 top none

    } elseif {$option == "oniom"} {
        mol modselect 1 top none
        set molUP::atomSelectionONIOM ""

    } elseif {$option == "freeze"} {
        mol modselect 1 top none
        set molUP::atomSelectionFreeze ""
    } else {
        
    }

}


#### Delete All Labels
proc molUP::deleteAllLabels {} {
    label delete Atoms All
    label delete Bonds All
    label delete Angles All
    label delete Dihedrals All
    label delete Springs All
}

#### Optimize index list on VMD Representantion
proc molUP::optimizeIndexList {list} {
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