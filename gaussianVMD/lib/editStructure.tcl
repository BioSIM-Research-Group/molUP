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

        display resetview
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
    mol selection chain H
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.300000 12.000000 12.000000
    mol addrep top
    mol showrep top 2 $gaussianVMD::HLrep

    #### Representantion of Medium layer
    mol selection chain M
    mol color Name
    mol material Diffuse
    mol representation Licorice 0.100000 12.000000 12.000000
    mol addrep top
    mol showrep top 3 $gaussianVMD::MLrep

    #### Representantion of Low layer
    mol selection chain L
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
proc gaussianVMD::changeRepCurSelection {} {
    set indexSelectedAtoms [$gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer curselection]
    
    mol modselect 1 top index $indexSelectedAtoms
}


#### Optimize index list on VMD Representantion
proc gaussianVMD::optimizeIndexList {list} {
    set outputVariable  ""
    set lastVar         "-2"
    set lastVarAlt      "-2"

    foreach value $list {
        
        if {$value != [expr $lastVar + 1]} {
            if {$lastVar != "-2" && $lastVarAlt != "-2" && $lastVarAlt != $lastVar} {
                     append outputVariable "to " $lastVar " "
            }
            append outputVariable $value " "
            set lastVarAlt $value
            set lastVar $value
        } elseif {$value == [expr $lastVar + 1]} {
            set lastVar $value
        }

    }

    return $outputVariable
}