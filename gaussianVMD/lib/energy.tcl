package provide energy 1.0
package require multiplot

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
			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6 -x 5 -y 5 -width 380 -height 250


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

    set plot [multiplot embed $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph -xsize 340 -ysize 200]

    set sortedList [lsort $totalE]
    set ymax [expr [format %.2f [lindex $sortedList 0]] + 0.01]
    set ymin [expr [format %.2f [lindex $sortedList end]] - 0.01]
    set xmax [expr [lindex $structure end]]

    ## Add variables to Plot
    $plot configure \
        -x $structure \
        -y $totalE \
        -marker circle \
        -radius 4 \
        -fillcolor black \
        -dash . \
        -linewidth 1 \
        -linecolor black \
        -xsize 380 \
        -ysize 180 \
        -title "Energetic Profile" \
        -xmin "1" \
        -xmax "$xmax" \
        -xmajortics 1 \
        -xmasminortics 0 \
        -ymin "$ymin" \
        -ymax "$ymax" \
        -callback gaussianVMD::clickTotalE
    
    $plot replot
   
    $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph.plotwindow0.f.cf configure -yscrollcommand {} -xscrollcommand {}
    destroy $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph.plotwindow0.f.y
    destroy $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph.plotwindow0.f.x
    destroy $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab6.graph.plotwindow0.menubar

}


proc gaussianVMD::clickTotalE {index x y color marker} {
    animate goto $index
}