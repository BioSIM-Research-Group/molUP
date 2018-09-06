package provide guiBADparam 1.5.1
package require Tk


proc molUP::badParams {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::topGui.badParams]} {wm deiconify $::molUP::topGui.badParams ; molUP::badPickAtom; return $::molUP::topGui.badParams}
	toplevel $::molUP::topGui.badParams
	wm attributes $::molUP::topGui.badParams -topmost yes

	#### Title of the window
	wm title $::molUP::topGui.badParams "Measure Bond, Angle and Dihedral Angles" ;# titulo da pagina
	wm resizable $::molUP::topGui.badParams 0 0

	## Apply theme
	ttk::style theme use molUPTheme


    #### GUI

		## Frame 0 - LABELS
		grid [ttk::frame $::molUP::topGui.badParams.frame0] -row 1 -column 0 -padx 1 -pady 1 -sticky news
		

			grid [ttk::label $::molUP::topGui.badParams.frame0.label0 -text "Click on Atoms of the VMD window to get Bond, Angle and \nDihedral parameters."] \
				-in $::molUP::topGui.badParams.frame0 \
				-row 0 -column 0
						

		## Frame 1  - BAD PARABETERS
		grid [ttk::frame $::molUP::topGui.badParams.frame1] -row 0 -column 0 -padx 1 -pady 1 -sticky news


			# LABELS
			
			foreach a "Param Atom Index Type Resid Value Units" column "0 1 2 3 4 5 6" {

			grid [ttk::label $::molUP::topGui.badParams.frame1.label_$a -text "$a"] \
				-in $::molUP::topGui.badParams.frame1 \
				-row 0 -column $column
						
			}
						
			# BAD PARAMETERS	
			
			foreach a "None Bond Angle Dihedral" row "1 2 3 4" {
				
				
				
				# label BOND ANGLE DIHEDRAL
				if {$a=="None"} {
				grid [ttk::label $::molUP::topGui.badParams.frame1.label_$a -text ""] \
					-in $::molUP::topGui.badParams.frame1 \
					-row $row -column 0
				} else {
				grid [ttk::label $::molUP::topGui.badParams.frame1.label_$a -text "$a"] \
									-in $::molUP::topGui.badParams.frame1 \
									-row $row -column 0
				}
				
				# entry Label 
				grid [ttk::label $::molUP::topGui.badParams.frame1.label1_$a -text $row] \
				-in $::molUP::topGui.badParams.frame1 \
				-row $row -column 1		
				
				# entry Index 
				grid [ttk::entry $::molUP::topGui.badParams.frame1.entryIndex_$a -width 5 -style molUP.TEntry] \
					-in $::molUP::topGui.badParams.frame1 \
					-row $row -column 2 -padx 1 -pady 1

				# entry 1 - INDEX SELECTION
				grid [ttk::entry $::molUP::topGui.badParams.frame1.entryAtom_$a -width 5 -style molUP.TEntry] \
					-in $::molUP::topGui.badParams.frame1 \
					-row $row -column 3 -padx 1 -pady 1	
					
					
				# entry 3 - INDEX SELECTION
				grid [ttk::entry $::molUP::topGui.badParams.frame1.entryResid_$a -width 5 -style molUP.TEntry] \
					-in $::molUP::topGui.badParams.frame1 \
					-row $row -column 4 -padx 1 -pady 1	



				if {$row>=2} {
				
					# entry 2 DISTANCE, ANGLE, DIHEDRAL
					grid [ttk::entry $::molUP::topGui.badParams.frame1.entryValue_$a -width 10 -style molUP.TEntry] \
						-in $::molUP::topGui.badParams.frame1 \
						-row $row -column 5 -padx 1 -pady 1	
		
		
					# Units
					if {$row==3 || $row==4} {set text "Degrees"
					} else {set text "Angstroms"}
					
					grid [ttk::label $::molUP::topGui.badParams.frame1.units_$a -text $text] \
					-in $::molUP::topGui.badParams.frame1 \
					-row $row -column 6 -sticky w
					
				}
				
			}
			
		## Frame 2 - Buttons
		grid [ttk::frame $::molUP::topGui.badParams.frame2] -row 2 -column 0 -padx 1 -pady 1 -sticky news
				
				grid [ttk::button $::molUP::topGui.badParams.frame2.button_1 -text "Close" \
							-command {mouse mode rotate;trace vdelete ::vmd_pick_atom w molUP::atomPickedBAD; wm withdraw $::molUP::topGui.badParams;
							    if {[winfo exists $::molUP::topGui.badParams]} {wm withdraw $::molUP::topGui.badParams}} \
                                -style molUP.TButton \
                                ] -in $::molUP::topGui.badParams.frame2 \
							-row 0 -column 3 -pady 10 -padx 20
							
				grid [ttk::button $::molUP::topGui.badParams.frame2.button_2 -text "Assign Atoms" \
					-command {mouse mode pick} \
                    -style molUP.TButton \
                    ] -in $::molUP::topGui.badParams.frame2 \
					-row 0 -column 1 -pady 10 -padx 20
											
											
				grid [ttk::button $::molUP::topGui.badParams.frame2.button_3 -text "Delete Data" \
					-command {molUP::deleteAll} \
                    -style molUP.TButton \
                    ] -in $::molUP::topGui.badParams.frame2 \
					-row 0 -column 2 -pady 10 -padx 20
	
	
	
	label textthickness 2
	molUP::badPickAtom
				
}


proc molUP::badPickAtom {} {
	
		## Trace the variable to run a command each time a atom is picked
	    trace variable ::vmd_pick_atom w molUP::atomPickedBAD
		
		## Activate atom pick
		mouse mode pick
}


proc molUP::deleteAll {} {
	
	
		$::molUP::topGui.badParams.frame1.entryIndex_None delete 0 end
		$::molUP::topGui.badParams.frame1.entryAtom_None delete 0 end
		$::molUP::topGui.badParams.frame1.entryResid_None delete 0 end
		
		$::molUP::topGui.badParams.frame1.entryIndex_Bond delete 0 end
		$::molUP::topGui.badParams.frame1.entryAtom_Bond delete 0 end
		$::molUP::topGui.badParams.frame1.entryResid_Bond delete 0 end
		$::molUP::topGui.badParams.frame1.entryValue_Bond delete 0 end
				 
		$::molUP::topGui.badParams.frame1.entryIndex_Angle delete 0 end
		$::molUP::topGui.badParams.frame1.entryAtom_Angle delete 0 end
		$::molUP::topGui.badParams.frame1.entryResid_Angle delete 0 end
		$::molUP::topGui.badParams.frame1.entryValue_Angle delete 0 end 
		
		$::molUP::topGui.badParams.frame1.entryIndex_Dihedral delete 0 end
		$::molUP::topGui.badParams.frame1.entryAtom_Dihedral delete 0 end
		$::molUP::topGui.badParams.frame1.entryResid_Dihedral delete 0 end
		$::molUP::topGui.badParams.frame1.entryValue_Dihedral delete 0 end
		
		
		# clean graphics
		foreach a $molUP::graphicsID {
			foreach b $a {
				graphics [molinfo [lindex $molUP::topMolecule 0]] delete $b
			}
		} 
		
		#delete labels
		
		label delete Atoms all 
		label delete Bonds all 
		label delete Angles all 
		label delete Dihedrals all 
				
		
		# delete data
		set molUP::graphicsID ""
		set molUP::pickedAtomsBAD ""

	
}

proc molUP::atomPickedBAD {args} {
	
	
	if {[lsearch $molUP::pickedAtomsBAD $::vmd_pick_atom]==-1} {


		if {[llength $molUP::pickedAtomsBAD]>=4 || [llength $molUP::pickedAtomsBAD]==0} {
		
		
		#Delete Index Atom Resid Param Value Check
		molUP::deleteAll
	
		# Add the first atom	
		set molUP::pickedAtomsBAD $::vmd_pick_atom
	
	
	} else {lappend molUP::pickedAtomsBAD $::vmd_pick_atom}
	
	
	# Put Values in the correct place
	
	if {[llength $molUP::pickedAtomsBAD]==1} {
		
		# First Atom
		$::molUP::topGui.badParams.frame1.entryIndex_None insert 0 "[lindex $molUP::pickedAtomsBAD 0]"
		set sel [atomselect [lindex $molUP::topMolecule 0] "index [lindex $molUP::pickedAtomsBAD 0]"] 
		$::molUP::topGui.badParams.frame1.entryAtom_None insert 0 "[$sel get name]"
		$::molUP::topGui.badParams.frame1.entryResid_None insert 0 "[$sel get resid]"	
		# Draw
			set mem [molUP::sphere [lindex $molUP::pickedAtomsBAD 0] red]
		
		set molUP::graphicsID [lappend molUP::graphicsID "$mem"]

				


	} elseif {[llength $molUP::pickedAtomsBAD]==2} {
		
		
		#BOND
		$::molUP::topGui.badParams.frame1.entryIndex_Bond insert 0 "[lindex $molUP::pickedAtomsBAD 1]"
		set sel [atomselect [lindex $molUP::topMolecule 0] "index [lindex $molUP::pickedAtomsBAD 1]"] 
		$::molUP::topGui.badParams.frame1.entryAtom_Bond insert 0 "[$sel get name]"
		$::molUP::topGui.badParams.frame1.entryResid_Bond insert 0 "[$sel get resid]"
	
		# Value
		set value [strictformat %7.2f [measure bond  "[lindex $molUP::pickedAtomsBAD 0] [lindex $molUP::pickedAtomsBAD 1]"] ]
		$::molUP::topGui.badParams.frame1.entryValue_Bond insert 0 "$value"
		label add Bonds [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 0] [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 1]


		# Draw
		set mem [molUP::sphere [lindex $molUP::pickedAtomsBAD 1] white]
		set mem1 [molUP::line [lindex $molUP::pickedAtomsBAD 0] [lindex $molUP::pickedAtomsBAD 1] white]
		
		
		set molUP::graphicsID [lappend molUP::graphicsID "$mem $mem1"]

	

	} elseif {[llength $molUP::pickedAtomsBAD]==3} {
		
		#ANGLE
		
		$::molUP::topGui.badParams.frame1.entryIndex_Angle insert 0 "[lindex $molUP::pickedAtomsBAD 2]"
		
		set sel [atomselect [lindex $molUP::topMolecule 0] "index [lindex $molUP::pickedAtomsBAD 2]"] 
		$::molUP::topGui.badParams.frame1.entryAtom_Angle insert 0 "[$sel get name]"
		$::molUP::topGui.badParams.frame1.entryResid_Angle insert 0 "[$sel get resid]"
		
		# Value
		set value [strictformat %7.2f [measure angle "[lindex $molUP::pickedAtomsBAD 0] [lindex $molUP::pickedAtomsBAD 1] [lindex $molUP::pickedAtomsBAD 2]"] ]
		$::molUP::topGui.badParams.frame1.entryValue_Angle insert 0 "$value"
		
		label add Angles [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 0] [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 1] [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 2]

		
		# Draw
		
		set mem [molUP::sphere [lindex $molUP::pickedAtomsBAD 2] yellow]
		set mem1 [molUP::triangle [lindex $molUP::pickedAtomsBAD 0] [lindex $molUP::pickedAtomsBAD 1] [lindex $molUP::pickedAtomsBAD 2] yellow]
		
		
		set molUP::graphicsID [lappend molUP::graphicsID "$mem $mem1"]
		
	} elseif {[llength $molUP::pickedAtomsBAD]==4} {
		
		#DIHEDRAL
		
		$::molUP::topGui.badParams.frame1.entryIndex_Dihedral insert 0 "[lindex $molUP::pickedAtomsBAD 3]"
		
		set sel [atomselect [lindex $molUP::topMolecule 0] "index [lindex $molUP::pickedAtomsBAD 3]"] 
		$::molUP::topGui.badParams.frame1.entryAtom_Dihedral insert 0 "[$sel get name]"
		$::molUP::topGui.badParams.frame1.entryResid_Dihedral insert 0 "[$sel get resid]"
	
	
		# value
		set value [strictformat %7.2f [measure dihed "[lindex $molUP::pickedAtomsBAD 0] [lindex $molUP::pickedAtomsBAD 1] [lindex $molUP::pickedAtomsBAD 2] [lindex $molUP::pickedAtomsBAD 3]"] ]
		$::molUP::topGui.badParams.frame1.entryValue_Dihedral insert 0 "$value"
		
		label add Dihedrals [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 0] [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 1] [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 2]  [molinfo [lindex $molUP::topMolecule 0]]/[lindex $molUP::pickedAtomsBAD 3]
		
		# Draw
		set mem [molUP::sphere [lindex $molUP::pickedAtomsBAD 3] cyan]
		#set mem1 [molUP::triangle [lindex $molUP::pickedAtomsBAD 1] [lindex $molUP::pickedAtomsBAD 2] [lindex $molUP::pickedAtomsBAD 3] cyan]
		set mem2 [molUP::cylinder [lindex $molUP::pickedAtomsBAD 1] [lindex $molUP::pickedAtomsBAD 2] cyan]
		
		
		set molUP::graphicsID [lappend molUP::graphicsID "$mem $mem2"]
	}
	
	
	
	}
}



proc molUP::strictformat {fmt value} {
    set f [format $fmt $value]
    regexp {%(\d+)} $fmt -> maxwidth
    if {[string length $f] > $maxwidth} {
        return [string repeat * $maxwidth]
    } else {
        return $f
    }
}


proc molUP::sphere {selection color} {	
	set coordinates [[atomselect [lindex $molUP::topMolecule 0] "index $selection"] get {x y z}]
	
	# Draw a circle around the coordinate
	draw color $color
	draw material Transparent
	set a [graphics [molinfo [lindex $molUP::topMolecule 0]] sphere "[lindex $coordinates 0] [lindex $coordinates 1] [lindex $coordinates 2]" radius 0.9 resolution 25]
	
	return  $a
	
}


proc molUP::line {selection0 selection1 color } {

	set coordinates0 [[atomselect [lindex $molUP::topMolecule 0] "index $selection0"] get {x y z}]
	set coordinates1 [[atomselect [lindex $molUP::topMolecule 0] "index $selection1"] get {x y z}]
	
	# Draw line
	draw color $color
	set a [graphics [molinfo [lindex $molUP::topMolecule 0]] line "[lindex $coordinates0 0] [lindex $coordinates0 1] [lindex $coordinates0 2]" "[lindex $coordinates1 0] [lindex $coordinates1 1] [lindex $coordinates1 2]" width 5 style dashed]
	
	# Add text
	#set b [graphics 0 text "[lindex $coordinates0 0] [lindex $coordinates0 1] [lindex $coordinates0 2]" "$value Angstroms"]
	
	return  "$a"


}


proc molUP::triangle {selection0 selection1 selection2 color } {
	set coordinates0 [[atomselect [lindex $molUP::topMolecule 0] "index $selection0"] get {x y z}]
	set coordinates1 [[atomselect [lindex $molUP::topMolecule 0] "index $selection1"] get {x y z}]
	set coordinates2 [[atomselect [lindex $molUP::topMolecule 0] "index $selection2"] get {x y z}]

	
	# Draw line
	
	draw color $color
	set a [graphics [molinfo [lindex $molUP::topMolecule 0]] triangle "[lindex $coordinates0 0] [lindex $coordinates0 1] [lindex $coordinates0 2]" "[lindex $coordinates1 0] [lindex $coordinates1 1] [lindex $coordinates1 2]" "[lindex $coordinates2 0] [lindex $coordinates2 1] [lindex $coordinates2 2]"]
	
	return  "$a"
}


proc molUP::cylinder {selection0 selection1 color} {
	set coordinates0 [[atomselect [lindex $molUP::topMolecule 0] "index $selection0"] get {x y z}]
	set coordinates1 [[atomselect [lindex $molUP::topMolecule 0] "index $selection1"] get {x y z}]

	# Draw
	
	draw color $color
	set a [graphics [molinfo [lindex $molUP::topMolecule 0]] cylinder "[lindex $coordinates0 0] [lindex $coordinates0 1] [lindex $coordinates0 2]" "[lindex $coordinates1 0] [lindex $coordinates1 1] [lindex $coordinates1 2]"  radius 0.5 resolution 50]
	
	# Add graphics that will be deleted
	return  $a
	
}

