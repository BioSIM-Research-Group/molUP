package provide readFreq 1.0 

proc gaussianVMD::readFreq {} {
    gaussianVMD::readFreqFile $gaussianVMD::path



	#### Create a new tab - Frequency
	$gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs add [frame $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5] -text "Frequencies"

	# Frequencies Tab
	place [tablelist::tablelist $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer \
			-showeditcursor true \
			-columns {0 "Frequency Number" center 0 "Frequency (cm-1)" center 0 "Infrared" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.yscb set] \
			-xscrollcommand [list $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.xscb set] \
			-selectmode single \
			-height 14 \
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 0 -y 0 -width 370 -height 200

	place [ttk::scrollbar $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.yscb \
			-orient vertical \
			-command [list $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer yview]\
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 370 -y 0 -width 20 -height 200

	place [ttk::scrollbar $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.xscb \
			-orient horizontal \
			-command [list $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer xview]\
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 0 -y 200 -height 20 -width 370

	place [ttk::button $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.clearSelection \
			-text "Clear Selection" \
			-command {gaussianVMD::clearSelectionFreq} \
			-style gaussianVMD.topButtons.TButton \
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 5 -y 225 -width 380

	place [ttk::label $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.animFreq \
			-text "Animation Frequency: " \
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 5 -y 265 -width 120

	variable animationFreq 3
	variable displacement 0.015
	variable freqVectorsList {}
	place [scale $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.animFreqSlider \
				-from 1 \
				-to 10 \
				-resolution 1 \
				-variable {gaussianVMD::animationFreq} \
				-command {gaussianVMD::animateFreq $gaussianVMD::freqVectorsList $gaussianVMD::animationFreq $gaussianVMD::displacement} \
				-orient horizontal \
				-showvalue 0 \
				] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 130 -y 265 -width 255

	place [ttk::label $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.displacement \
			-text "Displacement: " \
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 5 -y 300 -width 80

	place [scale $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.displacementSlided \
				-from 0.001 \
				-to 0.050 \
				-resolution 0.001 \
				-variable {gaussianVMD::displacement} \
				-command {gaussianVMD::animateFreq $gaussianVMD::freqVectorsList $gaussianVMD::animationFreq $gaussianVMD::displacement} \
				-orient horizontal \
				-showvalue 0 \
				] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 90 -y 300 -width 295

	variable showVectors 0
	variable vectorDrawScale 3
	place [ttk::checkbutton $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.showVector \
			-text "Show vectors" \
			-variable {gaussianVMD::showVectors} \
			-command {gaussianVMD::drawVectors $gaussianVMD::freqVectorsList none} \
			-style gaussianVMD.QuickRep.TCheckbutton \
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 5 -y 335 -width 165

	place [ttk::label $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.vectorScaleLabel \
			-text "Scale: " \
			] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 180 -y 335 -width 40

	place [scale $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.vectorScale \
				-from 0.1 \
				-to 10.0 \
				-resolution 0.1 \
				-variable {gaussianVMD::vectorDrawScale} \
				-command {gaussianVMD::drawVectors $gaussianVMD::freqVectorsList} \
				-orient horizontal \
				-showvalue 0 \
				] -in $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5 -x 220 -y 335 -width 165




	## Add each frequency to the table 
	set freqIndex 0
	foreach line $gaussianVMD::freqList lineIR $gaussianVMD::irList {
		foreach freq $line ir $lineIR {
			incr freqIndex
			$gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer insert end [list \
		   			"$freqIndex" \
		   			"$freq" \
					"$ir"
		   			]
		}
	}

	## Run a command when a freq is selected
	bind $gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer <<TablelistSelect>> {gaussianVMD::selectFreq}

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

proc gaussianVMD::animateFreq {freqList animationFreq displacement a} {
	# Delete previous animation
	animate delete beg 1 end 9999999 top

	# Animate stype rock
	animate style Loop

	#Animate Speed
	animate speed 1.00
	animate skip $gaussianVMD::animationFreq

	set factor $gaussianVMD::displacement


	for {set index 0} { $index < 40 } { incr index } {
		animate dup top
		foreach freq $freqList {
			set displacement $factor
			set sel [atomselect top "index [expr [lindex $freq 0] -1 ]"]
			$sel moveby [list "[expr $displacement * [lindex $freq 1]]" "[expr $displacement * [lindex $freq 2]]" "[expr $displacement * [lindex $freq 3]]"]
		}
	}
	for {set index 0} { $index < 80 } { incr index } {
		animate dup top
		foreach freq $freqList {
			set displacement -$factor
			set sel [atomselect top "index [expr [lindex $freq 0] -1 ]"]
			$sel moveby [list "[expr $displacement * [lindex $freq 1]]" "[expr $displacement * [lindex $freq 2]]" "[expr $displacement * [lindex $freq 3]]"]
		}
	}
	for {set index 0} { $index < 40 } { incr index } {
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
	set indexSelectedAtoms [$gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer curselection]
	set freqLineTable [$gaussianVMD::topGui.frame0.major.tabs.tabResults.tabs.tab5.tableLayer get $indexSelectedAtoms]
	set freqToSearch [lindex $freqLineTable 1]

	set answer [gaussianVMD::searchFreq $freqToSearch $gaussianVMD::freqList $gaussianVMD::freqLine]

	## Get the list of freq vectors
	set gaussianVMD::freqVectorsList [gaussianVMD::extractFreqVectors $gaussianVMD::path $answer]
	
	## Draw vectors
	gaussianVMD::drawVectors $gaussianVMD::freqVectorsList none

	## Animate Frequency
	gaussianVMD::animateFreq $gaussianVMD::freqVectorsList $gaussianVMD::animationFreq $gaussianVMD::displacement "none"


	
}

proc gaussianVMD::clearSelectionFreq {} {
	# Pause animation
	animate pause

	# Delete previous animation
	animate delete beg 1 end 9999999 top

	# Delete all vectors
	graphics top delete all
}

proc gaussianVMD::drawVectors {freqList none} {

	if {$gaussianVMD::showVectors == 0} {
		graphics top delete all
		
	} else {

	

	# Delete all vectors
	graphics top delete all

	graphics top color red
	
	set displacement $gaussianVMD::vectorDrawScale
	
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
			
			set vectorCone [vecscale $factorCone $vectorToScale]
			set lastPointCone [vecadd $lastPoint $vectorCone]
			
			graphics top cone $lastPoint $lastPointCone radius 0.10 resolution 10

		}

	}
}



