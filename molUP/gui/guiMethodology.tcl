package provide guiMethodology 1.0

proc molUP::methodology {} {
     #### Check if the window exists
	if {[winfo exists $::molUP::methodology]} {wm deiconify $::molUP::methodology ;return $::molUP::methodology}
	toplevel $::molUP::methodology
    wm attributes $::molUP::methodology

	#### Title of the windows
	wm title $molUP::methodology "Methodology" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::methodology 600x300+[expr ($sWidth - 600) / 2]+[expr ($sHeight -300) / 2]
	$::molUP::methodology configure -background {white}
	wm resizable $::molUP::methodology 0 0


	## Apply theme
	ttk::style theme use molUPTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::methodology.frame]
    pack [canvas $molUP::methodology.frame.back -bg white -width 600 -height 300 -highlightthickness 0] -in $molUP::methodology.frame

    ## Grep all options available
    catch {exec $molUP::grep "%" "$::molUPpath/user/methodology.txt" | $molUP::cut -f2 -d%} listOptions
	set listOptions [split $listOptions "\n"]

    variable methodOption

    place [ttk::combobox $molUP::methodology.frame.back.combo \
			-textvariable molUP::methodOption \
			-style molUP.TCombobox \
			-values "$listOptions" \
			-state readonly \
			] -in $molUP::methodology.frame.back -x 10 -y 5 -width 580
	bind $molUP::methodology.frame.back.combo <<ComboboxSelected>> {molUP::readMethodText}
    
    set content "Methodology \nPlease select one option from the ones available above."

    place [text $molUP::methodology.frame.back.label1 \
		-width 380 \
		-yscrollcommand "$molUP::methodology.frame.back.yscb0 set" \
		-wrap word \
		-state normal \
	] -in $molUP::methodology.frame.back -x 10 -y 50 -width 560 -height 210

    $molUP::methodology.frame.back.label1 edit modified true

	$molUP::methodology.frame.back.label1 delete 1.0 end
	$molUP::methodology.frame.back.label1 insert end $content
	$molUP::methodology.frame.back.label1 configure -state disabled

	place [ttk::scrollbar $molUP::methodology.frame.back.yscb0 \
			-orient vertical \
			-command [list $molUP::methodology.frame.back.label1 yview]\
	] -in $molUP::methodology.frame.back -x 575 -y 50 -width 15 -height 210

    place [ttk::button $molUP::methodology.frame.back.copyClipboardButton \
			-text "Copy to Clipboard" \
            -style molUP.copyButton.TButton \
			-command {molUP::copyClipboardFromText $molUP::methodology.frame.back.label1} \
	] -in $molUP::methodology.frame.back -x 10 -y 260 -width 20 -height 20

    place [ttk::button $molUP::methodology.frame.back.closeWindow \
			-text "Close" \
            -style molUP.TButton \
			-command {destroy $molUP::methodology} \
	] -in $molUP::methodology.frame.back -x 40 -y 260 -width 70 -height 20

}


proc molUP::readMethodText {args} {
    catch {exec $molUP::sed -n "/%$molUP::methodOption/I,/#################################################/p" "$::molUPpath/user/methodology.txt" | $molUP::grep -v -e "###################" -e "^%"} text

    $molUP::methodology.frame.back.label1 configure -state normal
    $molUP::methodology.frame.back.label1 delete 1.0 end
    $molUP::methodology.frame.back.label1 insert end "Methodology\n\n"
    $molUP::methodology.frame.back.label1 insert end $text
    $molUP::methodology.frame.back.label1 configure -state disabled

	molUP::checkFields $molUP::methodology.frame.back.label1

}

proc molUP::checkFields {pathName} {
	set blankSpace [list XXX]
	foreach word $blankSpace {
		molUP::textSearch $pathName $word blankSpace
	}
	$pathName tag configure blankSpace -foreground "red"
}