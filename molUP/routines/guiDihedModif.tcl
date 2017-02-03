package provide guiDihedModif 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiDihedModif {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::dihedModif]} {wm deiconify $::molUP::dihedModif ;return $::molUP::dihedModif}
	toplevel $::molUP::dihedModif

	#### Title of the windows
	wm title $molUP::dihedModif "Dihedral Angle Editor" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::dihedModif] -0]
	set sHeight [expr [winfo vrootheight $::molUP::dihedModif] -50]

	#### Change the location of window
    wm geometry $::molUP::dihedModif 400x200+[expr $sWidth - 400]+100
	$::molUP::dihedModif configure -background {white}
	wm resizable $::molUP::dihedModif 0 0

	## Apply theme
	ttk::style theme use molUPTheme

	wm protocol $::molUP::dihedModif WM_DELETE_WINDOW {molUP::bondGuiCloseSave}

	

    #### Information
    pack [ttk::frame $molUP::dihedModif.frame0]
	pack [canvas $molUP::dihedModif.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $molUP::dihedModif.frame0 
        
    place [ttk::label $molUP::dihedModif.frame0.frame.title \
		    -text {Four atoms were selected.} \
			-style molUP.white.TLabel \
		    ] -in $molUP::dihedModif.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $molUP::dihedModif.frame0.frame.atom1 \
		    -text {Atom 1:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::dihedModif.frame0.frame -x 10 -y 30 -width 60 

    place [ttk::entry $molUP::dihedModif.frame0.frame.atom1Index \
		        -textvariable {molUP::atom1DihedSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::dihedModif.frame0.frame -x 60 -y 30 -width 100

    place [ttk::label $molUP::dihedModif.frame0.frame.atom1OptionsLabel \
		        -text {Options: } \
				-style molUP.white.TLabel \
		        ] -in $molUP::dihedModif.frame0.frame -x 190 -y 30 -width 50
            
    place [ttk::combobox $molUP::dihedModif.frame0.frame.atom1Options \
		        -textvariable {molUP::atom1DihedOpt} \
			    -state readonly \
				-style molUP.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $molUP::dihedModif.frame0.frame -x 250 -y 30 -width 140

        
    place [ttk::label $molUP::dihedModif.frame0.frame.atom2 \
		    -text {Bond between atom} \
			-style molUP.white.TLabel \
		    ] -in $molUP::dihedModif.frame0.frame -x 10 -y 60 -width 110

    place [ttk::entry $molUP::dihedModif.frame0.frame.atom2Index \
		        -textvariable {molUP::atom2DihedSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::dihedModif.frame0.frame -x 130 -y 60 -width 100

	place [ttk::label $molUP::dihedModif.frame0.frame.andLabel \
		    -text {and} \
			-style molUP.whiteCenter.TLabel \
		    ] -in $molUP::dihedModif.frame0.frame -x 240 -y 60 -width 40

    place [ttk::entry $molUP::dihedModif.frame0.frame.atom3Index \
		        -textvariable {molUP::atom3DihedSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::dihedModif.frame0.frame -x 290 -y 60 -width 100


    place [ttk::label $molUP::dihedModif.frame0.frame.atom4 \
		    -text {Atom 4:} \
			-style molUP.white.TLabel \
		    ] -in $molUP::dihedModif.frame0.frame -x 10 -y 90 -width 60

    place [ttk::entry $molUP::dihedModif.frame0.frame.atom4Index \
		        -textvariable {molUP::atom4DihedSel} \
				-state readonly \
				-style molUP.TEntry \
		        ] -in $molUP::dihedModif.frame0.frame -x 60 -y 90 -width 100

    place [ttk::label $molUP::dihedModif.frame0.frame.atom4OptionsLabel \
		        -text {Options: } \
				-style molUP.white.TLabel \
		        ] -in $molUP::dihedModif.frame0.frame -x 190 -y 90 -width 50
            
    place [ttk::combobox $molUP::dihedModif.frame0.frame.atom3Options \
		        -textvariable {molUP::atom4DihedOpt} \
			    -state readonly \
				-style molUP.TCombobox \
		        -values "[list "Fixed Atom" "Move Atom" "Move Atoms"]"
		        ] -in $molUP::dihedModif.frame0.frame -x 250 -y 90 -width 140


	place [scale $molUP::dihedModif.frame0.frame.scaleBondDistance \
				-length 280 \
				-from {-180.00} \
				-to 180.00 \
				-resolution 0.01 \
				-variable {molUP::DihedValue} \
				-command {molUP::calcDihedDistance} \
				-orient horizontal \
				-showvalue 0 \
			] -in $molUP::dihedModif.frame0.frame -x 10 -y 120 -width 380


    place [ttk::label $molUP::dihedModif.frame0.frame.distanceLabel \
				-text {Dihedral (°): } \
				-style molUP.white.TLabel \
		        ] -in $molUP::dihedModif.frame0.frame -x 10 -y 153 -width 60

    place [spinbox $molUP::dihedModif.frame0.frame.distance \
					-from {-180.00} \
					-to {180.00} \
					-increment 0.01 \
					-textvariable {molUP::DihedValue} \
					-command {molUP::calcDihedDistance $molUP::DihedValue} \
                    ] -in $molUP::dihedModif.frame0.frame -x 80 -y 150 -width 100
                
    place [ttk::button $molUP::dihedModif.frame0.frame.apply \
		            -text "Apply" \
					-style molUP.TButton \
		            -command {molUP::dihedGuiCloseSave} \
		            ] -in $molUP::dihedModif.frame0.frame -x 230 -y 150 -width 75
				
	place [ttk::button $molUP::dihedModif.frame0.frame.cancel \
		            -text "Cancel" \
					-style molUP.TButton \
		            -command {molUP::dihedGuiCloseNotSave} \
		            ] -in $molUP::dihedModif.frame0.frame -x 315 -y 150 -width 75


	bind $molUP::dihedModif.frame0.frame.distance <KeyPress> {molUP::calcDihedDistance $molUP::DihedValue}
	bind $molUP::dihedModif.frame0.frame.distance <Leave> {molUP::calcDihedDistance $molUP::DihedValue}

}