package provide guiOpenFile 1.0
package require Tk


#### GUI ############################################################
proc gaussianVMD::guiOpenFile {} {

    #### Check if the window exists
	if {[winfo exists $::gaussianVMD::openFile]} {wm deiconify $::gaussianVMD::openFile ;return $::gaussianVMD::openFile}
	toplevel $::gaussianVMD::openFile

	#### Title of the windows
	wm title $gaussianVMD::openFile "Open a file" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::topGui] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::topGui] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::openFile 400x160+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::gaussianVMD::openFile configure -background {white}
	wm resizable $::gaussianVMD::openFile 0 0


	## Apply theme
	ttk::style theme use clearlooks

    ## Styles
	ttk::style configure gaussianVMD.button.TButton \
		-anchor center


    #### Draw the GUI
    # Frame
    pack [ttk::frame $gaussianVMD::openFile.frame]
    pack [canvas $gaussianVMD::openFile.frame.back -bg white -width 400 -height 160 -highlightthickness 0] -in $gaussianVMD::openFile.frame

    place [ttk::label $gaussianVMD::openFile.frame.back.label1 \
			-text {Choose a Gaussian Output (.log) or Input (.com) file...} \
            ] -in $gaussianVMD::openFile.frame.back -x 10 -y 10

    place [ttk::entry $gaussianVMD::openFile.frame.back.pathEntry \
		    -textvariable gaussianVMD::path \
            ] -in $gaussianVMD::openFile.frame.back -x 10 -y 40 -width 295 -height 28

    place [ttk::button $gaussianVMD::openFile.frame.back.buttonBrowseFile \
		    -text "Browse" \
		    -command gaussianVMD::onSelect \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::openFile.frame.back -x 315 -y 40 -width 75


    place [ttk::label $gaussianVMD::openFile.frame.back.label2 \
			-text {Loading options: } \
            ] -in $gaussianVMD::openFile.frame.back -x 10 -y 82 -width 100

    place [ttk::combobox $gaussianVMD::openFile.frame.back.selectLoadMode \
		    -textvariable $gaussianVMD::loadMode \
			-state readonly \
		    -values "[list "Last Structure" "First Structure" "All optimized structures" "All structures (may take a long time to load)"]"
            ] -in $gaussianVMD::openFile.frame.back -x 120 -y 80 -width 270

            $gaussianVMD::openFile.frame.back.selectLoadMode set "Last Structure"

    place [ttk::button $gaussianVMD::openFile.frame.back.buttonLoad \
		    -text "Load" \
		    -command {gaussianVMD::loadButton $gaussianVMD::fileExtension} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::openFile.frame.back -x 10 -y 120 -width 185

    place [ttk::button $gaussianVMD::openFile.frame.back.buttonCancel \
		    -text "Cancel" \
            -command {destroy $::gaussianVMD::openFile} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::openFile.frame.back -x 205 -y 120 -width 185

}