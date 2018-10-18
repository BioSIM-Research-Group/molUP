package provide publication 1.5.2

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
	wm title $molUP::citations "References to cite" ;# titulo da pagina

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

    place [text $molUP::citations.frame.back.label1 \
		-width 380 \
		-yscrollcommand "$molUP::citations.frame.back.yscb0 set" \
		-wrap word \
		-state normal \
	] -in $molUP::citations.frame.back -x 10 -y 10 -width 560 -height 250

    $molUP::citations.frame.back.label1 edit modified true

	$molUP::citations.frame.back.label1 delete 1.0 end
	$molUP::citations.frame.back.label1 insert end $content
	$molUP::citations.frame.back.label1 configure -state disabled

	place [ttk::scrollbar $molUP::citations.frame.back.yscb0 \
			-orient vertical \
			-command [list $molUP::citations.frame.back.label1 yview]\
	] -in $molUP::citations.frame.back -x 575 -y 10 -width 15 -height 250

    place [ttk::button $molUP::citations.frame.back.copyClipboardButton \
			-text "Copy to Clipboard" \
            -style molUP.copyButton.TButton \
			-command {molUP::copyClipboardFromText $molUP::citations.frame.back.label1} \
	] -in $molUP::citations.frame.back -x 10 -y 260 -width 20 -height 20

    place [ttk::button $molUP::citations.frame.back.closeWindow \
			-text "Close" \
            -style molUP.TButton \
			-command {destroy $molUP::citations} \
	] -in $molUP::citations.frame.back -x 40 -y 260 -width 70 -height 20

}

proc molUP::getCitationsFromKeywords {} {
    set molID [lindex $molUP::topMolecule 0]
    set references ""

    if {$molID != -1} {

        ## Read keywords entry
        set keywords [.molUP.frame0.major.mol$molID.tabs.tabInput.keywordsText get 1.0 end]

        catch {exec $molUP::grep "^%" "$::molUPpath/user/references.txt" | $molUP::cut -f2 -d%} searchDataBase


        foreach word $searchDataBase {
            set test [string match -nocase "*$word*" $keywords]
            if {$test == 1} {
                catch {exec $molUP::sed -n "/%$word/I,/#################################################/p" "$::molUPpath/user/references.txt" | $molUP::grep -v -e "###################" -e "^%"} ref

                append references "\n$word: \n$ref\n"
            } else {
                #Do nothing
            }
        }
    }

    set molUPRef "\nmolUP:\nmolUP: A VMD plugin to handle QM and ONIOM calculations using the gaussian software, H. S. Fernandes, M. J. Ramos, N. M. F. S. A. Cerqueira, J. Comput. Chem., (2018)\ndoi.org/10.1002/jcc.25189\n"
    set vmdRef "\nVMD:\nVMD - Visual Molecular Dynamics, Humphrey, W., Dalke, A. and Schulten, K., J. Molec. Graphics, (2018)\ndoi.org/10.1016/0263-7855(96)00018-5\n"
    set gaussianRef "\nGaussian09 D.01:\nGaussian 09, Revision D.01, M. J. Frisch, G. W. Trucks, H. B. Schlegel, G. E. Scuseria, M. A. Robb, J. R. Cheeseman, G. Scalmani, V. Barone, B. Mennucci, G. A. Petersson, H. Nakatsuji, M. Caricato, X. Li, H. P. Hratchian, A. F. Izmaylov, J. Bloino, G. Zheng, J. L. Sonnenberg, M. Hada, M. Ehara, K. Toyota, R. Fukuda, J. Hasegawa, M. Ishida, T. Nakajima, Y. Honda, O. Kitao, H. Nakai, T. Vreven, J. A. Montgomery, Jr., J. E. Peralta, F. Ogliaro, M. Bearpark, J. J. Heyd, E. Brothers, K. N. Kudin, V. N. Staroverov, T. Keith, R. Kobayashi, J. Normand, K. Raghavachari, A. Rendell, J. C. Burant, S. S. Iyengar, J. Tomasi, M. Cossi, N. Rega, J. M. Millam, M. Klene, J. E. Knox, J. B. Cross, V. Bakken, C. Adamo, J. Jaramillo, R. Gomperts, R. E. Stratmann, O. Yazyev, A. J. Austin, R. Cammi, C. Pomelli, J. W. Ochterski, R. L. Martin, K. Morokuma, V. G. Zakrzewski, G. A. Voth, P. Salvador, J. J. Dannenberg, S. Dapprich, A. D. Daniels, O. Farkas, J. B. Foresman, J. V. Ortiz, J. Cioslowski, and D. J. Fox, Gaussian, Inc., Wallingford CT, 2013.\n"
    
    append references $gaussianRef
    append references $molUPRef
    append references $vmdRef

    return $references
}