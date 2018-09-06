package provide guiChangelog 1.5.1

#### GUI ############################################################
proc molUP::guiChangelog {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::changelog]} {wm deiconify $::molUP::changelog ;return $::molUP::changelog}
	toplevel $::molUP::changelog

	#### Title of the windows
	wm title $molUP::changelog "Changelog" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::changelog] -0]
	set sHeight [expr [winfo vrootheight $::molUP::changelog] -50]

	#### Change the location of window
    wm geometry $::molUP::changelog 400x200+[expr $sWidth - 400]+100
	$::molUP::changelog configure -background {white}
	wm resizable $::molUP::changelog 0 0

	## Apply theme
	ttk::style theme use molUPTheme

    #### Information
    pack [ttk::frame $molUP::changelog.frame0]
	pack [canvas $molUP::changelog.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $molUP::changelog.frame0

	set file [open "$::molUPpath/changelog.txt" r]
	set content [read $file]

	place [text $molUP::changelog.frame0.frame.label1 \
		-width 380 \
		-yscrollcommand "$molUP::changelog.frame0.frame.yscb0 set" \
		-wrap word \
		-state normal \
	] -in $molUP::changelog.frame0.frame -x 10 -y 10 -width 360 -height 180

	$molUP::changelog.frame0.frame.label1 delete 1.0 end
	$molUP::changelog.frame0.frame.label1 insert end $content
	$molUP::changelog.frame0.frame.label1 configure -state disabled

	place [ttk::scrollbar $molUP::changelog.frame0.frame.yscb0 \
			-orient vertical \
			-command [list $molUP::changelog.frame0.frame.label1 yview]\
	] -in $molUP::changelog.frame0.frame -x 375 -y 10 -width 15 -height 180


}