package provide guiSaveFile 1.0
package require Tk


#### GUI ############################################################
proc gaussianVMD::guiSaveFile {} {

    #### Check if the window exists
	if {[winfo exists $::gaussianVMD::saveFile]} {wm deiconify $::gaussianVMD::saveFile ;return $::gaussianVMD::saveFile}
	toplevel $::gaussianVMD::saveFile

	#### Title of the windows
	wm title $gaussianVMD::saveFile "Save structure as ..." ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::topGui] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::topGui] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::saveFile 400x90+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::gaussianVMD::saveFile configure -background {white}
	wm resizable $::gaussianVMD::saveFile 0 0


	## Apply theme
	ttk::style theme use gaussianVMDTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $gaussianVMD::saveFile.frame]
    pack [canvas $gaussianVMD::saveFile.frame.back -bg white -width 400 -height 90 -highlightthickness 0] -in $gaussianVMD::saveFile.frame

    place [ttk::label $gaussianVMD::saveFile.frame.back.label1 \
			-text {Save current structure as } \
            ] -in $gaussianVMD::saveFile.frame.back -x 10 -y 13 -width 150

    place [ttk::combobox $gaussianVMD::saveFile.frame.back.selectLoadMode \
		    -textvariable gaussianVMD::saveOptions \
			-state readonly \
		    -values "[list "Gaussian Input File (.com)" "Protein Data Bank (.pdb)" "Coordinates XYZ (.xyz)"]"
            ] -in $gaussianVMD::saveFile.frame.back -x 170 -y 10 -width 220

            $gaussianVMD::saveFile.frame.back.selectLoadMode set "Gaussian Input File (.com)"
    
    place [ttk::button $gaussianVMD::saveFile.frame.back.buttonLoad \
		    -text "Save" \
		    -command {gaussianVMD::saveOrder} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::saveFile.frame.back -x 10 -y 50 -width 185

    place [ttk::button $gaussianVMD::saveFile.frame.back.buttonCancel \
		    -text "Cancel" \
            -command {destroy $::gaussianVMD::saveFile} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::saveFile.frame.back -x 205 -y 50 -width 185

}

proc gaussianVMD::saveOrder {} {
    if {$gaussianVMD::saveOptions == "Gaussian Input File (.com)"} {
        gaussianVMD::saveGaussian

    } elseif {$gaussianVMD::saveOptions == "Protein Data Bank (.pdb)"} {
        gaussianVMD::savePDB

    } elseif {$gaussianVMD::saveOptions == "Coordinates XYZ (.xyz)"} {
        gaussianVMD::saveXYZ
        
    } else {
        set message "Please select a suitable structure to save."
        gaussianVMD::guiError $message
    }
}