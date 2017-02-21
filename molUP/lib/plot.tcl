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


proc molUP::drawPlot {frame x y title titleColor titleSize markerFormat markerColor markerColorLine markerSize} {

    set width [$frame cget -width]
    set height [$frame cget -height]
    pack [canvas $frame.plotBackground -bg white -relief raised -width $width -height $height -highlightthickness 0 -xscrollcommand "$frame.plotBackground.xscb0 set" -scrollregion {0 0 380 0}] -in $frame
    puts $frame

    place [ttk::scrollbar $frame.plotBackground.xscb0 \
			-orient horizontal \
			-command [list $frame.plotBackground xview] \
			] -in $frame.plotBackground -x 0 -y [expr $height - 15] -width $width -height 15

    set areaWidth [expr $width - 50 - 20]
    set areaHeight [expr $height - 50 - 50]

    set numberPoints [llength $x]

    if {$numberPoints < 25} {
        ####################################################################################
        ## Title
        $frame.plotBackground create text \
            [expr ($width - 60) / 2 + 50 ] 15 \
            -text "$title" \
            -font "Helvetica -$titleSize bold" \
            -fill $titleColor \
            -tag title

        ## Draw Y axis
        # Axis
        $frame.plotBackground create line \
            50 50 \
            50 [expr $height - 50] \
            -width 2

        ## Draw X Axis
        # Axis
        $frame.plotBackground create line \
            50 [expr $height - 50] \
            [expr $width - 20] [expr $height - 50] \
            -width 2

        ## Axis Y Label
        $frame.plotBackground create text \
            5 37 \
            -text "E/Hartree" \
            -font {Helvetica -12 bold} \
            -anchor w

        ## Axis X Label
        $frame.plotBackground create text \
            [expr ($width - 60) / 2 + 50 ] [expr $height - 20] \
            -text "Reaction Coordinate" \
            -font {Helvetica -12 bold}

        ## Gaps Axis X
        set xSorted [lsort $x]
        set xMin [lindex $xSorted 0]
        set xMax [lindex $xSorted end]
        set xCount [llength $xSorted]
        set pixelValueX [expr ([format %.10f $xMax] - [format %.10f $xMin]) / $areaWidth]
        set gapWidth [expr $areaWidth / ($xCount - 1)]
        # Tics
        set i 0
        foreach value $x {
            $frame.plotBackground create line \
            [expr $gapWidth * $i + 50] [expr $height - 50] \
            [expr $gapWidth * $i + 50] [expr $height - 45] \
            -width 2

            $frame.plotBackground create text \
            [expr $gapWidth * $i + 50] [expr $height - 40] \
            -text "$value" \
            -font {Helvetica 10}

            incr i
        }

        ## Gaps Axis Y
        set ySorted [lsort -real $y]
        set yMin [lindex $ySorted 0]
        set yMax [lindex $ySorted end]
        set yCount [llength $ySorted]
        set pixelValueY [expr ([format %.10f $yMax] - [format %.10f $yMin]) / $areaHeight]
        set howManyGaps [format %.0f [expr $areaHeight / 40]]
        set gapHeight [expr $areaHeight / ($howManyGaps - 1)]
        # Tics
        for {set index 0} { $index < $howManyGaps } { incr index } {
            $frame.plotBackground create line \
            45 [expr ($height - 50) - $gapHeight * $index]  \
            50 [expr ($height - 50) - $gapHeight * $index]  \
            -width 2
            
            set scaleValue [format %.3f [expr $yMin + ($index * $pixelValueY * $gapHeight)]]

            $frame.plotBackground create text \
            43 [expr ($height - 50) - $gapHeight * $index] \
            -text "$scaleValue" \
            -font {Helvetica 8} \
            -anchor e
        }


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


    } else {
        ####################################################################################
        ## Title
        $frame.plotBackground create text \
            [expr ($width - 60) / 2 + 50 ] 15 \
            -text "$title" \
            -font "Helvetica -$titleSize bold" \
            -fill $titleColor \
            -tag title

        set width [expr 20 + 50 + (($numberPoints - 1) * 20)]
        set areaWidth [expr $width - 50 - 20]

        ## Draw Y axis
        # Axis
        $frame.plotBackground create line \
            50 50 \
            50 [expr $height - 50] \
            -width 2

        ## Draw X Axis
        # Axis
        $frame.plotBackground create line \
            50 [expr $height - 50] \
            [expr $width - 20] [expr $height - 50] \
            -width 2

        ## Axis Y Label
        $frame.plotBackground create text \
            5 37 \
            -text "E/Hartree" \
            -font {Helvetica -12 bold} \
            -anchor w

        ## Axis X Label
        $frame.plotBackground create text \
            [expr ($width - 60) / 2 + 50 ] [expr $height - 20] \
            -text "Reaction Coordinate" \
            -font {Helvetica -12 bold}

        ## Gaps Axis X
        set xSorted [lsort $x]
        set xMin [lindex $xSorted 0]
        set xMax [lindex $xSorted end]
        set xCount [llength $xSorted]
        set pixelValueX [expr ([format %.10f $xMax] - [format %.10f $xMin]) / $areaWidth]
        set gapWidth [expr $areaWidth / ($xCount - 1)]
        # Tics
        set i 0
        foreach value $x {
            $frame.plotBackground create line \
            [expr $gapWidth * $i + 50] [expr $height - 50] \
            [expr $gapWidth * $i + 50] [expr $height - 45] \
            -width 2

            $frame.plotBackground create text \
            [expr $gapWidth * $i + 50] [expr $height - 40] \
            -text "$value" \
            -font {Helvetica 10}

            incr i
        }

        ## Gaps Axis Y
        set ySorted [lsort -real $y]
        set yMin [lindex $ySorted 0]
        set yMax [lindex $ySorted end]
        set yCount [llength $ySorted]
        set pixelValueY [expr ([format %.10f $yMax] - [format %.10f $yMin]) / $areaHeight]
        set howManyGaps [format %.0f [expr $areaHeight / 40]]
        set gapHeight [expr $areaHeight / ($howManyGaps - 1)]
        # Tics
        for {set index 0} { $index < $howManyGaps } { incr index } {
            $frame.plotBackground create line \
            45 [expr ($height - 50) - $gapHeight * $index]  \
            50 [expr ($height - 50) - $gapHeight * $index]  \
            -width 2
            
            set scaleValue [format %.3f [expr $yMin + ($index * $pixelValueY * $gapHeight)]]

            $frame.plotBackground create text \
            43 [expr ($height - 50) - $gapHeight * $index] \
            -text "$scaleValue" \
            -font {Helvetica 8} \
            -anchor e
        }


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


        set scrollMax [expr $width - 380]
        $frame.plotBackground configure -scrollregion [list $scrollMax 0 380 0]

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