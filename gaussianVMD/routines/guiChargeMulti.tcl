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

	wm protocol $::gaussianVMD::chargeMulti WM_DELETE_WINDOW {gaussianVMD::bondGuiCloseSave}

	

    #### Information
    pack [ttk::frame $gaussianVMD::chargeMulti.frame0]
	pack [canvas $gaussianVMD::chargeMulti.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::chargeMulti.frame0 

    #Evaluate a possible ONIOM System
    set highLayerIndex [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "H" -all]
    set mediumLayerIndex [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "M" -all]
    set lowLayerIndex [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer searchcolumn 4 "L" -all]

    if {$highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex == "" &&} {
        
    }
    
    place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.initialLabel \
        -text {Adjust the charge and spin multiplicity for this stytem.} \
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 10 -width 380

    place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.chargeLabel \
        -text {Charge:} \
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 30 -width 80
    
    place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.charge \
        -textvariable {}\
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 100 -y 30 -width 90

    place [ttk::label $gaussianVMD::chargeMulti.frame0.frame.multiLabel \
        -text {Charge:} \
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 200 -y 30 -width 90
    
    place [ttk::entry $gaussianVMD::chargeMulti.frame0.frame.multi \
        -textvariable {}\
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 300 -y 30 -width 90

    place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.calculateCharges \
        -text {Calculate charge based on available MM charges} \
        -command {} \
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 70 -width 380

    place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.apply \
        -text {Apply} \
        -command {} \
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 10 -y 110 -width 185

    place [ttk::button $gaussianVMD::chargeMulti.frame0.frame.cancel \
        -text {Cancel} \
        -command {} \
        ] -in $gaussianVMD::chargeMulti.frame0.frame -x 205 -y 110 -width 185

}