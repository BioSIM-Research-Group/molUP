package provide gui 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::buildGui {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::topGui]} {wm deiconify $::gaussianVMD::topGui ;return $::gaussianVMD::topGui}
	toplevel $::gaussianVMD::topGui

	#### Title of the windows
	wm title $gaussianVMD::topGui "Gaussian for VMD v$gaussianVMD::version " ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::topGui] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::topGui] -50]

	#window wifth and height
	set wWidth [winfo reqwidth $::gaussianVMD::topGui]
	set wHeight [winfo reqheight $::gaussianVMD::topGui]
	
	display reposition 0 [expr ${sHeight} - 15]
	display resize [expr $sWidth - 400] ${sHeight}

	#wm geometry window $gaussianVMD::topGui 400x590
	set x [expr $sWidth - 2*($wWidth)]

	wm geometry $::gaussianVMD::topGui 400x600+$x+25
	$::gaussianVMD::topGui configure -background {white}
	wm resizable $::gaussianVMD::topGui 0 0

	## Apply theme
	ttk::style theme use clearlooks

	## Styles
	ttk::style configure gaussianVMD.jobTitle.TEntry \
		-font {"Arial Black" 12} \
		-foreground {blue} \

	ttk::style configure gaussianVMD.topButtons.TButton \
		-width 7 \
		-anchor center
	
	##########################################################


	#### FRAME 0 - initial logo
	pack [ttk::frame $gaussianVMD::topGui.frame0]
	pack [canvas $gaussianVMD::topGui.frame0.topSection -bg blue -border 0  -width 400 -height 50] -in $gaussianVMD::topGui.frame0 


	place [ttk::button $gaussianVMD::topGui.frame0.topSection.openButton \
			-text "OPEN" \
			-command {} \
			-style gaussianVMD.topButtons.TButton] -x 5 -y 10

	place [ttk::button $gaussianVMD::topGui.saveButton \
		    -text "SAVE" \
			-command {} \
			-style gaussianVMD.topButtons.TButton] -x 105 -y 10

	place [ttk::button $gaussianVMD::topGui.restartButton \
		    -text "RESTART" \
			-command {gaussianVMD::restart} \
			-style gaussianVMD.topButtons.TButton] -x 205 -y 10

	place [ttk::button $gaussianVMD::topGui.quitButton \
		    -text "QUIT" \
			-command {gaussianVMD::quit} \
			-style gaussianVMD.topButtons.TButton] -x 305 -y 10
}