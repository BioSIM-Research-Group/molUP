package provide guiAngleModif 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiAngleModif {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::angleModif]} {wm deiconify $::gaussianVMD::angleModif ;return $::gaussianVMD::angleModif}
	toplevel $::gaussianVMD::angleModif

	#### Title of the windows
	wm title $gaussianVMD::angleModif "Angle Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::angleModif] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::angleModif] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::angleModif 400x200+[expr $sWidth - 400]+100
	$::gaussianVMD::angleModif configure -background {white}
	wm resizable $::gaussianVMD::angleModif 0 0

	## Apply theme
	ttk::style theme use clearlooks

    ## Styles
	ttk::style configure gaussianVMD.button.TButton \
		-anchor center

	wm protocol $::gaussianVMD::angleModif WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
	pack [ttk::frame $gaussianVMD::angleModif.frame0]
	pack [canvas $gaussianVMD::angleModif.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::angleModif.frame0 
        
    place [ttk::label $gaussianVMD::angleModif.frame0.frame.title \
		    -text {Three atoms were selected. You can adjust the angle.} \
		    ] -in $gaussianVMD::angleModif.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $gaussianVMD::angleModif.frame0.frame.atom1 \
		    -text {Atom 1:} \
		    ] -in $gaussianVMD::angleModif.frame0.frame -x 10 -y 30 -width 60       

    place [ttk::entry $gaussianVMD::angleModif.frame0.frame.atom1Index \
		        -textvariable {gaussianVMD::atom1AngleSel} \
				-state readonly \
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 60 -y 30 -width 100

    place [ttk::label $gaussianVMD::angleModif.frame0.frame.atom1OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 190 -y 30 -width 50
            
    place [ttk::combobox $gaussianVMD::angleModif.frame0.frame.atom1Options \
		        -textvariable {gaussianVMD::atom1AngleOpt} \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 250 -y 30 -width 140

        
    place [ttk::label $gaussianVMD::angleModif.frame0.frame.atom2 \
		    -text {Atom 2:} \
		    ] -in $gaussianVMD::angleModif.frame0.frame -x 10 -y 60 -width 60

    place [ttk::entry $gaussianVMD::angleModif.frame0.frame.atom2Index \
		        -textvariable {gaussianVMD::atom2AngleSel} \
				-state readonly \
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 60 -y 60 -width 100


    place [ttk::label $gaussianVMD::angleModif.frame0.frame.atom3 \
		    -text {Atom 3:} \
		    ] -in $gaussianVMD::angleModif.frame0.frame -x 10 -y 90 -width 60

    place [ttk::entry $gaussianVMD::angleModif.frame0.frame.atom3Index \
		        -textvariable {gaussianVMD::atom3AngleSel} \
				-state readonly \
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 60 -y 90 -width 100

    place [ttk::label $gaussianVMD::angleModif.frame0.frame.atom3OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 190 -y 90 -width 50
            
    place [ttk::combobox $gaussianVMD::angleModif.frame0.frame.atom3Options \
		        -textvariable {gaussianVMD::atom3AngleOpt} \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 250 -y 90 -width 140


	place [scale $gaussianVMD::angleModif.frame0.frame.scaleBondDistance \
				-length 280 \
				-from {-180.00} \
				-to 180.00 \
				-resolution 0.01 \
				-variable {gaussianVMD::AngleValue} \
				-command {gaussianVMD::calcAngleDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $gaussianVMD::angleModif.frame0.frame -x 10 -y 120 -width 380


    place [ttk::label $gaussianVMD::angleModif.frame0.frame.distanceLabel \
				-text {Angle (°): } \
		        ] -in $gaussianVMD::angleModif.frame0.frame -x 10 -y 153 -width 60

    place [spinbox $gaussianVMD::angleModif.frame0.frame.distance \
					-from {-180.00} \
					-to {180.00} \
					-increment 0.01 \
					-textvariable {gaussianVMD::AngleValue} \
					-command {gaussianVMD::calcAngleDistance $gaussianVMD::AngleValue} \
                    ] -in $gaussianVMD::angleModif.frame0.frame -x 80 -y 150 -width 100
                
    place [ttk::button $gaussianVMD::angleModif.frame0.frame.apply \
		            -text "Apply" \
		            -command {gaussianVMD::angleGuiCloseSave} \
		            ] -in $gaussianVMD::angleModif.frame0.frame -x 230 -y 150 -width 75
				
	place [ttk::button $gaussianVMD::angleModif.frame0.frame.cancel \
		            -text "Cancel" \
		            -command {gaussianVMD::angleGuiCloseNotSave} \
		            ] -in $gaussianVMD::angleModif.frame0.frame -x 315 -y 150 -width 75


	bind $gaussianVMD::angleModif.frame0.frame.distance <KeyPress> {gaussianVMD::calcAngleDistance $gaussianVMD::AngleValue}
	bind $gaussianVMD::angleModif.frame0.frame.distance <Leave> {gaussianVMD::calcAngleDistance $gaussianVMD::AngleValue}

}