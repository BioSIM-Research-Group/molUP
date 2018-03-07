package provide guiAngleModif 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiAngleModif {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::angleModif]} {wm deiconify $::molUP::angleModif ;return $::molUP::angleModif}
	toplevel $::molUP::angleModif
	wm attributes $::molUP::angleModif -topmost yes

	#### Title of the windows
	wm title $molUP::angleModif "Angle Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::angleModif] -0]
	set sHeight [expr [winfo vrootheight $::molUP::angleModif] -50]

	#### Change the location of window
    wm geometry $::molUP::angleModif 400x260+[expr $sWidth - 400]+100
	$::molUP::angleModif configure -background {white}
	wm resizable $::molUP::angleModif 0 0

	## Apply theme
	ttk::style theme use molUPTheme

	wm protocol $::molUP::angleModif WM_DELETE_WINDOW {molUP::bondGuiCloseSave}

	

    #### Information
	pack [ttk::frame $molUP::angleModif.frame0]
	pack [canvas $molUP::angleModif.frame0.frame -bg white -width 400 -height 260 -highlightthickness 0] -in $molUP::angleModif.frame0 
        
    place [ttk::label $molUP::angleModif.frame0.frame.title \
		    -text {Three atoms were selected. You can adjust the angle.} \
			-style molUP.white.TLabel \
		    ] -in $molUP::angleModif.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $molUP::angleModif.frame0.frame.atom1 \
		    -text {Atom 1:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::angleModif.frame0.frame -x 10 -y 30 -width 60       

    place [ttk::entry $molUP::angleModif.frame0.frame.atom1Index \
		        -textvariable {molUP::atom1AngleSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::angleModif.frame0.frame -x 60 -y 30 -width 100

    place [ttk::label $molUP::angleModif.frame0.frame.atom1OptionsLabel \
		        -text {Options: } \
				-style molUP.white.TLabel \
		        ] -in $molUP::angleModif.frame0.frame -x 190 -y 30 -width 50
            
    place [ttk::combobox $molUP::angleModif.frame0.frame.atom1Options \
		        -textvariable {molUP::atom1AngleOpt} \
			    -state readonly \
				-style molUP.white.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms" "Custom"]"
		        ] -in $molUP::angleModif.frame0.frame -x 250 -y 30 -width 140

        
    place [ttk::label $molUP::angleModif.frame0.frame.atom2 \
		    -text {Atom 2:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::angleModif.frame0.frame -x 10 -y 60 -width 60

    place [ttk::entry $molUP::angleModif.frame0.frame.atom2Index \
		        -textvariable {molUP::atom2AngleSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::angleModif.frame0.frame -x 60 -y 60 -width 100


    place [ttk::label $molUP::angleModif.frame0.frame.atom3 \
		    -text {Atom 3:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::angleModif.frame0.frame -x 10 -y 90 -width 60

    place [ttk::entry $molUP::angleModif.frame0.frame.atom3Index \
		        -textvariable {molUP::atom3AngleSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::angleModif.frame0.frame -x 60 -y 90 -width 100

    place [ttk::label $molUP::angleModif.frame0.frame.atom3OptionsLabel \
		        -text {Options: } \
				-style molUP.white.TLabel \
		        ] -in $molUP::angleModif.frame0.frame -x 190 -y 90 -width 50
            
    place [ttk::combobox $molUP::angleModif.frame0.frame.atom3Options \
		        -textvariable {molUP::atom3AngleOpt} \
			    -state readonly \
				-style molUP.white.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms" "Custom"]"
		        ] -in $molUP::angleModif.frame0.frame -x 250 -y 90 -width 140


	place [ttk::label $molUP::angleModif.frame0.frame.customAtom1 \
		    -text "Custom Selection (Atom 1):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::angleModif.frame0.frame -x 10 -y 120 -width 180

	place [ttk::entry $molUP::angleModif.frame0.frame.customAtom1Entry \
		        -textvariable {molUP::customSelection1} \
				-style molUP.TEntry \
				-state disabled \
		        ] -in $molUP::angleModif.frame0.frame -x 200 -y 120 -width 190

	place [ttk::label $molUP::angleModif.frame0.frame.customAtom2 \
		    -text "Custom Selection (Atom 2):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::angleModif.frame0.frame -x 10 -y 150 -width 180

	place [ttk::entry $molUP::angleModif.frame0.frame.customAtom2Entry \
		        -textvariable {molUP::customSelection2} \
				-state disabled \
				-style molUP.TEntry \
		        ] -in $molUP::angleModif.frame0.frame -x 200 -y 150 -width 190

	place [scale $molUP::angleModif.frame0.frame.scaleBondDistance \
				-length 280 \
				-from {-180.00} \
				-to 180.00 \
				-resolution 0.01 \
				-variable {molUP::AngleValue} \
				-command {molUP::calcAngleDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $molUP::angleModif.frame0.frame -x 10 -y 180 -width 380


    place [ttk::label $molUP::angleModif.frame0.frame.distanceLabel \
				-text {Angle (°): } \
				-style molUP.white.TLabel \
		        ] -in $molUP::angleModif.frame0.frame -x 10 -y 213 -width 60

    place [spinbox $molUP::angleModif.frame0.frame.distance \
					-from {-180.00} \
					-to {180.00} \
					-increment 0.01 \
					-textvariable {molUP::AngleValue} \
					-command {molUP::calcAngleDistance $molUP::AngleValue} \
                    ] -in $molUP::angleModif.frame0.frame -x 80 -y 210 -width 100
                
    place [ttk::button $molUP::angleModif.frame0.frame.apply \
		            -text "Apply" \
					-style molUP.TButton \
		            -command {molUP::angleGuiCloseSave} \
		            ] -in $molUP::angleModif.frame0.frame -x 230 -y 210 -width 75
				
	place [ttk::button $molUP::angleModif.frame0.frame.cancel \
		            -text "Cancel" \
					-style molUP.TButton \
		            -command {molUP::angleGuiCloseNotSave} \
		            ] -in $molUP::angleModif.frame0.frame -x 315 -y 210 -width 75


	bind $molUP::angleModif.frame0.frame.distance <KeyPress> {molUP::calcAngleDistance $molUP::AngleValue}
	bind $molUP::angleModif.frame0.frame.distance <Leave> {molUP::calcAngleDistance $molUP::AngleValue}

	# Custom - Enable Entry
	bind $molUP::angleModif.frame0.frame.atom1Options <<ComboboxSelected>> {
		if {$molUP::atom1AngleOpt == "Custom"} {
			$molUP::angleModif.frame0.frame.customAtom1Entry configure -state normal
		} else {
			$molUP::angleModif.frame0.frame.customAtom1Entry configure -state disabled
		}
	}
	bind $molUP::angleModif.frame0.frame.atom3Options <<ComboboxSelected>> {
		if {$molUP::atom3AngleOpt == "Custom"} {
			$molUP::angleModif.frame0.frame.customAtom2Entry configure -state normal
		} else {
			$molUP::angleModif.frame0.frame.customAtom2Entry configure -state disabled
		}
	}
	if {$molUP::atom1AngleOpt == "Custom"} {
		$molUP::angleModif.frame0.frame.customAtom1Entry configure -state normal
	} else {
		$molUP::angleModif.frame0.frame.customAtom1Entry configure -state disabled
		set molUP::customSelection1 ""
	}

	if {$molUP::atom3AngleOpt == "Custom"} {
		$molUP::angleModif.frame0.frame.customAtom2Entry configure -state normal
	} else {
		$molUP::angleModif.frame0.frame.customAtom2Entry configure -state disabled
		set molUP::customSelection2 ""
	}

}