package provide energy 1.0

proc molUP::firstProcEnergy {} {
    set oniomTrue [catch {exec $molUP::grep -E -m 1 "oniom" $molUP::path}]
    if {$oniomTrue == "0"} {
        molUP::energy
    } else {
        molUP::energyNotONIOM
    }
}

proc molUP::firstProcEnergyAll {} {
    set oniomTrue [catch {exec $molUP::grep -E -m 1 "oniom" $molUP::path}]
    if {$oniomTrue == "0"} {
        molUP::energyAll
    } else {
        molUP::energyNotONIOMAll
    }
}

proc molUP::energyLastStructure {} {
    set oniomTrue [catch {exec $molUP::grep -E -m 1 "oniom" $molUP::path}]
    if {$oniomTrue == "0"} {
        molUP::energyLastStructureOniom
    } else {
        molUP::energyLastStructureNotOniom
    }
}

proc molUP::energyLastStructureOniom {} {
    if {$molUP::normalTermination == "YES"} {
        if {[string is integer $molUP::stopLine] != 1} {
            catch {exec $molUP::grep "ONIOM: gridpoint" $molUP::path | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
        } else {
		    catch {exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep "ONIOM: gridpoint" | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
        }
	} else {
        catch {exec $molUP::grep "ONIOM: gridpoint" $molUP::path | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
	}

    if {$numberGridpoints == 3} {
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
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry insert end [format %.12f $energyLastStructure]
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
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL insert end [format %.12f $energyLastStructureHL]
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
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL insert end [format %.12f $energyLastStructureLL]
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL edit modified false
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL configure -state disabled

        place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyLL \
            -style molUP.copyButton.TButton \
            -text "Copy to clipboard" \
            -command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntryLL} \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 126 -width 20 -height 20
        balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyLL -text "Copy to clipboard"




    } elseif {$numberGridpoints == 6} {
        ## Get All energies
        set energies [molUP::gettingEnergyLast3Layer $molUP::path]

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
            } elseif {$column3 == 4} {
                lappend molUP::listEnergies $value
            } elseif {$column3 == 5} {
                lappend molUP::listEnergies $value
            } elseif {$column3 == 6} {
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
            set highEnergy [lindex $molUP::listEnergies [expr $strut - 3]]
            set mediumEnergy [expr [lindex $molUP::listEnergies [expr $strut - 2]] - [lindex $molUP::listEnergies [expr $strut - 5]]]
            set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 4]] - [lindex $molUP::listEnergies [expr $strut - 6]]]
            set totalEnergy [expr $highEnergy + $mediumEnergy + $lowEnergy]
            set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy" "$mediumEnergy"]

            lappend molUP::listEnergiesOpt $list

            incr structure
        }

        set energyLastStructure [lindex [lindex $molUP::listEnergiesOpt end] 1]
        set energyLastStructureHL [lindex [lindex $molUP::listEnergiesOpt end] 2]
        set energyLastStructureLL [lindex [lindex $molUP::listEnergiesOpt end] 3]
        set energyLastStructureML [lindex [lindex $molUP::listEnergiesOpt end] 4]


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
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry insert end [format %.12f $energyLastStructure]
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
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL insert end [format %.12f $energyLastStructureHL]
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL edit modified false
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryHL configure -state disabled

        place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyHL \
            -style molUP.copyButton.TButton \
            -text "Copy to clipboard" \
            -command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntryHL} \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 96 -width 20 -height 20
        balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyHL -text "Copy to clipboard"



        place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyLabelML \
            -style molUP.white.TLabel \
            -text "      ML Electronic Energy (Hartree)" \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 10 -y 130 -width 200

        place [text $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryML \
            -bd 1 \
            -highlightcolor #017aff \
            -highlightthickness 1 \
            -wrap word \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 130 -width 130 -height 25
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryML insert end [format %.12f $energyLastStructureML]
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryML edit modified false
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryML configure -state disabled

        place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyML \
            -style molUP.copyButton.TButton \
            -text "Copy to clipboard" \
            -command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntryLL} \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 126 -width 20 -height 20
        balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyML -text "Copy to clipboard"




        place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyLabelLL \
            -style molUP.white.TLabel \
            -text "      LL Electronic Energy (Hartree)" \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 10 -y 160 -width 200

        place [text $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL \
            -bd 1 \
            -highlightcolor #017aff \
            -highlightthickness 1 \
            -wrap word \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 160 -width 130 -height 25
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL insert end [format %.12f $energyLastStructureLL]
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL edit modified false
        $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntryLL configure -state disabled

        place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyLL \
            -style molUP.copyButton.TButton \
            -text "Copy to clipboard" \
            -command {molUP::copyClipboardFromText $molUP::topGui.frame0.major.mol[molinfo top].tabs.tabOutput.tabs.tab6.energyEntryLL} \
            ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph -x 355 -y 156 -width 20 -height 20
        balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph.copyEnergyLL -text "Copy to clipboard"
    }    
}


proc molUP::energyLastStructureNotOniom {} {
    if {$molUP::normalTermination == "YES"} {
        if {[string is integer $molUP::stopLine] != 1} {
            catch {exec $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters" $molUP::path} energies
        } else {
            catch {exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters"} energies
        }
    } else {
        catch {exec $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters" $molUP::path} energies
	}
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
	$molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.energyEntry insert end [format %.12f $energyLastStructure]
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
    if {$molUP::normalTermination == "YES"} {
        if {[string is integer $molUP::stopLine] != 1} {
            set energies [exec $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters" $molUP::path]
        } else {
            set energies [exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters"]
        }
    } else {
        set energies [exec $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters" $molUP::path]
	}
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

        if {[llength $molUP::listEnergiesOpt] != 1} {
            ### Draw the Graph
            molUP::drawGraph 
        } else {
            ### Get the last structure
            molUP::energyLastStructureNotOniom
        }  

    }

}

proc molUP::energyNotONIOMAll {} {
    if {$molUP::normalTermination == "YES"} {
        if {[string is integer $molUP::stopLine] != 1} {
            set energies [exec $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters" $molUP::path]
        } else {
            set energies [exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters"]
        }
    } else {
        set energies [exec $molUP::grep -E -e "SCF Done:  E" -e "Optimized Parameters" $molUP::path]
	}
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

   if {[llength $molUP::listEnergiesOpt] != 1} {
        ### Draw the Graph
        molUP::drawGraph 
    } else {
        ### Get the last structure
        molUP::energyLastStructureNotOniom
    } 
}


proc molUP::energy {} {
    if {$molUP::normalTermination == "YES" && [string is integer $molUP::stopLine] == 1} {
        catch {exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep "ONIOM: gridpoint" | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
    } else {
        catch {exec $molUP::grep "ONIOM: gridpoint" $molUP::path | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
	}

    if {$numberGridpoints == 3} {
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
        }
    } elseif {$numberGridpoints == 6} {
         ## Get All energies
        set energies [molUP::gettingEnergy3Layer $molUP::path]

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
            } elseif {$column3 == 4} {
                lappend molUP::listEnergies $value
            } elseif {$column3 == 5} {
                lappend molUP::listEnergies $value
            } elseif {$column3 == 6} {
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
                set highEnergy [lindex $molUP::listEnergies [expr $strut - 3]]
                set mediumEnergy [expr [lindex $molUP::listEnergies [expr $strut - 2]] - [lindex $molUP::listEnergies [expr $strut - 5]]]
                set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 4]] - [lindex $molUP::listEnergies [expr $strut - 6]]]
                set totalEnergy [expr $highEnergy + $mediumEnergy + $lowEnergy]
                set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy" "$mediumEnergy"]

                lappend molUP::listEnergiesOpt $list

                incr structure
            }

            foreach a $nonOptEnergy {
                set b [lsearch $optEnergy $a]
                lappend molUP::listEnergiesNonOpt [expr $b + 1]
            }
        }
    }

    
    if {[llength $molUP::listEnergiesOpt] != 1} {
        ### Draw the Graph
        molUP::drawGraph 
    } else {
        ### Get the last structure
        molUP::energyLastStructureOniom
    }
    
}

proc molUP::energyAll {} {
    if {$molUP::normalTermination == "YES" && [string is integer $molUP::stopLine] == 1} {
        catch {exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep "ONIOM: gridpoint" | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
    } else {
        catch {exec $molUP::grep "ONIOM: gridpoint" $molUP::path | $molUP::tail -n 1 | $molUP::cut -f5 -d \ } numberGridpoints
	}

    if {$numberGridpoints == 3} {

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

    } elseif {$numberGridpoints == 6} {
         ## Get All energies
        set energies [molUP::gettingEnergy3Layer $molUP::path]

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
            } elseif {$column3 == 4} {
                    lappend molUP::listEnergies $value
            } elseif {$column3 == 5} {
                    lappend molUP::listEnergies $value
            } elseif {$column3 == 6} {
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
            set highEnergy [lindex $molUP::listEnergies [expr $strut - 3]]
            set mediumEnergy [expr [lindex $molUP::listEnergies [expr $strut - 2]] - [lindex $molUP::listEnergies [expr $strut - 5]]]
            set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 4]] - [lindex $molUP::listEnergies [expr $strut - 6]]]
            set totalEnergy [expr $highEnergy + $mediumEnergy + $lowEnergy]
            set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy" "$mediumEnergy"]

            lappend molUP::listEnergiesOpt $list

            incr structure
        }
    }

    if {[llength $molUP::listEnergiesOpt] != 1} {
        ### Draw the Graph
        molUP::drawGraph 
    } else {
        ### Get the last structure
        molUP::energyLastStructureOniom
    }
}



### Procedures to grep the ONIOM energies from the file
proc molUP::gettingEnergy {File} {
        if {$molUP::normalTermination == "YES" && [string is integer $molUP::stopLine] == 1} {
            set energies [exec $molUP::head -n $molUP::stopLine $File | $molUP::grep -E -e "low   system:  model energy:" -e "high  system:  model energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters"]
        } else {
            set energies [exec $molUP::grep -E -e "low   system:  model energy:" -e "high  system:  model energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters" $File]
	    }
        return $energies
}

proc molUP::gettingEnergyLast {File} {
        if {$molUP::normalTermination == "YES" && [string is integer $molUP::stopLine] == 1} {
            set energies [exec $molUP::head -n $molUP::stopLine $File | $molUP::grep -E -e "low   system:  model energy:" -e "high  system:  model energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters" | $molUP::tail -n 5]
        } else {
            set energies [exec $molUP::grep -E -e "low   system:  model energy:" -e "high  system:  model energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters" $File | $molUP::tail -n 5]
	    }
        return $energies
}

proc molUP::gettingEnergy3Layer {File} {
        if {$molUP::normalTermination == "YES" && [string is integer $molUP::stopLine] == 1} {
            set energies [exec $molUP::head -n $molUP::stopLine $File | $molUP::grep -E -e "low   system:  model energy:" -e "med   system:  model energy:" -e "low   system:  mid   energy:" -e "high  system:  model energy:" -e "med   system:  mid   energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters"]
        } else {
            set energies [exec $molUP::grep -E -e "low   system:  model energy:" -e "med   system:  model energy:" -e "low   system:  mid   energy:" -e "high  system:  model energy:" -e "med   system:  mid   energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters" $File]
	    }
        return $energies
}

proc molUP::gettingEnergyLast3Layer {File} {
        if {$molUP::normalTermination == "YES" && [string is integer $molUP::stopLine] == 1} {
            set energies [exec $molUP::head -n $molUP::stopLine $File | $molUP::grep -E -e "low   system:  model energy:" -e "med   system:  model energy:" -e "low   system:  mid   energy:" -e "high  system:  model energy:" -e "med   system:  mid   energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters" | $molUP::tail -n 8]
        } else {
            set energies [exec $molUP::grep -E -e "low   system:  model energy:" -e "med   system:  model energy:" -e "low   system:  mid   energy:" -e "high  system:  model energy:" -e "med   system:  mid   energy:" -e "low   system:  real  energy:" -e "ONIOM: extrapolated energy" -e "Optimized Parameters" $File | $molUP::tail -n 8]
	    }
        return $energies
}





### Draw the Graph
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


    ### Choose which data must be plotted
    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.chooseDataToPlotLabel \
			-style molUP.white.TLabel \
			-text {Data } ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 333

    variable dataPlotted "Total Energy"
    variable layersInfoEnergy {"Total Energy"}

    place [ttk::combobox $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.chooseDataToPlot \
			-textvariable molUP::dataPlotted \
			-style molUP.TCombobox \
			-values "$molUP::layersInfoEnergy" \
			-state readonly \
			] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 40 -y 330 -width 150
	bind $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.chooseDataToPlot <<ComboboxSelected>> {molUP::rePlotGraph}


    ### Choose the Units
    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.unitsEnergyLabel \
			-style molUP.white.TLabel \
			-text {Energy units } ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 333

    variable energyUnit "Hartree"
    variable energyUnits {"Hartree" "kcal/mol" "kJ/mol" "eV"}
    place [ttk::combobox $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.unitsEnergy \
			-textvariable molUP::energyUnit \
			-style molUP.TCombobox \
			-values "$molUP::energyUnits" \
			-state readonly \
			] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 300 -y 330 -width 80
	bind $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.unitsEnergy <<ComboboxSelected>> {molUP::rePlotGraph}


    ### Energy value
    place [ttk::label $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.totalEnergyLabel \
		-style molUP.white.TLabel \
		-text {Energy} \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 360 -width 180


    variable totalEnergyValuePick "0.000000"

     place [ttk::entry $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.totalEnergy \
		-style molUP.TEntry \
		-textvariable molUP::totalEnergyValuePick \
        -state readonly \
        ] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 55 -y 358 -width 110

    place [ttk::button $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.copy \
        -style molUP.copyButton.TButton \
        -text "Copy to clipboard" \
		-command {clipboard clear; clipboard append [format %.7f $molUP::totalEnergyValuePick]} \
		] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 170 -y 360 -width 20 -height 20
    balloon $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.copy -text "Copy to clipboard"


    variable graphOriginToZero 0
    ### Set origin to zero
    place [ttk::checkbutton $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graphOriginToZero \
			-text "Set 0 for 1st structure" \
			-variable molUP::graphOriginToZero \
			-command {molUP::rePlotGraph} \
			-style molUP.white.TCheckbutton \
	] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 220 -y 360 -width 160
 

    ## Create a list for each variable
    variable structure[subst $molID] {}
    variable totalE[subst $molID] {}
    variable hlE[subst $molID] {}
    variable llE[subst $molID] {}
    variable mlE[subst $molID] {}

    foreach list $molUP::listEnergiesOpt {
        lappend structure[subst $molID] [lindex $list 0]
        lappend totalE[subst $molID] [lindex $list 1]
        lappend hlE[subst $molID] [lindex $list 2]
        lappend llE[subst $molID] [lindex $list 3]
        lappend mlE[subst $molID] [lindex $list 4]
    }

    set structure [subst $[subst molUP::structure$molID]]
    set totalE [subst $[subst molUP::totalE$molID]]
    set hlE [subst $[subst molUP::hlE$molID]]
    set llE [subst $[subst molUP::llE$molID]]
    set mlE [subst $[subst molUP::mlE$molID]]
    
    ## Draw the graph
    molUP::drawPlot $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph $structure $totalE "Energetic Profile" black 16 oval black black 7 "Energy\n(Hartree)"


    ## Check the ONIOM layers to plot data
    if {[lindex $hlE 0] != "" } {
        lappend layersInfoEnergy "High-level Layer Energy"
    } 
    if {[lindex $mlE 0] != "" } {
        lappend layersInfoEnergy "Medium-level Layer Energy"
    } 
    if {[lindex $llE 0] != "" } {
        lappend layersInfoEnergy "Low-level Layer Energy"
    }

    $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.chooseDataToPlot configure -values $molUP::layersInfoEnergy
}



### Update the plot considering the new configurations
proc molUP::rePlotGraph {} {
    set molID [molinfo top]

    ## Destroy the previous graph
    destroy $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph

    ## Draw the canvas again
    place [ttk::frame $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph \
            -width 380 \
            -height 250 \
	] -in $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6 -x 5 -y 5 -width 380 -height 250

    ## Plot new values
    if {$molUP::dataPlotted == "Total Energy" && $molUP::energyUnit == "Hartree"} {
        set structure [subst $[subst molUP::structure$molID]]
        set energy [subst $[subst molUP::totalE$molID]]
        set pointShape "oval"
        set energyUnitsLabel "Energy\n(Hartree)"
    } elseif {$molUP::dataPlotted == "High-level Layer Energy" && $molUP::energyUnit == "Hartree"} {
        set structure [subst $[subst molUP::structure$molID]]
        set energy [subst $[subst molUP::hlE$molID]]
        set pointShape "rectangle"
        set energyUnitsLabel "Energy\n(Hartree)"
    } elseif {$molUP::dataPlotted == "Medium-level Layer Energy" && $molUP::energyUnit == "Hartree"} {
        set structure [subst $[subst molUP::structure$molID]]
        set energy [subst $[subst molUP::mlE$molID]]
        set pointShape "rectangle"
        set energyUnitsLabel "Energy\n(Hartree)"
    } elseif {$molUP::dataPlotted == "Low-level Layer Energy" && $molUP::energyUnit == "Hartree"} {
        set structure [subst $[subst molUP::structure$molID]]
        set energy [subst $[subst molUP::llE$molID]]
        set pointShape "rectangle"
        set energyUnitsLabel "Energy\n(Hartree)"
    
    } elseif {$molUP::dataPlotted == "Total Energy" && $molUP::energyUnit == "kcal/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::totalE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 627.509391} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kcal/mol)"

    } elseif {$molUP::dataPlotted == "High-level Layer Energy" && $molUP::energyUnit == "kcal/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::hlE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 627.509391} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kcal/mol)"
    } elseif {$molUP::dataPlotted == "Medium-level Layer Energy" && $molUP::energyUnit == "kcal/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::mlE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 627.509391} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kcal/mol)"
    } elseif {$molUP::dataPlotted == "Low-level Layer Energy" && $molUP::energyUnit == "kcal/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::llE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 627.509391} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kcal/mol)"
    
    } elseif {$molUP::dataPlotted == "Total Energy" && $molUP::energyUnit == "kJ/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::totalE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 2625.5} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kJ/mol)"
    } elseif {$molUP::dataPlotted == "High-level Layer Energy" && $molUP::energyUnit == "kJ/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::hlE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 2625.5} newValue
            lappend energy $newValue
        }
    } elseif {$molUP::dataPlotted == "Medium-level Layer Energy" && $molUP::energyUnit == "kJ/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::mlE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 2625.5} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kJ/mol)"
    } elseif {$molUP::dataPlotted == "Low-level Layer Energy" && $molUP::energyUnit == "kJ/mol"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::llE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 2625.5} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(kJ/mol)"
    
    } elseif {$molUP::dataPlotted == "Total Energy" && $molUP::energyUnit == "eV"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::totalE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 27.2113845} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(eV)"
    } elseif {$molUP::dataPlotted == "High-level Layer Energy" && $molUP::energyUnit == "eV"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::hlE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 27.2113845} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(eV)"
    } elseif {$molUP::dataPlotted == "Medium-level Layer Energy" && $molUP::energyUnit == "eV"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::mlE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 27.2113845} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(eV)"
    } elseif {$molUP::dataPlotted == "Low-level Layer Energy" && $molUP::energyUnit == "eV"} {
        set structure [subst $[subst molUP::structure$molID]]
        set yy [subst $[subst molUP::llE$molID]]
        
        set energy {}
        set pointShape "oval"

        foreach value $yy {
            catch {expr $value * 27.2113845} newValue
            lappend energy $newValue
        }
        set energyUnitsLabel "Energy\n(eV)"

    } else {
        ## Do nothing
    }


    ## Check if the zero point option is on or off
    if {$molUP::graphOriginToZero == "1"} {
        set yy $energy

        set energy {}
        foreach value $yy {
            catch {expr $value - [lindex $yy 0]} newValue

            lappend energy $newValue
        }

    } else {
        # Do nothing
    }

    molUP::drawPlot $molUP::topGui.frame0.major.mol$molID.tabs.tabOutput.tabs.tab6.graph $structure $energy "Energetic Profile" black 16 $pointShape black black 7 $energyUnitsLabel

}


### Mouse click move the frame
proc molUP::mouseClick {x y} {
    animate goto [expr [format %.0f $x] - 1]
}



### Save the graph as a PostScript image
proc molUP::savePS {pathname} {
        set fileTypes {
                {{PostScript (.ps)}       {.ps}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".ps" -title "Save image" -initialfile "energy.ps"]

        if {$path != ""} {
            $pathname.plotBackground.area.canvas postscript -file [list $path]
        } else {}
}


### Export Energy Values to a texzt file
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



### Copy text to the clipboard
proc molUP::copyClipboardFromText {pathName} {
    clipboard clear
    set text [$pathName get 1.0 end]
    clipboard append $text
}