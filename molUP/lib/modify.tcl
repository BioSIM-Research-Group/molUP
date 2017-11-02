package provide modify 1.0

##############################################################################
#### Initial procedute BondGui
proc molUP::bondModifInitialProc {} {
    ## Clear the pickedAtoms variable
	set molUP::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w molUP::atomPicked
	## Activate atom pick
	mouse mode pick

}

#### Initial procedute AngleGui
proc molUP::angleModifInitialProc {} {
    ## Clear the pickedAtoms variable
	set molUP::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w molUP::atomPickedAngle
	## Activate atom pick
	mouse mode pick
}

#### Initial procedute DihedGui
proc molUP::dihedModifInitialProc {} {
    ## Clear the pickedAtoms variable
	set molUP::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w molUP::atomPickedDihed
	## Activate atom pick
	mouse mode pick
}
##############################################################################

##############################################################################
#### Initial procedure BondGui
proc molUP::guiBondModifInitialProc {} {
    ## Get the index of the atoms picked
    set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel]]
    set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel]]
    set atomSelect [atomselect top "index $indexes1 $indexes2"]
    set molUP::initialSelection [$atomSelect get index]
    set molUP::initialSelectionX [$atomSelect get {x y z}]

    ## Deactivate the atom pick
    trace remove variable ::vmd_pick_atom write molUP::atomPicked
    mouse mode rotate

}

#### Initial procedure AngleGui
proc molUP::guiAngleModifInitialProc {} {
    ## Get the index of the atoms picked
    set indexes1 [join [::util::bondedsel top $molUP::atom2AngleSel $molUP::atom1AngleSel]]
    set indexes3 [join [::util::bondedsel top $molUP::atom2AngleSel $molUP::atom3AngleSel]]
    set atomSelect [atomselect top "index $indexes1 $indexes3"]
    set molUP::initialSelection [$atomSelect get index]
    set molUP::initialSelectionX [$atomSelect get {x y z}]

    ## Deactivate the atom pick
    trace remove variable ::vmd_pick_atom write molUP::atomPickedAngle
    mouse mode rotate
}

#### Initial procedure DihedGui
proc molUP::guiDihedModifInitialProc {} {
    ## Get the index of the atoms picked
    set indexes1 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom2DihedSel]]
    set indexes2 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom3DihedSel]]
    set indexes3 [join [::util::bondedsel top $molUP::atom2DihedSel $molUP::atom3DihedSel]]
    set indexes4 [join [::util::bondedsel top $molUP::atom3DihedSel $molUP::atom4DihedSel]]
    set atomSelect [atomselect top "index $indexes1 $indexes2 $indexes3 $indexes4"]
    set molUP::initialSelection [$atomSelect get index]
    set molUP::initialSelectionX [$atomSelect get {x y z}]

    ## Deactivate the atom pick
    trace remove variable ::vmd_pick_atom write molUP::atomPickedDihed
    mouse mode rotate
}
##############################################################################

##############################################################################
#### Revert the initial structure
proc molUP::revertInitialStructure {} {

    set i 0
    foreach atom $molUP::initialSelection {
        set sel [atomselect top "index $atom"]
        $sel moveto [lindex $molUP::initialSelectionX $i]
        incr i
    }

    set molUP::initialSelectionX []

}
##############################################################################

##############################################################################
#### Run this everytime an atom is picked - Bond
proc molUP::atomPicked {args} {
    global vmd_pick_atom
    global vmd_pick_shift_state

    set numberPickedAtoms [llength $molUP::pickedAtoms]
    set molUP::BondDistance "0.00"

    if {$numberPickedAtoms > 1 } {

        set molUP::pickedAtoms {}

        lappend molUP::pickedAtoms $vmd_pick_atom

        mol modselect 9 top index $molUP::pickedAtoms

        set molUP::atom1BondSel [lindex $molUP::pickedAtoms 0]
        set molUP::atom2BondSel [lindex $molUP::pickedAtoms 1]
        set molUP::BondDistance [measure bond [list [list $molUP::atom1BondSel 0] [list $molUP::atom2BondSel 0]]]
        set molUP::initialBondDistance $molUP::BondDistance
    
        

    } else {
        
        lappend molUP::pickedAtoms $vmd_pick_atom

        mol modselect 9 top index $molUP::pickedAtoms

        set molUP::atom1BondSel [lindex $molUP::pickedAtoms 0]
        set molUP::atom2BondSel [lindex $molUP::pickedAtoms 1]
        set molUP::BondDistance [measure bond [list [list $molUP::atom1BondSel 0] [list $molUP::atom2BondSel 0]]]
        set molUP::initialBondDistance $molUP::BondDistance
    }

    #### Load the GUI
    molUP::guiBondModif

    #### Run the initial procedure
	molUP::guiBondModifInitialProc
}

#### Run this everytime an atom is picked - Angle
proc molUP::atomPickedAngle {args} {
    global vmd_pick_atom
    global vmd_pick_shift_state

    set numberPickedAtoms [llength $molUP::pickedAtoms]
    set molUP::AngleValue "0.00"

    if {$numberPickedAtoms > 2 } {

        set molUP::pickedAtoms {}

        lappend molUP::pickedAtoms $vmd_pick_atom

        mol modselect 9 top index $molUP::pickedAtoms

        set molUP::atom1AngleSel [lindex $molUP::pickedAtoms 0]
        set molUP::atom2AngleSel [lindex $molUP::pickedAtoms 1]
        set molUP::atom3AngleSel [lindex $molUP::pickedAtoms 2]
        set molUP::AngleValue [measure angle [list [list $molUP::atom1AngleSel 0] [list $molUP::atom2AngleSel 0] [list $molUP::atom3AngleSel 0]]]
        set molUP::initialAngleValue $molUP::AngleValue
    

    } else {
        
        lappend molUP::pickedAtoms $vmd_pick_atom

        mol modselect 9 top index $molUP::pickedAtoms

        set molUP::atom1AngleSel [lindex $molUP::pickedAtoms 0]
        set molUP::atom2AngleSel [lindex $molUP::pickedAtoms 1]
        set molUP::atom3AngleSel [lindex $molUP::pickedAtoms 2]
        set molUP::AngleValue [measure angle [list [list $molUP::atom1AngleSel 0] [list $molUP::atom2AngleSel 0] [list $molUP::atom3AngleSel 0]]]
        set molUP::initialAngleValue $molUP::AngleValue
    }

    ## Set the selections for the desired atoms
    set selection1 [atomselect top "index $molUP::atom1AngleSel"]
    set selection2 [atomselect top "index $molUP::atom2AngleSel"]
    set selection3 [atomselect top "index $molUP::atom3AngleSel"]

    ## Get atom coordinates
    set molUP::pos1 [join [$selection1 get {x y z}]]
    set molUP::pos2 [join [$selection2 get {x y z}]]
    set molUP::pos3 [join [$selection3 get {x y z}]]
    $selection1 delete
    $selection2 delete
    $selection3 delete

    ## Set vectors
    set dir1   [vecnorm [vecsub $molUP::pos1 $molUP::pos2]]
    set dir2   [vecnorm [vecsub $molUP::pos2 $molUP::pos3]]
    set molUP::normvec [vecnorm [veccross $dir1 $dir2]]

    set molUP::initialAngleValue [measure angle [list [list $molUP::atom1AngleSel 0] [list $molUP::atom2AngleSel 0] [list $molUP::atom3AngleSel 0]]]

    #### Load the GUI
    molUP::guiAngleModif

    #### Run the initial procedure
	molUP::guiAngleModifInitialProc
}

#### Run this everytime an atom is picked - Dihed
proc molUP::atomPickedDihed {args} {
    global vmd_pick_atom
    global vmd_pick_shift_state

    set numberPickedAtoms [llength $molUP::pickedAtoms]
    set molUP::DihedValue "0.00"

    if {$numberPickedAtoms > 3 } {

        set molUP::pickedAtoms {}

        lappend molUP::pickedAtoms $vmd_pick_atom

        mol modselect 9 top index $molUP::pickedAtoms

        set molUP::atom1DihedSel [lindex $molUP::pickedAtoms 0]
        set molUP::atom2DihedSel [lindex $molUP::pickedAtoms 1]
        set molUP::atom3DihedSel [lindex $molUP::pickedAtoms 2]
        set molUP::atom4DihedSel [lindex $molUP::pickedAtoms 3]
        set molUP::DihedValue [measure dihed [list [list $molUP::atom1DihedSel 0] [list $molUP::atom2DihedSel 0] [list $molUP::atom3DihedSel 0] [list $molUP::atom4DihedSel 0]]]
        set molUP::initialDihedValue $molUP::DihedValue
    

    } else {
        
        lappend molUP::pickedAtoms $vmd_pick_atom

        mol modselect 9 top index $molUP::pickedAtoms

        set molUP::atom1DihedSel [lindex $molUP::pickedAtoms 0]
        set molUP::atom2DihedSel [lindex $molUP::pickedAtoms 1]
        set molUP::atom3DihedSel [lindex $molUP::pickedAtoms 2]
        set molUP::atom4DihedSel [lindex $molUP::pickedAtoms 3]
        set molUP::DihedValue [measure dihed [list [list $molUP::atom1DihedSel 0] [list $molUP::atom2DihedSel 0] [list $molUP::atom3DihedSel 0] [list $molUP::atom4DihedSel 0]]]
        set molUP::initialDihedValue $molUP::DihedValue
    }

    ## Set the selections for the desired atoms
    set selection1 [atomselect top "index $molUP::atom1DihedSel"]
    set selection2 [atomselect top "index $molUP::atom2DihedSel"]
    set selection3 [atomselect top "index $molUP::atom3DihedSel"]
    set selection4 [atomselect top "index $molUP::atom4DihedSel"]

    ## Get atom coordinates
    set molUP::pos1 [join [$selection1 get {x y z}]]
    set molUP::pos2 [join [$selection2 get {x y z}]]
    set molUP::pos3 [join [$selection3 get {x y z}]]
    set molUP::pos4 [join [$selection4 get {x y z}]]
    $selection1 delete
    $selection2 delete
    $selection3 delete
    $selection4 delete

    set molUP::initialDihedValue [measure dihed [list [list $molUP::atom1DihedSel 0] [list $molUP::atom2DihedSel 0] [list $molUP::atom3DihedSel 0] [list $molUP::atom4DihedSel 0]]]

    #### Load the GUI
    molUP::guiDihedModif

    #### Run the initial procedure
	molUP::guiDihedModifInitialProc
}
##############################################################################

##############################################################################
#### Procedure to calculate the bond distance and move the bond
proc molUP::calcBondDistance {bondlength} {

    if {$molUP::atom2BondSel != ""} {

        set atomsToBeMoved1 100
        set atomsToBeMoved2 1

        ## Set the selections for the desired atoms
        set selection1 [atomselect top "index $molUP::atom1BondSel"]
        set selection2 [atomselect top "index $molUP::atom2BondSel"]

        ## Get atom coordinates
        set pos1 [join [$selection1 get {x y z}]]
        set pos2 [join [$selection2 get {x y z}]]
        $selection1 delete
        $selection2 delete

        ## Set vectors
        set dir    [vecnorm [vecsub $pos1 $pos2]]
        set curval [veclength [vecsub $pos2 $pos1]]
        
        
        if {$molUP::atom1BondOpt == "Fixed Atom" && $molUP::atom2BondOpt == "Fixed Atom"} {
            set alert [tk_messageBox -message "At least one atom must be free to move." -type ok -icon error]

        } elseif {$molUP::atom1BondOpt == "Fixed Atom" && $molUP::atom2BondOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            #set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1]]
            if {[catch {::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2}] == 0} {
                set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2]]
            } else {
                set indexes2 $molUP::atom2BondSel
            }
            #set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            #$selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            #$selection1 delete
            $selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Move Atom" && $molUP::atom2BondOpt == "Fixed Atom"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1BondSel
            }
            #set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            #set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -1*($curval-$bondlength)] $dir]
            #$selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            $selection1 delete
            #$selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Move Atom" && $molUP::atom2BondOpt == "Move Atom"} {

            set atomsToBeMoved1 1
            set atomsToBeMoved2 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1BondSel
            }

            if {[catch {::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2}] == 0} {
                set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2]]
            } else {
                set indexes2 $molUP::atom2BondSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Move Atom" && $molUP::atom2BondOpt == "Move Atoms"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1BondSel
            }

            if {[catch {::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel}] == 0} {
                set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel]]
            } else {
                set indexes2 $molUP::atom2BondSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Move Atoms" && $molUP::atom2BondOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel]]
            } else {
                set indexes1 $molUP::atom1BondSel
            }

            if {[catch {::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2}] == 0} {
                set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2]]
            } else {
                set indexes2 $molUP::atom2BondSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Move Atoms" && $molUP::atom2BondOpt == "Move Atoms"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel]]
            } else {
                set indexes1 $molUP::atom1BondSel
            }

            if {[catch {::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel}] == 0} {
                set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel]]
            } else {
                set indexes2 $molUP::atom2BondSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            $selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 0.5*($curval-$bondlength)] $dir]
            $selection1 delete
            $selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Fixed Atom" && $molUP::atom2BondOpt == "Move Atoms"} {

            ## Atoms to be moved
            #set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel -maxdepth $atomsToBeMoved1]]
            if {[catch {::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel}] == 0} {
                set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel]]
            } else {
                set indexes2 $molUP::atom2BondSel
            }
            #set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
            ## Move atoms according to distance
            #$selection1 moveby [vecscale [expr -0.5*($curval-$bondlength)] $dir]
            $selection2 moveby [vecscale [expr 1*($curval-$bondlength)] $dir]
            #$selection1 delete
            $selection2 delete
            
        } elseif {$molUP::atom1BondOpt == "Move Atoms" && $molUP::atom2BondOpt == "Fixed Atom"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom2BondSel $molUP::atom1BondSel]]
            } else {
                set indexes1 $molUP::atom1BondSel
            }
            #set indexes2 [join [::util::bondedsel top $molUP::atom1BondSel $molUP::atom2BondSel -maxdepth $atomsToBeMoved2]]
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom2BondSel"]
            #set selection2 [atomselect top "index $indexes2 and not index $molUP::atom1BondSel"]
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

    set molUP::initialBondDistance $molUP::BondDistance

}


#### Procedure to calculate the angle and move the angle
proc molUP::calcAngleDistance {newangle} {

    if {$molUP::atom3AngleSel != ""} {

        set atomsToBeMoved1 100
        set atomsToBeMoved3 1


        ## Set the delta value
        set delta [expr $molUP::initialAngleValue - $newangle]
        

        if {$molUP::atom1AngleOpt == "Fixed Atom" && $molUP::atom3AngleOpt == "Fixed Atom"} {
            set alert [tk_messageBox -message "At least one atom must be free to move." -type ok -icon error]

        } elseif {$molUP::atom1AngleOpt == "Fixed Atom" && $molUP::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved3 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel -maxdepth $atomsToBeMoved3}] == 0} {
                set indexes3 [join [::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel -maxdepth $atomsToBeMoved3]]
            } else {
                set indexes3 $molUP::atom3AngleSel
            }
            set selection3 [atomselect top "index $indexes3 and not index $molUP::atom1AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection3 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] $delta deg]
            $selection3 delete
            
        } elseif {$molUP::atom1AngleOpt == "Move Atom" && $molUP::atom3AngleOpt == "Fixed Atom"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1AngleSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] $delta deg]
            $selection1 delete
            
        } elseif {$molUP::atom1AngleOpt == "Move Atom" && $molUP::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved1 1
            set atomsToBeMoved2 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1AngleSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel -maxdepth $atomsToBeMoved3}] == 0} {
                set indexes3 [join [::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel -maxdepth $atomsToBeMoved3]]
            } else {
                set indexes3 $molUP::atom3AngleSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3AngleSel $molUP::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $molUP::atom1AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$molUP::atom1AngleOpt == "Move Atom" && $molUP::atom3AngleOpt == "Move Atoms"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1AngleSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel}] == 0} {
                set indexes3 [join [::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel]]
            } else {
                set indexes3 $molUP::atom3AngleSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3AngleSel $molUP::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $molUP::atom1AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$molUP::atom1AngleOpt == "Move Atoms" && $molUP::atom3AngleOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel]]
            } else {
                set indexes1 $molUP::atom1AngleSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel -maxdepth $atomsToBeMoved3}] == 0} {
                set indexes3 [join [::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel -maxdepth $atomsToBeMoved3]]
            } else {
                set indexes3 $molUP::atom3AngleSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3AngleSel $molUP::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $molUP::atom1AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$molUP::atom1AngleOpt == "Move Atoms" && $molUP::atom3AngleOpt == "Move Atoms"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel]]
            } else {
                set indexes1 $molUP::atom1AngleSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel}] == 0} {
                set indexes3 [join [::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel]]
            } else {
                set indexes3 $molUP::atom3AngleSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3AngleSel $molUP::atom2AngleSel"]
            set selection3 [atomselect top "index $indexes3 and not index $molUP::atom1AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * -0.5] deg]
            $selection3 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] [expr $delta * 0.5] deg]
            $selection1 delete
            $selection3 delete
            
        } elseif {$molUP::atom1AngleOpt == "Fixed Atom" && $molUP::atom3AngleOpt == "Move Atoms"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel}] == 0} {
                set indexes3 [join [::util::bondedsel top $molUP::atom1AngleSel $molUP::atom3AngleSel]]
            } else {
                set indexes3 $molUP::atom3AngleSel
            }
            set selection3 [atomselect top "index $indexes3 and not index $molUP::atom1AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection3 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] $delta deg]
            $selection3 delete
            
        } elseif {$molUP::atom1AngleOpt == "Move Atoms" && $molUP::atom3AngleOpt == "Fixed Atom"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3AngleSel $molUP::atom1AngleSel]]
            } else {
                set indexes1 $molUP::atom1AngleSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3AngleSel $molUP::atom2AngleSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 [vecadd $molUP::normvec $molUP::pos2] $delta deg]
            $selection1 delete
            
        } else {
            set alert [tk_messageBox -message "Unkown error. Please contact the developer." -type ok -icon error]
        }


    } else {
        
    }

    set molUP::initialAngleValue $molUP::AngleValue

}

#### Procedure to calculate the angle and move the angle
proc molUP::calcDihedDistance {newdihed} {

    if {$molUP::atom4DihedSel != ""} {

        set atomsToBeMoved1 100
        set atomsToBeMoved3 1


        ## Set the delta value
        set delta [expr $newdihed - $molUP::initialDihedValue]
        

        if {$molUP::atom1DihedOpt == "Fixed Atom" && $molUP::atom4DihedOpt == "Fixed Atom"} {
            set alert [tk_messageBox -message "At least one atom must be free to move." -type ok -icon error]

        } elseif {$molUP::atom1DihedOpt == "Fixed Atom" && $molUP::atom4DihedOpt == "Move Atom"} {

            set atomsToBeMoved4 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel -maxdepth $atomsToBeMoved4}] == 0} {
                set indexes4 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel -maxdepth $atomsToBeMoved4]]
            } else {
                set indexes4 $molUP::atom4DihedSel
            }
            set selection4 [atomselect top "index $indexes4 and not index $molUP::atom1DihedSel $molUP::atom2DihedSel $molUP::atom3DihedSel"]
            ## Move atoms according to distance
            $selection4 move [trans bond $molUP::pos2 $molUP::pos3 $delta deg]
            $selection4 delete
            
        } elseif {$molUP::atom1DihedOpt == "Move Atom" && $molUP::atom4DihedOpt == "Fixed Atom"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1DihedSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3DihedSel $molUP::atom2DihedSel $molUP::atom4DihedSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 $molUP::pos3 $delta deg]
            $selection1 delete
            
        } elseif {$molUP::atom1DihedOpt == "Move Atom" && $molUP::atom4DihedOpt == "Move Atom"} {

            set atomsToBeMoved1 1
            set atomsToBeMoved2 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1DihedSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel -maxdepth $atomsToBeMoved4}] == 0} {
                set indexes4 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel -maxdepth $atomsToBeMoved4]]
            } else {
                set indexes4 $molUP::atom4DihedSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3DihedSel $molUP::atom2DihedSel $molUP::atom4DihedSel"]
            set selection4 [atomselect top "index $indexes4 and not index $molUP::atom1DihedSel $molUP::atom2DihedSel $molUP::atom3DihedSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * -0.5] deg]
            $selection4 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * 0.5] deg]
            $selection1 delete
            $selection4 delete
            
        } elseif {$molUP::atom1DihedOpt == "Move Atom" && $molUP::atom4DihedOpt == "Move Atoms"} {

            set atomsToBeMoved1 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel -maxdepth $atomsToBeMoved1}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel -maxdepth $atomsToBeMoved1]]
            } else {
                set indexes1 $molUP::atom1DihedSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel}] == 0} {
                set indexes4 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel]]
            } else {
                set indexes4 $molUP::atom4DihedSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3DihedSel $molUP::atom2DihedSel $molUP::atom4DihedSel"]
            set selection4 [atomselect top "index $indexes4 and not index $molUP::atom1DihedSel $molUP::atom2DihedSel $molUP::atom3DihedSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * -0.5] deg]
            $selection4 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * 0.5] deg]
            $selection1 delete
            $selection4 delete
            
        } elseif {$molUP::atom1DihedOpt == "Move Atoms" && $molUP::atom4DihedOpt == "Move Atom"} {

            set atomsToBeMoved2 1

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel]]
            } else {
                set indexes1 $molUP::atom1DihedSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel -maxdepth $atomsToBeMoved4}] == 0} {
                set indexes4 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel -maxdepth $atomsToBeMoved4]]
            } else {
                set indexes4 $molUP::atom4DihedSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3DihedSel $molUP::atom2DihedSel $molUP::atom4DihedSel"]
            set selection4 [atomselect top "index $indexes4 and not index $molUP::atom1DihedSel $molUP::atom2DihedSel $molUP::atom3DihedSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * -0.5] deg]
            $selection4 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * 0.5] deg]
            $selection1 delete
            $selection4 delete
            
        } elseif {$molUP::atom1DihedOpt == "Move Atoms" && $molUP::atom4DihedOpt == "Move Atoms"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel]]
            } else {
                set indexes1 $molUP::atom1DihedSel
            }
            if {[catch {::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel}] == 0} {
                set indexes4 [join [::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel]]
            } else {
                set indexes4 $molUP::atom4DihedSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3DihedSel $molUP::atom2DihedSel $molUP::atom4DihedSel"]
            set selection4 [atomselect top "index $indexes4 and not index $molUP::atom1DihedSel $molUP::atom2DihedSel $molUP::atom3DihedSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * -0.5] deg]
            $selection4 move [trans bond $molUP::pos2 $molUP::pos3 [expr $delta * 0.5] deg]
            $selection1 delete
            $selection4 delete
            
        } elseif {$molUP::atom1DihedOpt == "Fixed Atom" && $molUP::atom4DihedOpt == "Move Atoms"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom1DihedSel $molUP::atom4DihedSel}] == 0} {
                set indexes4 [join [::util::bondedsel top $molUP::atom2DihedSel $molUP::atom4DihedSel]]
            } else {
                set indexes4 $molUP::atom4DihedSel
            }
            set selection4 [atomselect top "index $indexes4 and not index $molUP::atom1DihedSel $molUP::atom2DihedSel $molUP::atom3DihedSel"]
            ## Move atoms according to distance
            $selection4 move [trans bond $molUP::pos2 $molUP::pos3 $delta deg]
            $selection4 delete
            
        } elseif {$molUP::atom1DihedOpt == "Move Atoms" && $molUP::atom4DihedOpt == "Fixed Atom"} {

            ## Atoms to be moved
            if {[catch {::util::bondedsel top $molUP::atom4DihedSel $molUP::atom1DihedSel}] == 0} {
                set indexes1 [join [::util::bondedsel top $molUP::atom3DihedSel $molUP::atom1DihedSel]]
            } else {
                set indexes1 $molUP::atom1DihedSel
            }
            set selection1 [atomselect top "index $indexes1 and not index $molUP::atom3DihedSel $molUP::atom2DihedSel $molUP::atom4DihedSel"]
            ## Move atoms according to distance
            $selection1 move [trans bond $molUP::pos2 $molUP::pos3 $delta deg]
            $selection1 delete
            
        } else {
            set alert [tk_messageBox -message "Unkown error. Please contact the developer." -type ok -icon error]
        }


    } else {
        
    }

    set molUP::initialDihedValue $molUP::DihedValue

}
##############################################################################

##############################################################################
#### Bond - Apply and Cancel button
proc molUP::bondGuiCloseSave {} {
    trace remove variable ::vmd_pick_atom write molUP::atomPicked
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    destroy $::molUP::bondModif
}


proc molUP::bondGuiCloseNotSave {} {
    trace remove variable ::vmd_pick_atom write molUP::atomPicked
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    molUP::revertInitialStructure
    destroy $::molUP::bondModif
}


#### Angle - Apply and Cancel button
proc molUP::angleGuiCloseSave {} {
    trace remove variable ::vmd_pick_atom write molUP::atomPickedAngle
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    destroy $::molUP::angleModif
}


proc molUP::angleGuiCloseNotSave {} {
    trace remove variable ::vmd_pick_atom write molUP::atomPickedAngle
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    molUP::revertInitialStructure
    destroy $::molUP::angleModif
}

#### Dihed - Apply and Cancel button
proc molUP::dihedGuiCloseSave {} {
    trace remove variable ::vmd_pick_atom write molUP::atomPickedDihed
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    destroy $::molUP::dihedModif
}


proc molUP::dihedGuiCloseNotSave {} {
    trace remove variable ::vmd_pick_atom write molUP::atomPickedDihed
    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    molUP::revertInitialStructure
    destroy $::molUP::dihedModif
}
##############################################################################
