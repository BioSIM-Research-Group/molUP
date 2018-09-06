package provide guiOpenFile 1.5.1
package require Tk


#### GUI ############################################################
proc molUP::guiOpenFile {} {

    #### Contidition to evaluate if a new molecule can or not be loaded.
    if {$molUP::openNewFileMode == "NO"} {
        molUP::guiError "One molecule has already been loaded in molUP. \n Please click File-Restart to load a new molecule."
    } else {

    

    #### Check if the window exists
	if {[winfo exists $::molUP::openFile]} {wm deiconify $::molUP::openFile ;return $::molUP::openFile}
	toplevel $::molUP::openFile

	#### Title of the windows
	wm title $molUP::openFile "Open a file" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::openFile 400x190+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::molUP::openFile configure -background {white}
	wm resizable $::molUP::openFile 0 0


	## Apply theme
	ttk::style theme use molUPTheme
 

    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::openFile.frame]
    pack [canvas $molUP::openFile.frame.back -bg white -width 400 -height 190 -highlightthickness 0] -in $molUP::openFile.frame

    place [ttk::label $molUP::openFile.frame.back.label1 \
			-text {Choose a Gaussian Output (.log) or Input (.com) file...} \
            -style molUP.white.TLabel \
            ] -in $molUP::openFile.frame.back -x 10 -y 10

    place [ttk::entry $molUP::openFile.frame.back.pathEntry \
		    -textvariable molUP::path \
            -style molUP.white.TEntry \
            ] -in $molUP::openFile.frame.back -x 10 -y 40 -width 295 -height 28

    place [ttk::button $molUP::openFile.frame.back.buttonBrowseFile \
		    -text "Browse" \
		    -command molUP::onSelect \
            -style molUP.TButton \
            ] -in $molUP::openFile.frame.back -x 315 -y 40 -width 75


    place [ttk::label $molUP::openFile.frame.back.label2 \
			-text {Loading options: } \
            -style molUP.white.TLabel \
            ] -in $molUP::openFile.frame.back -x 10 -y 82 -width 100

    place [ttk::combobox $molUP::openFile.frame.back.selectLoadMode \
		    -textvariable $molUP::loadMode \
			-state readonly \
            -style molUP.TCombobox \
		    -values "[list "Last Structure" "First Structure" "All optimized structures" "All structures (may take a long time to load)"]"
            ] -in $molUP::openFile.frame.back -x 120 -y 80 -width 270

            $molUP::openFile.frame.back.selectLoadMode set "Last Structure"

    place [ttk::button $molUP::openFile.frame.back.buttonLoad \
		    -text "Load" \
		    -command {molUP::loadButton $molUP::fileExtension} \
            -style molUP.TButton \
            ] -in $molUP::openFile.frame.back -x 10 -y 120 -width 185

    place [ttk::button $molUP::openFile.frame.back.buttonCancel \
		    -text "Cancel" \
            -command {destroy $::molUP::openFile} \
            -style molUP.TButton \
            ] -in $molUP::openFile.frame.back -x 205 -y 120 -width 185

    place [ttk::label $molUP::openFile.frame.back.labelFinal \
			-text {This window will close automatically when the structure loads.} \
            -style molUP.white.TLabel \
            ] -in $molUP::openFile.frame.back -x 10 -y 160 -width 380

    }

}