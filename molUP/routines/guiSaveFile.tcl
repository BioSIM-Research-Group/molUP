package provide guiSaveFile 1.0
package require Tk


#### GUI ############################################################
proc molUP::guiSaveFile {} {

    #### Check if the window exists
	if {[winfo exists $::molUP::saveFile]} {wm deiconify $::molUP::saveFile ;return $::molUP::saveFile}
	toplevel $::molUP::saveFile

	#### Title of the windows
	wm title $molUP::saveFile "Save structure as ..." ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::saveFile 400x90+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::molUP::saveFile configure -background {white}
	wm resizable $::molUP::saveFile 0 0


	## Apply theme
	ttk::style theme use molUPTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::saveFile.frame]
    pack [canvas $molUP::saveFile.frame.back -bg white -width 400 -height 90 -highlightthickness 0] -in $molUP::saveFile.frame

    place [ttk::label $molUP::saveFile.frame.back.label1 \
			-text {Save current structure as } \
            ] -in $molUP::saveFile.frame.back -x 10 -y 13 -width 150

    place [ttk::combobox $molUP::saveFile.frame.back.selectLoadMode \
		    -textvariable molUP::saveOptions \
			-state readonly \
		    -values "[list "Gaussian Input File (.com)" "Protein Data Bank (.pdb)" "Coordinates XYZ (.xyz)"]"
            ] -in $molUP::saveFile.frame.back -x 170 -y 10 -width 220

            $molUP::saveFile.frame.back.selectLoadMode set "Gaussian Input File (.com)"
    
    place [ttk::button $molUP::saveFile.frame.back.buttonLoad \
		    -text "Save" \
		    -command {molUP::saveOrder} \
            -style molUP.button.TButton \
            ] -in $molUP::saveFile.frame.back -x 10 -y 50 -width 185

    place [ttk::button $molUP::saveFile.frame.back.buttonCancel \
		    -text "Cancel" \
            -command {destroy $::molUP::saveFile} \
            -style molUP.button.TButton \
            ] -in $molUP::saveFile.frame.back -x 205 -y 50 -width 185

}

proc molUP::saveOrder {} {
    if {$molUP::saveOptions == "Gaussian Input File (.com)"} {
        molUP::saveGaussian

    } elseif {$molUP::saveOptions == "Protein Data Bank (.pdb)"} {
        molUP::savePDB

    } elseif {$molUP::saveOptions == "Coordinates XYZ (.xyz)"} {
        molUP::saveXYZ
        
    } else {
        set message "Please select a suitable structure to save."
        molUP::guiError $message
    }
}