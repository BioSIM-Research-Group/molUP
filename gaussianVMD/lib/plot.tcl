#package provide plot 1.0

if {[winfo exists .window]} {wm deiconify .window ;return .window}
	toplevel .window

wm geometry .window 400x300
pack [ttk::frame .window.frame -width 400 -height 300]

set x {1 2 3 4 5}
set y {-12 -10 -9 1 19.354}

set title "Energetic Profile XPTO"




proc drawPlot {frame x y title} {

    set width [$frame cget -width]
    set height [$frame cget -height]
    pack [canvas $frame.plotBackground -bg white -relief raised -width $width -height $height -highlightthickness 0] -in $frame

    set areaWidth [expr $width - 50 - 20]
    set areaHeight [expr $height - 50 - 50]

    ## Title
    $frame.plotBackground create text \
        [expr ($width - 60) / 2 + 50 ] 15 \
        -text "$title" \
        -font {Helvetica 14} \
        -fill Blue

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
        -font {Helvetica 12} \
        -anchor w

    ## Axis X Label
    $frame.plotBackground create text \
        [expr ($width - 60) / 2 + 50 ] [expr $height - 20] \
        -text "Reaction Coordinate" \
        -font {Helvetica 12}

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
         -font {Helvetica 10} \
         -anchor e
    }


    #################
    ## Place Points
    set dotSize 6
    foreach xValue $x yValue $y {
        set x1 [expr 50 + (($xValue - $xMin)* (1 / $pixelValueX)) - ($dotSize/2)]
        set y1 [expr ($height - 50) - (($yValue - $yMin)* (1 / $pixelValueY)) - ($dotSize/2)]

        set x2 [expr 50 + (($xValue - $xMin)* (1 / $pixelValueX)) + ($dotSize/2)]
        set y2 [expr ($height - 50) - (($yValue - $yMin)* (1 /$pixelValueY)) + ($dotSize/2)]


    $frame.plotBackground create oval \
            $x1 $y1 \
            $x2 $y2 \
            -outline Black \
            -activeoutline Yellow \
            -fill blue
    }




}

drawPlot ".window.frame" $x $y $title