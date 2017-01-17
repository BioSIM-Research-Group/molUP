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


    #foreach line $lines {
	#	if {[regexp {optstucture} $line -> foundOPT]} {
	#		lassign $line column1 column2 column3 column4
    #        lappend gaussianVMD::listEnergies [list "$struct" "$column4" "$column2" "[expr $column3 - $column1]" ]
	#	}
	#    incr struct
    #}

    puts $gaussianVMD::listEnergiesOpt
}


proc gaussianVMD::gettingEnergy {File} {
        set energies [exec egrep {low   system:  model energy:|high  system:  model energy:|low   system:  real  energy:|ONIOM: extrapolated energy|Optimized Parameters} $File]
        return $energies
}