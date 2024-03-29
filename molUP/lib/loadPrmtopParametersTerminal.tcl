package provide loadPrmtopTerminal 1.7.1

proc molUP::loadPrmtopParametersTerminal {path} {
    set molID [lindex $molUP::topMolecule 0]

    set parametersInfoFromPrmtop ""

    if {$path != ""} {
        append parametersInfoFromPrmtop "NonBon 3 1 0 0 0.0 0.0 0.5 0.0 0.0 -1.2\n"

        ### Get Atom Types
        set listAtomTypes [molUP::prmtopGetDataFromFlag "AMBER_ATOM_TYPE" $path]
            ## Uppercase all atom types
            set newList {}
            set lowerCaseList {}
            set alternativeAtomTypes [list J K X Y Z 8 9 I V 5 6 7 F G H Q R S T U L W]
            set i 0
            foreach atomType $listAtomTypes {
                if {[string is lower [string range $atomType 0 0]] == 1} {
                    if {[lsearch $lowerCaseList $atomType] == -1} {
                        lappend lowerCaseList $atomType

                        #Change type on VMD lists
                        set selection [atomselect [lindex $molUP::topMolecule 0] "type \"$atomType\""]
                        set type "[string toupper [string range $atomType 0 0][lindex $alternativeAtomTypes $i]]"
                        $selection set type $type

                        #Change type on molUP tablelist
                        set indexes [$selection get index]
                        set molID [lindex $molUP::topMolecule 0]
                        foreach atom $indexes {
                            .molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer configcells [subst $atom],1 -text [subst $type]
                        }

                        set atomType "[string toupper [string range $atomType 0 0][lindex $alternativeAtomTypes $i]]"
                        
                        
                        incr i
                    } else {
                        set index [lsearch $lowerCaseList $atomType]
                        set atomType "[string toupper [string range $atomType 0 0][lindex $alternativeAtomTypes $index]]"
                    }

                    lappend newList $atomType
                } else {
                    lappend newList $atomType
                }
            }
            set listAtomTypes $newList


        ### Get Unique Atom Types
        set listAtomTypesUnique [lsort -unique $listAtomTypes]





        ### Get VDW Information
        set lennardJonesA [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "LENNARD_JONES_ACOEF" $path]]
        set lennardJonesB [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "LENNARD_JONES_BCOEF" $path]]
        set icoList [molUP::prmtopGetDataFromFlag "NONBONDED_PARM_INDEX" $path]
        set atomTypesList [molUP::prmtopGetDataFromFlag "ATOM_TYPE_INDEX" $path]

        set nTypes [lindex [lsort -real -decreasing $atomTypesList] 0]
        foreach index $listAtomTypesUnique {
            set atomTypeIndex [lindex [lsearch $listAtomTypes $index] 0]

            if {$atomTypeIndex != -1} {
                set valueAtomTypeIndex [lindex $atomTypesList $atomTypeIndex]

                set ico [expr $nTypes*($valueAtomTypeIndex-1)+$valueAtomTypeIndex - 1]
                set coefIndex [lindex $icoList $ico]

                set coefA [lindex $lennardJonesA [expr $coefIndex - 1]]
                set coefB [lindex $lennardJonesB [expr $coefIndex - 1]]

                if {$coefA != 0 && $coefB != 0 && $coefA != "" && $coefB != ""} {
                    set r [expr ((2*$coefA/$coefB)**(1/6.000000000000000))/2]
                    set e [expr $coefB / (4* $coefA/$coefB)]
                } else {
                    set r 0.0000
                    set e 0.0000
                }
                append parametersInfoFromPrmtop "VDW \"$index\" [format %8.4f $r] [format %8.4f $e]\n"
            }
        }


        ### Get Bonds Information
        set bondsIncH [molUP::prmtopGetDataFromFlag "BONDS_INC_HYDROGEN" $path]
        set bondsNotH [molUP::prmtopGetDataFromFlag "BONDS_WITHOUT_HYDROGEN" $path]
        set bondsList [concat $bondsIncH $bondsNotH]
        set bondForceList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "BOND_FORCE_CONSTANT" $path]]
        set bondEquiList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "BOND_EQUIL_VALUE" $path]]

        set uniqueList {}
        set numberBonds [expr [llength $bondsList] / 3]
        for {set index 0} { $index < $numberBonds } { incr index } {
            set atom1Index [expr [lindex $bondsList [expr ($index*3+0)]] /3]
            set atom2Index [expr [lindex $bondsList [expr ($index*3+1)]] /3]
            set valueIndexes [expr [lindex $bondsList [expr ($index*3+2)]] - 1]

            set atom1 [lindex $listAtomTypes $atom1Index]
            set atom2 [lindex $listAtomTypes $atom2Index]
            set force [lindex $bondForceList $valueIndexes]
            set equil [lindex $bondEquiList $valueIndexes]

            if {[string match {*\**} $atom1] == 1} {
                set atom1Search "[string range $atom1 0 0]\[\*\]"
            } else {
                set atom1Search $atom1
            }

             if {[string match {*\**} $atom2] == 1} {
                set atom2Search "[string range $atom2 0 0]\[\*\]"
            } else {
                set atom2Search $atom2
            }

            if {[lsearch -exact $uniqueList "[string trim $atom1] [string trim $atom2]"] == -1} {
                lappend uniqueList "[string trim $atom1] [string trim $atom2]"
                lappend uniqueList "[string trim $atom2] [string trim $atom1]"
                append parametersInfoFromPrmtop "HrmStr1 \"$atom1\" \"$atom2\" [format %6.2f $force] [format %6.4f $equil]\n"
            } else {
                #Do nothing
            }
        }


        ### Get Angles Information
        set anglesIncH [molUP::prmtopGetDataFromFlag "ANGLES_INC_HYDROGEN" $path]
        set anglesNotH [molUP::prmtopGetDataFromFlag "ANGLES_WITHOUT_HYDROGEN" $path]
        set anglesList [concat $anglesIncH $anglesNotH]
        set angleForceList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "ANGLE_FORCE_CONSTANT" $path]]
        set angleEquiList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "ANGLE_EQUIL_VALUE" $path]]

        set uniqueList {}
        set numberAngles [expr [llength $anglesList] / 4]
        for {set index 0} { $index < $numberAngles } { incr index } {
            set atom1Index [expr [lindex $anglesList [expr ($index*4+0)]] /3]
            set atom2Index [expr [lindex $anglesList [expr ($index*4+1)]] /3]
            set atom3Index [expr [lindex $anglesList [expr ($index*4+2)]] /3]
            set valueIndexes [expr [lindex $anglesList [expr ($index*4+3)]] - 1]

            set atom1 [lindex $listAtomTypes $atom1Index]
            set atom2 [lindex $listAtomTypes $atom2Index]
            set atom3 [lindex $listAtomTypes $atom3Index]
            set force [lindex $angleForceList $valueIndexes]
            set equil [expr [lindex $angleEquiList $valueIndexes]*180/3.1415926535897931]


            if {[string match {*\**} $atom1] == 1} {
                set atom1Search "[string range $atom1 0 0]\[\*\]"
            } else {
                set atom1Search $atom1
            }

            if {[string match {*\**} $atom2] == 1} {
                set atom2Search "[string range $atom2 0 0]\[\*\]"
            } else {
                set atom2Search $atom2
            }

            if {[string match {*\**} $atom3] == 1} {
                set atom3Search "[string range $atom3 0 0]\[\*\]"
            } else {
                set atom3Search $atom3
            }

            if {[lsearch -exact $uniqueList "[string trim $atom1] [string trim $atom2] [string trim $atom3]"] == -1} {
                lappend uniqueList "[string trim $atom1] [string trim $atom2] [string trim $atom3]"
                lappend uniqueList "[string trim $atom3] [string trim $atom2] [string trim $atom1]"
                append parametersInfoFromPrmtop "HrmBnd1 \"$atom1\" \"$atom2\" \"$atom3\"  [format %4.2f $force] [format %7.4f $equil]\n"
            } else {
                #Do nothing
            }
        }
                ## Add the angle parameters for TIP3P water molecules
                append parametersInfoFromPrmtop "HrmBnd1 \"HW\" \"HW\" \"OW\"   0.00   0.0000\n"
                append parametersInfoFromPrmtop "HrmBnd1 \"HW\" \"OW\" \"HW\"   0.00   0.0000\n"





       ### Get Dihedral Angles Information
        set dihedIncH [molUP::prmtopGetDataFromFlag "DIHEDRALS_INC_HYDROGEN" $path]
        set dihedNotH [molUP::prmtopGetDataFromFlag "DIHEDRALS_WITHOUT_HYDROGEN" $path]
        set dihedList [concat $dihedIncH $dihedNotH]
        set dihedForceList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "DIHEDRAL_FORCE_CONSTANT" $path]]
        set dihedPeriodList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "DIHEDRAL_PERIODICITY" $path]]
        set dihedPhaseList [molUP::prmtopTableExtractValues [molUP::prmtopGetDataFromFlag "DIHEDRAL_PHASE" $path]]


        set uniqueList {}
        set uniqueListDihed {}
        set uniqueListDihed1 {}
        set dihedralAnglesList {}
        set numberDihed [expr [llength $dihedList] / 5]
        for {set index 0} { $index < $numberDihed } { incr index } {
            set atom1Index [expr [lindex $dihedList [expr ($index*5+0)]] /3]
            set atom2Index [expr [lindex $dihedList [expr ($index*5+1)]] /3]
            set atom3Index [expr [lindex $dihedList [expr ($index*5+2)]] /3]
            set atom4Index [expr [lindex $dihedList [expr ($index*5+3)]] /3]
            set valueIndexes [expr [lindex $dihedList [expr ($index*5+4)]] - 1]

            if {$atom4Index < 0} {
                ## Improper Dihedral Angle
                set atom1 [lindex $listAtomTypes $atom1Index]
                set atom2 [lindex $listAtomTypes $atom2Index]
                set atom3 [lindex $listAtomTypes [expr abs($atom3Index)]]
                set atom4 [lindex $listAtomTypes [expr abs($atom4Index)]]
                set force [lindex $dihedForceList $valueIndexes]
                set period [lindex $dihedPeriodList $valueIndexes]
                set phase [expr [lindex $dihedPhaseList $valueIndexes]*180/3.1415926535897931]

                 if {[lsearch -exact $uniqueList "$atom1 $atom2 $atom3 $atom4"] == -1} {
                     lappend uniqueList "$atom1 $atom3 $atom2 $atom4"
                     lappend uniqueList "$atom3 $atom1 $atom2 $atom4"
                     lappend uniqueList "$atom2 $atom1 $atom3 $atom4"
                     lappend uniqueList "$atom1 $atom2 $atom3 $atom4"
                     lappend uniqueList "$atom3 $atom2 $atom1 $atom4"
                     lappend uniqueList "$atom2 $atom3 $atom1 $atom4"

                     lappend uniqueList "$atom4 $atom1 $atom3 $atom2"
                     lappend uniqueList "$atom4 $atom3 $atom1 $atom2"
                     lappend uniqueList "$atom4 $atom2 $atom1 $atom3"
                     lappend uniqueList "$atom4 $atom1 $atom2 $atom3"
                     lappend uniqueList "$atom4 $atom3 $atom2 $atom1"
                     lappend uniqueList "$atom4 $atom2 $atom3 $atom1"
                     append parametersInfoFromPrmtop "ImpTrs \"$atom1\" \"$atom2\" \"$atom3\" \"$atom4\" [format %4.1f $force] [format %5.1f $phase] 2.0\n"
                 } else {
                     #Do nothing
                 }

                
            } elseif {$atom4Index > 0} {
                set atom1 [lindex $listAtomTypes $atom1Index]
                set atom2 [lindex $listAtomTypes $atom2Index]
                set atom3 [lindex $listAtomTypes [expr abs($atom3Index)]]
                set atom4 [lindex $listAtomTypes [expr abs($atom4Index)]]
                set force [lindex $dihedForceList $valueIndexes]
                set period [lindex $dihedPeriodList $valueIndexes]
                set phase [expr [lindex $dihedPhaseList $valueIndexes]*180/3.1415926535897931]

                if {[lsearch $dihedralAnglesList "$atom1 $atom2 $atom3 $atom4 $force $phase $period"] == -1} {
                    lappend dihedralAnglesList "$atom1 $atom2 $atom3 $atom4 $force $phase $period"
                } else {

                }

                if {[lsearch -exact $uniqueListDihed "$atom1 $atom2 $atom3 $atom4"] == -1} {
                     lappend uniqueListDihed "$atom1 $atom2 $atom3 $atom4"
                     lappend uniqueListDihed "$atom4 $atom3 $atom2 $atom1"

                     lappend uniqueListDihed1 "$atom1 $atom2 $atom3 $atom4"
                 } else {
                     #Do nothing
                 }

            }
        }


        foreach dihed $uniqueListDihed1 {
            set values [lsearch -all $dihedralAnglesList "[subst $dihed] *"]

            set phase1 0
            set phase2 0
            set phase3 0
            set phase4 0
            set force1 0
            set force2 0
            set force3 0
            set force4 0
            set atom1 X
            set atom2 X
            set atom3 X
            set atom4 X

            foreach value $values {

                if {[lindex [lindex $dihedralAnglesList $value] 6] == 1} {

                    set force1 [lindex [lindex $dihedralAnglesList $value] 4]
                    set phase1 [lindex [lindex $dihedralAnglesList $value] 5]

                } elseif {[lindex [lindex $dihedralAnglesList $value] 6] == 2} {

                    set force2 [lindex [lindex $dihedralAnglesList $value] 4]
                    set phase2 [lindex [lindex $dihedralAnglesList $value] 5]

                } elseif {[lindex [lindex $dihedralAnglesList $value] 6] == 3} {

                    set force3 [lindex [lindex $dihedralAnglesList $value] 4]
                    set phase3 [lindex [lindex $dihedralAnglesList $value] 5]

                } elseif {[lindex [lindex $dihedralAnglesList $value] 6] == 4} {

                    set force4 [lindex [lindex $dihedralAnglesList $value] 4]
                    set phase4 [lindex [lindex $dihedralAnglesList $value] 5]

                } else {     
                }
            }
                
            append parametersInfoFromPrmtop "AmbTrs \"[lindex $dihed 0]\" \"[lindex $dihed 1]\" \"[lindex $dihed 2]\" \"[lindex $dihed 3]\" [format %3.0f $phase1] [format %3.0f $phase2] [format %3.0f $phase3] [format %3.0f $phase4]   [format %5.3f $force1] [format %5.3f $force2] [format %5.3f $force3] [format %5.3f $force4] 1.0\n"
            set phase1 0
            set phase2 0
            set phase3 0
            set phase4 0
            set force1 0
            set force2 0
            set force3 0
            set force4 0
            set atom1 X
            set atom2 X
            set atom3 X
            set atom4 X
        }


       $molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param delete 1.0 end
       $molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param insert end $parametersInfoFromPrmtop

    } else {}

}

