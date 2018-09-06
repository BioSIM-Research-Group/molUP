package provide guiOpenMultiFile 1.5.1
package require Tk


#### GUI ############################################################
proc molUP::guiOpenMultiFile {} {

    #### Contidition to evaluate if a new molecule can or not be loaded.
    if {$molUP::openNewFileMode == "NO"} {
        molUP::guiError "One molecule has already been loaded in molUP. \n Please click File-Restart to load a new molecule."
    } else {

    

    #### Check if the window exists
	if {[winfo exists $::molUP::openMultiFile]} {wm deiconify $::molUP::openMultiFile ;return $::molUP::openMultiFile}
	toplevel $::molUP::openMultiFile

	#### Title of the windows
	wm title $molUP::openMultiFile "Open multiple files" ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::openMultiFile 400x190+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::molUP::openMultiFile configure -background {white}
	wm resizable $::molUP::openMultiFile 0 0


	## Apply theme
	ttk::style theme use molUPTheme
 

    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::openMultiFile.frame]
    pack [canvas $molUP::openMultiFile.frame.back -bg white -width 400 -height 190 -highlightthickness 0] -in $molUP::openMultiFile.frame

    place [ttk::label $molUP::openMultiFile.frame.back.label1 \
			-text "Choose multiple Gaussian Output (.log) and/or Input (.com) files..." \
            -style molUP.white.TLabel \
            ] -in $molUP::openMultiFile.frame.back -x 10 -y 10

    place [text $molUP::openMultiFile.frame.back.pathEntry \
		    -yscrollcommand "$molUP::openMultiFile.frame.back.yscb0 set" \
		    -bd 1 \
		    -highlightcolor #017aff \
		    -highlightthickness 1 \
            ] -in $molUP::openMultiFile.frame.back -x 10 -y 40 -width 285 -height 75
    $molUP::openMultiFile.frame.back.pathEntry insert end "/"

    place [ttk::scrollbar $molUP::openMultiFile.frame.back.yscb0 \
			-orient vertical \
			-command [list $molUP::openMultiFile.frame.back.pathEntry yview]\
			] -in $molUP::openMultiFile.frame.back -x 295 -y 40 -width 15 -height 75

    place [ttk::button $molUP::openMultiFile.frame.back.buttonBrowseFile \
		    -text "Browse" \
		    -command molUP::onSelectMultiple \
            -style molUP.TButton \
            ] -in $molUP::openMultiFile.frame.back -x 315 -y 40 -width 75

    place [ttk::button $molUP::openMultiFile.frame.back.buttonLoad \
		    -text "Load" \
		    -command {molUP::loadMultipleFiles} \
            -style molUP.TButton \
            ] -in $molUP::openMultiFile.frame.back -x 10 -y 120 -width 185

    place [ttk::button $molUP::openMultiFile.frame.back.buttonCancel \
		    -text "Cancel" \
            -command {destroy $::molUP::openMultiFile} \
            -style molUP.TButton \
            ] -in $molUP::openMultiFile.frame.back -x 205 -y 120 -width 185

    place [ttk::label $molUP::openMultiFile.frame.back.labelFinal \
			-text "This window will close automatically when all structures are loaded." \
            -style molUP.white.TLabel \
            ] -in $molUP::openMultiFile.frame.back -x 10 -y 160 -width 380

    }

}

proc molUP::onSelectMultiple {} {
    set fileTypes {
			{{Gaussian Files}       {.log .com}        }
            {{Gaussian Input (.com)}       {.com}        }
            {{Gaussian Output (.log)}       {.log}        }
    }
    set molUP::path [tk_getOpenFile -filetypes $fileTypes -multiple 1]

    $molUP::openMultiFile.frame.back.pathEntry delete 1.0 end
    foreach path $molUP::path {
        $molUP::openMultiFile.frame.back.pathEntry insert end "$path\n"
    }
}

proc molUP::loadMultipleFiles {} {
    set paths [split [$molUP::openMultiFile.frame.back.pathEntry get 1.0 end] " "]
    set i 1
    while {[$molUP::openMultiFile.frame.back.pathEntry get $i.0 $i.end] != ""} {
        set molUP::path [$molUP::openMultiFile.frame.back.pathEntry get $i.0 $i.end]
        set fileExtension [molUP::fileExtension "$molUP::path"]
        molUP::loadBash $fileExtension "-multiple"
        incr i
    }
    destroy $molUP::openMultiFile
}