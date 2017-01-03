package provide modify 1.0

##############################################################################
#### Initial procedute BondGui
proc gaussianVMD::bondModifInitialProc {} {
    ## Clear the pickedAtoms variable
	set gaussianVMD::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w gaussianVMD::atomPicked
	## Activate atom pick
	mouse mode pick

}

#### Initial procedute AngleGui
proc gaussianVMD::angleModifInitialProc {} {
    ## Clear the pickedAtoms variable
	set gaussianVMD::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w gaussianVMD::atomPickedAngle
	## Activate atom pick
	mouse mode pick
}
##############################################################################

##############################################################################
#### Initial procedure BondGui
proc gaussianVMD::guiBondModifInitialProc {} {
    ## Get the index of the atoms picked
    set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel]]
    set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel]]
    set atomSelect [atomselect top "index $indexes1 $indexes2"]
    set gaussianVMD::initialSelection [$atomSelect get index]
    set gaussianVMD::initialSelectionX [$atomSelect get {x y z}]

    ## Deactivate the atom pick
    trace remove variable ::vmd_pick_atom write gaussianVMD::atomPicked
    mouse mode rotate

}

#### Initial procedure AngleGui
proc gaussianVMD::guiAngleModifInitialProc {} {
    ## Get the index of the atoms picked
    set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2AngleSel $gaussianVMD::atom1AngleSel]]
    set indexes3 [join [::util::bondedsel top $gaussianVMD::atom2AngleSel $gaussianVMD::atom3AngleSel]]
    set atomSelect [atomselect top "index $indexes1 $indexes3"]
    set gaussianVMD::initialSelection [$atomSelect get index]
    set gaussianVMD::initialSelectionX [$atomSelect get {x y z}]

    ## Deactivate the atom pick
    trace remove variable ::vmd_pick_atom write gaussianVMD::atomPicked
    mouse mode rotate
}
##############################################################################

##############################################################################
#### Revert the initial structure
proc gaussianVMD::revertInitialStructure {} {

    set i 0
    foreach atom $gaussianVMD::initialSelection {
        set sel [atomselect top "index $atom"]
        $sel moveto [lindex $gaussianVMD::initialSelectionX $i]
        incr i
    }

    set gaussianVMD::initialSelectionX []
    set gaussianVMD::initialSelectionY []
    set gaussianVMD::initialSelectionZ []

}
##############################################################################

##############################################################################
#### Run this everytime an atom is picked - Bond
proc gaussianVMD::atomPicked {args} {
    global vmd_pick_atom
    global vmd_pick_shift_state

    set numberPickedAtoms [llength $gaussianVMD::pickedAtoms]
    set gaussianVMD::BondDistance "0.00"

    if {$numberPickedAtoms > 1 } {

        set gaussianVMD::pickedAtoms {}

        lappend gaussianVMD::pickedAtoms $vmd_pick_atom

        mol modselect 10 top index $gaussianVMD::pickedAtoms

        set gaussianVMD::atom1BondSel [lindex $gaussianVMD::pickedAtoms 0]
        set gaussianVMD::atom2BondSel [lindex $gaussianVMD::pickedAtoms 1]
        set gaussianVMD::BondDistance [measure bond [list [list $gaussianVMD::atom1BondSel 0] [list $gaussianVMD::atom2BondSel 0]]]
        set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance
    
        

    } else {
        
        lappend gaussianVMD::pickedAtoms $vmd_pick_atom

        mol modselect 10 top index $gaussianVMD::pickedAtoms

        set gaussianVMD::atom1BondSel [lindex $gaussianVMD::pickedAtoms 0]
        set gaussianVMD::atom2BondSel [lindex $gaussianVMD::pickedAtoms 1]
        set gaussianVMD::BondDistance [measure bond [list [list $gaussianVMD::atom1BondSel 0] [list $gaussianVMD::atom2BondSel 0]]]
        set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance
    }

    #### Load the GUI
    gaussianVMD::guiBondModif

    #### Run the initial procedure
	gaussianVMD::guiBondModifInitialProc
}

#### Run this everytime an atom is picked - Angle
proc gaussianVMD::atomPickedAngle {args} {
    global vmd_pick_atom
    global vmd_pick_shift_state

    set numberPickedAtoms [llength $gaussianVMD::pickedAtoms]
    set gaussianVMD::AngleValue "0.00"

    if {$numberPickedAtoms > 2 } {

        set gaussianVMD::pickedAtoms {}

        lappend gaussianVMD::pickedAtoms $vmd_pick_atom

        mol modselect 10 top index $gaussianVMD::pickedAtoms

        set gaussianVMD::atom1AngleSel [lindex $gaussianVMD::pickedAtoms 0]
        set gaussianVMD::atom2AngleSel [lindex $gaussianVMD::pickedAtoms 1]
        set gaussianVMD::atom3AngleSel [lindex $gaussianVMD::pickedAtoms 2]
        set gaussianVMD::AngleValue [measure angle [list [list $gaussianVMD::atom1AngleSel 0] [list $gaussianVMD::atom2AngleSel 0] [list $gaussianVMD::atom3AngleSel 0]]]
        set gaussianVMD::initialAngleValue $gaussianVMD::AngleValue
    

    } else {
        
        lappend gaussianVMD::pickedAtoms $vmd_pick_atom

        mol modselect 10 top index $gaussianVMD::pickedAtoms

        set gaussianVMD::atom1AngleSel [lindex $gaussianVMD::pickedAtoms 0]
        set gaussianVMD::atom2AngleSel [lindex $gaussianVMD::pickedAtoms 1]
        set gaussianVMD::atom3AngleSel [lindex $gaussianVMD::pickedAtoms 2]
        set gaussianVMD::AngleValue [measure angle [list [list $gaussianVMD::atom1AngleSel 0] [list $gaussianVMD::atom2AngleSel 0] [list $gaussianVMD::atom3AngleSel 0]]]
        set gaussianVMD::initialAngleValue $gaussianVMD::AngleValue
    }

    ## Set the selections for the desired atoms
    set selection1 [atomselect top "index $gaussianVMD::atom1AngleSel"]
    set selection2 [atomselect top "index $gaussianVMD::atom2AngleSel"]
    set selection3 [atomselect top "index $gaussianVMD::atom3AngleSel"]

    ## Get atom coordinates
    set gaussianVMD::pos1 [join [$selection1 get {x y z}]]
    set gaussianVMD::pos2 [join [$selection2 get {x y z}]]
    set gaussianVMD::pos3 [join [$selection3 get {x y z}]]
    $selection1 delete
    $selection2 delete
    $selection3 delete

    ## Set vectors
    set dir1   [vecnorm [vecsub $gaussianVMD::pos1 $gaussianVMD::pos2]]
    set dir2   [vecnorm [vecsub $gaussianVMD::pos2 $gaussianVMD::pos3]]
    set gaussianVMD::normvec [vecnorm [veccross $dir1 $dir2]]

    set gaussianVMD::initialAngleValue [measure angle [list [list $gaussianVMD::atom1AngleSel 0] [list $gaussianVMD::atom2AngleSel 0] [list $gaussianVMD::atom3AngleSel 0]]]

    #### Load the GUI
    gaussianVMD::guiAngleModif

    #### Run the initial procedure
	gaussianVMD::guiAngleModifInitialProc
}
##############################################################################

##############################################################################
#### Procedure to calculate the bond distance and move the bond
proc gaussianVMD::calcBondDistance {bondlength} {

    if {$gaussianVMD::atom2BondSel != ""} {

        set atomsToBeMoved1 100
        set atomsToBeMoved2 1

        ## Set the selections for the desired atoms
        set selection1 [atomselect top "index $gaussianVMD::atom1BondSel"]
        set selection2 [atomselect top "index $gaussianVMD::atom2BondSel"]

        ## Get atom coordinates
        set pos1 [join [$selection1 get {x y z}]]
        set pos2 [join [$selection2 get {x y z}]]
        $selection1 delete
        $selection2 delete

        ## Set vectors
        set dir    [vecnorm [vecsub $pos1 $pos2]]
        set curval [veclength [vecsub $pos2 $pos1]]
        
        
        if {$gaussianVMD::atom1AngleOpt == "Fixed Atom" && $gaussianVMD::atom3AngleOpt == "Fixed Atom"} {
            set alert [tk_messageBox -message "At least one atom must be free to move." -type ok -icon error]

        } elseif {$gaussianVMD::atom1AngleOpt == "Fixed Atom" && $gaussianVMD::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            #set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel -maxdepth $atomsToBeMoved1]]
            set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel -maxdepth $atomsToBeMoved2]]
            #set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            #$selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            #$selection1 delete
            $selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atom" && $gaussianVMD::atom3AngleOpt == "Fixed Atom"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel -maxdepth $atomsToBeMoved1]]
            #set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            #set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -1*($curval-$bondlength)] $dir]
            #$selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            $selection1 delete
            #$selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atom" && $gaussianVMD::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved1 1
            set atomsToBeMoved2 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel -maxdepth $atomsToBeMoved1]]
            set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atom" && $gaussianVMD::atom3AngleOpt == "Move Atoms"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel -maxdepth $atomsToBeMoved1]]
            set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atoms" && $gaussianVMD::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel]]
            set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atoms" && $gaussianVMD::atom3AngleOpt == "Move Atoms"} {

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel]]
            set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Fixed Atom" && $gaussianVMD::atom3AngleOpt == "Move Atoms"} {

            ## Atoms to be moved
            #set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel -maxdepth $atomsToBeMoved1]]
            set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel]]
            #set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            #$selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            #$selection1 delete
            $selection2 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atoms" && $gaussianVMD::atom3AngleOpt == "Fixed Atom"} {

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom2BondSel $gaussianVMD::atom1BondSel]]
            #set indexes2 [join [::util::bondedsel top $gaussianVMD::atom1BondSel $gaussianVMD::atom2BondSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom2BondSel"]
            #set selection2 [atomselect top "index $indexes2 and not index $gaussianVMD::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -1*($curval-$bondlength)] $dir]
            #$selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            $selection1 delete
            #$selection2 delete
            
        } else {
            set alert [tk_messageBox -message "Unkown error. Please contact the developer." -type ok -icon error]
        }


    } else {
        
    }

    set gaussianVMD::initialBondDistance $gaussianVMD::BondDistance

}


#### Procedure to calculate the angle and move the angle
proc gaussianVMD::calcAngleDistance {newangle} {

    if {$gaussianVMD::atom3AngleSel != ""} {

        set atomsToBeMoved1 100
        set atomsToBeMoved3 1


        ## Set the delta value
        set delta [expr $gaussianVMD::initialAngleValue - $newangle]
        

        if {$gaussianVMD::atom1AngleOpt == "Fixed Atom" && $gaussianVMD::atom3AngleOpt == "Fixed Atom"} {
            set alert [tk_messageBox -message "At least one atom must be free to move." -type ok -icon error]

        } elseif {$gaussianVMD::atom1AngleOpt == "Fixed Atom" && $gaussianVMD::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved3 1

            ## Atoms to be moved
            set indexes3 [join [::util::bondedsel top $gaussianVMD::atom1AngleSel $gaussianVMD::atom3AngleSel -maxdepth $atomsToBeMoved3]]
            set selection3 [atomselect top "index $indexes3 and not index $gaussianVMD::atom1AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection3 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] $delta deg]
            $selection3 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atom" && $gaussianVMD::atom3AngleOpt == "Fixed Atom"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom3AngleSel $gaussianVMD::atom1AngleSel -maxdepth $atomsToBeMoved1]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom3AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] $delta deg]
            $selection1 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atom" && $gaussianVMD::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved1 1
            set atomsToBeMoved2 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom3AngleSel $gaussianVMD::atom1AngleSel -maxdepth $atomsToBeMoved1]]
            set indexes3 [join [::util::bondedsel top $gaussianVMD::atom1AngleSel $gaussianVMD::atom3AngleSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom3AngleSel $gaussianVMD::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $gaussianVMD::atom1AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atom" && $gaussianVMD::atom3AngleOpt == "Move Atoms"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom3AngleSel $gaussianVMD::atom1AngleSel -maxdepth $atomsToBeMoved1]]
            set indexes3 [join [::util::bondedsel top $gaussianVMD::atom1AngleSel $gaussianVMD::atom3AngleSel]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom3AngleSel $gaussianVMD::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $gaussianVMD::atom1AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atoms" && $gaussianVMD::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom3AngleSel $gaussianVMD::atom1AngleSel]]
            set indexes3 [join [::util::bondedsel top $gaussianVMD::atom1AngleSel $gaussianVMD::atom3AngleSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom3AngleSel $gaussianVMD::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $gaussianVMD::atom1AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atoms" && $gaussianVMD::atom3AngleOpt == "Move Atoms"} {

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom3AngleSel $gaussianVMD::atom1AngleSel]]
            set indexes3 [join [::util::bondedsel top $gaussianVMD::atom1AngleSel $gaussianVMD::atom3AngleSel]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom3AngleSel $gaussianVMD::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $gaussianVMD::atom1AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Fixed Atom" && $gaussianVMD::atom3AngleOpt == "Move Atoms"} {

            ## Atoms to be moved
            set indexes3 [join [::util::bondedsel top $gaussianVMD::atom1AngleSel $gaussianVMD::atom3AngleSel]]
            set selection3 [atomselect top "index $indexes3 and not index $gaussianVMD::atom1AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection3 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] $delta deg]
            $selection3 delete
            
        } elseif {$gaussianVMD::atom1AngleOpt == "Move Atoms" && $gaussianVMD::atom3AngleOpt == "Fixed Atom"} {

            ## Atoms to be moved
            set indexes1 [join [::util::bondedsel top $gaussianVMD::atom3AngleSel $gaussianVMD::atom1AngleSel]]
            set selection1 [atomselect top "index $indexes1 and not index $gaussianVMD::atom3AngleSel $gaussianVMD::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $gaussianVMD::pos2 [vecadd $gaussianVMD::normvec $gaussianVMD::pos2] $delta deg]
            $selection1 delete
            
        } else {
            set alert [tk_messageBox -message "Unkown error. Please contact the developer." -type ok -icon error]
        }


    } else {
        
    }

    set gaussianVMD::initialAngleValue $gaussianVMD::AngleValue

}


#### Bond - Apply and Cancel button
proc gaussianVMD::bondGuiCloseSave {} {
    trace remove variable ::vmd_pick_atom write gaussianVMD::atomPicked
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 10 top "none"
    }

    destroy $::gaussianVMD::bondModif
}


proc gaussianVMD::bondGuiCloseNotSave {} {
    trace remove variable ::vmd_pick_atom write gaussianVMD::atomPicked
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 10 top "none"
    }

    gaussianVMD::revertInitialStructure
    destroy $::gaussianVMD::bondModif
}


#### Angle - Apply and Cancel button
proc gaussianVMD::angleGuiCloseSave {} {
    trace remove variable ::vmd_pick_atom write gaussianVMD::atomPicked
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 10 top "none"
    }

    destroy $::gaussianVMD::angleModif
}


proc gaussianVMD::angleGuiCloseNotSave {} {
    trace remove variable ::vmd_pick_atom write gaussianVMD::atomPicked
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 10 top "none"
    }

    gaussianVMD::revertInitialStructure
    destroy $::gaussianVMD::angleModif
}