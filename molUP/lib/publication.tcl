package provide publication 1.0

proc molUP::citeMolUP {} {
     #### Check if the window exists
	if {[winfo exists $::molUP::citeMolUP]} {wm deiconify $::molUP::citeMolUP ;return $::molUP::citeMolUP}
	toplevel $::molUP::citeMolUP
    wm attributes $::molUP::citeMolUP -topmost yes

	#### Title of the windows
	wm title $molUP::citeMolUP "Cite MolUP" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::citeMolUP 400x130+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::molUP::citeMolUP configure -background {white}
	wm resizable $::molUP::citeMolUP 0 0


	## Apply theme
	ttk::style theme use molUPTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::citeMolUP.frame]
    pack [canvas $molUP::citeMolUP.frame.back -bg white -width 400 -height 130 -highlightthickness 0] -in $molUP::citeMolUP.frame

    set message "Thanks for using MolUP.\nPlease cite MolUP according to the following information:\nFernandes, HS and Cerqueira, N. M. F. S. A., 2017"

    place [ttk::label $molUP::citeMolUP.frame.back.label1 \
            -text [subst $message] \
            -style molUP.white.TLabel \
            ] -in $molUP::citeMolUP.frame.back -x 10 -y 13 -width 380

    place [ttk::button $molUP::citeMolUP.frame.back.buttonCancel \
		    -text "Export citation" \
            -command {destroy $::molUP::citeMolUP} \
            -style molUP.TButton \
            ] -in $molUP::citeMolUP.frame.back -x 100 -y 90 -width 200
}

proc molUP::citations {} {
     #### Check if the window exists
	if {[winfo exists $::molUP::citations]} {wm deiconify $::molUP::citations ;return $::molUP::citations}
	toplevel $::molUP::citations
    wm attributes $::molUP::citations -topmost yes

	#### Title of the windows
	wm title $molUP::citations "Referenes to cite" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::citations 600x300+[expr ($sWidth - 600) / 2]+[expr ($sHeight -300) / 2]
	$::molUP::citations configure -background {white}
	wm resizable $::molUP::citations 0 0


	## Apply theme
	ttk::style theme use molUPTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::citations.frame]
    pack [canvas $molUP::citations.frame.back -bg white -width 600 -height 300 -highlightthickness 0] -in $molUP::citations.frame

    set content "This is a list of the references that you should cite based on the calculations that you performed:\n"

    set references [molUP::getCitationsFromKeywords]

    append content $references
    puts $references

    place [text $molUP::citations.frame.back.label1 \
		-width 380 \
		-yscrollcommand "$molUP::citations.frame.back.yscb0 set" \
		-wrap word \
		-state normal \
	] -in $molUP::citations.frame.back -x 10 -y 10 -width 560 -height 180

    $molUP::citations.frame.back.label1 edit modified true

	$molUP::citations.frame.back.label1 delete 1.0 end
	$molUP::citations.frame.back.label1 insert end $content
	$molUP::citations.frame.back.label1 configure -state disabled

	place [ttk::scrollbar $molUP::citations.frame.back.yscb0 \
			-orient vertical \
			-command [list $molUP::citations.frame.back.label1 yview]\
	] -in $molUP::citations.frame.back -x 575 -y 10 -width 15 -height 180

    place [ttk::button $molUP::citations.frame.back.copyClipboardButton \
			-text "Copy to Clipboard" \
			-command {clipboard append "Hello"} \
	] -in $molUP::citations.frame.back -x 100 -y 210 -width 300

}

proc molUP::getCitationsFromKeywords {} {
    set molID [molinfo top]

    ## Read keywords entry
    set keywords [.molUP.frame0.major.mol$molID.tabs.tabInput.keywordsText get 1.0 end]

    catch {exec grep "^%" "$::molUPpath/lib/references.txt" | cut -f2 -d%} searchDataBase

    set references ""

    foreach word $searchDataBase {
        set test [string match -nocase "*$word*" $keywords]
        if {$test == 1} {
            catch {exec sed -n "/%$word/I,/#################################################/p" "$::molUPpath/lib/references.txt" | egrep -v -e "###################" -e "^%"} ref

            append references "\n$word: \n$ref\n"
        } else {
            #Do nothing
        }
    }

    return $references
}