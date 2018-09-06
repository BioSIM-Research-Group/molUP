package provide guiModRedundant 1.5.1

proc molUP::guiModRed {} {
    #### Check if the window exists
	if {[winfo exists $::molUP::modRedundant]} {wm deiconify $::molUP::modRedundant ;return $::molUP::modRedundant}
	toplevel $::molUP::modRedundant
	wm attributes $::molUP::modRedundant -topmost yes

	#### Title of the windows
	wm title $molUP::modRedundant "ModRedudant Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::modRedundant] -0]
	set sHeight [expr [winfo vrootheight $::molUP::modRedundant] -50]

	#### Change the location of window
    wm geometry $::molUP::modRedundant 400x185+[expr $sWidth - 400]+100
	$::molUP::modRedundant configure -background {white}
	wm resizable $::molUP::modRedundant 0 0

	## Apply theme
	ttk::style theme use molUPTheme
	
    ### Varaibles
    variable modRedPickedAtoms {}



    #### Information
	pack [ttk::frame $molUP::modRedundant.frame0]
	pack [canvas $molUP::modRedundant.frame0.frame -bg white -width 400 -height 185 -highlightthickness 0] -in $molUP::modRedundant.frame0 



    ## Line One
    place [ttk::label $molUP::modRedundant.frame0.frame.scanLabel \
		    -text "Select the type of scan (bond, angle or dihedral):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 10 -y 12 -width 290

    variable modRedScanModeOption "Bond"

    place [ttk::combobox $molUP::modRedundant.frame0.frame.scanOptionsCombo \
		    -textvariable molUP::modRedScanModeOption \
            -values {"Bond" "Angle" "Dihedral"}\
            -state readonly \
			-style molUP.white.TCombobox \
		    ] -in $molUP::modRedundant.frame0.frame -x 300 -y 10 -width 90
    bind $molUP::modRedundant.frame0.frame.scanOptionsCombo <<ComboboxSelected>> {molUP::modRedChangeScanOpt}


    ## Line Two
    place [ttk::label $molUP::modRedundant.frame0.frame.atomsLabel \
		    -text "Atoms:" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 10 -y 62 -width 40


    variable atom1ModRedSel
    variable atom2ModRedSel
    variable atom3ModRedSel
    variable atom4ModRedSel

    place [ttk::entry $molUP::modRedundant.frame0.frame.atom1Index \
		        -textvariable {molUP::atom1ModRedSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::modRedundant.frame0.frame -x 60 -y 60 -width 55
    
    place [ttk::entry $molUP::modRedundant.frame0.frame.atom2Index \
		        -textvariable {molUP::atom2ModRedSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::modRedundant.frame0.frame -x 125 -y 60 -width 55

    place [ttk::entry $molUP::modRedundant.frame0.frame.atom3Index \
		        -textvariable {molUP::atom3ModRedSel} \
				-state disabled \
				-style molUP.TEntry \
		        ] -in $molUP::modRedundant.frame0.frame -x 190 -y 60 -width 55

    place [ttk::entry $molUP::modRedundant.frame0.frame.atom4Index \
		        -textvariable {molUP::atom4ModRedSel} \
				-state disabled \
				-style molUP.TEntry \
		        ] -in $molUP::modRedundant.frame0.frame -x 255 -y 60 -width 55

    # Pick atoms button
    place [ttk::button $molUP::modRedundant.frame0.frame.pickAtoms \
		            -text "Pick" \
					-style molUP.TButton \
		            -command {molUP::modRedPickAtoms} \
		            ] -in $molUP::modRedundant.frame0.frame -x 320 -y 60 -width 70


    ## Line Three
    place [ttk::label $molUP::modRedundant.frame0.frame.stepsLabel \
		    -text "Steps:" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 10 -y 102 -width 35

    variable modRedSteps "0"
    place [ttk::entry $molUP::modRedundant.frame0.frame.steps \
		        -textvariable {molUP::modRedSteps} \
				-state editable \
				-style molUP.TEntry \
		        ] -in $molUP::modRedundant.frame0.frame -x 55 -y 100 -width 45

    
    place [ttk::label $molUP::modRedundant.frame0.frame.sizeLabel \
		    -text "Size:" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 120 -y 102 -width 30

    variable modRedSize "0.0"

    place [ttk::entry $molUP::modRedundant.frame0.frame.size \
		        -textvariable {molUP::modRedSize} \
				-state editable \
				-style molUP.TEntry \
		        ] -in $molUP::modRedundant.frame0.frame -x 160 -y 100 -width 50

    place [ttk::label $molUP::modRedundant.frame0.frame.units \
		    -text "Angstroms" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 220 -y 102 -width 160


    ## Line Four
    place [ttk::button $molUP::modRedundant.frame0.frame.apply \
		            -text "Apply" \
					-style molUP.TButton \
		            -command {molUP::modRedApply} \
		            ] -in $molUP::modRedundant.frame0.frame -x 120 -y 150 -width 130

    place [ttk::button $molUP::modRedundant.frame0.frame.cancel \
		            -text "Cancel" \
					-style molUP.TButton \
		            -command {molUP::modRedCancel} \
		            ] -in $molUP::modRedundant.frame0.frame -x 260 -y 150 -width 130

}

proc molUP::modRedCancel {} {
    mol modselect 9 [lindex $molUP::topMolecule 0] "none"

    set molUP::atom1ModRedSel ""
    set molUP::atom2ModRedSel ""
    set molUP::atom3ModRedSel ""
    set molUP::atom4ModRedSel ""

    set molUP::modRedSize 0.0
    set molUP::modRedSteps 0

    destroy $::molUP::modRedundant
}


proc molUP::modRedChangeScanOpt {} {
    ## Update the GUI

    if {$molUP::modRedScanModeOption == "Bond"} {
        $molUP::modRedundant.frame0.frame.atom3Index configure -state disabled
        $molUP::modRedundant.frame0.frame.atom4Index configure -state disabled

        destroy $molUP::modRedundant.frame0.frame.units
        place [ttk::label $molUP::modRedundant.frame0.frame.units \
		    -text "Angstroms" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 220 -y 102 -width 160

    } elseif {$molUP::modRedScanModeOption == "Angle"} {
        $molUP::modRedundant.frame0.frame.atom3Index configure -state editable
        $molUP::modRedundant.frame0.frame.atom4Index configure -state disabled

        destroy $molUP::modRedundant.frame0.frame.units
        place [ttk::label $molUP::modRedundant.frame0.frame.units \
		    -text "Degrees" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 220 -y 102 -width 160

    } elseif {$molUP::modRedScanModeOption == "Dihedral"} {
        $molUP::modRedundant.frame0.frame.atom3Index configure -state editable
        $molUP::modRedundant.frame0.frame.atom4Index configure -state editable

        destroy $molUP::modRedundant.frame0.frame.units
        place [ttk::label $molUP::modRedundant.frame0.frame.units \
		    -text "Degrees" \
			-style molUP.white.TLabel \
		    ] -in $molUP::modRedundant.frame0.frame -x 220 -y 102 -width 160
    } else {
        #Do nothing
    }

    set molUP::modRedPickedAtoms {}
    mol modselect 9 [lindex $molUP::topMolecule 0] "none"

    set molUP::atom1ModRedSel ""
    set molUP::atom2ModRedSel ""
    set molUP::atom3ModRedSel ""
    set molUP::atom4ModRedSel ""

}


proc molUP::modRedPickAtoms {} {
    set molUP::modRedPickedAtoms {}
    mol modselect 9 [lindex $molUP::topMolecule 0] "none"

    set molUP::atom1ModRedSel ""
    set molUP::atom2ModRedSel ""
    set molUP::atom3ModRedSel ""
    set molUP::atom4ModRedSel ""


    ## Trace the variable to run a command each time a atom is picked
	    trace variable ::vmd_pick_atom w molUP::modRedPickAtomsSecond
		
		## Activate atom pick
		mouse mode pick

}

proc molUP::modRedPickAtomsSecond {args} {
    global vmd_pick_atom

    if {$molUP::modRedScanModeOption == "Bond"} {
        if {[llength $molUP::modRedPickedAtoms] == 0} {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom1ModRedSel [lindex $molUP::modRedPickedAtoms 0]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

        } else {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom2ModRedSel [lindex $molUP::modRedPickedAtoms 1]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

            trace remove variable ::vmd_pick_atom write molUP::modRedPickAtomsSecond
            mouse mode rotate
        }


    } elseif {$molUP::modRedScanModeOption == "Angle"} {
        if {[llength $molUP::modRedPickedAtoms] == 0} {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom1ModRedSel [lindex $molUP::modRedPickedAtoms 0]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

        } elseif {[llength $molUP::modRedPickedAtoms] == 1} {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom2ModRedSel [lindex $molUP::modRedPickedAtoms 1]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

        } else {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom3ModRedSel [lindex $molUP::modRedPickedAtoms 2]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

            trace remove variable ::vmd_pick_atom write molUP::modRedPickAtomsSecond
            mouse mode rotate
        }

    } elseif {$molUP::modRedScanModeOption == "Dihedral"} {
        if {[llength $molUP::modRedPickedAtoms] == 0} {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom1ModRedSel [lindex $molUP::modRedPickedAtoms 0]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

        } elseif {[llength $molUP::modRedPickedAtoms] == 1} {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom2ModRedSel [lindex $molUP::modRedPickedAtoms 1]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms


        } elseif {[llength $molUP::modRedPickedAtoms] == 2} {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom3ModRedSel [lindex $molUP::modRedPickedAtoms 2]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms
            
        } else {
            lappend molUP::modRedPickedAtoms $vmd_pick_atom
            set molUP::atom4ModRedSel [lindex $molUP::modRedPickedAtoms 3]
            mol modselect 9 [lindex $molUP::topMolecule 0] index $molUP::modRedPickedAtoms

            trace remove variable ::vmd_pick_atom write molUP::modRedPickAtomsSecond
            mouse mode rotate
        }
    } else {
        # Do nothing
    }

}


proc molUP::modRedApply {} {


    if {$molUP::modRedScanModeOption == "Bond"} {
    set lineToAdd "B [expr $molUP::atom1ModRedSel + 1] [expr $molUP::atom2ModRedSel + 1] S [format %.0f $molUP::modRedSteps] [format %.6f $molUP::modRedSize]\n"

    } elseif {$molUP::modRedScanModeOption == "Angle"} {
    set lineToAdd "A [expr $molUP::atom1ModRedSel + 1] [expr $molUP::atom2ModRedSel + 1]  [expr $molUP::atom3ModRedSel + 1] S [format %.0f $molUP::modRedSteps] [format %.6f $molUP::modRedSize]\n"

    } elseif {$molUP::modRedScanModeOption == "Dihedral"} {
    set lineToAdd "D [expr $molUP::atom1ModRedSel + 1] [expr $molUP::atom2ModRedSel + 1] [expr $molUP::atom3ModRedSel + 1] [expr $molUP::atom4ModRedSel + 1] S [format %.0f $molUP::modRedSteps] [format %.6f $molUP::modRedSize]\n"

    } else {
        #Do Nothing
    }


    ## Add line to 
    set molID [lindex $molUP::topMolecule 0]
    .molUP.frame0.major.mol$molID.tabs.tabInput.param insert 1.0 $lineToAdd


    ## Close the GUI
    molUP::modRedCancel

}