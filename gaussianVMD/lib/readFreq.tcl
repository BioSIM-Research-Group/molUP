package provide readFreq 1.0 

proc gaussianVMD::readFreq {} {
    gaussianVMD::readFreqFile $gaussianVMD::path
	#puts "$gaussianVMD::freqLine"
	#puts "$gaussianVMD::freqList"
	#puts "$gaussianVMD::irList"


	#### Create a new tab - Frequency
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList add [frame $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5] -text "Frequencies"

	# Frequencies Tab
	place [tablelist::tablelist $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer \
			-showeditcursor true \
			-columns {0 "Frequency Number" center 0 "Frequency (cm-1)" center 0 "Infrared" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.yscb set] \
			-xscrollcommand [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.xscb set] \
			-selectmode single \
			-height 14 \
			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5 -x 0 -y 0 -width 370 -height 300

	place [ttk::scrollbar $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.yscb \
			-orient vertical \
			-command [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer yview]\
			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5 -x 370 -y 0 -width 20 -height 300

	place [ttk::scrollbar $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.xscb \
			-orient horizontal \
			-command [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer xview]\
			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5 -x 0 -y 300 -height 20 -width 370

	place [ttk::button $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.clearSelection \
			-text "Clear Selection" \
			-command {gaussianVMD::clearSelectionFreq} \
			-style gaussianVMD.topButtons.TButton \
			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5 -x 5 -y 325 -width 380

	## Add each frequency to the table 
	set freqIndex 0
	foreach line $gaussianVMD::freqList lineIR $gaussianVMD::irList {
		foreach freq $line ir $lineIR {
			incr freqIndex
			$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer insert end [list \
		   			"$freqIndex" \
		   			"$freq" \
					"$ir"
		   			]
		}
	}

	## Run a command when a freq is selected
	bind $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer <<TablelistSelect>> {gaussianVMD::selectFreq}

}

proc gaussianVMD::readFreqFile {file} { 
	variable freqList
	variable freqLine
	variable irList

	set a [split [exec egrep -n "Frequencies --" $file] "\n"]
	set b [split [exec egrep -n "IR Inten    --" $file] "\n"]

	foreach line  $a {
        	set gaussianVMD::freqList [lappend gaussianVMD::freqList "[lindex $line 3] [lindex $line 4] [lindex $line 5]"]
        	set gaussianVMD::freqLine [lappend gaussianVMD::freqLine [lindex [split [lindex $line 0] ":"] 0]]
	}

	foreach line  $b {
        	set gaussianVMD::irList [lappend gaussianVMD::irList "[lindex $line 4] [lindex $line 5] [lindex $line 6]"]
	}

}

proc gaussianVMD::searchFreq {freq_value freq_list freq_line} {

	set line 0
	set answer ""
	foreach a $freq_list {
		set pos [lsearch $a $freq_value]
		if {$pos !=-1} {set answer "$line $pos"}
		incr line 
	}

return $answer
}

proc gaussianVMD::extractFreqVectors {file where} {

	set vectors [exec sed -n "[expr [lindex $gaussianVMD::freqLine [lindex $where 0]] +5], [expr [lindex $gaussianVMD::freqLine [expr [lindex $where 0]+1]]-3] p" $file]
	set vectors_split [split $vectors "\n"]

	set columnX [expr [lindex $where 1] +2 + [lindex $where 1]*2]
	set columnY [expr [lindex $where 1] +3 + [lindex $where 1]*2]
	set columnZ [expr [lindex $where 1] +4 + [lindex $where 1]*2]

	set freq_vector ""
	foreach a $vectors_split {
		set freq_vector [lappend list "[lindex $a 0] [lindex $a $columnX] [lindex $a $columnY] [lindex $a $columnZ]"]
	}

return $freq_vector
}

proc gaussianVMD::animateFreq {freqList} {
	# Delete previous animation
	animate delete beg 1 end 9999999 top

	# Animate stype rock
	animate style Loop

	#Animate Speed
	animate speed 1.00
	animate skip 3
	
	# Displacemente Factor
	set factor 0.015

	for {set index 0} { $index < 80 } { incr index } {
		animate dup top
		foreach freq $freqList {
			set displacement $factor
			set sel [atomselect top "index [expr [lindex $freq 0] -1 ]"]
			$sel moveby [list "[expr $displacement * [lindex $freq 1]]" "[expr $displacement * [lindex $freq 2]]" "[expr $displacement * [lindex $freq 3]]"]
		}
	}
	for {set index 0} { $index < 160 } { incr index } {
		animate dup top
		foreach freq $freqList {
			set displacement -$factor
			set sel [atomselect top "index [expr [lindex $freq 0] -1 ]"]
			$sel moveby [list "[expr $displacement * [lindex $freq 1]]" "[expr $displacement * [lindex $freq 2]]" "[expr $displacement * [lindex $freq 3]]"]
		}
	}
	for {set index 0} { $index < 80 } { incr index } {
		animate dup top
		foreach freq $freqList {
			set displacement $factor
			set sel [atomselect top "index [expr [lindex $freq 0] -1 ]"]
			$sel moveby [list "[expr $displacement * [lindex $freq 1]]" "[expr $displacement * [lindex $freq 2]]" "[expr $displacement * [lindex $freq 3]]"]
		}
	}

	animate forward

}

proc gaussianVMD::selectFreq {} {
	set indexSelectedAtoms [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer curselection]
	set freqLineTable [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab5.tableLayer get $indexSelectedAtoms]
	set freqToSearch [lindex $freqLineTable 1]

	set answer [gaussianVMD::searchFreq $freqToSearch $gaussianVMD::freqList $gaussianVMD::freqLine]

	## Get the list of freq vectors
	set freqVectorsList [gaussianVMD::extractFreqVectors $gaussianVMD::path $answer]
	
	## Draw vectors
	gaussianVMD::drawVectors $freqVectorsList

	## Animate Frequency
	gaussianVMD::animateFreq $freqVectorsList


	
}

proc gaussianVMD::clearSelectionFreq {} {
	# Pause animation
	animate pause

	# Delete previous animation
	animate delete beg 1 end 9999999 top

	# Delete all vectors
	graphics top delete all
}

proc gaussianVMD::drawVectors {freqList} {
	# Delete all vectors
	graphics top delete all

	graphics top color red
	
	set factor 3
	set displacement $factor
	
	foreach freq $freqList {
			set sel [atomselect top "index [expr [lindex $freq 0] -1 ]"]
			set x [$sel get x]
			set y [$sel get y]
			set z [$sel get z]
			set atomCoord [list "$x" "$y" "$z"]

			set vectorToScale [vecscale $displacement [list "[lindex $freq 1]" "[lindex $freq 2]" "[lindex $freq 3]"]]

			set lastPoint [vecadd $atomCoord $vectorToScale]
			graphics top cylinder $atomCoord $lastPoint radius 0.05 resolution 10 filled yes

			set vectorSize [veclength $vectorToScale]
			if {$vectorSize == 0} {
				set factorCone 0
			} else {
				set factorCone [expr 0.2 / $vectorSize]
			}
			#puts $factorCone
			#puts $$vectorToScale
			
			set vectorCone [vecscale $factorCone $vectorToScale]
			#puts $vectorCone
			set lastPointCone [vecadd $lastPoint $vectorCone]
			
			graphics top cone $lastPoint $lastPointCone radius 0.10 resolution 10

		}
}



