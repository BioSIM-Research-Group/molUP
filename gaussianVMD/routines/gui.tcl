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
	ttk::style configure gaussianVMD.topButtons.TButton \
		-width 7 \
		-anchor center
	
	##########################################################


	#### Top Section
	pack [ttk::frame $gaussianVMD::topGui.frame0]
	pack [canvas $gaussianVMD::topGui.frame0.topSection -bg white -width 400 -height 40 -highlightthickness 0] -in $gaussianVMD::topGui.frame0 


	place [ttk::button $gaussianVMD::topGui.frame0.topSection.openButton \
			-text "OPEN" \
			-command {} \
			-style gaussianVMD.topButtons.TButton] -x 5 -y 5 -in $gaussianVMD::topGui.frame0.topSection

	place [ttk::button $gaussianVMD::topGui.saveButton \
		    -text "SAVE" \
			-command {} \
			-style gaussianVMD.topButtons.TButton] -x 105 -y 5 -in $gaussianVMD::topGui.frame0.topSection

	place [ttk::button $gaussianVMD::topGui.restartButton \
		    -text "RESTART" \
			-command {gaussianVMD::restart} \
			-style gaussianVMD.topButtons.TButton] -x 205 -y 5 -in $gaussianVMD::topGui.frame0.topSection

	place [ttk::button $gaussianVMD::topGui.quitButton \
		    -text "QUIT" \
			-command {gaussianVMD::quit} \
			-style gaussianVMD.topButtons.TButton] -x 305 -y 5 -in $gaussianVMD::topGui.frame0.topSection


	#### Job Title
	pack [canvas $gaussianVMD::topGui.frame0.jobTitle -bg white -width 400 -height 30 -highlightthickness 0] -in $gaussianVMD::topGui.frame0
	place [label $gaussianVMD::topGui.frame0.jobTitle.labe \
			-text {Job Title:} \
			-background {white}] -in $gaussianVMD::topGui.frame0.jobTitle -x 5 -y 5
	
	place [ttk::entry $gaussianVMD::topGui.frame0.jobTitle.entry \
			-textvariable gaussianVMD::title ] -in $gaussianVMD::topGui.frame0.jobTitle -x 70 -y 5 -width 320







}