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



    #### MenuBar
    ttk::style configure gaussianVMD.menuBar.TFrame \
        -background $cyan

    ttk::style configure gaussianVMD.menuBar.TMenubutton \
        -background $cyan

    #### Combobox
    ttk::style configure gaussianVMD.TCombobox \
        -padding 5 \
        -background white

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
         -sticky ew -border 4 -padding 5

    ttk::style layout gaussianVMD.TCombobox {
        Combobox.gaussianVMD.Combobox.downarrow -side right
        Combobox.gaussianVMD.Combobox.field -children {
            Combobox.entry
        }
    }


}