package provide gaussianTheme 1.0

proc gaussianVMD::loadImages {imgdir {patterns {*.gif}}} {
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

array set gaussianVMD::images [gaussianVMD::loadImages [file join [file dirname [info script]] images] *.gif]

ttk::style theme create gaussianVMDTheme -parent clam -settings {

    

    #### Colors
    set blue #017aff
    set cyan #b3dbff
    set gray #ededed
    set lightGreen #ccffcc


    #### Buttons

    #Reset Button
    ttk::style element create gaussianVMD.reset.Button image \
        [list $gaussianVMD::images(button-reset) \
        active $gaussianVMD::images(button-reset-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.reset.TButton {
        Button.gaussianVMD.reset.Button
    }

    ttk::style element create gaussianVMD.center.Button image \
        [list $gaussianVMD::images(button-center) \
        active $gaussianVMD::images(button-center-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.center.TButton {
        Button.gaussianVMD.center.Button
    }

    ttk::style element create gaussianVMD.deleteAllLabels.Button image \
        [list $gaussianVMD::images(button-deletelabel) \
        active $gaussianVMD::images(button-deletelabel-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.deleteAllLabels.TButton {
        Button.gaussianVMD.deleteAllLabels.Button
    }

    ttk::style element create gaussianVMD.mouseModeRotate.Button image \
        [list $gaussianVMD::images(button-rotate) \
        active $gaussianVMD::images(button-rotate-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.mouseModeRotate.TButton {
        Button.gaussianVMD.mouseModeRotate.Button
    }

    ttk::style element create gaussianVMD.mouseModeTranslate.Button image \
        [list $gaussianVMD::images(button-mouseModeTranslate) \
        active $gaussianVMD::images(button-mouseModeTranslate-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.mouseModeTranslate.TButton {
        Button.gaussianVMD.mouseModeTranslate.Button
    }

    ttk::style element create gaussianVMD.mouseModeScale.Button image \
        [list $gaussianVMD::images(button-mouseModeScale) \
        active $gaussianVMD::images(button-mouseModeScale-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.mouseModeScale.TButton {
        Button.gaussianVMD.mouseModeScale.Button
    }

    ttk::style element create gaussianVMD.bondEdit.Button image \
        [list $gaussianVMD::images(button-bondEdit) \
        active $gaussianVMD::images(button-bondEdit-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.bondEdit.TButton {
        Button.gaussianVMD.bondEdit.Button
    }

    ttk::style element create gaussianVMD.angleEdit.Button image \
        [list $gaussianVMD::images(button-angleEdit) \
        active $gaussianVMD::images(button-angleEdit-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.angleEdit.TButton {
        Button.gaussianVMD.angleEdit.Button
    }

    ttk::style element create gaussianVMD.dihedralEdit.Button image \
        [list $gaussianVMD::images(button-dihedralEdit) \
        active $gaussianVMD::images(button-dihedralEdit-a)
        ] \
        -width 30 -height 30 -sticky news
    ttk::style layout gaussianVMD.dihedralEdit.TButton {
        Button.gaussianVMD.dihedralEdit.Button
    }



    #### MenuBar
    ttk::style configure gaussianVMD.menuBar.TFrame \
        -background $cyan \
        -relief raised

    ttk::style configure gaussianVMD.menuBar.TMenubutton \
        -background $cyan

    #### Label
    ttk::style configure gaussianVMD.gray.TLabel \
        -background $gray

    ttk::style configure gaussianVMD.white.TLabel \
        -background white

    ttk::style configure gaussianVMD.yellow.TLabel \
        -background #ffe87a        

    ttk::style configure gaussianVMD.whiteCenter.TLabel \
        -background white \
        -anchor center

    ttk::style configure gaussianVMD.lightGreen.TLabel \
        -background $lightGreen

    ttk::style configure gaussianVMD.grayCenter.TLabel \
        -background $gray \
        -anchor center

    ttk::style configure gaussianVMD.cyan.TLabel \
        -background $cyan

    #### Combobox
    ttk::style configure gaussianVMD.TCombobox \
        -background $gray \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style element create gaussianVMD.Combobox.downarrow image \
         [list $gaussianVMD::images(comboarrow-n) \
         disabled $gaussianVMD::images(comboarrow-d) \
         pressed $gaussianVMD::images(comboarrow-p) \
         active $gaussianVMD::images(comboarrow-a) \
         ] \
         -border 1 -sticky {}

    ttk::style element create gaussianVMD.Combobox.field image \
         [list $gaussianVMD::images(combo-n) \
         ] \
         -sticky ew -border 4
    
    ttk::style layout gaussianVMD.TCombobox {
        Combobox.gaussianVMD.Combobox.downarrow -side right
        Combobox.gaussianVMD.Combobox.field -children {
            Combobox.gaussianVMD.Combobox.padding -children {
                Combobox.gaussianVMD.Combobox.textarea -expand true
            }
        }
    }


    ttk::style configure gaussianVMD.green.TCombobox \
        -background $lightGreen \
        -anchor center \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style element create gaussianVMD.green.Combobox.downarrow image \
         [list $gaussianVMD::images(comboarrow-n) \
         disabled $gaussianVMD::images(comboarrow-d) \
         pressed $gaussianVMD::images(comboarrow-p) \
         active $gaussianVMD::images(comboarrow-a) \
         ] \
         -border 1 -sticky {}

    ttk::style element create gaussianVMD.green.Combobox.field image \
         [list $gaussianVMD::images(combo-n) \
         ] \
         -sticky ew -border 4
    
    ttk::style layout gaussianVMD.green.TCombobox {
        Combobox.gaussianVMD.green.Combobox.downarrow -side right
        Combobox.gaussianVMD.green.Combobox.field -children {
            Combobox.gaussianVMD.green.Combobox.padding -children {
                Combobox.gaussianVMD.green.Combobox.textarea -expand true
            }
        }
    }

    ttk::style configure gaussianVMD.white.TCombobox \
        -background white \
        -anchor center \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style element create gaussianVMD.white.Combobox.downarrow image \
         [list $gaussianVMD::images(comboarrow-n) \
         disabled $gaussianVMD::images(comboarrow-d) \
         pressed $gaussianVMD::images(comboarrow-p) \
         active $gaussianVMD::images(comboarrow-a) \
         ] \
         -border 1 -sticky {}

    ttk::style element create gaussianVMD.white.Combobox.field image \
         [list $gaussianVMD::images(combo-n) \
         ] \
         -sticky ew -border 4
    
    ttk::style layout gaussianVMD.white.TCombobox {
        Combobox.gaussianVMD.white.Combobox.downarrow -side right
        Combobox.gaussianVMD.white.Combobox.field -children {
            Combobox.gaussianVMD.white.Combobox.padding -children {
                Combobox.gaussianVMD.white.Combobox.textarea -expand true
            }
        }
    }


    #### Major Notebook
    ttk::style configure gaussianVMD.major.TNotebook \
        -relief flat \
        -bordercolor $cyan \
        -lightcolor $cyan

    ttk::style configure gaussianVMD.major.TNotebook.Tab \
        -padding {6 2 6 2} \
        -lightcolor $cyan \
        -bordercolor $cyan \
        -anchor center

    ttk::style element create gaussianVMD.major.Notebook.tab \
            image [list $gaussianVMD::images(tab-n) \
                        selected    $gaussianVMD::images(tab-a) \
                        active      $gaussianVMD::images(tab-h) \
            ] -border {2 2 2 0}
    
    ttk::style layout gaussianVMD.major.TNotebook.Tab {
        Notebook.gaussianVMD.major.Notebook.tab -children {
            Notebook.gaussianVMD.major.Notebook.label
        }
    }

    ttk::style configure gaussianVMD.results.TNotebook \
        -relief flat \
        -bordercolor $lightGreen \
        -lightcolor $lightGreen \
        -background $cyan

    ttk::style configure gaussianVMD.results.TNotebook.Tab \
        -padding {6 2 6 2} \
        -lightcolor $lightGreen \
        -bordercolor $lightGreen \
        -background $cyan \
        -anchor center

    ttk::style element create gaussianVMD.results.Notebook.tab \
            image [list $gaussianVMD::images(tab1-n) \
                        selected    $gaussianVMD::images(tab1-a) \
                        active      $gaussianVMD::images(tab1-h) \
            ] -border {2 2 2 0}
    
    ttk::style layout gaussianVMD.results.TNotebook.Tab {
        Notebook.gaussianVMD.results.Notebook.tab -children {
            Notebook.gaussianVMD.results.Notebook.padding -children {
             Notebook.gaussianVMD.results.Notebook.label
             }
        }
    }


    #### Checkbutton
    ttk::style element create gaussianVMD.Checkbutton.indicator \
        image [list $gaussianVMD::images(check-nu) \
                 {disabled selected} $gaussianVMD::images(check-dc) \
                 disabled $gaussianVMD::images(check-du) \
                 {pressed selected} $gaussianVMD::images(check-pc) \
                 pressed $gaussianVMD::images(check-pu) \
                 {active selected} $gaussianVMD::images(check-ac) \
                 active $gaussianVMD::images(check-au) \
                 selected $gaussianVMD::images(check-nc) \
                 ]

    ttk::style configure gaussianVMD.TCheckbutton \
        -background $gray \
        -padding {5 0 0 0}   

     ttk::style layout gaussianVMD.TCheckbutton {
        Checkbutton.gaussianVMD.Checkbutton.indicator -side left
        Checkbutton.gaussianVMD.Checkbutton.padding -children {
            Checkbutton.gaussianVMD.Checkbutton.label -side left -expand true
        }
     }


     #### TButton
     ttk::style element create gaussianVMD.Button.button \
        image [list $gaussianVMD::images(button-n) \
                 pressed $gaussianVMD::images(button-n) \
                 {selected active} $gaussianVMD::images(button-n) \
                 selected $gaussianVMD::images(button-n) \
                 active $gaussianVMD::images(button-a) \
                 disabled $gaussianVMD::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure gaussianVMD.TButton \
        -anchor center

    ttk::style layout gaussianVMD.TButton {
        Button.gaussianVMD.Button.button -children {
            Button.gaussianVMD.Button.label
        }
    }

    ttk::style element create gaussianVMD.blue.Button.button \
        image [list $gaussianVMD::images(button-n) \
                 pressed $gaussianVMD::images(button-n) \
                 {selected active} $gaussianVMD::images(button-n) \
                 selected $gaussianVMD::images(button-n) \
                 active $gaussianVMD::images(button-a-blue) \
                 disabled $gaussianVMD::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure gaussianVMD.blue.TButton \
        -anchor center

    ttk::style layout gaussianVMD.blue.TButton {
        Button.gaussianVMD.blue.Button.button -children {
            Button.gaussianVMD.blue.Button.label
        }
    }




    #### Entry
    ttk::style element create gaussianVMD.Entry.field \
        image [list $gaussianVMD::images(button-n) \
                 pressed $gaussianVMD::images(button-n) \
                 {selected active} $gaussianVMD::images(button-n) \
                 selected $gaussianVMD::images(button-n) \
                 active $gaussianVMD::images(button-a) \
                 disabled $gaussianVMD::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure gaussianVMD.TEntry \
        -selectbackground $cyan \
        -selectforeground black

    ttk::style layout gaussianVMD.TEntry {
        Entry.gaussianVMD.Entry.field -children {
            Entry.gaussianVMD.Entry.textarea
        }
    }


    ttk::style element create gaussianVMD.white.Entry.field \
        image [list $gaussianVMD::images(button-n) \
                 pressed $gaussianVMD::images(button-n) \
                 {selected active} $gaussianVMD::images(button-n) \
                 selected $gaussianVMD::images(button-n) \
                 active $gaussianVMD::images(button-a) \
                 disabled $gaussianVMD::images(button-n) \
                ] \
                -border 4 -sticky ew

    ttk::style configure gaussianVMD.white.TEntry \
        -selectbackground white \
        -selectforeground black \
        -background white

    ttk::style layout gaussianVMD.white.TEntry {
        Entry.gaussianVMD.white.Entry.field -children {
            Entry.gaussianVMD.white.Entry.textarea
        }
    }


}