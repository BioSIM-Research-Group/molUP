package provide guiBondModif 1.5.1
package require Tk

#### GUI ############################################################
proc molUP::guiBondModif {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::bondModif]} {wm deiconify $::molUP::bondModif ;return $::molUP::bondModif}
	toplevel $::molUP::bondModif
	wm attributes $::molUP::bondModif -topmost yes

	#### Title of the windows
	wm title $molUP::bondModif "Bond Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::bondModif] -0]
	set sHeight [expr [winfo vrootheight $::molUP::bondModif] -50]

	#### Change the location of window
    wm geometry $::molUP::bondModif 400x220+[expr $sWidth - 400]+100
	$::molUP::bondModif configure -background {white}
	wm resizable $::molUP::bondModif 0 0


	## Apply theme
	ttk::style theme use molUPTheme

	wm protocol $::molUP::bondModif WM_DELETE_WINDOW {molUP::bondGuiCloseSave}

	

    #### Information
	pack [ttk::frame $molUP::bondModif.frame0]
	pack [canvas $molUP::bondModif.frame0.frame -bg white -width 400 -height 220 -highlightthickness 0] -in $molUP::bondModif.frame0 
        
    place [ttk::label $molUP::bondModif.frame0.frame.title \
		    -text {Two atoms were selected. You can adjust the bond distance.} \
			-style molUP.white.TLabel \
		    ] -in $molUP::bondModif.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $molUP::bondModif.frame0.frame.atom1 \
		    -text {Atom 1:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::bondModif.frame0.frame -x 10 -y 30 -width 60

    place [ttk::entry $molUP::bondModif.frame0.frame.atom1Index \
		        -textvariable {molUP::atom1BondSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::bondModif.frame0.frame -x 60 -y 30 -width 100

    place [ttk::label $molUP::bondModif.frame0.frame.atom1OptionsLabel \
		        -text {Options: } \
				-style molUP.white.TLabel \
		        ] -in $molUP::bondModif.frame0.frame -x 190 -y 30 -width 50
            
    place [ttk::combobox $molUP::bondModif.frame0.frame.atom1Options \
		        -textvariable {molUP::atom1BondOpt} \
			    -state readonly \
				-style molUP.white.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms" "Custom"]"
		        ] -in $molUP::bondModif.frame0.frame -x 250 -y 30 -width 140

        
    place [ttk::label $molUP::bondModif.frame0.frame.atom2 \
		    -text {Atom 2:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::bondModif.frame0.frame -x 10 -y 60 -width 60

    place [ttk::entry $molUP::bondModif.frame0.frame.atom2Index \
		        -textvariable {molUP::atom2BondSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::bondModif.frame0.frame -x 60 -y 60 -width 100

    place [ttk::label $molUP::bondModif.frame0.frame.atom2OptionsLabel \
		        -text {Options: } \
				-style molUP.white.TLabel \
		        ] -in $molUP::bondModif.frame0.frame -x 190 -y 60 -width 50
            
    place [ttk::combobox $molUP::bondModif.frame0.frame.atom2Options \
		        -textvariable {molUP::atom2BondOpt} \
			    -state readonly \
				-style molUP.white.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms" "Custom"]"
		        ] -in $molUP::bondModif.frame0.frame -x 250 -y 60 -width 140

	place [ttk::label $molUP::bondModif.frame0.frame.customAtom1 \
		    -text "Custom Selection (Atom 1):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::bondModif.frame0.frame -x 10 -y 90 -width 180

	place [ttk::entry $molUP::bondModif.frame0.frame.customAtom1Entry \
		        -textvariable {molUP::customSelection1} \
				-style molUP.TEntry \
				-state disabled \
		        ] -in $molUP::bondModif.frame0.frame -x 200 -y 90 -width 190

	place [ttk::label $molUP::bondModif.frame0.frame.customAtom2 \
		    -text "Custom Selection (Atom 2):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::bondModif.frame0.frame -x 10 -y 120 -width 180

	place [ttk::entry $molUP::bondModif.frame0.frame.customAtom2Entry \
		        -textvariable {molUP::customSelection2} \
				-state disabled \
				-style molUP.TEntry \
		        ] -in $molUP::bondModif.frame0.frame -x 200 -y 120 -width 190

	place [scale $molUP::bondModif.frame0.frame.scaleBondDistance \
				-length 280 \
				-from 0.01 \
				-to 100.00 \
				-resolution 0.01 \
				-variable {molUP::BondDistance} \
				-command {molUP::calcBondDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $molUP::bondModif.frame0.frame -x 10 -y 150 -width 380


    place [ttk::label $molUP::bondModif.frame0.frame.distanceLabel \
				-text {Bond (A): } \
				-style molUP.white.TLabel \
		        ] -in $molUP::bondModif.frame0.frame -x 10 -y 183 -width 60

    place [spinbox $molUP::bondModif.frame0.frame.distance \
					-from 0.01 \
					-to 15.00 \
					-increment 0.01 \
					-textvariable {molUP::BondDistance} \
					-command {molUP::calcBondDistance $molUP::BondDistance} \
                ] -in $molUP::bondModif.frame0.frame -x 80 -y 180 -width 100
                
    place [ttk::button $molUP::bondModif.frame0.frame.apply \
		            -text "Apply" \
		            -command {molUP::bondGuiCloseSave} \
					-style molUP.TButton \
		            ] -in $molUP::bondModif.frame0.frame -x 230 -y 180 -width 75
				
	place [ttk::button $molUP::bondModif.frame0.frame.cancel \
		            -text "Cancel" \
		            -command {molUP::bondGuiCloseNotSave} \
					-style molUP.TButton \
		            ] -in $molUP::bondModif.frame0.frame -x 315 -y 180 -width 75


	bind $molUP::bondModif.frame0.frame.distance <KeyPress> {molUP::calcBondDistance $molUP::BondDistance}
	bind $molUP::bondModif.frame0.frame.distance <Leave> {molUP::calcBondDistance $molUP::BondDistance}

	# Custom - Enable Entry
	bind $molUP::bondModif.frame0.frame.atom1Options <<ComboboxSelected>> {
		if {$molUP::atom1BondOpt == "Custom"} {
			$molUP::bondModif.frame0.frame.customAtom1Entry configure -state normal
		} else {
			$molUP::bondModif.frame0.frame.customAtom1Entry configure -state disabled
		}
	}
	bind $molUP::bondModif.frame0.frame.atom2Options <<ComboboxSelected>> {
		if {$molUP::atom2BondOpt == "Custom"} {
			$molUP::bondModif.frame0.frame.customAtom2Entry configure -state normal
		} else {
			$molUP::bondModif.frame0.frame.customAtom2Entry configure -state disabled
		}
	}
	if {$molUP::atom1BondOpt == "Custom"} {
		$molUP::bondModif.frame0.frame.customAtom1Entry configure -state normal
	} else {
		$molUP::bondModif.frame0.frame.customAtom1Entry configure -state disabled
		set molUP::customSelection1 ""
	}

	if {$molUP::atom2BondOpt == "Custom"} {
		$molUP::bondModif.frame0.frame.customAtom2Entry configure -state normal
	} else {
		$molUP::bondModif.frame0.frame.customAtom2Entry configure -state disabled
		set molUP::customSelection2 ""
	}

}