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

	#### Change the location of window
    wm geometry $::gaussianVMD::dihedModif 400x200+[expr $sWidth - 400]+100
	$::gaussianVMD::dihedModif configure -background {white}
	wm resizable $::gaussianVMD::dihedModif 0 0

	## Apply theme
	ttk::style theme use gaussianVMDTheme

	wm protocol $::gaussianVMD::dihedModif WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
    pack [ttk::frame $gaussianVMD::dihedModif.frame0]
	pack [canvas $gaussianVMD::dihedModif.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::dihedModif.frame0 
        
    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.title \
		    -text {Four atoms were selected.} \
			-style gaussianVMD.white.TLabel \
		    ] -in $gaussianVMD::dihedModif.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.atom1 \
		    -text {Atom 1:} \
			-style gaussianVMD.white.TLabel \
		    ] -in $gaussianVMD::dihedModif.frame0.frame -x 10 -y 30 -width 60 

    place [ttk::entry $gaussianVMD::dihedModif.frame0.frame.atom1Index \
		        -textvariable {gaussianVMD::atom1DihedSel} \
				-state readonly \
				-style gaussianVMD.TEntry \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 60 -y 30 -width 100

    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.atom1OptionsLabel \
		        -text {Options: } \
				-style gaussianVMD.white.TLabel \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 190 -y 30 -width 50
            
    place [ttk::combobox $gaussianVMD::dihedModif.frame0.frame.atom1Options \
		        -textvariable {gaussianVMD::atom1DihedOpt} \
			    -state readonly \
				-style gaussianVMD.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 250 -y 30 -width 140

        
    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.atom2 \
		    -text {Bond between atom} \
			-style gaussianVMD.white.TLabel \
		    ] -in $gaussianVMD::dihedModif.frame0.frame -x 10 -y 60 -width 110

    place [ttk::entry $gaussianVMD::dihedModif.frame0.frame.atom2Index \
		        -textvariable {gaussianVMD::atom2DihedSel} \
				-state readonly \
				-style gaussianVMD.TEntry \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 130 -y 60 -width 100

	place [ttk::label $gaussianVMD::dihedModif.frame0.frame.andLabel \
		    -text {and} \
			-style gaussianVMD.whiteCenter.TLabel \
		    ] -in $gaussianVMD::dihedModif.frame0.frame -x 240 -y 60 -width 40

    place [ttk::entry $gaussianVMD::dihedModif.frame0.frame.atom3Index \
		        -textvariable {gaussianVMD::atom3DihedSel} \
				-state readonly \
				-style gaussianVMD.TEntry \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 290 -y 60 -width 100


    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.atom4 \
		    -text {Atom 4:} \
			-style gaussianVMD.white.TLabel \
		    ] -in $gaussianVMD::dihedModif.frame0.frame -x 10 -y 90 -width 60

    place [ttk::entry $gaussianVMD::dihedModif.frame0.frame.atom4Index \
		        -textvariable {gaussianVMD::atom4DihedSel} \
				-state readonly \
				-style gaussianVMD.TEntry \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 60 -y 90 -width 100

    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.atom4OptionsLabel \
		        -text {Options: } \
				-style gaussianVMD.white.TLabel \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 190 -y 90 -width 50
            
    place [ttk::combobox $gaussianVMD::dihedModif.frame0.frame.atom3Options \
		        -textvariable {gaussianVMD::atom4DihedOpt} \
			    -state readonly \
				-style gaussianVMD.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 250 -y 90 -width 140


	place [scale $gaussianVMD::dihedModif.frame0.frame.scaleBondDistance \
				-length 280 \
				-from {-180.00} \
				-to 180.00 \
				-resolution 0.01 \
				-variable {gaussianVMD::DihedValue} \
				-command {gaussianVMD::calcDihedDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $gaussianVMD::dihedModif.frame0.frame -x 10 -y 120 -width 380


    place [ttk::label $gaussianVMD::dihedModif.frame0.frame.distanceLabel \
				-text {Dihedral (°): } \
				-style gaussianVMD.white.TLabel \
		        ] -in $gaussianVMD::dihedModif.frame0.frame -x 10 -y 153 -width 60

    place [spinbox $gaussianVMD::dihedModif.frame0.frame.distance \
					-from {-180.00} \
					-to {180.00} \
					-increment 0.01 \
					-textvariable {gaussianVMD::DihedValue} \
					-command {gaussianVMD::calcDihedDistance $gaussianVMD::DihedValue} \
                    ] -in $gaussianVMD::dihedModif.frame0.frame -x 80 -y 150 -width 100
                
    place [ttk::button $gaussianVMD::dihedModif.frame0.frame.apply \
		            -text "Apply" \
		            -command {gaussianVMD::dihedGuiCloseSave} \
		            ] -in $gaussianVMD::dihedModif.frame0.frame -x 230 -y 150 -width 75
				
	place [ttk::button $gaussianVMD::dihedModif.frame0.frame.cancel \
		            -text "Cancel" \
		            -command {gaussianVMD::dihedGuiCloseNotSave} \
		            ] -in $gaussianVMD::dihedModif.frame0.frame -x 315 -y 150 -width 75


	bind $gaussianVMD::dihedModif.frame0.frame.distance <KeyPress> {gaussianVMD::calcDihedDistance $gaussianVMD::DihedValue}
	bind $gaussianVMD::dihedModif.frame0.frame.distance <Leave> {gaussianVMD::calcDihedDistance $gaussianVMD::DihedValue}

}