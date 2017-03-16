package provide guiChargeMulti 1.0

#### GUI ############################################################
proc molUP::guiChargeMulti {frame} {

    #### Information
	place [canvas $frame.frame -bg white -width 400 -height 260 -highlightthickness 0] -in $frame 

    #Evaluate a possible ONIOM System
    set highLayerIndex [$molUP::tableLayer searchcolumn 4 "H" -all]
    set mediumLayerIndex [$molUP::tableLayer searchcolumn 4 "M" -all]
    set lowLayerIndex [$molUP::tableLayer searchcolumn 4 "L" -all]


#######################################################################################

    if {($highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex == "") || \
        $highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex == "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex != "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex == "" } {        
        

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $frame.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $frame.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 10} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $frame.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 210 -y 40 -width 180

        place [ttk::label $frame.frame.chargeLabel \
            -text {Charge:} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 10 -y 70 -width 50
        
        place [ttk::entry $frame.frame.charge \
            -textvariable {molUP::chargeAll}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 60 -y 70 -width 90

        place [ttk::label $frame.frame.multiLabel \
            -text {Multiplicity:} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 200 -y 70 -width 60
        
        place [ttk::entry $frame.frame.multi \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 70 -width 90

        place [ttk::button $frame.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum all} \
            -style molUP.TButton \
            ] -in $frame.frame -x 10 -y 100 -width 380


    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex == ""} {

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $frame.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $frame.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 10} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $frame.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $frame.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 70 -width 120

        place [ttk::label $frame.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 140 -y 70 -width 120

        place [ttk::label $frame.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $frame.frame.hllayerLabel \
            -text {High Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 100 -width 120

        place [ttk::entry $frame.frame.hllayerCharge \
            -textvariable {molUP::chargeHL}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 100 -width 120

        place [ttk::entry $frame.frame.hllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $frame.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 130 -width 120

        place [ttk::entry $frame.frame.mllayerCharge \
            -textvariable {molUP::chargeML}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 130 -width 120

        place [ttk::entry $frame.frame.mllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 130 -width 120


        # Calculate Button
        place [ttk::button $frame.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $frame.frame -x 10 -y 160 -width 380


    } elseif {$highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {

        #wm geometry $::molUP::chargeMulti 400x250+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $frame.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $frame.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 10} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $frame.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $frame.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 70 -width 120

        place [ttk::label $frame.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 140 -y 70 -width 120

        place [ttk::label $frame.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $frame.frame.hllayerLabel \
            -text {High Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 100 -width 120

        place [ttk::entry $frame.frame.hllayerCharge \
            -textvariable {molUP::chargeHL}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 100 -width 120

        place [ttk::entry $frame.frame.hllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $frame.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 130 -width 120

        place [ttk::entry $frame.frame.lllayerCharge \
            -textvariable {molUP::chargeLL}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 130 -width 120

        place [ttk::entry $frame.frame.lllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 130 -width 120


        # Calculate Button
        place [ttk::button $frame.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $frame.frame -x 10 -y 160 -width 380


    } elseif {$highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
         #wm geometry $::molUP::chargeMulti 400x250+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $frame.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $frame.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 10} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $frame.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $frame.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 70 -width 120

        place [ttk::label $frame.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 140 -y 70 -width 120

        place [ttk::label $frame.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $frame.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 100 -width 120

        place [ttk::entry $frame.frame.mllayerCharge \
            -textvariable {molUP::chargeML}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 100 -width 120

        place [ttk::entry $frame.frame.mllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $frame.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 130 -width 120

        place [ttk::entry $frame.frame.lllayerCharge \
            -textvariable {molUP::chargeLL}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 130 -width 120

        place [ttk::entry $frame.frame.lllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 130 -width 120


        # Calculate Button
        place [ttk::button $frame.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $frame.frame -x 10 -y 160 -width 380


    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
        #wm geometry $::molUP::chargeMulti 400x280+[expr $sWidth - 400]+100

        # Evaluate the negative and positve amino acids 
        molUP::showNegPosResidues


        # Place common items to all possibilities
        place [ttk::label $frame.frame.initialLabel \
            -text {Adjust the charge and spin multiplicity for this stytem.} \
            -style molUP.white.TLabel \
            ] -in $frame.frame -x 10 -y 10 -width 380

        place [ttk::checkbutton $frame.frame.showPositiveResidues \
            -text {Show Positive Residues} \
            -variable {showPosChargedResidues} \
            -command {molUP::onOffRepresentation 10} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 10 -y 40 -width 180

        place [ttk::checkbutton $frame.frame.showNegativeResidues \
            -text {Show Negative Residues} \
            -variable {showNegChargedResidues} \
            -command {molUP::onOffRepresentation 11} \
            -style molUP.white.TCheckbutton \
            ] -in $frame.frame -x 210 -y 40 -width 180



        # Table Header
        place [ttk::label $frame.frame.layer \
            -text {Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 70 -width 120

        place [ttk::label $frame.frame.charge \
            -text {Charge} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 140 -y 70 -width 120

        place [ttk::label $frame.frame.multi \
            -text {Multiplicity} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 270 -y 70 -width 120

        # Line 1
        place [ttk::label $frame.frame.hllayerLabel \
            -text {High Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 100 -width 120

        place [ttk::entry $frame.frame.hllayerCharge \
            -textvariable {molUP::chargeHL}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 100 -width 120

        place [ttk::entry $frame.frame.hllayerMulti \
            -textvariable {molUP::multiplicityValue}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 100 -width 120

        # Line 2
        place [ttk::label $frame.frame.mllayerLabel \
            -text {Medium Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 130 -width 120

        place [ttk::entry $frame.frame.mllayerCharge \
            -textvariable {molUP::chargeML}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 130 -width 120

        place [ttk::entry $frame.frame.mllayerMulti \
            -textvariable {molUP::multiplicityValue1}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 130 -width 120

        # Line 3
        place [ttk::label $frame.frame.lllayerLabel \
            -text {Low Level Layer} \
            -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 160 -width 120

        place [ttk::entry $frame.frame.lllayerCharge \
            -textvariable {molUP::chargeLL}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 140 -y 160 -width 120

        place [ttk::entry $frame.frame.lllayerMulti \
            -textvariable {molUP::multiplicityValue2}\
            -style molUP.TEntry \
            ] -in $frame.frame -x 270 -y 160 -width 120


        # Calculate Button
        place [ttk::button $frame.frame.calculateCharges \
            -text {Calculate charge based on available MM charges} \
            -command {molUP::getChargesSum none} \
            -style molUP.TButton \
            ] -in $frame.frame -x 10 -y 190 -width 380


    } else {
        #wm geometry $::molUP::chargeMulti 400x60+[expr $sWidth - 400]+100

        place [ttk::label $frame.frame.noMol \
            -text "No molecule was loaded. \nTherefore, you cannot adjust the carge and spin multiplicity." \
           -style molUP.whiteCenter.TLabel \
            ] -in $frame.frame -x 10 -y 10 -width 380

    }

}


#### Get the sum of all charges of each layer. Options can be "all" "hl" "ml" "ll"
proc molUP::getChargesSum {layer} {
    set mol [molinfo top]
    set molUP::tableCharges ".molUP.frame0.major.mol$mol.tabs.tabResults.tabs.tab4.tableLayer"
    set molUP::tableLayer ".molUP.frame0.major.mol$mol.tabs.tabResults.tabs.tab2.tableLayer"

    
    if {$layer == "all"} {
        set list [$molUP::tableCharges get 0 end]
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


        set list [$molUP::tableCharges get 0 end]
        set charge 0
        foreach atom $list {
            set charge [expr $charge + [lindex $atom 4]]
        }
        set molUP::chargeLL [format %.4f $charge]

    }
}

proc molUP::showNegPosResidues {} {
    
    set sel [atomselect top "all"]
    set lastResid [lindex [$sel get resid] end]

    set listResidPos ""
    set listResidNeg ""

    for {set index 0} { $index <= $lastResid } { incr index } {
        set sel [atomselect top "resid $index"]
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
        mol modselect 10 top "resid $listResidPos"
    } else {}

    if {$listResidNeg != ""} {
        mol modselect 11 top "resid $listResidNeg"
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
}

