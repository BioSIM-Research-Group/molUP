package provide energy 1.0

proc gaussianVMD::energy {} {

    ## Get All energies
    set energies [gaussianVMD::gettingEnergy $gaussianVMD::path]

    ## Optimized Energies
	set lines [split $energies \n]

    ## Variable containing the list of energies for all structures
    variable listEnergies {}
    variable listEnergiesOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value
		
        if {$column3 == 1} {
            lappend gaussianVMD::listEnergies $value
		} elseif {$column3 == 2} {
			lappend gaussianVMD::listEnergies $value
		} elseif {$column3 == 3} {
			lappend gaussianVMD::listEnergies $value
		} elseif {[regexp {Optimized} $line -> optimizedLine]} {
			lappend gaussianVMD::listEnergies "optstructure"
		}

	}

    ## Search for optimized strcutures
    set optEnergy [lsearch -all $gaussianVMD::listEnergies "optstructure"]

    set structure 1
    foreach strut $optEnergy {
        set highEnergy [lindex $gaussianVMD::listEnergies [expr $strut - 2]]
        set lowEnergy [expr [lindex $gaussianVMD::listEnergies [expr $strut - 1]] - [lindex $gaussianVMD::listEnergies [expr $strut - 3]]]
        set totalEnergy [expr $highEnergy + $lowEnergy]
        set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy"]

        lappend gaussianVMD::listEnergiesOpt $list

        incr structure
    }

    #puts $gaussianVMD::listEnergiesOpt

    gaussianVMD::drawGraph
}


proc gaussianVMD::gettingEnergy {File} {
        set energies [exec egrep {low   system:  model energy:|high  system:  model energy:|low   system:  real  energy:|ONIOM: extrapolated energy|Optimized Parameters} $File]
        return $energies
}

proc gaussianVMD::drawGraph {} {
    #### Create a new tab - Energies
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList add [frame $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6] -text "Energies"

    place [ttk::frame $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph \
			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6 -x 0 -y 0 -width 370 -height 200

    ## Create a list for each variable
    set structure {}
    set totalE {}
    set hlE {}
    set llE {}
    foreach list $gaussianVMD::listEnergiesOpt {
        lappend structure [lindex $list 0]
        lappend totalE [lindex $list 1]
        lappend hlE [lindex $list 2]
        lappend llE [lindex $list 3]
    }

    puts "$structure \n $totalE \n $hlE \n $llE"

    #multiplot embed $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph

    ## Add variables to Plot
    set plothandle [multiplot -x $structure -y $totalE -title "Energetic Profile" -lines -linewidth 5 -marker circle -autoscale -plot]
    #$plothandle add $x $hlE
    #$plothandle add $x $llE

    ## Place Plot

}