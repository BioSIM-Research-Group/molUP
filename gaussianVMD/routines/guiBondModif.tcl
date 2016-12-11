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
	
	#display reposition 0 [expr ${sHeight} - 15]
	#display resize [expr $sWidth - 400] ${sHeight}

	#wm geometry window $gaussianVMD::bondModif 400x590
	#set x [expr $sWidth - 2*($wWidth)]

	#wm geometry $::gaussianVMD::bondModif 400x${sHeight}+$x+25
	$::gaussianVMD::bondModif configure -background {white}
	wm resizable $::gaussianVMD::bondModif 0 0



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
		        -textvariable {} \
		        -width 12 \
		        ] -in $gaussianVMD::bondModif.frame0 -row 2 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::bondModif.frame0.atom1OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::bondModif.frame0 -row 2 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::bondModif.frame0.atom1Options \
		        -textvariable {} \
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
		        -textvariable {} \
		        -width 12 \
		        ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::bondModif.frame0.atom2OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::bondModif.frame0.atom2Options \
		        -textvariable {} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::bondModif.frame0 -row 4 -column 3 -sticky news



        grid [ttk::frame $gaussianVMD::bondModif.frame2] -row 1 -column 0 -padx 5 -pady 5 -sticky news
            


        grid [ttk::frame $gaussianVMD::bondModif.frame1] -row 2 -column 0 -padx 5 -pady 5 -sticky news
            grid [ttk::label $gaussianVMD::bondModif.frame1.distanceLabel \
		        -text {Distance (Angstrom): } \
		        ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 0 -padx 2 -pady 2 -sticky news

                grid [ttk::entry $gaussianVMD::bondModif.frame1.distance \
                    -textvariable {} \
                    -width 10 \
                    ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 1 -padx 2 -pady 2 -sticky news
                
                grid [ttk::button $gaussianVMD::bondModif.frame1.apply \
		            -text "Apply" \
		            -command {} \
		            ] -in $gaussianVMD::bondModif.frame1 -row 0 -column 2 -sticky news


}