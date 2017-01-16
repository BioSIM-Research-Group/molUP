package provide guiCredits 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiCredits {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::credits]} {wm deiconify $::gaussianVMD::credits ;return $::gaussianVMD::credits}
	toplevel $::gaussianVMD::credits

	#### Title of the windows
	wm title $gaussianVMD::credits "Credits" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::credits] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::credits] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::credits 400x200+[expr $sWidth - 400]+100
	$::gaussianVMD::credits configure -background {white}
	wm resizable $::gaussianVMD::credits 0 0

	## Apply theme
	ttk::style theme use clearlooks

    ## Styles
	ttk::style configure gaussianVMD.button.TButton \
		-anchor center

	ttk::style configure gaussianVMD.label.TLabel \
		-anchor center

    #### Information
    pack [ttk::frame $gaussianVMD::credits.frame0]
	pack [canvas $gaussianVMD::credits.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::credits.frame0 


}