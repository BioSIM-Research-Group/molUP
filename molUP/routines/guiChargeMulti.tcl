package provide guiChargeMulti 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiChargeMulti {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::chargeMulti]} {wm deiconify $::molUP::chargeMulti ;return $::molUP::chargeMulti}
	toplevel $::molUP::chargeMulti

	#### Title of the windows
	wm title $molUP::chargeMulti "Charge and Multiplicity" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::chargeMulti] -0]
	set sHeight [expr [winfo vrootheight $::molUP::chargeMulti] -50]

	#### Change the location of window
    wm geometry $::molUP::chargeMulti 400x200+[expr $sWidth - 400]+100
	$::molUP::chargeMulti configure -background {white}
	wm resizable $::molUP::chargeMulti 0 0

	## Apply theme
	ttk::style theme use molUPTheme
	

    #### Information
    pack [ttk::frame $molUP::chargeMulti.frame0]
	pack [canvas $molUP::chargeMulti.frame0.frame -bg white -width 400 -height 260 -highlightthickness 0] -in $molUP::chargeMulti.frame0 

    #Evaluate a possible ONIOM System
    set highLayerIndex [$molUP::tableLayer searchcolumn 4 "H" -all]
    set mediumLayerIndex [$molUP::tableLayer searchcolumn 4 "M" -all]
    set lowLayerIndex [$molUP::tableLayer searchcolumn 4 "L" -all]




########################################################################################

    if {($highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex == "") || \
        $highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex == "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {        
        
        # Resize window
        wm geometry $::molUP::chargeMulti 400x180+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $molUP::chargeMulti.frame0.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 12} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 210 -y 40 -width 180




        place [ttk::label $molUP::chargeMulti.frame0.frame.chargeLabel \
            -text {Charge:} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 70 -width 50
        
        place [ttk::entry $molUP::chargeMulti.frame0.frame.charge \
            -textvariable {molUP::chargeAll}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 60 -y 70 -width 90

        place [ttk::label $molUP::chargeMulti.frame0.frame.multiLabel \
            -text {Multiplicity:} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 200 -y 70 -width 60
        
        place [ttk::entry $molUP::chargeMulti.frame0.frame.multi \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 70 -width 90

        place [ttk::button $molUP::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum all} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 100 -width 380

        place [ttk::button $molUP::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {molUP::applyChargeMultiGUI $highLayerIndex $mediumLayerIndex $lowLayerIndex} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 140 -width 185

        place [ttk::button $molUP::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {molUP::cancelChargeMultiGUI} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 205 -y 140 -width 185


    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex == ""} {
         
         
        wm geometry $::molUP::chargeMulti 400x250+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $molUP::chargeMulti.frame0.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 12} \
            ] -in $molUP::chargeMulti.frame0.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $molUP::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $molUP::chargeMulti.frame0.frame.hllayerLabel \
            -text {High Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.hllayerCharge \
            -textvariable {molUP::chargeHL}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.hllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $molUP::chargeMulti.frame0.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.mllayerCharge \
            -textvariable {molUP::chargeML}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.mllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 130 -width 120


        # Calculate Button
        place [ttk::button $molUP::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 160 -width 380

        # Apply Cancel Buttons
        place [ttk::button $molUP::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {molUP::applyChargeMultiGUI $highLayerIndex $mediumLayerIndex $lowLayerIndex} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 200 -width 185

        place [ttk::button $molUP::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {molUP::cancelChargeMultiGUI} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 205 -y 200 -width 185

    } elseif {$highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {

        wm geometry $::molUP::chargeMulti 400x250+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $molUP::chargeMulti.frame0.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 12} \
            ] -in $molUP::chargeMulti.frame0.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $molUP::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $molUP::chargeMulti.frame0.frame.hllayerLabel \
            -text {High Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.hllayerCharge \
            -textvariable {molUP::chargeHL}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.hllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $molUP::chargeMulti.frame0.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.lllayerCharge \
            -textvariable {molUP::chargeLL}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.lllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 130 -width 120


        # Calculate Button
        place [ttk::button $molUP::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 160 -width 380

        # Apply Cancel Buttons
        place [ttk::button $molUP::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {molUP::applyChargeMultiGUI $highLayerIndex $mediumLayerIndex $lowLayerIndex} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 200 -width 185

        place [ttk::button $molUP::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {molUP::cancelChargeMultiGUI} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 205 -y 200 -width 185

    } elseif {$highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
         wm geometry $::molUP::chargeMulti 400x250+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $molUP::chargeMulti.frame0.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 12} \
            ] -in $molUP::chargeMulti.frame0.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $molUP::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $molUP::chargeMulti.frame0.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.mllayerCharge \
            -textvariable {molUP::chargeML}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.mllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $molUP::chargeMulti.frame0.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.lllayerCharge \
            -textvariable {molUP::chargeLL}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.lllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 130 -width 120


        # Calculate Button
        place [ttk::button $molUP::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 160 -width 380

        # Apply Cancel Buttons
        place [ttk::button $molUP::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {molUP::applyChargeMultiGUI $highLayerIndex $mediumLayerIndex $lowLayerIndex} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 200 -width 185

        place [ttk::button $molUP::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {molUP::cancelChargeMultiGUI} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 205 -y 200 -width 185

    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
        wm geometry $::molUP::chargeMulti 400x280+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $molUP::chargeMulti.frame0.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $molUP::chargeMulti.frame0.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 12} \
            ] -in $molUP::chargeMulti.frame0.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $molUP::chargeMulti.frame0.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 70 -width 120

        place [ttk::label $molUP::chargeMulti.frame0.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $molUP::chargeMulti.frame0.frame.hllayerLabel \
            -text {High Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.hllayerCharge \
            -textvariable {molUP::chargeHL}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 100 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.hllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $molUP::chargeMulti.frame0.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.mllayerCharge \
            -textvariable {molUP::chargeML}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 130 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.mllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 130 -width 120

        # Line 3
        place [ttk::label $molUP::chargeMulti.frame0.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 160 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.lllayerCharge \
            -textvariable {molUP::chargeLL}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 140 -y 160 -width 120

        place [ttk::entry $molUP::chargeMulti.frame0.frame.lllayerMulti \
            -textvariable {molUP::multiplicityValue2}\
            -style molUP.TEntry \
            ] -in $molUP::chargeMulti.frame0.frame -x 270 -y 160 -width 120


        # Calculate Button
        place [ttk::button $molUP::chargeMulti.frame0.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 190 -width 380

        # Apply Cancel Buttons
        place [ttk::button $molUP::chargeMulti.frame0.frame.apply \
            -text {Apply} \
            -command {molUP::applyChargeMultiGUI $highLayerIndex $mediumLayerIndex $lowLayerIndex} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 230 -width 185

        place [ttk::button $molUP::chargeMulti.frame0.frame.cancel \
            -text {Cancel} \
            -command {molUP::cancelChargeMultiGUI} \
            -style molUP.TButton \
            ] -in $molUP::chargeMulti.frame0.frame -x 205 -y 230 -width 185

    } else {
        wm geometry $::molUP::chargeMulti 400x60+[expr $sWidth - 400]+100

        place [ttk::label $molUP::chargeMulti.frame0.frame.noMol \
            -text "No molecule was loaded. \nTherefore, you cannot adjust the carge and spin multiplicity." \
           -style molUP.whiteCenter.TLabel \
            ] -in $molUP::chargeMulti.frame0.frame -x 10 -y 10 -width 380

    }

}


#### Get the sum of all charges of each layer. Options can be "all" "hl" "ml" "ll"
proc molUP::getChargesSum {layer} {
    
    if {$layer == "all"} {
        set list [$molUP::tableCharges get anchor end]
        set charge 0
        foreach atom $list {
            set charge [expr $charge + [lindex $atom 4]]
        }
        set molUP::chargeAll [format %.4f $charge]


    } else {
        set hl [$molUP::tableLayer searchcolumn 4 "H" -all]
        set ml [$molUP::tableLayer searchcolumn 4 "M" -all]

        set listHL [$molUP::tableCharges get $hl]
        set listML [$molUP::tableCharges get $ml]

        set charge 0
        foreach atom $listHL {
            set charge [expr $charge + [lindex $atom 4]]
        }
        set molUP::chargeHL [format %.4f $charge]

        set charge 0
        foreach atom $listML {
            set charge [expr $charge + [lindex $atom 4]]
        }
        set molUP::chargeML [format %.4f $charge]


        set list [$molUP::tableCharges get anchor end]
        set charge 0
        foreach atom $list {
            set charge [expr $charge + [lindex $atom 4]]
        }
        set molUP::chargeLL [format %.4f $charge]

    }
}

proc molUP::showNegPosResidues {} {
    set sel [atomselect top "all"]
    set lastResid [lindex [$sel get residue] end]

    set listResidPos ""
    set listResidNeg ""

    for {set index 0} { $index <= $lastResid } { incr index } {
        set sel [atomselect top "residue $index"]
        set indexes [$sel list]
        set list [$molUP::tableCharges get $indexes]
        set charge 0
        foreach atom $list {
            if {[lindex $atom 4] != ""} {
                set charge [expr $charge + [lindex $atom 4]]
            }
        }
        if {$charge > 0.7} {
            append listResidPos "$index "
        } elseif {$charge < -0.7} {
            append listResidNeg "$index "
        } else {}

    }

    if {$listResidPos != ""} {
        mol modselect 11 0 "residue $listResidPos"
    } else {}

    if {$listResidNeg != ""} {
        mol modselect 12 0 "residue $listResidNeg"
    } else {}
}

proc molUP::applyChargeMultiGUI {highLayerIndex mediumLayerIndex lowLayerIndex} {
    
    if {($highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex == "") || \
        $highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex == "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {

            set molUP::chargesMultip "[format %.0f $molUP::chargeAll] [format %.0f $molUP::multiplicityValue]"

    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex == ""} {

            set molUP::chargesMultip "[format %.0f $molUP::chargeML] [format %.0f $molUP::multiplicityValue1] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue]"
    
    } elseif {$highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {

            set molUP::chargesMultip "[format %.0f $molUP::chargeLL] [format %.0f $molUP::multiplicityValue1] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue]"

    } elseif {$highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {

            set molUP::chargesMultip "[format %.0f $molUP::chargeLL] [format %.0f $molUP::multiplicityValue1] [format %.0f $molUP::chargeML] [format %.0f $molUP::multiplicityValue] [format %.0f $molUP::chargeML] [format %.0f $molUP::multiplicityValue]"

    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {

            set molUP::chargesMultip "[format %.0f $molUP::chargeLL] [format %.0f $molUP::multiplicityValue2] [format %.0f $molUP::chargeML] [format %.0f $molUP::multiplicityValue1] [format %.0f $molUP::chargeML] [format %.0f $molUP::multiplicityValue1] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue] [format %.0f $molUP::chargeHL] [format %.0f $molUP::multiplicityValue]"

    } else {

            # Do nothing
    }

    destroy $molUP::chargeMulti
}


proc molUP::cancelChargeMultiGUI {} {
    destroy $molUP::chargeMulti
}

