package provide updateChargesFromFile 1.5.2

proc molUP::updateChargesFromFile {} {
    set fileTypes {
                {{Gaussian Output Files (.log)}       {.log}        }
    }
    
    set molUP::path [tk_getOpenFile -filetypes $fileTypes -defaultextension ".log" -title "Choose a Gaussian output file ..."]
    set molID [lindex $molUP::topMolecule 0]

    catch {exec $molUP::grep -n -m 1 -F "1\\1" $molUP::path | $molUP::cut -f1 -d:} molUP::stopLine

    if {[string is integer $molUP::stopLine] != 1} {
        set chargeLines [split [exec $molUP::grep -n -e "charges:" $molUP::path] "\n"]
    } else {
        set chargeLines [split [exec $molUP::head -n $molUP::stopLine $molUP::path | $molUP::grep -n -e "charges:"] "\n"]
    }

    variable chargeTypes {}
    variable lineNumbers {}
    foreach line $chargeLines {
        regexp {([0-9]+): (\S+) charges} $line -> lineNumber chargeType
        lappend molUP::lineNumbers [expr $lineNumber + 2]
        lappend molUP::chargeTypes $chargeType
    }

    #### Graphical Interface
    #### Check if the window exists
	if {[winfo exists $::molUP::updateCharges]} {wm deiconify $::molUP::updateCharges ;return $::molUP::updateCharges}
	toplevel $::molUP::updateCharges
	wm attributes $::molUP::updateCharges -topmost yes

	#### Title of the windows
	wm title $molUP::updateCharges "Update Charges from Gaussian Output file" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::updateCharges] -0]
	set sHeight [expr [winfo vrootheight $::molUP::updateCharges] -50]

	#### Change the location of window
    wm geometry $::molUP::updateCharges 400x170+[expr $sWidth - 400]+100
	$::molUP::updateCharges configure -background {white}
	wm resizable $::molUP::updateCharges 0 0


	## Apply theme
	ttk::style theme use molUPTheme
	

    #### Information
	pack [ttk::frame $molUP::updateCharges.frame0]
	pack [canvas $molUP::updateCharges.frame0.frame -bg white -width 400 -height 170 -highlightthickness 0] -in $molUP::updateCharges.frame0 

    place [ttk::label $molUP::updateCharges.frame0.frame.description \
		-text {Please, choose one of the following types of computed charges:} \
		-style molUP.white.TLabel \
		] -in $molUP::updateCharges.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $molUP::updateCharges.frame0.frame.labelComboBoxTypeOfCharges \
		-text {Type of Charges:} \
		-style molUP.white.TLabel \
		] -in $molUP::updateCharges.frame0.frame -x 10 -y 40 -width 100

    variable typeOfChargeFromFileSelected ""
    place [ttk::combobox $molUP::updateCharges.frame0.frame.typeOfCharges \
	    -textvariable {molUP::typeOfChargeFromFileSelected} \
	    -state readonly \
	    -style molUP.white.TCombobox \
	    -values $chargeTypes
	    ] -in $molUP::updateCharges.frame0.frame -x 120 -y 40 -width 270

    variable ignoreNullCharges 1
    place [ttk::checkbutton $molUP::updateCharges.frame0.frame.ignoreNullCharges \
		-text "Ignore null (0.00) charges during the update." \
		-variable molUP::ignoreNullCharges \
		-style molUP.TCheckbutton \
		] -in $molUP::updateCharges.frame0.frame -x 10 -y 70 -width 380

    place [ttk::button $molUP::updateCharges.frame0.frame.update \
		-text "Update" \
		-command {
            if {$molUP::typeOfChargeFromFileSelected != ""} {
                set firstLine [lindex $molUP::lineNumbers [lsearch $molUP::chargeTypes $molUP::typeOfChargeFromFileSelected]]
                set lastLine [expr $firstLine + [[atomselect [lindex $molUP::topMolecule 0] all] num] - 1]

                #### Get lines
                catch {exec $molUP::sed -n "$firstLine {p; :loop n; p; $lastLine q; b loop}" $molUP::path} output
                set output [split $output "\n"]

                if {$molUP::ignoreNullCharges != 1} {
                    set index 0
                    foreach line $output {
                        set charge [lindex $line 2]
                        .molUP.frame0.major.mol[lindex $molUP::topMolecule 0].tabs.tabResults.tabs.tab4.tableLayer configcells [subst $index],4 -text [subst $charge]
                        incr index
                    }
                } else {
                    set index 0
                    foreach line $output {
                        set charge [lindex $line 2]
                        if {$charge != "0.000000"} {
                            .molUP.frame0.major.mol[lindex $molUP::topMolecule 0].tabs.tabResults.tabs.tab4.tableLayer configcells [subst $index],4 -text [subst $charge]
                        }
                        incr index
                    }
                }

            }
        } \
		-style molUP.TButton \
		] -in $molUP::updateCharges.frame0.frame -x 180 -y 130 -width 100

    place [ttk::button $molUP::updateCharges.frame0.frame.cancel \
		-text "Cancel" \
		-command {destroy $molUP::updateCharges} \
		-style molUP.TButton \
		] -in $molUP::updateCharges.frame0.frame -x 290 -y 130 -width 100



}