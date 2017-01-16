package provide guiCalcSetup 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiCalcSetup {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::calcSetup]} {wm deiconify $::gaussianVMD::calcSetup ;return $::gaussianVMD::calcSetup}
	toplevel $::gaussianVMD::calcSetup

	#### Title of the windows
	wm title $gaussianVMD::calcSetup "Gaussian Calculation Setup (BETA)" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::calcSetup] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::calcSetup] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::calcSetup 400x400+[expr $sWidth - 400]+100
	$::gaussianVMD::calcSetup configure -background {white}
	wm resizable $::gaussianVMD::calcSetup 0 0

	## Apply theme
	ttk::style theme use clearlooks

    ## Styles
	ttk::style configure gaussianVMD.button.TButton \
		-anchor center

	ttk::style configure gaussianVMD.label.TLabel \
		-anchor center
	

    #### Variables
    variable typeOfCalculation "Energy"
    variable calcType      " "
    variable method        " "
    variable geom          "geom=connectivity"


    #### Information
    pack [ttk::frame $gaussianVMD::calcSetup.frame0]
	pack [canvas $gaussianVMD::calcSetup.frame0.frame -bg white -width 400 -height 50 -highlightthickness 0] -in $gaussianVMD::calcSetup.frame0 

    place [ttk::label $gaussianVMD::calcSetup.frame0.frame.keywordLabel \
            -text {Keywords: } \
            ] -in $gaussianVMD::calcSetup.frame0.frame -x 10 -y 10 -width 60

    place [ttk::entry $gaussianVMD::calcSetup.frame0.frame.keywords \
            -textvariable {gaussianVMD::keywordsCalc}\
            ] -in $gaussianVMD::calcSetup.frame0.frame -x 80 -y 10 -width 310

    
    ## Type of Calculation
    pack [ttk::frame $gaussianVMD::calcSetup.typeCalcSelector]
    pack [canvas $gaussianVMD::calcSetup.typeCalcSelector.frame -bg white -width 400 -height 50 -highlightthickness 0] -in $gaussianVMD::calcSetup.typeCalcSelector

    place [ttk::label $gaussianVMD::calcSetup.typeCalcSelector.frame.typeCalcLabel \
            -text {Type of Calculation: } \
            ] -in $gaussianVMD::calcSetup.typeCalcSelector.frame -x 10 -y 10 -width 110

    place [ttk::combobox $gaussianVMD::calcSetup.typeCalcSelector.frame.typeCalc \
            -textvariable {gaussianVMD::typeOfCalculation} \
			-values "[list "Energy" "Optimization (Minimum)" "Optimization (TS)" "Frequency" "IRC" "Scan"]" \
            ] -in $gaussianVMD::calcSetup.typeCalcSelector.frame -x 130 -y 8 -width 260

    trace variable gaussianVMD::typeOfCalculation w gaussianVMD::placeTypeCalc

    pack [ttk::frame $gaussianVMD::calcSetup.typeCalc]
    pack [canvas $gaussianVMD::calcSetup.typeCalc.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::calcSetup.typeCalc  

    trace variable gaussianVMD::calcType w gaussianVMD::updateKeywordSection
    trace variable gaussianVMD::method w gaussianVMD::updateKeywordSection
    trace variable gaussianVMD::geom w gaussianVMD::updateKeywordSection
}


proc gaussianVMD::placeTypeCalc {args} {
    if {$gaussianVMD::typeOfCalculation == "Energy"} {
        destroy $gaussianVMD::calcSetup.typeCalc.frame
        pack [canvas $gaussianVMD::calcSetup.typeCalc.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::calcSetup.typeCalc

        place [ttk::label $gaussianVMD::calcSetup.typeCalc.frame.noOptions \
            -text {A single-point energy calculation will be performed.} \
            ] -in $gaussianVMD::calcSetup.typeCalc.frame -x 10 -y 10 -width 380

        set gaussianVMD::calcType " "

    } elseif {$gaussianVMD::typeOfCalculation == "Optimization (Minimum)"} {
        destroy $gaussianVMD::calcSetup.typeCalc.frame
        pack [canvas $gaussianVMD::calcSetup.typeCalc.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::calcSetup.typeCalc

        place [ttk::label $gaussianVMD::calcSetup.typeCalc.frame.noOptions \
            -text {The structure will be optimized to a minimum.} \
            ] -in $gaussianVMD::calcSetup.typeCalc.frame -x 10 -y 10 -width 380

        place [ttk::label $gaussianVMD::calcSetup.typeCalc.frame.calcForceConstLabel \
            -text {Calculate Force Constants: } \
            ] -in $gaussianVMD::calcSetup.typeCalc.frame -x 10 -y 40 -width 150  

        variable forceConstant "Never"
        place [ttk::combobox $gaussianVMD::calcSetup.typeCalc.frame.calcForceConst \
            -textvariable {gaussianVMD::forceConstant} \
			-values "[list "Never" "Once" "Always" "Read"]" \
            ] -in $gaussianVMD::calcSetup.typeCalc.frame -x 170 -y 38 -width 220

        set gaussianVMD::calcType "opt"  

    } else {

    }
}

proc gaussianVMD::updateKeywordSection {args} {
    set gaussianVMD::keywordsCalc "# $gaussianVMD::calcType $gaussianVMD::method $gaussianVMD::geom"
}