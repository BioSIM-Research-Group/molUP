package provide guiChargeMulti 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiChargeMulti {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::chargeMulti]} {wm deiconify $::gaussianVMD::chargeMulti ;return $::gaussianVMD::chargeMulti}
	toplevel $::gaussianVMD::chargeMulti

	#### Title of the windows
	wm title $gaussianVMD::chargeMulti "Charge and Multiplicity" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::chargeMulti] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::chargeMulti] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::chargeMulti 400x200+[expr $sWidth - 400]+100
	$::gaussianVMD::chargeMulti configure -background {white}
	wm resizable $::gaussianVMD::chargeMulti 0 0

	## Apply theme
	ttk::style theme use clearlooks

    ## Styles
	ttk::style configure gaussianVMD.button.TButton \
		-anchor center

	ttk::style configure gaussianVMD.label.TLabel \
		-anchor center
	

    #### Information
    pack [ttk::frame $gaussianVMD::chargeMulti.frame0]
	pack [canvas $gaussianVMD::chargeMulti.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::chargeMulti.frame0 

    #Evaluate a possible ONIOM System
    set highLayerIndex [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "H" -all]
    set mediumLayerIndex [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "M" -all]
    set lowLayerIndex [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "L" -all]


    # Evaluate the negative and positve amino acids 
    gaussianVMD::showNegPosResidues

    # Place common items to all possibilities
    place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 10 -width 380

    if {($highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex == "") || \
        $highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex == "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {        
        
        # Resize window
        wm geometry $::gaussianVMD::chargeMulti 400x150+[expr $sWidth - 400]+100

        # Place Elements
        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.chargeLabel \
            -text {Charge:} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 40 -width 50
        
        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.charge \
            -textvariable {gaussianVMD::chargeAll}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 60 -y 40 -width 90

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.multiLabel \
            -text {Multiplicity:} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 200 -y 40 -width 60
        
        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.multi \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 270 -y 40 -width 90

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {gaussianVMD::getChargesSum all} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 70 -width 380

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 110 -width 185

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 205 -y 110 -width 185


    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex == ""} {
         wm geometry $::gaussianVMD::chargeMulti 400x210+[expr $sWidth - 400]+100

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 40 -width 120

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.showCharged \
            -text {Show} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 320 -y 40 -width 70

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.hllayerLabel \
            -text {High Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.hllayerCharge \
            -textvariable {gaussianVMD::chargeHL}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 70 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.hllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 70 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.hllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 70 -width 20

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.mllayerCharge \
            -textvariable {gaussianVMD::chargeML}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 100 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.mllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 100 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.mllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 100 -width 20

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {gaussianVMD::getChargesSum none} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 130 -width 380

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 170 -width 185

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 205 -y 170 -width 185

    } elseif {$highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {
         wm geometry $::gaussianVMD::chargeMulti 400x210+[expr $sWidth - 400]+100

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 40 -width 120

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.showCharged \
            -text {Show} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 320 -y 40 -width 70

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.hllayerLabel \
            -text {High Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.hllayerCharge \
            -textvariable {gaussianVMD::chargeHL}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 70 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.hllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 70 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.hllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 70 -width 20

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.lllayerCharge \
            -textvariable {gaussianVMD::chargeLL}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 100 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.lllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 100 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.lllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 100 -width 20

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {gaussianVMD::getChargesSum none} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 130 -width 380

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 170 -width 185

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 205 -y 170 -width 185

    } elseif {$highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
         wm geometry $::gaussianVMD::chargeMulti 400x210+[expr $sWidth - 400]+100

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 40 -width 120

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.showCharged \
            -text {Show} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 320 -y 40 -width 70

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.mllayerCharge \
            -textvariable {gaussianVMD::chargeML}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 70 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.mllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 70 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.mllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 70 -width 20

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.lllayerCharge \
            -textvariable {gaussianVMD::chargeLL}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 100 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.lllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 100 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.lllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 100 -width 20

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {gaussianVMD::getChargesSum none} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 130 -width 380

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 170 -width 185

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 205 -y 170 -width 185

    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
         wm geometry $::gaussianVMD::chargeMulti 400x250+[expr $sWidth - 400]+100

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 40 -width 120

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 40 -width 75

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.showCharged \
            -text {Show} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 320 -y 40 -width 70

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.hllayerLabel \
            -text {High Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.hllayerCharge \
            -textvariable {gaussianVMD::chargeHL}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 70 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.hllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 70 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.hllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 70 -width 20

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.mllayerCharge \
            -textvariable {gaussianVMD::chargeML}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 100 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.mllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 100 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.mllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 100 -width 20

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 130 -width 120

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.lllayerCharge \
            -textvariable {gaussianVMD::chargeLL}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 140 -y 130 -width 75

        place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.lllayerMulti \
            -textvariable {gaussianVMD::multiplicityValue}\
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 235 -y 130 -width 75

        place [ttk::checkbutton $gaussianVMD::chargeMulti.frame0.frame.lllayerShow \
            -text {} \
            -variable {} \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 345 -y 130 -width 20

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {gaussianVMD::getChargesSum none} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 170 -width 380

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 210 -width 185

        place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {} \
            -style gaussianVMD.button.TButton \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 205 -y 210 -width 185

    } else {
        wm geometry $::gaussianVMD::chargeMulti 400x80+[expr $sWidth - 400]+100

        place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.noMol \
            -text "No molecule was loaded. \nTherefore, you cannot adjust the carge and spin multiplicity." \
            -style gaussianVMD.label.TLabel \
            ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 40 -width 380

    }

}


#### Get the sum of all charges of each layer. Options can be "all" "hl" "ml" "ll"
proc gaussianVMD::getChargesSum {layer} {
    
    if {$layer == "all"} {
        set list [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer get anchor end]
        set charge 0
        foreach atom $list {
            set charge [expr $charge + [format %f [lindex $atom 4]]]
        }
        set gaussianVMD::chargeAll [format %.4f $charge]


    } else {
        set hl [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "H" -all]
        set ml [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "M" -all]

        set listHL [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer get $hl]
        set listML [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer get $ml]

        set charge 0
        foreach atom $listHL {
            set charge [expr $charge + [format %f [lindex $atom 4]]]
        }
        set gaussianVMD::chargeHL [format %.4f $charge]

        set charge 0
        foreach atom $listML {
            set charge [expr $charge + [format %f [lindex $atom 4]]]
        }
        set gaussianVMD::chargeML [format %.4f $charge]


        set list [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer get anchor end]
        set charge 0
        foreach atom $list {
            set charge [expr $charge + [format %f [lindex $atom 4]]]
        }
        set gaussianVMD::chargeLL [format %.4f $charge]

    }
}

proc gaussianVMD::showNegPosResidues {} {
    set sel [atomselect top "all"]
    set lastResid [lindex [$sel get residue] end]

    set listResidPos ""
    set listResidNeg ""

    for {set index 0} { $index <= $lastResid } { incr index } {
        set sel [atomselect top "residue $index"]
        set indexes [$sel list]
        set list [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer get $indexes]
        set charge 0
        foreach atom $list {
            set charge [expr $charge + [format %f [lindex $atom 4]]]
        }
        if {$charge > 0.7} {
            append listResidPos "$index "
        } elseif {$charge < -0.7} {
            append listResidNeg "$index "
        } else {}

    }

    mol modselect 11 0 "residue $listResidPos"
    mol modselect 12 0 "residue $listResidNeg"

}