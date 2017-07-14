package provide energy 1.0

proc molUP::firstProcEnergy {} {
    set oniomTrue [catch {exec egrep -m 1 "oniom" $molUP::path}]
    if {$oniomTrue == "0"} {
        molUP::energy
    } else {
        molUP::energyNotONIOM
    }
}

proc molUP::firstProcEnergyAll {} {
    set oniomTrue [catch {exec egrep -m 1 "oniom" $molUP::path}]
    if {$oniomTrue == "0"} {
        molUP::energyAll
    } else {
        molUP::energyNotONIOMAll
    }
}

proc molUP::energyLastStructure {} {
    set oniomTrue [catch {exec egrep -m 1 "oniom" $molUP::path}]
    if {$oniomTrue == "0"} {
        molUP::energyLastStructureOniom
    } else {
        molUP::energyLastStructureNotOniom
    }
}

proc molUP::energyLastStructureOniom {} {
    ## Get All energies
    set energies [molUP::gettingEnergyLast $molUP::path]

    ## Optimized Energies
	set lines [split $energies \n]

    ## Variable containing the list of energies for all structures
    variable listEnergies {}
    variable listEnergiesOpt {}
    variable listEnergiesNonOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value

        if {$value == "******************"} {
            set value 999999999999999999
        } else {}
		
        if {$column3 == 1} {
            lappend molUP::listEnergies $value
		} elseif {$column3 == 2} {
			lappend molUP::listEnergies $value
		} elseif {$column3 == 3} {
			lappend molUP::listEnergies $value
            lappend molUP::listEnergies "newStruct"
		} elseif {[regexp {Non-Optimized} $line -> optimizedLine]} {
			#lappend molUP::listEnergies "nonoptstructure"
		} elseif {[regexp {Optimized} $line -> optimizedLine]} {
			#lappend molUP::listEnergies "optstructure"
		}

	}

    ## Search for optimized strcutures
    set optEnergy [lsearch -all $molUP::listEnergies "newStruct"]

    set structure 1
    foreach strut $optEnergy {
        set highEnergy [lindex $molUP::listEnergies [expr $strut - 2]]
        set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 3]]]
        set totalEnergy [expr $highEnergy + $lowEnergy]
        set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy"]

        lappend molUP::listEnergiesOpt $list

        incr structure
    }

    set energyLastStructure [lindex [lindex $molUP::listEnergiesOpt end] 1]
    set energyLastStructureHL [lindex [lindex $molUP::listEnergiesOpt end] 2]
    set energyLastStructureLL [lindex [lindex $molUP::listEnergiesOpt end] 3]


    set molID [molinfo top]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs add [frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6] -text "Energies"

    place [ttk::frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph \
            -width 380 \
            -height 300 \
			] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 5 -width 380 -height 300

    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.title \
		-style molUP.white.TLabel \
		-text {Energy Summary} \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 150 -y 10 -width 200
    

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.infoButton \
        -style molUP.infoButton.TButton \
        -text "Information" \
		-command {molUP::guiInfo "energy.txt"} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 5 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.infoButton -text "Detailed information about energy calculation"

    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyLabel \
		-style molUP.white.TLabel \
		-text "Total Electronic Energy (Hartree)" \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 10 -y 50 -width 200

    place [text $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		-wrap word \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 50 -width 130 -height 25
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry insert end $energyLastStructure
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry edit modified false
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry configure -state disabled

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergy \
        -style molUP.copyButton.TButton \
        -text "Copy to clipboard" \
		-command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntry} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 46 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergy -text "Copy to clipboard"


    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyLabelHL \
		-style molUP.white.TLabel \
		-text "      HL Electronic Energy (Hartree)" \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 10 -y 100 -width 200

    place [text $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		-wrap word \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 100 -width 130 -height 25
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL insert end $energyLastStructureHL
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL edit modified false
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL configure -state disabled

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyHL \
        -style molUP.copyButton.TButton \
        -text "Copy to clipboard" \
		-command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntryHL} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 96 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyHL -text "Copy to clipboard"



     place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyLabelLL \
		-style molUP.white.TLabel \
		-text "      LL Electronic Energy (Hartree)" \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 10 -y 130 -width 200

    place [text $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		-wrap word \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 130 -width 130 -height 25
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL insert end $energyLastStructureLL
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL edit modified false
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL configure -state disabled

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyLL \
        -style molUP.copyButton.TButton \
        -text "Copy to clipboard" \
		-command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntryLL} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 126 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyLL -text "Copy to clipboard"
    
}


proc molUP::energyLastStructureNotOniom {} {
    catch {exec egrep {SCF Done:  E|Optimized Parameters} $molUP::path} energies
    set lines [split $energies \n]

    variable listEnergies {}
    variable listEnergiesOpt {}
    variable listEnergiesNonOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value
		
        if {$column1 == "SCF"} {
            lappend molUP::listEnergies $column5
		} else {

        }
	}

    ## Search for optimized strcutures

    set structure 1
    foreach strut $molUP::listEnergies {
        set list [list "$structure" "$strut"]

        lappend molUP::listEnergiesOpt $list

        incr structure
    }

    set energyLastStructure [lindex [lindex $molUP::listEnergiesOpt end] 1]


    set molID [molinfo top]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs add [frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6] -text "Energies"

    place [ttk::frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph \
            -width 380 \
            -height 300 \
			] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 5 -width 380 -height 300

    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.title \
		-style molUP.white.TLabel \
		-text {Energy Summary} \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 150 -y 10 -width 200
    

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.infoButton \
        -style molUP.infoButton.TButton \
        -text "Information" \
		-command {molUP::guiInfo "energy.txt"} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 5 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.infoButton -text "Detailed information about energy calculation"

    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyLabel \
		-style molUP.white.TLabel \
		-text {Total Electronic Energy (Hartree)} \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 10 -y 50 -width 200

    place [text $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		-wrap word \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 50 -width 130 -height 25
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry insert end $energyLastStructure
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry edit modified false
    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry configure -state disabled

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergy \
        -style molUP.copyButton.TButton \
        -text "Copy to clipboard" \
		-command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntry} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 46 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergy -text "Copy to clipboard"

}



proc molUP::energyNotONIOM {} {
    set energies [exec egrep {SCF Done:  E|Optimized Parameters} $molUP::path]
    set lines [split $energies \n]

    variable listEnergies {}
    variable listEnergiesOpt {}
    variable listEnergiesNonOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value
		
        if {$column1 == "SCF"} {
            lappend molUP::listEnergies $column5
		} elseif {[regexp {Non-Optimized} $line -> optimizedLine]} {
			lappend molUP::listEnergies "nonoptstructure"
		} elseif {[regexp {Optimized} $line -> optimizedLine]} {
			lappend molUP::listEnergies "optstructure"
		}
	}

    ## Search for optimized strcutures
    set optEnergy [lsearch -all $molUP::listEnergies "*optstructure"]
    set nonOptEnergy [lsearch -all $molUP::listEnergies "nonoptstructure"]

    if {$optEnergy == "" && $nonOptEnergy == ""} {
        #Ignore and plot no graph  
        molUP::guiError "No optimized structure was found.\nThe last structure was loaded instead." "No optmimized structure"
    } else {

        set structure 1
        foreach strut $optEnergy {
            set energy [lindex $molUP::listEnergies [expr $strut - 1]]
            set list [list "$structure" "$energy"]

            lappend molUP::listEnergiesOpt $list

            incr structure
        }

        foreach a $nonOptEnergy {
            set b [lsearch $optEnergy $a]
            lappend molUP::listEnergiesNonOpt [expr $b + 1]
        }

        molUP::drawGraph 

    }

}

proc molUP::energyNotONIOMAll {} {
    set energies [exec egrep {SCF Done:  E|Optimized Parameters} $molUP::path]
    set lines [split $energies \n]

    variable listEnergies {}
    variable listEnergiesOpt {}
    variable listEnergiesNonOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value
		
        if {$column1 == "SCF"} {
            lappend molUP::listEnergies $column5
		} else {

        }
	}

    ## Search for optimized strcutures

    set structure 1
    foreach strut $molUP::listEnergies {
        set list [list "$structure" "$strut"]

        lappend molUP::listEnergiesOpt $list

        incr structure
    }

    molUP::drawGraph 
}


proc molUP::energy {} {

    ## Get All energies
    set energies [molUP::gettingEnergy $molUP::path]

    ## Optimized Energies
	set lines [split $energies \n]

    ## Variable containing the list of energies for all structures
    variable listEnergies {}
    variable listEnergiesOpt {}
    variable listEnergiesNonOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value

        if {$value == "******************"} {
            set value 999999999999999999
        } else {}
		
        if {$column3 == 1} {
            lappend molUP::listEnergies $value
		} elseif {$column3 == 2} {
			lappend molUP::listEnergies $value
		} elseif {$column3 == 3} {
			lappend molUP::listEnergies $value
		} elseif {[regexp {Non-Optimized} $line -> optimizedLine]} {
			lappend molUP::listEnergies "nonoptstructure"
		} elseif {[regexp {Optimized} $line -> optimizedLine]} {
			lappend molUP::listEnergies "optstructure"
		}

	}

    ## Search for optimized strcutures
    set optEnergy [lsearch -all $molUP::listEnergies "*optstructure"]
    set nonOptEnergy [lsearch -all $molUP::listEnergies "nonoptstructure"]

    if {$optEnergy == "" && $nonOptEnergy == ""} {
        #Ignore and plot no graph  
        molUP::guiError "No optimized structure was found.\nThe last structure was loaded instead." "No optmimized structure"
    } else {

        set structure 1
        foreach strut $optEnergy {
            set highEnergy [lindex $molUP::listEnergies [expr $strut - 2]]
            set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 3]]]
            set totalEnergy [expr $highEnergy + $lowEnergy]
            set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy"]

            lappend molUP::listEnergiesOpt $list

            incr structure
        }

        foreach a $nonOptEnergy {
            set b [lsearch $optEnergy $a]
            lappend molUP::listEnergiesNonOpt [expr $b + 1]
        }

        molUP::drawGraph 

    }
}

proc molUP::energyAll {} {

    ## Get All energies
    set energies [molUP::gettingEnergy $molUP::path]

    ## Optimized Energies
	set lines [split $energies \n]

    ## Variable containing the list of energies for all structures
    variable listEnergies {}
    variable listEnergiesOpt {}
    variable listEnergiesNonOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value

        if {$value == "******************"} {
            set value 999999999999999999
        } else {}
		
        if {$column3 == 1} {
            lappend molUP::listEnergies $value
		} elseif {$column3 == 2} {
			lappend molUP::listEnergies $value
		} elseif {$column3 == 3} {
			lappend molUP::listEnergies $value
            lappend molUP::listEnergies "newStruct"
		} elseif {[regexp {Non-Optimized} $line -> optimizedLine]} {
			#lappend molUP::listEnergies "nonoptstructure"
		} elseif {[regexp {Optimized} $line -> optimizedLine]} {
			#lappend molUP::listEnergies "optstructure"
		}

	}

    ## Search for optimized strcutures
    set optEnergy [lsearch -all $molUP::listEnergies "newStruct"]

    set structure 1
    foreach strut $optEnergy {
        set highEnergy [lindex $molUP::listEnergies [expr $strut - 2]]
        set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 3]]]
        set totalEnergy [expr $highEnergy + $lowEnergy]
        set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy"]

        lappend molUP::listEnergiesOpt $list

        incr structure
    }

    molUP::drawGraph 
}


proc molUP::gettingEnergy {File} {
        set energies [exec egrep {low   system:  model energy:|high  system:  model energy:|low   system:  real  energy:|ONIOM: extrapolated energy|Optimized Parameters} $File]
        return $energies
}

proc molUP::gettingEnergyLast {File} {
        set energies [exec egrep {low   system:  model energy:|high  system:  model energy:|low   system:  real  energy:|ONIOM: extrapolated energy|Optimized Parameters} $File | tail -n 5]
        return $energies
}

proc molUP::drawGraph {} {
    #### Create a new tab - Energies
    set molID [molinfo top]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs add [frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6] -text "Energies"

    place [ttk::frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph \
            -width 380 \
            -height 250 \
			] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 5 -width 380 -height 250

    #pack [canvas $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.area -background white -width 380 -height 250]

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.savePS \
            -text "Save as vector image (PostScript)" \
            -style molUP.TButton \
            -command {molUP::savePS $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.graph}
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 260 -width 250 

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.exportData \
            -text "Export data" \
            -style molUP.TButton \
            -command {molUP::exportEnergy}
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 265 -y 260 -width 120 

    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.note \
		-style molUP.white.TLabel \
		-text {Red points (if available) correspond to non-optimized structure.} ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 290
    
    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.note1 \
		-style molUP.white.TLabel \
		-text {Zoom In: Drag the mouse     Zoom Out: Right or Middle -click} ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 305

    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.totalEnergyLabel \
		-style molUP.white.TLabel \
		-text {Total Energy (Hartree)} \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 360 -width 180

    variable totalEnergyValuePick "0.000000"

     place [ttk::entry $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.totalEnergy \
		-style molUP.TEntry \
		-textvariable molUP::totalEnergyValuePick \
        -state readonly \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 200 -y 358 -width 150

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.copy \
        -style molUP.copyButton.TButton \
        -text "Copy to clipboard" \
		-command {clipboard clear; clipboard append [format %.7f $molUP::totalEnergyValuePick]} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 355 -y 360 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.copy -text "Copy to clipboard"
 

    ## Create a list for each variable
    set structure {}
    set totalE {}
    set hlE {}
    set llE {}
    foreach list $molUP::listEnergiesOpt {
        lappend structure [lindex $list 0]
        lappend totalE [lindex $list 1]
        lappend hlE [lindex $list 2]
        lappend llE [lindex $list 3]
    }

    set xMax [expr [lindex [lsort -real -decreasing $structure] 0] + 1]
    set xMin [lindex [lsort -real -increasing $structure] 0]
    set xInt [expr [format %.0f [expr ($xMax - $xMin)/10]] + 1]

    set yMax [expr [lindex [lsort -real -decreasing $totalE] 0] + (([lindex [lsort -real -decreasing $totalE] 0] - [lindex [lsort -real -increasing $totalE] 0])*0.05)]
    set yMin [expr [lindex [lsort -real -increasing $totalE] 0] - (($yMax - [lindex [lsort -real -increasing $totalE] 0])*0.05)]
    set yInt [expr ($yMax - $yMin)/10]

    



    ## Draw the graph
    molUP::drawPlot $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph $structure $totalE "Energetic Profile" black 16 oval black black 7
    #molUP::addData $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph $structure $hlE oval red red 8
    #molUP::addData $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph $structure $llE oval blue blue 8

}

proc molUP::mouseClick {x y} {
    animate goto [expr [format %.0f $x] - 1]
}

proc molUP::firstStepReference {list} {
    variable firstStepRefList {}

    set firstLine [lindex $list 0]
    set numberEnegeries [expr [llength $firstLine] -1]

    foreach value $list {
        set a [lindex $value 0]
        for {set index 1} { $index <= $numberEnegeries } { incr index } {
            set energy [expr ([lindex $value $index] - [lindex $firstLine $index]) * 627.509]
            lappend a $energy
        }
        lappend molUP::firstStepRefList $a
    }

    return $molUP::firstStepRefList
}

proc molUP::drawFirstStepRef {} {
    set molID [molinfo top]
    destroy $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph

    place [ttk::frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph \
            -width 380 \
            -height 250 \
			] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 5 -width 380 -height 250

    
    molUP::firstStepReference $molUP::listEnergiesOpt

    ## Create a list for each variable
    set structure {}
    set totalE {}
    set hlE {}
    set llE {}
    foreach list $molUP::firstStepRefList {
        lappend structure [lindex $list 0]
        lappend totalE [lindex $list 1]
        lappend hlE [lindex $list 2]
        lappend llE [lindex $list 3]
    }

    ## Draw the graph
    molUP::drawPlot $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph $structure $totalE "Energetic Profile" black 16 oval blue black 8

}


proc molUP::savePS {pathname} {
        set fileTypes {
                {{PostScript (.ps)}       {.ps}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".ps" -title "Save image" -initialfile "energy.ps"]

        if {$path != ""} {
            $pathname.plotBackground.area.canvas postscript -file [list $path]
        } else {}
}

proc molUP::exportEnergy {args} {
        set fileTypes {
                {{Text (.txt)}       {.txt}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".txt" -title "Export energy values" -initialfile "energy.txt"] 

        if {$path != ""} {
            set file [open $path w]
            set numberColumns [llength [lindex $molUP::listEnergiesOpt 0]]

            if {$numberColumns == 4} {
                puts $file "Energy of optimized structures (Units: Hartree)\nData exported by molUP - a VMD plugin\nStructure \t Total Energy \t High level Energy \t Low level Energy"
                foreach value $molUP::listEnergiesOpt {
                    puts $file "[lindex $value 0] \t\t [lindex $value 1] \t [lindex $value 2] \t [lindex $value 3]"
                }
            } else {
                puts $file "Energy of optimized structures (Units: Hartree)\nStructure \t Energy"
                foreach value $molUP::listEnergiesOpt {
                    puts $file "[lindex $value 0] \t\t [lindex $value 1]"
                }
            }

            close $file

        } else {}
}


proc molUP::copyClipboardFromText {pathName} {
    clipboard clear
    set text [$pathName get 1.0 end]
    clipboard append $text
}