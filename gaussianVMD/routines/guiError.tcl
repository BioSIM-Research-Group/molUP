package provide guiError 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiError {message} {

    #### Check if the window exists
	if {[winfo exists $::gaussianVMD::error]} {wm deiconify $::gaussianVMD::error ;return $::gaussianVMD::error}
	toplevel $::gaussianVMD::error

	#### Title of the windows
	wm title $gaussianVMD::error "Error" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::topGui] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::topGui] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::error 400x90+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::gaussianVMD::error configure -background {white}
	wm resizable $::gaussianVMD::error 0 0


	## Apply theme
	ttk::style theme use gaussianVMDTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $gaussianVMD::error.frame]
    pack [canvas $gaussianVMD::error.frame.back -bg #ffe87a -width 400 -height 90 -highlightthickness 0] -in $gaussianVMD::error.frame

    place [ttk::label $gaussianVMD::error.frame.back.label1 \
            -text [subst $message] \
            -style gaussianVMD.yellow.TLabel \
            ] -in $gaussianVMD::error.frame.back -x 10 -y 13 -width 380

    place [ttk::button $gaussianVMD::error.frame.back.buttonCancel \
		    -text "OK" \
            -command {destroy $::gaussianVMD::error} \
            -style gaussianVMD.TButton \
            ] -in $gaussianVMD::error.frame.back -x 100 -y 50 -width 200

}