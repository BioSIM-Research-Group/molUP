package provide guiError 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiError {message} {

    #### Check if the window exists
	if {[winfo exists $::molUP::error]} {wm deiconify $::molUP::error ;return $::molUP::error}
	toplevel $::molUP::error

	#### Title of the windows
	wm title $molUP::error "Error" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::error 400x90+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::molUP::error configure -background {white}
	wm resizable $::molUP::error 0 0


	## Apply theme
	ttk::style theme use molUPTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::error.frame]
    pack [canvas $molUP::error.frame.back -bg #ffe87a -width 400 -height 90 -highlightthickness 0] -in $molUP::error.frame

    place [ttk::label $molUP::error.frame.back.label1 \
            -text [subst $message] \
            -style molUP.yellow.TLabel \
            ] -in $molUP::error.frame.back -x 10 -y 13 -width 380

    place [ttk::button $molUP::error.frame.back.buttonCancel \
		    -text "OK" \
            -command {destroy $::molUP::error} \
            -style molUP.TButton \
            ] -in $molUP::error.frame.back -x 100 -y 50 -width 200

}