package provide guiSaveFile 1.5.1
package require Tk


#### GUI ############################################################
proc molUP::guiSaveFile {} {

    #### Check if the window exists
	if {[winfo exists $::molUP::saveFile]} {wm deiconify $::molUP::saveFile ;return $::molUP::saveFile}
	toplevel $::molUP::saveFile

	#### Title of the windows
	wm title $molUP::saveFile "Save structure as ..." ;# titulo da pagina

    # screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -50]

	#### Change the location of window
    wm geometry $::molUP::saveFile 400x180+[expr ($sWidth - 400) / 2]+[expr ($sHeight -200) / 2]
	$::molUP::saveFile configure -background {white}
	wm resizable $::molUP::saveFile 0 0


	## Apply theme
	ttk::style theme use molUPTheme


    #### Draw the GUI
    # Frame
    pack [ttk::frame $molUP::saveFile.frame]
    pack [canvas $molUP::saveFile.frame.back -bg white -width 400 -height 180 -highlightthickness 0] -in $molUP::saveFile.frame

    place [ttk::label $molUP::saveFile.frame.back.label1 \
			-text {Save current structure as } \
            -style molUP.white.TLabel \
            ] -in $molUP::saveFile.frame.back -x 10 -y 13 -width 150

    place [ttk::combobox $molUP::saveFile.frame.back.selectLoadMode \
		    -textvariable molUP::saveOptions \
			-state readonly \
            -style molUP.white.TCombobox \
		    -values "[list "Gaussian Input File (.com)" "Protein Data Bank (.pdb)" "Coordinates XYZ (.xyz)" "ORCA Input File (.inp)"]"
            ] -in $molUP::saveFile.frame.back -x 170 -y 10 -width 220

            $molUP::saveFile.frame.back.selectLoadMode set "Gaussian Input File (.com)"
    
    place [ttk::button $molUP::saveFile.frame.back.buttonLoad \
		    -text "Save" \
		    -command {molUP::saveOrder} \
            -style molUP.TButton \
            ] -in $molUP::saveFile.frame.back -x 10 -y 50 -width 185

    place [ttk::button $molUP::saveFile.frame.back.buttonCancel \
		    -text "Cancel" \
            -command {destroy $::molUP::saveFile} \
            -style molUP.TButton \
            ] -in $molUP::saveFile.frame.back -x 205 -y 50 -width 185

     place [ttk::label $molUP::saveFile.frame.back.advancedOptionsLabel \
			-text {Advanced options } \
            -style molUP.white.TLabel \
            ] -in $molUP::saveFile.frame.back -x 10 -y 95 -width 150

    place [ttk::label $molUP::saveFile.frame.back.saveOptionLabel \
			-text {Save:} \
            -style molUP.white.TLabel \
            ] -in $molUP::saveFile.frame.back -x 20 -y 118 -width 150

    place [ttk::combobox $molUP::saveFile.frame.back.saveAdvancedOptions \
		    -textvariable molUP::saveAdvancedOptions \
			-state readonly \
            -style molUP.white.TCombobox \
		    -values "[list "All" "High Layer" "Medium Layer" "Low Layer" "Freeze atoms" "Unfreeze atoms" "Protein" "Custom"]"
            ] -in $molUP::saveFile.frame.back -x 80 -y 115 -width 310
    bind $molUP::saveFile.frame.back.saveAdvancedOptions <<ComboboxSelected>> molUP::saveAdvancedOptions

    place [ttk::label $molUP::saveFile.frame.back.atomSelectionLabel \
			-text {Atom Selection:} \
            -style molUP.white.TLabel \
            ] -in $molUP::saveFile.frame.back -x 20 -y 143 -width 150

    place [ttk::entry $molUP::saveFile.frame.back.atomSelection \
			-textvariable molUP::atomSelectionSave \
			-style molUP.TEntry \
            -state disabled \
			] -in $molUP::saveFile.frame.back -x 120 -y 140 -width 270

}

proc molUP::saveAdvancedOptions {} {
    if {$molUP::saveAdvancedOptions == "All"} {
        set molUP::atomSelectionSave "all"
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } elseif {$molUP::saveAdvancedOptions == "Custom"} {
        set molUP::atomSelectionSave "index "
        $molUP::saveFile.frame.back.atomSelection configure -state normal
    } elseif {$molUP::saveAdvancedOptions == "High Layer"} {
        set molUP::atomSelectionSave "altloc H"
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } elseif {$molUP::saveAdvancedOptions == "Medium Layer"} {
        set molUP::atomSelectionSave "altloc M"
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } elseif {$molUP::saveAdvancedOptions == "Low Layer"} {
        set molUP::atomSelectionSave "altloc L"
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } elseif {$molUP::saveAdvancedOptions == "Freeze atoms"} {
        set molUP::atomSelectionSave "user \"-1\" \"-2\" \"-3\""
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } elseif {$molUP::saveAdvancedOptions == "Unfreeze atoms"} {
        set molUP::atomSelectionSave "user 0"
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } elseif {$molUP::saveAdvancedOptions == "Protein"} {
        set molUP::atomSelectionSave "protein"
        $molUP::saveFile.frame.back.atomSelection configure -state disabled
    } else {
        #Do nothing
    }
}

proc molUP::saveOrder {} {
    if {$molUP::saveOptions == "Gaussian Input File (.com)"} {
        molUP::saveGaussian

    } elseif {$molUP::saveOptions == "Protein Data Bank (.pdb)"} {
        molUP::savePDB

    } elseif {$molUP::saveOptions == "Coordinates XYZ (.xyz)"} {
        molUP::saveXYZ

    } elseif {$molUP::saveOptions == "ORCA Input File (.inp)"} {
        molUP::saveORCA
        
    } else {
        set message "Please select a suitable structure to save."
        molUP::guiError $message
    }
}