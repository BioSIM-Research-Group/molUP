package provide guiDeleteAtoms 1.5.1
package require Tk

#### GUI ############################################################
proc molUP::guiDeleteAtoms {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::deleteAtoms]} {wm deiconify $::molUP::deleteAtoms ;return $::molUP::deleteAtoms}
	toplevel $::molUP::deleteAtoms
	wm attributes $::molUP::deleteAtoms -topmost yes

	#### Title of the windows
	wm title $molUP::deleteAtoms "Delete Atoms" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::deleteAtoms] -0]
	set sHeight [expr [winfo vrootheight $::molUP::deleteAtoms] -50]

	#### Change the location of window
    wm geometry $::molUP::deleteAtoms 400x220+[expr $sWidth - 400]+100
	$::molUP::deleteAtoms configure -background {white}
	wm resizable $::molUP::deleteAtoms 0 0


	## Apply theme
	ttk::style theme use molUPTheme

	wm protocol $::molUP::deleteAtoms WM_DELETE_WINDOW {molUP::deleteAtomsGuiCloseSave}


    #### Information
	pack [ttk::frame $molUP::deleteAtoms.frame0]
	pack [canvas $molUP::deleteAtoms.frame0.frame -bg white -width 400 -height 220 -highlightthickness 0] -in $molUP::deleteAtoms.frame0 
        
    place [ttk::label $molUP::deleteAtoms.frame0.frame.title \
		    -text {Pick the atoms that you want to delete.} \
			-style molUP.white.TLabel \
		    ] -in $molUP::deleteAtoms.frame0.frame -x 10 -y 10 -width 380

    place [tablelist::tablelist $molUP::deleteAtoms.frame0.frame.table \
			-showeditcursor true \
			-columns {0 "Index" center 0 "Name" center 0 "Resname" center 0 "Resid" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $molUP::deleteAtoms.frame0.frame.yscb set] \
			-xscrollcommand [list $molUP::deleteAtoms.frame0.frame.xscb set] \
			-selectmode extended \
			-height 14 \
			-state normal \
			-borderwidth 0 \
			-relief flat \
			] -in $molUP::deleteAtoms.frame0.frame -x 10 -y 40 -width 370 -height 100

    place [ttk::scrollbar $molUP::deleteAtoms.frame0.frame.yscb \
			-orient vertical \
			-command [list $molUP::deleteAtoms.frame0.frame.table yview]\
			] -in $molUP::deleteAtoms.frame0.frame -x 370 -y 40 -width 20 -height 100

	place [ttk::scrollbar $molUP::deleteAtoms.frame0.frame.xscb \
			-orient horizontal \
			-command [list $molUP::deleteAtoms.frame0.frame.table xview]\
			] -in $molUP::deleteAtoms.frame0.frame -x 10 -y 140 -height 20 -width 360
                
    place [ttk::button $molUP::deleteAtoms.frame0.frame.apply \
		            -text "Delete" \
		            -command {molUP::deleteAtomProcess} \
					-style molUP.TButton \
		            ] -in $molUP::deleteAtoms.frame0.frame -x 230 -y 180 -width 75
				
	place [ttk::button $molUP::deleteAtoms.frame0.frame.cancel \
		            -text "Cancel" \
		            -command {molUP::deleteAtomsGuiCloseSave} \
					-style molUP.TButton \
		            ] -in $molUP::deleteAtoms.frame0.frame -x 315 -y 180 -width 75


    after idle {
        ## Trace variable to pick atoms to delete
        trace variable ::vmd_pick_atom w molUP::pickAtomsToDelete
        mouse mode pick
    }
}

proc molUP::deleteAtomsGuiCloseSave {} {
    trace remove variable ::vmd_pick_atom write molUP::pickAtomsToDelete
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    destroy $::molUP::deleteAtoms
}