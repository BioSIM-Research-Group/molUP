package provide plot 1.0

## frame        - give a frame where the graph should be embed to
## x            - list of x values
## y            - list of y values
## title        - string with title (Ex: "Energetic Profile")
## titleColor   - color of title (Ex: red, blue, black, #ffffff, etc...)
## titleSize    - any integer value (Ex: 10, 12, 14, etc...)
## markerFormat - format of marker (Ex: rectangle, circle)
## markerColor      -
## markerSize       - 
## markerColorLine  - 


proc molUP::drawPlot {frame x y title titleColor titleSize markerFormat markerColor markerColorLine markerSize yAxisLabel} {

    set width [$frame cget -width]
    set height [$frame cget -height]
    pack [canvas $frame.plotBackground -bg white -relief raised -width $width -height $height -highlightthickness 0] -in $frame


    set areaWidth [expr $width - 50 - 20]
    set areaHeight [expr $height - 50 - 50]

    set numberPoints [llength $x]



    ## Title
    place [ttk::frame $frame.plotBackground.title \
        -width $areaWidth \
        -height 50 \
        ] -in $frame.plotBackground -x 50 -y 0 -width $areaWidth -height 50

    pack [canvas $frame.plotBackground.title.canvas -bg "white" -width $areaWidth -height 50 ] -in $frame.plotBackground.title

    $frame.plotBackground.title.canvas create text \
            [expr ($width - 70) / 2] 15 \
            -text "$title" \
            -font "Helvetica -$titleSize bold" \
            -fill $titleColor \
            -tag title

    ## X-Axis
    place [ttk::frame $frame.plotBackground.xAxis \
        -width $areaWidth \
        -height 50 \
        ] -in $frame.plotBackground -x 50 -y [expr $areaHeight + 50 + 15] -width $areaWidth -height 50

    pack [canvas $frame.plotBackground.xAxis.canvas -bg "white" -width $areaWidth -height 50 ] -in $frame.plotBackground.xAxis

    $frame.plotBackground.xAxis.canvas create text \
        [expr $areaWidth / 2] 10 \
        -text "Reaction Coordinate" \
        -font {Helvetica -12 bold}

    ## Y-Axis
    place [ttk::frame $frame.plotBackground.yAxis \
        -width 50 \
        -height [expr $areaHeight + 30] \
        ] -in $frame.plotBackground -x 0 -y 20 -width 50 -height [expr $areaHeight + 30]

    pack [canvas $frame.plotBackground.yAxis.canvas -bg "white" -width 50 -height [expr $areaHeight + 30] -yscrollcommand "$frame.plotBackground.yscb0 set"] -in $frame.plotBackground.yAxis

    $frame.plotBackground.yAxis.canvas create text \
        25 15 \
        -text $yAxisLabel \
        -font {Helvetica -9 bold}



    ## Graph
    place [ttk::frame $frame.plotBackground.area \
        -width $areaWidth \
        -height $areaHeight \
        ] -in $frame.plotBackground -x 50 -y 50 -width $areaWidth -height $areaHeight

    pack [canvas $frame.plotBackground.area.canvas -bg "white" -width $areaWidth -height $areaHeight -yscrollcommand "$frame.plotBackground.yscb0 set" -xscrollcommand "$frame.plotBackground.xscb0 set" -scrollregion [list 0 0 $areaWidth $areaHeight] -cursor crosshair] -in $frame.plotBackground.area

    place [ttk::scrollbar $frame.plotBackground.yscb0 \
			-orient vertical \
			-command [list $frame.plotBackground.area.canvas yview] \
			] -in $frame.plotBackground -x 365 -y 50 -width 15 -height $areaHeight

    place [ttk::scrollbar $frame.plotBackground.xscb0 \
			-orient horizontal \
			-command [list $frame.plotBackground.area.canvas xview]\
			] -in $frame.plotBackground -x 50 -y 200 -height 15 -width $areaWidth


    variable zoomStatus 0
    
    set  molUP::zoomStatus 0
    bind $frame.plotBackground.area.canvas <ButtonPress-1> [list molUP::zoomIn %x %y $frame]
    bind $frame.plotBackground.area.canvas <ButtonRelease-1> [list molUP::zoomInA %x %y $frame]

    bind $frame.plotBackground.area.canvas <ButtonPress-2> [list molUP::zoomOut %x %y $frame]

    bind $frame.plotBackground.area.canvas <Motion> [list molUP::updateSelectionRectangle %x %y $frame]


    ### Plot data
    set numberPoints [llength $x]   

        ####################################################################################
        ### Draw Y axis
        ## Axis
        $frame.plotBackground.yAxis.canvas create line \
            45 30 \
            45 [expr $areaHeight + 30] \
            -width 2

        ### Draw X Axis
        ## Axis
        #$frame.plotBackground.yAxis.canvas create line \
        #    49 [expr $areaHeight + 30] \
        #    49 30 \
        #    -width 2

        ### Axis Y Label
        #$frame.plotBackground create text \
        #    5 37 \
        #    -text "E/Hartree" \
        #    -font {Helvetica -12 bold} \
        #    -anchor w
#
       

        ## Gaps Axis X
        set xSorted [lsort $x]
        set xMin [lindex $xSorted 0]
        set xMax [lindex $xSorted end]
        set xCount [llength $xSorted]
        set pixelValueX [expr ([format %.10f $xMax] - [format %.10f $xMin]) / ($areaWidth - 20)]
        if {$xCount != 1} {
            set a $xCount
        } else {
            set a 2
        }
        set gapWidth [expr ($areaWidth - 20) / ($a - 1)]
        # Tics
        #set i 0
        #foreach value $x {
        #    $frame.plotBackground create line \
        #    [expr $gapWidth * $i + 50] [expr $height - 50] \
        #    [expr $gapWidth * $i + 50] [expr $height - 45] \
        #    -width 2
#
        #    $frame.plotBackground create text \
        #    [expr $gapWidth * $i + 50] [expr $height - 40] \
        #    -text "$value" \
        #    -font {Helvetica 10}
#
        #    incr i
        #}

        ## Gaps Axis Y
        set ySorted [lsort -real $y]
        set yMin [lindex $ySorted 0]
        set yMax [lindex $ySorted end]
        set yCount [llength $ySorted]
        set pixelValueY [expr ([format %.10f $yMax] - [format %.10f $yMin]) / ($areaHeight - 20)]
        set howManyGaps 6
        set gapHeight [expr ($areaHeight - 20) / ($howManyGaps - 1)]
        # Tics
        for {set index 0} { $index < $howManyGaps } { incr index } {
            $frame.plotBackground.yAxis.canvas create line \
            42 [expr ($areaHeight +15) - $gapHeight * $index]  \
            45 [expr ($areaHeight +15) - $gapHeight * $index]  \
            -width 2 \
            -tags yAxis
            
            set scaleValue [format %.2f [expr $yMin + ($index * $pixelValueY * $gapHeight)]]

            $frame.plotBackground.yAxis.canvas create text \
            40 [expr ($areaHeight +15) - $gapHeight * $index] \
            -text "$scaleValue" \
            -font {Helvetica 9} \
            -anchor e  \
            -tags yAxis
        }


        #################
        ## Place Points
        set dotSize $markerSize

        set i 0
        foreach xValue $x yValue $y {
            ## Draw Lines
            if {[lindex $x [expr $i + 1]] != ""} {
                set xActual [expr $gapWidth * $i + 5]
                set yActual [expr ($areaHeight) - (($yValue - $yMin)* (1 / $pixelValueY)) - 10]

                set xNext [expr $gapWidth * ($i+1) + 5]
                set yNext [expr ($areaHeight) - (([lindex $y [expr $i + 1]] - $yMin)* (1 / $pixelValueY)) - 10]

                $frame.plotBackground.area.canvas create line \
                        $xActual $yActual \
                        $xNext $yNext \
                        -dash 2 
            }


            set testValue [lsearch $molUP::listEnergiesNonOpt [expr $i + 1]]

            if {$testValue == -1 } {
                set markerColor black
                set markerColorLine black
            } else {
                set markerColor red
                set markerColorLine red
            }


            ## Draw points
            set x1 [expr ($gapWidth * $i) + 5 - ($dotSize/2)]
            set y1 [expr ($areaHeight ) - (($yValue - $yMin)* (1 / $pixelValueY)) - ($dotSize/2) - 10]

            set x2 [expr ($gapWidth * $i) + 5 + ($dotSize/2)]
            set y2 [expr ($areaHeight) - (($yValue - $yMin)* (1 /$pixelValueY)) + ($dotSize/2) - 10]

            $frame.plotBackground.area.canvas create $markerFormat \
                    $x1 $y1 \
                    $x2 $y2 \
                    -outline black \
                    -fill $markerColor \
                    -state normal \
                    -activeoutline green \
                    -activefill green \
                    -activewidth 3 \
                    -tags [list point$xValue$yValue points]

            $frame.plotBackground.area.canvas bind point$xValue$yValue <Button-1> "animate goto [expr $xValue - 1]; puts \"$xValue $yValue\"; set molUP::totalEnergyValuePick $yValue; $frame.plotBackground.area.canvas itemconfigure points -outline black -width 1; $frame.plotBackground.area.canvas itemconfigure point$xValue$yValue -outline green -width 8"
            $frame.plotBackground.area.canvas bind point$xValue$yValue <Enter> "$frame.plotBackground.area.canvas configure -cursor hand2"
            $frame.plotBackground.area.canvas bind point$xValue$yValue <Leave> "$frame.plotBackground.area.canvas configure -cursor crosshair"

            
            incr i
        }


}


proc molUP::zoomOut {x y frame} {
    if {$molUP::zoomStatus == 1} {
    $frame.plotBackground.area.canvas yview scroll -999 units
    $frame.plotBackground.area.canvas xview scroll -999 units

    $frame.plotBackground.area.canvas scale all 0 0 [expr [format %.999f 1] / $molUP::xZoomFactor] [expr [format %.999f 1] / $molUP::yZoomFactor]


    $frame.plotBackground.area.canvas configure -scrollregion [list 0 0 [$frame.plotBackground.area.canvas cget -width] [$frame.plotBackground.area.canvas cget -height]]


    ## Y Axis
    $frame.plotBackground.yAxis.canvas yview moveto 0
    $frame.plotBackground.yAxis.canvas scale yAxis 0 0 1 [expr [format %.999f 1] / $molUP::yZoomFactor]

    set  molUP::zoomStatus 0

    } else {
        #Do nothing
    }
}

proc molUP::zoomIn {x y frame} {
    if {$molUP::zoomStatus == 0} {
        variable initialXPos $x
        variable initialYPos $y


        $frame.plotBackground.area.canvas create rectangle \
                        $x $y \
                        [expr $x + 1] [expr $y + 1] \
                        -dash 2 \
                        -tags selectionRectangle
    } else {
        #Do nothing
    }
}

proc molUP::zoomInA {x y frame} {

    if {$molUP::zoomStatus == 0 && $x > $molUP::initialXPos && $y > $molUP::initialYPos} {
        variable xZoomFactor [expr [$frame.plotBackground.area.canvas cget -width] / ($x - $molUP::initialXPos)]
        variable yZoomFactor [expr [$frame.plotBackground.area.canvas cget -height] / ($y - $molUP::initialYPos)]

        $frame.plotBackground.area.canvas scale all 0 0 $molUP::xZoomFactor $molUP::yZoomFactor
        set width [expr [$frame.plotBackground.area.canvas cget -width] * $molUP::xZoomFactor ]
        set height [expr [$frame.plotBackground.area.canvas cget -height] * $molUP::yZoomFactor ]

        $frame.plotBackground.area.canvas configure -scrollregion [list 0 0 $width $height]

        set xMoveto [expr ($molUP::initialXPos / [format %.7f [$frame.plotBackground.area.canvas cget -width]])]
        set yMoveto [expr ($molUP::initialYPos / [format %.7f [$frame.plotBackground.area.canvas cget -height]])]

        $frame.plotBackground.area.canvas xview moveto $xMoveto
        $frame.plotBackground.area.canvas yview moveto $yMoveto


        ## Y Axis
        $frame.plotBackground.yAxis.canvas scale yAxis 0 0 1 $molUP::yZoomFactor
        set yMovetoAxis [expr (($molUP::initialYPos + 30) / [format %.7f [$frame.plotBackground.yAxis.canvas cget -height]])]
        $frame.plotBackground.yAxis.canvas yview moveto $yMovetoAxis
    
        set  molUP::zoomStatus 1

    } else {
        #Do nothing
    }

    $frame.plotBackground.area.canvas delete selectionRectangle

    

}

proc molUP::updateSelectionRectangle {x y frame} {
    if {$molUP::zoomStatus == 0} {
        catch {$frame.plotBackground.area.canvas coords selectionRectangle [list $molUP::initialXPos $molUP::initialYPos $x $y]} a
    } else {

    }
}

proc molUP::addData {frame x y markerFormat markerColor markerColorLine markerSize} {
    set width [$frame cget -width]
    set height [$frame cget -height]

    set areaWidth [expr $width - 50 - 20]
    set areaHeight [expr $height - 50 - 50]

    ## Gaps Axis X
    set xSorted [lsort $x]
    set xMin [lindex $xSorted 0]
    set xMax [lindex $xSorted end]
    set xCount [llength $xSorted]
    set pixelValueX [expr ([format %.10f $xMax] - [format %.10f $xMin]) / $areaWidth]
    set gapWidth [expr $areaWidth / ($xCount - 1)]

    ## Gaps Axis Y
    set ySorted [lsort -real $y]
    set yMin [lindex $ySorted 0]
    set yMax [lindex $ySorted end]
    set yCount [llength $ySorted]
    set pixelValueY [expr ([format %.10f $yMax] - [format %.10f $yMin]) / $areaHeight]
    set howManyGaps [format %.0f [expr $areaHeight / 40]]
    set gapHeight [expr $areaHeight / ($howManyGaps - 1)]


    #################
    ## Place Points
    set dotSize $markerSize

    set i 0
    foreach xValue $x yValue $y {
        ## Draw Lines
        if {[lindex $x [expr $i + 1]] != ""} {
            set xActual [expr 50 + $gapWidth * $i]
            set yActual [expr ($height - 50) - (($yValue - $yMin)* (1 / $pixelValueY))]

            set xNext [expr 50 + $gapWidth * ($i+1)]
            set yNext [expr ($height - 50) - (([lindex $y [expr $i + 1]] - $yMin)* (1 / $pixelValueY))]

            $frame.plotBackground create line \
                    $xActual $yActual \
                    $xNext $yNext \
                    -dash 2 
        }


        ## Draw points
        set x1 [expr 50 + ($gapWidth * $i) - ($dotSize/2)]
        set y1 [expr ($height - 50) - (($yValue - $yMin)* (1 / $pixelValueY)) - ($dotSize/2)]

        set x2 [expr 50 + ($gapWidth * $i) + ($dotSize/2)]
        set y2 [expr ($height - 50) - (($yValue - $yMin)* (1 /$pixelValueY)) + ($dotSize/2)]

        $frame.plotBackground create $markerFormat \
                $x1 $y1 \
                $x2 $y2 \
                -outline $markerColorLine \
                -fill $markerColor \
                -state normal \
                -tags point$xValue$yValue

        $frame.plotBackground bind point$xValue$yValue <Button-1> "animate goto [expr $xValue - 1]; puts \"$xValue $yValue\""

        incr i
    }

}