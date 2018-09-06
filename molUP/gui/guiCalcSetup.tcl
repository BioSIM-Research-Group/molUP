package provide guiCalcSetup 1.5.1
package require Tk

#### GUI ############################################################
proc molUP::guiCalcSetup {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::calcSetup]} {wm deiconify $::molUP::calcSetup ;return $::molUP::calcSetup}
	toplevel $::molUP::calcSetup

	#### Title of the windows
	wm title $molUP::calcSetup "Gaussian Calculation Setup (BETA)" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::calcSetup] -0]
	set sHeight [expr [winfo vrootheight $::molUP::calcSetup] -50]

	#### Change the location of window
    wm geometry $::molUP::calcSetup 400x400+[expr $sWidth - 400]+100
	$::molUP::calcSetup configure -background {white}
	wm resizable $::molUP::calcSetup 0 0

	## Apply theme
	ttk::style theme use molUPTheme
	

    #### Variables
    variable typeOfCalculation "Energy"
    variable calcType      " "
    variable method        " "
    variable geom          "geom=connectivity"


    #### Information
    pack [ttk::frame $molUP::calcSetup.frame0]
	pack [canvas $molUP::calcSetup.frame0.frame -bg white -width 400 -height 50 -highlightthickness 0] -in $molUP::calcSetup.frame0 

    place [ttk::label $molUP::calcSetup.frame0.frame.keywordLabel \
            -text {Keywords: } \
            ] -in $molUP::calcSetup.frame0.frame -x 10 -y 10 -width 60

    place [ttk::entry $molUP::calcSetup.frame0.frame.keywords \
            -textvariable {molUP::keywordsCalc}\
            ] -in $molUP::calcSetup.frame0.frame -x 80 -y 10 -width 310

    
    ## Type of Calculation
    pack [ttk::frame $molUP::calcSetup.typeCalcSelector]
    pack [canvas $molUP::calcSetup.typeCalcSelector.frame -bg white -width 400 -height 50 -highlightthickness 0] -in $molUP::calcSetup.typeCalcSelector

    place [ttk::label $molUP::calcSetup.typeCalcSelector.frame.typeCalcLabel \
            -text {Type of Calculation: } \
            ] -in $molUP::calcSetup.typeCalcSelector.frame -x 10 -y 10 -width 110

    place [ttk::combobox $molUP::calcSetup.typeCalcSelector.frame.typeCalc \
            -textvariable {molUP::typeOfCalculation} \
			-values "[list "Energy" "Optimization (Minimum)" "Optimization (TS)" "Frequency" "IRC" "Scan"]" \
            ] -in $molUP::calcSetup.typeCalcSelector.frame -x 130 -y 8 -width 260

    trace variable molUP::typeOfCalculation w molUP::placeTypeCalc

    pack [ttk::frame $molUP::calcSetup.typeCalc]
    pack [canvas $molUP::calcSetup.typeCalc.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $molUP::calcSetup.typeCalc  

    trace variable molUP::calcType w molUP::updateKeywordSection
    trace variable molUP::method w molUP::updateKeywordSection
    trace variable molUP::geom w molUP::updateKeywordSection
}


proc molUP::placeTypeCalc {args} {
    if {$molUP::typeOfCalculation == "Energy"} {
        destroy $molUP::calcSetup.typeCalc.frame
        pack [canvas $molUP::calcSetup.typeCalc.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $molUP::calcSetup.typeCalc

        place [ttk::label $molUP::calcSetup.typeCalc.frame.noOptions \
            -text {A single-point energy calculation will be performed.} \
            ] -in $molUP::calcSetup.typeCalc.frame -x 10 -y 10 -width 380

        set molUP::calcType " "

    } elseif {$molUP::typeOfCalculation == "Optimization (Minimum)"} {
        destroy $molUP::calcSetup.typeCalc.frame
        pack [canvas $molUP::calcSetup.typeCalc.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $molUP::calcSetup.typeCalc

        place [ttk::label $molUP::calcSetup.typeCalc.frame.noOptions \
            -text {The structure will be optimized to a minimum.} \
            ] -in $molUP::calcSetup.typeCalc.frame -x 10 -y 10 -width 380

        place [ttk::label $molUP::calcSetup.typeCalc.frame.calcForceConstLabel \
            -text {Calculate Force Constants: } \
            ] -in $molUP::calcSetup.typeCalc.frame -x 10 -y 40 -width 150  

        variable forceConstant "Never"
        place [ttk::combobox $molUP::calcSetup.typeCalc.frame.calcForceConst \
            -textvariable {molUP::forceConstant} \
			-values "[list "Never" "Once" "Always" "Read"]" \
            ] -in $molUP::calcSetup.typeCalc.frame -x 170 -y 38 -width 220

        set molUP::calcType "opt"  

    } else {

    }
}

proc molUP::updateKeywordSection {args} {
    set molUP::keywordsCalc "# $molUP::calcType $molUP::method $molUP::geom"
}