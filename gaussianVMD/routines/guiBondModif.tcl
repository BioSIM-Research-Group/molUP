package provide guiBondModif 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiBondModif {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::bondModif]} {wm deiconify $::gaussianVMD::bondModif ;return $::gaussianVMD::bondModif}
	toplevel $::gaussianVMD::bondModif

	#### Title of the windows
	wm title $gaussianVMD::bondModif "Bond Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::bondModif] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::bondModif] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::bondModif 400x160+[expr $sWidth - 400]+100
	$::gaussianVMD::bondModif configure -background {white}
	wm resizable $::gaussianVMD::bondModif 0 0


	## Apply theme
	ttk::style theme use clearlooks

    ## Styles
	ttk::style configure gaussianVMD.button.TButton \
		-anchor center

	wm protocol $::gaussianVMD::bondModif WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
	pack [ttk::frame $gaussianVMD::bondModif.frame0]
	pack [canvas $gaussianVMD::bondModif.frame0.frame -bg white -width 400 -height 160 -highlightthickness 0] -in $gaussianVMD::bondModif.frame0 
        
    place [ttk::label $gaussianVMD::bondModif.frame0.frame.title \
		    -text {Two atoms were selected. You can adjust the bond distance.} \
		    ] -in $gaussianVMD::bondModif.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $gaussianVMD::bondModif.frame0.frame.atom1 \
		    -text {Atom 1:} \
		    ] -in $gaussianVMD::bondModif.frame0.frame -x 10 -y 30 -width 60

    place [ttk::entry $gaussianVMD::bondModif.frame0.frame.atom1Index \
		        -textvariable {gaussianVMD::atom1BondSel} \
				-state readonly \
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 60 -y 30 -width 100

    place [ttk::label $gaussianVMD::bondModif.frame0.frame.atom1OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 190 -y 30 -width 50
            
    place [ttk::combobox $gaussianVMD::bondModif.frame0.frame.atom1Options \
		        -textvariable {gaussianVMD::atom1BondOpt} \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 250 -y 30 -width 140

        
    place [ttk::label $gaussianVMD::bondModif.frame0.frame.atom2 \
		    -text {Atom 2:} \
		    ] -in $gaussianVMD::bondModif.frame0.frame -x 10 -y 60 -width 60

    place [ttk::entry $gaussianVMD::bondModif.frame0.frame.atom2Index \
		        -textvariable {gaussianVMD::atom2BondSel} \
				-state readonly \
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 60 -y 60 -width 100

    place [ttk::label $gaussianVMD::bondModif.frame0.frame.atom2OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 190 -y 60 -width 50
            
    place [ttk::combobox $gaussianVMD::bondModif.frame0.frame.atom2Options \
		        -textvariable {gaussianVMD::atom2BondOpt} \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 250 -y 60 -width 140



	place [scale $gaussianVMD::bondModif.frame0.frame.scaleBondDistance \
				-length 280 \
				-from 0.01 \
				-to 15.00 \
				-resolution 0.01 \
				-variable {gaussianVMD::BondDistance} \
				-command {gaussianVMD::calcBondDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $gaussianVMD::bondModif.frame0.frame -x 10 -y 90 -width 380


    place [ttk::label $gaussianVMD::bondModif.frame0.frame.distanceLabel \
				-text {Bond (A): } \
		        ] -in $gaussianVMD::bondModif.frame0.frame -x 10 -y 123 -width 60

    place [spinbox $gaussianVMD::bondModif.frame0.frame.distance \
					-from 0.01 \
					-to 15.00 \
					-increment 0.01 \
					-textvariable {gaussianVMD::BondDistance} \
					-command {gaussianVMD::calcBondDistance $gaussianVMD::BondDistance} \
                ] -in $gaussianVMD::bondModif.frame0.frame -x 80 -y 120 -width 100
                
    place [ttk::button $gaussianVMD::bondModif.frame0.frame.apply \
		            -text "Apply" \
		            -command {gaussianVMD::bondGuiCloseSave} \
					-style gaussianVMD.button.TButton \
		            ] -in $gaussianVMD::bondModif.frame0.frame -x 230 -y 120 -width 75
				
	place [ttk::button $gaussianVMD::bondModif.frame0.frame.cancel \
		            -text "Cancel" \
		            -command {gaussianVMD::bondGuiCloseNotSave} \
					-style gaussianVMD.button.TButton \
		            ] -in $gaussianVMD::bondModif.frame0.frame -x 315 -y 120 -width 75


	bind $gaussianVMD::bondModif.frame0.frame.distance <KeyPress> {gaussianVMD::calcBondDistance $gaussianVMD::BondDistance}
	bind $gaussianVMD::bondModif.frame0.frame.distance <Leave> {gaussianVMD::calcBondDistance $gaussianVMD::BondDistance}

	

}