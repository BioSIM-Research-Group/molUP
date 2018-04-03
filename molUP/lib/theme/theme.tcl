package provide gaussianTheme 1.0

proc molUP::loadImages {imgdir {patterns {*.gif}}} {
    foreach pattern $patterns {
        foreach file [glob -directory $imgdir $pattern] {
            set img [file tail [file rootname $file]]
            if {![info exists images($img)]} {
                set images($img) [image create photo -file $file]
            }
        }
    }
    return [array get images]
}

variable images

array set molUP::images [molUP::loadImages [file join [file dirname [info script]] images] *.gif]

ttk::style theme create molUPTheme -parent clam -settings {

    

    #### Colors
    set blue #017aff
    set cyan #b3dbff
    set gray #ededed
    set lightGreen #ccffcc

    ttk::style configure . \
        -background white

    #### Buttons

    #Reset Button
    ttk::style element create molUP.reset.Button image \
        [list $molUP::images(button-reset) \
        active $molUP::images(button-reset-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.reset.TButton {
        Button.molUP.reset.Button
    }

    ttk::style element create molUP.center.Button image \
        [list $molUP::images(button-center) \
        active $molUP::images(button-center-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.center.TButton {
        Button.molUP.center.Button
    }

    ttk::style element create molUP.deleteAllLabels.Button image \
        [list $molUP::images(button-deletelabel) \
        active $molUP::images(button-deletelabel-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.deleteAllLabels.TButton {
        Button.molUP.deleteAllLabels.Button
    }

    ttk::style element create molUP.mouseModeRotate.Button image \
        [list $molUP::images(button-rotate) \
        active $molUP::images(button-rotate-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.mouseModeRotate.TButton {
        Button.molUP.mouseModeRotate.Button
    }

    ttk::style element create molUP.mouseModeTranslate.Button image \
        [list $molUP::images(button-mouseModeTranslate) \
        active $molUP::images(button-mouseModeTranslate-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.mouseModeTranslate.TButton {
        Button.molUP.mouseModeTranslate.Button
    }

    ttk::style element create molUP.mouseModeScale.Button image \
        [list $molUP::images(button-mouseModeScale) \
        active $molUP::images(button-mouseModeScale-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.mouseModeScale.TButton {
        Button.molUP.mouseModeScale.Button
    }

    ttk::style element create molUP.addRemoveBonds.Button image \
        [list $molUP::images(button-mouseModeAddRemoveBonds) \
        active $molUP::images(button-mouseModeAddRemoveBonds-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.addRemoveBonds.TButton {
        Button.molUP.addRemoveBonds.Button
    }

    ttk::style element create molUP.bondEdit.Button image \
        [list $molUP::images(button-bondEdit) \
        active $molUP::images(button-bondEdit-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.bondEdit.TButton {
        Button.molUP.bondEdit.Button
    }

    ttk::style element create molUP.angleEdit.Button image \
        [list $molUP::images(button-angleEdit) \
        active $molUP::images(button-angleEdit-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.angleEdit.TButton {
        Button.molUP.angleEdit.Button
    }

    ttk::style element create molUP.dihedralEdit.Button image \
        [list $molUP::images(button-dihedralEdit) \
        active $molUP::images(button-dihedralEdit-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.dihedralEdit.TButton {
        Button.molUP.dihedralEdit.Button
    }

    ttk::style element create molUP.addAtoms.Button image \
        [list $molUP::images(button-addAtoms) \
        active $molUP::images(button-addAtoms-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.addAtoms.TButton {
        Button.molUP.addAtoms.Button
    }

    ttk::style element create molUP.removeAtoms.Button image \
        [list $molUP::images(button-removeAtoms) \
        active $molUP::images(button-removeAtoms-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout molUP.removeAtoms.TButton {
        Button.molUP.removeAtoms.Button
    }



    #### Info button
    ttk::style element create molUP.infoButton.Button image \
        [list $molUP::images(infoButton) \
        active $molUP::images(infoButton-a)
        ] \
        -width 20 -height 20 -sticky news
    ttk::style layout molUP.infoButton.TButton {
        Button.molUP.infoButton.Button
    }

    #### Copy to clipboard button
    ttk::style element create molUP.copyButton.Button image \
        [list $molUP::images(button-copy) \
        active $molUP::images(button-copy-a)
        ] \
        -width 20 -height 20 -sticky news
    ttk::style layout molUP.copyButton.TButton {
        Button.molUP.copyButton.Button
    }



    #### MenuBar
    ttk::style configure molUP.menuBar.TFrame \
        -background $cyan \
        -relief raised

    ttk::style configure molUP.menuBar.TMenubutton \
        -background $cyan

    #### Label
    ttk::style configure molUP.gray.TLabel \
        -background $gray

    ttk::style configure molUP.white.TLabel \
        -background white

    ttk::style configure molUP.yellow.TLabel \
        -background #ffe87a        

    ttk::style configure molUP.whiteCenter.TLabel \
        -background white \
        -anchor center

    ttk::style configure molUP.cyanCenter.TLabel \
        -background $cyan \
        -anchor center

    ttk::style configure molUP.lightGreen.TLabel \
        -background $lightGreen

    ttk::style configure molUP.grayCenter.TLabel \
        -background $gray \
        -anchor center

    ttk::style configure molUP.cyan.TLabel \
        -background $cyan

    #### Combobox
    ttk::style configure molUP.TCombobox \
        -background $gray \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style element create molUP.Combobox.downarrow image \
         [list $molUP::images(comboarrow-n) \
         disabled $molUP::images(comboarrow-d) \
         pressed $molUP::images(comboarrow-p) \
         active $molUP::images(comboarrow-a) \
         ] \
         -border 1 -sticky {}

    ttk::style element create molUP.Combobox.field image \
         [list $molUP::images(combo-n) \
         ] \
         -sticky ew -border 4
    
    ttk::style layout molUP.TCombobox {
        Combobox.molUP.Combobox.downarrow -side right
        Combobox.molUP.Combobox.field -children {
            Combobox.molUP.Combobox.padding -children {
                Combobox.molUP.Combobox.textarea -expand true
            }
        }
    }


    ttk::style configure molUP.green.TCombobox \
        -background $lightGreen \
        -anchor center \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style element create molUP.green.Combobox.downarrow image \
         [list $molUP::images(comboarrow-n) \
         disabled $molUP::images(comboarrow-d) \
         pressed $molUP::images(comboarrow-p) \
         active $molUP::images(comboarrow-a) \
         ] \
         -border 1 -sticky {}

    ttk::style element create molUP.green.Combobox.field image \
         [list $molUP::images(combo-n) \
         ] \
         -sticky ew -border 4
    
    ttk::style layout molUP.green.TCombobox {
        Combobox.molUP.green.Combobox.downarrow -side right
        Combobox.molUP.green.Combobox.field -children {
            Combobox.molUP.green.Combobox.padding -children {
                Combobox.molUP.green.Combobox.textarea -expand true
            }
        }
    }

    ttk::style configure molUP.white.TCombobox \
        -background white \
        -anchor center \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style element create molUP.white.Combobox.downarrow image \
         [list $molUP::images(comboarrow-n) \
         disabled $molUP::images(comboarrow-d) \
         pressed $molUP::images(comboarrow-p) \
         active $molUP::images(comboarrow-a) \
         ] \
         -border 1 -sticky {}

    ttk::style element create molUP.white.Combobox.field image \
         [list $molUP::images(combo-n) \
         ] \
         -sticky ew -border 4
    
    ttk::style layout molUP.white.TCombobox {
        Combobox.molUP.white.Combobox.downarrow -side right
        Combobox.molUP.white.Combobox.field -children {
            Combobox.molUP.white.Combobox.padding -children {
                Combobox.molUP.white.Combobox.textarea -expand true
            }
        }
    }


    #### Major Notebook
    ttk::style configure molUP.major.TNotebook \
        -relief flat \
        -bordercolor $cyan \
        -lightcolor $cyan

    ttk::style configure molUP.major.TNotebook.Tab \
        -padding {6 2 6 2} \
        -lightcolor $cyan \
        -bordercolor $cyan \
        -anchor center

    ttk::style element create molUP.major.Notebook.tab \
            image [list $molUP::images(tab-n) \
                        selected    $molUP::images(tab-a) \
                        active      $molUP::images(tab-h) \
            ] -border {2 2 2 0}
    
    ttk::style layout molUP.major.TNotebook.Tab {
        Notebook.molUP.major.Notebook.tab -children {
            Notebook.molUP.major.Notebook.label
        }
    }

    ttk::style configure molUP.results.TNotebook \
        -relief flat \
        -bordercolor $lightGreen \
        -lightcolor $lightGreen \
        -background $cyan

    ttk::style configure molUP.results.TNotebook.Tab \
        -padding {6 2 6 2} \
        -lightcolor $lightGreen \
        -bordercolor $lightGreen \
        -background $cyan \
        -anchor center

    ttk::style element create molUP.results.Notebook.tab \
            image [list $molUP::images(tab1-n) \
                        selected    $molUP::images(tab1-a) \
                        active      $molUP::images(tab1-h) \
            ] -border {2 2 2 0}
    
    ttk::style layout molUP.results.TNotebook.Tab {
        Notebook.molUP.results.Notebook.tab -children {
            Notebook.molUP.results.Notebook.padding -children {
             Notebook.molUP.results.Notebook.label
             }
        }
    }


    #### Checkbutton
    ttk::style element create molUP.Checkbutton.indicator \
        image [list $molUP::images(check-nu) \
                 {disabled selected} $molUP::images(check-dc) \
                 disabled $molUP::images(check-du) \
                 {pressed selected} $molUP::images(check-pc) \
                 pressed $molUP::images(check-pu) \
                 {active selected} $molUP::images(check-ac) \
                 active $molUP::images(check-au) \
                 selected $molUP::images(check-nc) \
                 ]

    ttk::style configure molUP.TCheckbutton \
        -background $gray \
        -padding {5 0 0 0}   

     ttk::style layout molUP.TCheckbutton {
        Checkbutton.molUP.Checkbutton.indicator -side left
        Checkbutton.molUP.Checkbutton.padding -children {
            Checkbutton.molUP.Checkbutton.label -side left -expand true
        }
     }


     ttk::style element create molUP.white.Checkbutton.indicator \
        image [list $molUP::images(check-nu) \
                 {disabled selected} $molUP::images(check-dc) \
                 disabled $molUP::images(check-du) \
                 {pressed selected} $molUP::images(check-pc) \
                 pressed $molUP::images(check-pu) \
                 {active selected} $molUP::images(check-ac) \
                 active $molUP::images(check-au) \
                 selected $molUP::images(check-nc) \
                 ]

    ttk::style configure molUP.white.TCheckbutton \
        -background white \
        -padding {5 0 0 0}   

     ttk::style layout molUP.white.TCheckbutton {
        Checkbutton.molUP.white.Checkbutton.indicator -side left
        Checkbutton.molUP.white.Checkbutton.padding -children {
            Checkbutton.molUP.white.Checkbutton.label -side left -expand true
        }
     }


     ttk::style element create molUP.cyan.Checkbutton.indicator \
        image [list $molUP::images(check-nu) \
                 {disabled selected} $molUP::images(check-dc) \
                 disabled $molUP::images(check-du) \
                 {pressed selected} $molUP::images(check-pc) \
                 pressed $molUP::images(check-pu) \
                 {active selected} $molUP::images(check-ac) \
                 active $molUP::images(check-au) \
                 selected $molUP::images(check-nc) \
                 ]

    ttk::style configure molUP.cyan.TCheckbutton \
        -background $cyan \
        -padding {5 0 0 0}   

     ttk::style layout molUP.cyan.TCheckbutton {
        Checkbutton.molUP.cyan.Checkbutton.indicator -side left
        Checkbutton.molUP.cyan.Checkbutton.padding -children {
            Checkbutton.molUP.cyan.Checkbutton.label -side left -expand true
        }
     }


     #### TButton
     ttk::style element create molUP.Button.button \
        image [list $molUP::images(button-n) \
                 pressed $molUP::images(button-n) \
                 {selected active} $molUP::images(button-n) \
                 selected $molUP::images(button-n) \
                 active $molUP::images(button-a) \
                 disabled $molUP::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure molUP.TButton \
        -anchor center

    ttk::style layout molUP.TButton {
        Button.molUP.Button.button -children {
            Button.molUP.Button.label
        }
    }

    ttk::style element create molUP.blue.Button.button \
        image [list $molUP::images(button-n) \
                 pressed $molUP::images(button-n) \
                 {selected active} $molUP::images(button-n) \
                 selected $molUP::images(button-n) \
                 active $molUP::images(button-a-blue) \
                 disabled $molUP::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure molUP.blue.TButton \
        -anchor center

    ttk::style layout molUP.blue.TButton {
        Button.molUP.blue.Button.button -children {
            Button.molUP.blue.Button.label
        }
    }




    #### Entry
    ttk::style element create molUP.Entry.field \
        image [list $molUP::images(button-n) \
                 pressed $molUP::images(button-n) \
                 {selected active} $molUP::images(button-n) \
                 selected $molUP::images(button-n) \
                 active $molUP::images(button-a) \
                 disabled $molUP::images(button-d) \
                ] \
                -border 4 -sticky ew

    ttk::style configure molUP.TEntry \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style layout molUP.TEntry {
        Entry.molUP.Entry.field -children {
            Entry.molUP.Entry.textarea
        }
    }


    ttk::style element create molUP.white.Entry.field \
        image [list $molUP::images(button-n) \
                 pressed $molUP::images(button-n) \
                 {selected active} $molUP::images(button-n) \
                 selected $molUP::images(button-n) \
                 active $molUP::images(button-a) \
                 disabled $molUP::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure molUP.white.TEntry \
        -selectbackground white \
        -selectforeground black \
        -background white

    ttk::style layout molUP.white.TEntry {
        Entry.molUP.white.Entry.field -children {
            Entry.molUP.white.Entry.textarea
        }
    }


}