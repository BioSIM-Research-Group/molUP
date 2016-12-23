package provide guiBondModif 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiBondModif {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::bondModif]} {wm deiconify $::gaussianVMD::bondModif ;return $::gaussianVMD::bondModif}
	toplevel $::gaussianVMD::bondModif

	#### Title of the windows
	wm title $gaussianVMD::bondModif "Modify Bond" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::bondModif] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::bondModif] -50]

	#window wifth and height
	set wWidth [winfo reqwidth $::gaussianVMD::bondModif]
	set wHeight [winfo reqheight $::gaussianVMD::bondModif]
	$::gaussianVMD::bondModif configure -background {white}
	wm resizable $::gaussianVMD::bondModif 0 0

	wm protocol $::gaussianVMD::bondModif WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
    grid [ttk::frame $gaussianVMD::bondModif.frame0] -row 0 -column 0 -padx 5 -pady 2 -sticky news
        
        grid [ttk::label $gaussianVMD::bondModif.frame0.title \
		    -text {Select two atoms...} \
		    ] -in $gaussianVMD::bondModif.frame0 -row 0 -column 0 -padx 2 -pady 8 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::bondModif.frame0.atom1 \
		    -text {Atom 1:} \
		    ] -in $gaussianVMD::bondModif.frame0 -row 1 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::bondModif.frame0.atom1IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::bondModif.frame0 -row 2 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::bondModif.frame0.atom1Index \
		        -textvariable {gaussianVMD::atom1BondSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::bondModif.frame0 -row 2 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::bondModif.frame0.atom1OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::bondModif.frame0 -row 2 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::bondModif.frame0.atom1Options \
		        -textvariable {gaussianVMD::atom1BondOpt} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::bondModif.frame0 -row 2 -column 3 -sticky news

        
        grid [ttk::label $gaussianVMD::bondModif.frame0.atom2 \
		    -text {Atom 2:} \
		    ] -in $gaussianVMD::bondModif.frame0 -row 3 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::bondModif.frame0.atom2IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::bondModif.frame0.atom2Index \
		        -textvariable {gaussianVMD::atom2BondSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::bondModif.frame0.atom2OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::bondModif.frame0.atom2Options \
		        -textvariable {gaussianVMD::atom2BondOpt} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 3 -sticky news



        grid [ttk::frame $gaussianVMD::bondModif.frame2] -row 1 -column 0 -padx 5 -pady 5 -sticky news
			grid [scale $gaussianVMD::bondModif.frame2.scaleBondDistance \
				-length 280 \
				-from 0.01 \
				-to 15.00 \
				-resolution 0.01 \
				-variable {gaussianVMD::BondDistance} \
				-command {gaussianVMD::calcBondDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $gaussianVMD::bondModif.frame2 -row 0 -column 0 -padx 5 -sticky news


        grid [ttk::frame $gaussianVMD::bondModif.frame1] -row 2 -column 0 -padx 5 -pady 5 -sticky news
            grid [ttk::label $gaussianVMD::bondModif.frame1.distanceLabel \
				-text {Bond (A): } \
		        ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 0 -padx 2 -pady 2 -sticky news

                grid [spinbox $gaussianVMD::bondModif.frame1.distance \
					-from 0.01 \
					-to 15.00 \
					-increment 0.01 \
					-textvariable {gaussianVMD::BondDistance} \
					-command {gaussianVMD::calcBondDistance $gaussianVMD::BondDistance} \
					-width 5 \
                    ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 1 -padx 2 -pady 2 -sticky news
                
                grid [ttk::button $gaussianVMD::bondModif.frame1.apply \
		            -text "Apply" \
		            -command {gaussianVMD::bondGuiCloseSave} \
		            ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 2 -sticky news
				
				grid [ttk::button $gaussianVMD::bondModif.frame1.cancel \
		            -text "Cancel" \
		            -command {gaussianVMD::bondGuiCloseNotSave} \
		            ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 3 -sticky news


	bind $gaussianVMD::bondModif.frame1.distance <KeyPress> {gaussianVMD::calcBondDistance $gaussianVMD::BondDistance}
	bind $gaussianVMD::bondModif.frame1.distance <Leave> {gaussianVMD::calcBondDistance $gaussianVMD::BondDistance}

	

}