package provide guiInfo 1.0

#### GUI ############################################################
proc molUP::guiInfo {fileName} {

	#### Check if the window exists
	if {[winfo exists $::molUP::info]} {wm deiconify $::molUP::info ;return $::molUP::info}
	toplevel $::molUP::info

	#### Title of the windows
	wm title $molUP::info "Information" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::info] -0]
	set sHeight [expr [winfo vrootheight $::molUP::info] -50]

	#### Change the location of window
    wm geometry $::molUP::info 400x600+[expr $sWidth - 400]+100
	$::molUP::info configure -background {white}
	wm resizable $::molUP::info 0 0

	## Apply theme
	ttk::style theme use molUPTheme

    #### Information
    pack [ttk::frame $molUP::info.frame0]
	pack [canvas $molUP::info.frame0.frame -bg white -width 400 -height 600 -highlightthickness 0] -in $molUP::info.frame0

	set file [open "$::molUPpath/infoTexts/$fileName" r]
	set content [read $file]

	place [text $molUP::info.frame0.frame.label1 \
		-width 380 \
		-yscrollcommand "$molUP::info.frame0.frame.yscb0 set" \
		-wrap word \
		-state normal \
	] -in $molUP::info.frame0.frame -x 10 -y 10 -width 360 -height 580

	$molUP::info.frame0.frame.label1 delete 1.0 end
	$molUP::info.frame0.frame.label1 insert end $content
	$molUP::info.frame0.frame.label1 configure -state disabled

	place [ttk::scrollbar $molUP::info.frame0.frame.yscb0 \
			-orient vertical \
			-command [list $molUP::info.frame0.frame.label1 yview]\
	] -in $molUP::info.frame0.frame -x 375 -y 10 -width 15 -height 580


}