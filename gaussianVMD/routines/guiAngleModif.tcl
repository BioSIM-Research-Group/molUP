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

	#window wifth and height
	set wWidth [winfo reqwidth $::gaussianVMD::angleModif]
	set wHeight [winfo reqheight $::gaussianVMD::angleModif]
	$::gaussianVMD::angleModif configure -background {white}
	wm resizable $::gaussianVMD::angleModif 0 0

	wm protocol $::gaussianVMD::angleModif WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
    grid [ttk::frame $gaussianVMD::angleModif.frame0] -row 0 -column 0 -padx 5 -pady 2 -sticky news
        
        grid [ttk::label $gaussianVMD::angleModif.frame0.title \
		    -text {Three atoms were selected. You can adjust the angle.} \
		    ] -in $gaussianVMD::angleModif.frame0 -row 0 -column 0 -padx 2 -pady 8 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::angleModif.frame0.atom1 \
		    -text {Atom 1:} \
		    ] -in $gaussianVMD::angleModif.frame0 -row 1 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::angleModif.frame0.atom1IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::angleModif.frame0 -row 2 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::angleModif.frame0.atom1Index \
		        -textvariable {gaussianVMD::atom1AngleSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::angleModif.frame0 -row 2 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::angleModif.frame0.atom1OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::angleModif.frame0 -row 2 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::angleModif.frame0.atom1Options \
		        -textvariable {gaussianVMD::atom1AngleOpt} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::angleModif.frame0 -row 2 -column 3 -sticky news

        
        grid [ttk::label $gaussianVMD::angleModif.frame0.atom2 \
		    -text {Atom 2:} \
		    ] -in $gaussianVMD::angleModif.frame0 -row 3 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::angleModif.frame0.atom2IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::angleModif.frame0 -row 4 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::angleModif.frame0.atom2Index \
		        -textvariable {gaussianVMD::atom2AngleSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::angleModif.frame0 -row 4 -column 1 -sticky news


        grid [ttk::label $gaussianVMD::angleModif.frame0.atom3 \
		    -text {Atom 3:} \
		    ] -in $gaussianVMD::angleModif.frame0 -row 5 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::angleModif.frame0.atom3IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::angleModif.frame0 -row 6 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::angleModif.frame0.atom3Index \
		        -textvariable {gaussianVMD::atom3AngleSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::angleModif.frame0 -row 6 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::angleModif.frame0.atom3OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::angleModif.frame0 -row 6 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::angleModif.frame0.atom3Options \
		        -textvariable {gaussianVMD::atom3AngleOpt} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::angleModif.frame0 -row 6 -column 3 -sticky news



        grid [ttk::frame $gaussianVMD::angleModif.frame2] -row 1 -column 0 -padx 5 -pady 5 -sticky news
			grid [scale $gaussianVMD::angleModif.frame2.scaleBondDistance \
				-length 280 \
				-from {-180.00} \
				-to 180.00 \
				-resolution 0.01 \
				-variable {gaussianVMD::AngleValue} \
				-command {gaussianVMD::calcAngleDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $gaussianVMD::angleModif.frame2 -row 0 -column 0 -padx 5 -sticky news


        grid [ttk::frame $gaussianVMD::angleModif.frame1] -row 2 -column 0 -padx 5 -pady 5 -sticky news
            grid [ttk::label $gaussianVMD::angleModif.frame1.distanceLabel \
				-text {Angle (°): } \
		        ] -in $gaussianVMD::angleModif.frame1 -row 0 -column 0 -padx 2 -pady 2 -sticky news

                grid [spinbox $gaussianVMD::angleModif.frame1.distance \
					-from {-180.00} \
					-to {180.00} \
					-increment 0.01 \
					-textvariable {gaussianVMD::AngleValue} \
					-command {gaussianVMD::calcAngleDistance $gaussianVMD::AngleValue} \
					-width 5 \
                    ] -in $gaussianVMD::angleModif.frame1 -row 0 -column 1 -padx 2 -pady 2 -sticky news
                
                grid [ttk::button $gaussianVMD::angleModif.frame1.apply \
		            -text "Apply" \
		            -command {gaussianVMD::angleGuiCloseSave} \
		            ] -in $gaussianVMD::angleModif.frame1 -row 0 -column 2 -sticky news
				
				grid [ttk::button $gaussianVMD::angleModif.frame1.cancel \
		            -text "Cancel" \
		            -command {gaussianVMD::angleGuiCloseNotSave} \
		            ] -in $gaussianVMD::angleModif.frame1 -row 0 -column 3 -sticky news


	bind $gaussianVMD::angleModif.frame1.distance <KeyPress> {gaussianVMD::calcAngleDistance $gaussianVMD::AngleValue}
	bind $gaussianVMD::angleModif.frame1.distance <Leave> {gaussianVMD::calcAngleDistance $gaussianVMD::AngleValue}

}