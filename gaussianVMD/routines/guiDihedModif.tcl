package provide guiDihedModif 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiDihedModif {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::dihedModif]} {wm deiconify $::gaussianVMD::dihedModif ;return $::gaussianVMD::dihedModif}
	toplevel $::gaussianVMD::dihedModif

	#### Title of the windows
	wm title $gaussianVMD::dihedModif "Dihedral Angle Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::dihedModif] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::dihedModif] -50]

	#window wifth and height
	set wWidth [winfo reqwidth $::gaussianVMD::dihedModif]
	set wHeight [winfo reqheight $::gaussianVMD::dihedModif]
	$::gaussianVMD::dihedModif configure -background {white}
	wm resizable $::gaussianVMD::dihedModif 0 0

	wm protocol $::gaussianVMD::dihedModif WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
    grid [ttk::frame $gaussianVMD::dihedModif.frame0] -row 0 -column 0 -padx 5 -pady 2 -sticky news
        
        grid [ttk::label $gaussianVMD::dihedModif.frame0.title \
		    -text {Four atoms were selected.} \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 0 -column 0 -padx 2 -pady 8 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom1 \
		    -text {Atom 1:} \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 1 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom1IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 2 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::dihedModif.frame0.atom1Index \
		        -textvariable {gaussianVMD::atom1DihedSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::dihedModif.frame0 -row 2 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::dihedModif.frame0.atom1OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::dihedModif.frame0 -row 2 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::dihedModif.frame0.atom1Options \
		        -textvariable {gaussianVMD::atom1DihedOpt} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::dihedModif.frame0 -row 2 -column 3 -sticky news

        
        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom2 \
		    -text {Bond:} \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 3 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom2IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 4 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::dihedModif.frame0.atom2Index \
		        -textvariable {gaussianVMD::atom2DihedSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::dihedModif.frame0 -row 4 -column 1 -sticky news

        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom3IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 4 -column 2 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::dihedModif.frame0.atom3Index \
		        -textvariable {gaussianVMD::atom3DihedSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::dihedModif.frame0 -row 4 -column 3 -sticky news


        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom4 \
		    -text {Atom 4:} \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 5 -column 0 -padx 2 -pady 0 -sticky news -columnspan 4

        grid [ttk::label $gaussianVMD::dihedModif.frame0.atom4IndexLabel \
		    -text {Index: } \
		    ] -in $gaussianVMD::dihedModif.frame0 -row 6 -column 0 -padx 2 -pady 0 -sticky news

            grid [ttk::entry $gaussianVMD::dihedModif.frame0.atom4Index \
		        -textvariable {gaussianVMD::atom4DihedSel} \
		        -width 12 \
				-state readonly \
		        ] -in $gaussianVMD::dihedModif.frame0 -row 6 -column 1 -sticky news

            grid [ttk::label $gaussianVMD::dihedModif.frame0.atom4OptionsLabel \
		        -text {Options: } \
		        ] -in $gaussianVMD::dihedModif.frame0 -row 6 -column 2 -padx 2 -pady 0 -sticky news
            
            grid [ttk::combobox $gaussianVMD::dihedModif.frame0.atom3Options \
		        -textvariable {gaussianVMD::atom4DihedOpt} \
		        -width 10 \
			    -state readonly \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::dihedModif.frame0 -row 6 -column 3 -sticky news



        grid [ttk::frame $gaussianVMD::dihedModif.frame2] -row 1 -column 0 -padx 5 -pady 5 -sticky news
			grid [scale $gaussianVMD::dihedModif.frame2.scaleBondDistance \
				-length 280 \
				-from {-180.00} \
				-to 180.00 \
				-resolution 0.01 \
				-variable {gaussianVMD::DihedValue} \
				-command {gaussianVMD::calcDihedDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $gaussianVMD::dihedModif.frame2 -row 0 -column 0 -padx 5 -sticky news


        grid [ttk::frame $gaussianVMD::dihedModif.frame1] -row 2 -column 0 -padx 5 -pady 5 -sticky news
            grid [ttk::label $gaussianVMD::dihedModif.frame1.distanceLabel \
				-text {Dihedral (°): } \
		        ] -in $gaussianVMD::dihedModif.frame1 -row 0 -column 0 -padx 2 -pady 2 -sticky news

                grid [spinbox $gaussianVMD::dihedModif.frame1.distance \
					-from {-180.00} \
					-to {180.00} \
					-increment 0.01 \
					-textvariable {gaussianVMD::DihedValue} \
					-command {gaussianVMD::calcDihedDistance $gaussianVMD::DihedValue} \
					-width 5 \
                    ] -in $gaussianVMD::dihedModif.frame1 -row 0 -column 1 -padx 2 -pady 2 -sticky news
                
                grid [ttk::button $gaussianVMD::dihedModif.frame1.apply \
		            -text "Apply" \
		            -command {gaussianVMD::dihedGuiCloseSave} \
		            ] -in $gaussianVMD::dihedModif.frame1 -row 0 -column 2 -sticky news
				
				grid [ttk::button $gaussianVMD::dihedModif.frame1.cancel \
		            -text "Cancel" \
		            -command {gaussianVMD::dihedGuiCloseNotSave} \
		            ] -in $gaussianVMD::dihedModif.frame1 -row 0 -column 3 -sticky news


	bind $gaussianVMD::dihedModif.frame1.distance <KeyPress> {gaussianVMD::calcDihedDistance $gaussianVMD::DihedValue}
	bind $gaussianVMD::dihedModif.frame1.distance <Leave> {gaussianVMD::calcDihedDistance $gaussianVMD::DihedValue}

}