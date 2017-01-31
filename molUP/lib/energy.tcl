package provide energy 1.0
package require multiplot

proc molUP::energy {} {

    ## Get All energies
    set energies [molUP::gettingEnergy $molUP::path]

    ## Optimized Energies
	set lines [split $energies \n]

    ## Variable containing the list of energies for all structures
    variable listEnergies {}
    variable listEnergiesOpt {}
	
    foreach line $lines {
		lassign $line column1 column2 column3 column4 column5 column6 column7 column8 value
		
        if {$column3 == 1} {
            lappend molUP::listEnergies $value
		} elseif {$column3 == 2} {
			lappend molUP::listEnergies $value
		} elseif {$column3 == 3} {
			lappend molUP::listEnergies $value
		} elseif {[regexp {Optimized} $line -> optimizedLine]} {
			lappend molUP::listEnergies "optstructure"
		}

	}

    ## Search for optimized strcutures
    set optEnergy [lsearch -all $molUP::listEnergies "optstructure"]

    set structure 1
    foreach strut $optEnergy {
        set highEnergy [lindex $molUP::listEnergies [expr $strut - 2]]
        set lowEnergy [expr [lindex $molUP::listEnergies [expr $strut - 1]] - [lindex $molUP::listEnergies [expr $strut - 3]]]
        set totalEnergy [expr $highEnergy + $lowEnergy]
        set list [list "$structure" "$totalEnergy" "$highEnergy" "$lowEnergy"]

        lappend molUP::listEnergiesOpt $list

        incr structure
    }

    #puts $molUP::listEnergiesOpt

    molUP::drawGraph
}


proc molUP::gettingEnergy {File} {
        set energies [exec egrep {low   system:  model energy:|high  system:  model energy:|low   system:  real  energy:|ONIOM: extrapolated energy|Optimized Parameters} $File]
        return $energies
}

proc molUP::drawGraph {} {
    #### Create a new tab - Energies
	$molUP::topGui.frame0.major.tabs.tabResults.tabs add [frame $molUP::topGui.frame0.major.tabs.tabResults.tabs.tab6] -text "Energies"

    place [ttk::frame $molUP::topGui.frame0.major.tabs.tabResults.tabs.tab6.graph \
            -width 380 \
            -height 250 \
			] -in $molUP::topGui.frame0.major.tabs.tabResults.tabs.tab6 -x 5 -y 5 -width 380 -height 250


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


    ## Draw the graph
    molUP::drawPlot "$molUP::topGui.frame0.major.tabs.tabResults.tabs.tab6.graph" $structure $totalE "Energetic Profile" black 16 oval blue black 8

}