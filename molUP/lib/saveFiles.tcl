package provide saveFiles 1.5.1

proc molUP::savePDB {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{PDB (.pdb)}       {.pdb}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".pdb"]

        if {$path != ""} {
            animate write pdb [list $path] beg 0 end 0 skip 1 [lindex $molUP::topMolecule 0]
        } else {}
    }

    destroy $::molUP::saveFile
}


proc molUP::saveXYZ {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{XYZ (.xyz)}       {.xyz}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".xyz"]

        if {$path != ""} {
            animate write xyz [list $path] beg 0 end 0 skip 1 [lindex $molUP::topMolecule 0]
        } else {}
    }

    destroy $::molUP::saveFile
}

proc molUP::saveGaussian {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{Gaussian Input File (.com)}       {.com}        }
        }
        set path [tk_getSaveFile -title "Save file as Gaussian Input" -filetypes $fileTypes -defaultextension ".com" -initialfile "Created_by_molUP.com"]

        if {$path != ""} {
            if {$molUP::saveAdvancedOptions == "All"} {
                molUP::writeGaussianFile $path
            } else {
                molUP::writeGaussianFileAdvanced $path $molUP::atomSelectionSave
            }
        } else {}

    }

    destroy $::molUP::saveFile

}

proc molUP::saveORCA {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{ORCA input files (.inp)}       {.inp}        }
        }
        set path [tk_getSaveFile -title "Save file as ORCA Input" -filetypes $fileTypes -defaultextension ".inp" -initialfile "Created_by_molUP.inp"]

        if {$path != ""} {
            molUP::writeORCAFileAdvanced $path $molUP::atomSelectionSave
        } else {}

    }

    destroy $::molUP::saveFile

}

proc molUP::writeGaussianFileAdvanced {path selection} {
    ## Create a file 
	set file [open "$path" wb]

    set molID [lindex $molUP::topMolecule 0]

    set keywords [.molUP.frame0.major.mol$molID.tabs.tabInput.keywordsText get 1.0 end]
    set title [.molUP.frame0.major.mol$molID.tabs.tabInput.jobTitleEntry get 1.0 end]

    ## Write keywords
    puts $file "$keywords"

    ## Write title
    puts $file "$title"

    set sel [atomselect [lindex $molUP::topMolecule 0] $selection]
    set indexes [$sel get index]

    ## Write Charge and Multi
    set molUP::chargesMultip "0 1"
    puts $file $molUP::chargesMultip

    ## Get coordinates
    set allCoord [$sel get {x y z}]
    set elementInfo [$sel get element]

    ## Get Layer Info
    set layerInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer get $indexes]

    ## Get Freeze Info
    set freezeInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab3.tableLayer get $indexes]
    
    ## Get Charges Info
    set chargesInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer get $indexes]

  
    ## Write on the file
    set i 0
    foreach atomLayer $layerInfoList atomFreeze $freezeInfoList atomCharge $chargesInfoList atomCoord $allCoord element $elementInfo {
        if {$element == "X"} {
            set element [lindex $atomLayer 1]
            regsub -all {[0-9]*} $element "" element; #Remove numbers from the element name
            if {[string is lower "[string range $element 1 1]"] == 1} {
                set element [string range $element 0 1]
            } else {
                set element [string range $element 0 0]
            }
        } else {

        }

        
        
        set lookForLinkAtom [lsearch $molUP::linkAtomsListIndex $i]

        set xx [lindex $atomCoord 0]
        set yy [lindex $atomCoord 1]
        set zz [lindex $atomCoord 2]

        if {[lindex $atomFreeze 4] == ""} {
            set freeze 0
        } else {
            set freeze [format %.0f [lindex $atomFreeze 4]]
        }

        if {$lookForLinkAtom == -1} {
            set initialInfo " $element-[lindex $atomCharge 1]-[format %.6f [lindex $atomCharge 4]](PDBName=[lindex $atomLayer 1],ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s $freeze] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]"
        } else {
            set linkAtom [lindex $molUP::linkAtomsList $lookForLinkAtom]

            set initialInfo " [string range [lindex $atomCharge 1] 0 0]-[lindex $atomCharge 1]-[format %.6f [lindex $atomCharge 4]](PDBName=[lindex $atomLayer 1],ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s $freeze] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]$linkAtom"
        }
    
        incr i
    }




    ## Add link atoms
    set connectivity [topo getbondlist order]

    set listD {}
    foreach value $indexes {
        set a [lsearch -index 0 -all $connectivity $value]
        set listA {}
        foreach c $a {
            set d [lindex [lindex $connectivity $c] 1]
            lappend listA $d
        }

        set b [lsearch -index 1 -all $connectivity $value]
        set listB {}
        foreach c $b {
            set d [lindex [lindex $connectivity $c] 0]
            lappend listB $d
        }

        set listC [concat $listA $listB]

        lappend listD $listC

    }

    set linkAtomsList [lsort -unique -real [join $listD]]
    #puts $linkAtomsList
    #puts "indexes $indexes"

    #Get the atoms from the HL that are bonded to link atoms
    molUP::linkAtoms
    set linkAtomsPairList {}
    foreach a $molUP::linkAtomsListIndex b $molUP::linkAtomsList {
        lappend linkAtomsPairList [list $a [lindex $b 1]]
    }

    foreach linkAtom $linkAtomsList {
        if {[lsearch $indexes $linkAtom] == -1} {
            set sel [atomselect [lindex $molUP::topMolecule 0] "index $linkAtom"]

            set atomLayer [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer get $linkAtom]
            set atomFreeze [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab3.tableLayer get $linkAtom]
            set atomCharge [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer get $linkAtom]

            #Get the index of the atom in HL
            set hlAtom [lindex [lsearch -index 0 -inline $linkAtomsPairList $linkAtom] 1]

            # Get the coordinates of the link atom and the respective atom in the HL
            set selHL [atomselect [lindex $molUP::topMolecule 0] "index [expr $hlAtom - 1]"]
            set vecHL [join [$selHL get {x y z}]]
            set vecLA [join [$sel get {x y z}]]

            # Interatomic distance between the link atoms and the atom in the HL
            set linkAtomDistance "1.09"

            # Calculate the vector and apply it to move the link atom to the distance above
            set vec [vecsub $vecHL $vecLA]
            set vecLength [veclength $vec]
            set scaling [format %.6f [expr ($vecLength - $linkAtomDistance) / $vecLength]]
            set movingVector [vecscale $scaling $vec]
            set finalPos [vecadd $vecLA $movingVector]

            set xx [lindex $finalPos 0]
            set yy [lindex $finalPos 1]
            set zz [lindex $finalPos 2]

            if {[lindex $atomFreeze 4] == ""} {
                set freeze 0
            } else {
                set freeze [lindex $atomFreeze 4]
            }

            set initialInfo " H-H-[lindex $atomCharge 4](PDBName=H,ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s $freeze] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]"

            $sel delete
            $selHL delete
        }

    }


    ## Connectivity
    set connectivity [molUP::connectivityFromVMD "index $indexes"]
    puts $file "\n$connectivity"

    set parameters [.molUP.frame0.major.mol$molID.tabs.tabInput.param get 1.0 end]
    puts $file "$parameters"

    close $file

}

proc molUP::writeGaussianFile {path} {
    ## Create a file 
	set file [open "$path" wb]

    set molID [lindex $molUP::topMolecule 0]


    set keywords [.molUP.frame0.major.mol$molID.tabs.tabInput.keywordsText get 1.0 end]
    set title [.molUP.frame0.major.mol$molID.tabs.tabInput.jobTitleEntry get 1.0 end]

    ## Write keywords
    puts $file "$keywords"

    ## Write title
    puts $file "$title"

    ## Write Charge and Multi
    set molUP::chargesMultip ""
    set molID [lindex $molUP::topMolecule 0]
    set highLayerIndex [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer searchcolumn 4 "H" -all]
    set mediumLayerIndex [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer searchcolumn 4 "M" -all]
    set lowLayerIndex [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer searchcolumn 4 "L" -all]
    if {($highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex == "") || \
        $highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex == "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex != "" || \
        $highLayerIndex == "" && $mediumLayerIndex == "" && $lowLayerIndex == "" } {              
        set molUP::chargesMultip "[expr round($molUP::chargeAll)] $molUP::multiplicityValue"
    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex == ""} {
        set molUP::chargesMultip "[expr round($molUP::chargeML)] $molUP::multiplicityValue1 [expr round($molUP::chargeHL)] $molUP::multiplicityValue [expr round($molUP::chargeHL)] $molUP::multiplicityValue"
    } elseif {$highLayerIndex != "" && $mediumLayerIndex == "" && $lowLayerIndex != ""} {
        set molUP::chargesMultip "[expr round($molUP::chargeLL)] $molUP::multiplicityValue1 [expr round($molUP::chargeHL)] $molUP::multiplicityValue [expr round($molUP::chargeHL)] $molUP::multiplicityValue"
    } elseif {$highLayerIndex == "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
        set molUP::chargesMultip "[expr round($molUP::chargeLL)] $molUP::multiplicityValue1 [expr round($molUP::chargeML)] $molUP::multiplicityValue [expr round($molUP::chargeML)] $molUP::multiplicityValue"
    } elseif {$highLayerIndex != "" && $mediumLayerIndex != "" && $lowLayerIndex != ""} {
        set molUP::chargesMultip "[expr round($molUP::chargeLL)] $molUP::multiplicityValue2 [expr round($molUP::chargeML)] $molUP::multiplicityValue1 [expr round($molUP::chargeML)] $molUP::multiplicityValue1 [expr round($molUP::chargeHL)] $molUP::multiplicityValue [expr round($molUP::chargeHL)] $molUP::multiplicityValue [expr round($molUP::chargeHL)] $molUP::multiplicityValue"
    } else {
        
        set molUP::chargesMultip "0 1"

    }
    puts $file $molUP::chargesMultip

    ## Get coordinates
    set allSelection [atomselect [lindex $molUP::topMolecule 0] "all"]
    set allCoord [$allSelection get {x y z}]
    set elementInfo [$allSelection get element]

    ## Get Layer Info
    set layerInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer get 0 end]

    ## Get Freeze Info
    set freezeInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab3.tableLayer get 0 end]
    
    ## Get Charges Info
    set chargesInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer get 0 end]

    ## Add link atoms (hydrogens)
    molUP::linkAtoms

    ## Write on the file
    set i 0
    foreach atomLayer $layerInfoList atomFreeze $freezeInfoList atomCharge $chargesInfoList atomCoord $allCoord element $elementInfo {
        if {$element == "X"} {
            set element [lindex $atomLayer 1]
            regsub -all {[0-9]*} $element "" element; #Remove numbers from the element name
            if {[string is lower "[string range $element 1 1]"] == 1} {
                set element [string range $element 0 1]
            } else {
                set element [string range $element 0 0]
            }
        } else {

        }


        set lookForLinkAtom [lsearch $molUP::linkAtomsListIndex $i]

        set xx [lindex $atomCoord 0]
        set yy [lindex $atomCoord 1]
        set zz [lindex $atomCoord 2]

        if {[lindex $atomFreeze 4] == ""} {
            set freeze 0
        } else {
            set freeze [format %.0f [lindex $atomFreeze 4]]
        }

        if {$lookForLinkAtom == -1} {
            set initialInfo " $element-[lindex $atomCharge 1]-[format %.6f [lindex $atomCharge 4]](PDBName=[lindex $atomLayer 1],ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s $freeze] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]"
        } else {
            set linkAtom [lindex $molUP::linkAtomsList $lookForLinkAtom]

            set initialInfo " [string range [lindex $atomCharge 1] 0 0]-[lindex $atomCharge 1]-[format %.6f [lindex $atomCharge 4]](PDBName=[lindex $atomLayer 1],ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s $freeze] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]$linkAtom"
        }
    
        incr i
    }

    set connectivity [split [.molUP.frame0.major.mol$molID.tabs.tabInput.connect get 1.0 end] "\n"]
    puts $file ""
    foreach line $connectivity {
        if {[regexp {^\s*$} $line] == 0} {
            puts $file $line
        }
    }

    set parameters [.molUP.frame0.major.mol$molID.tabs.tabInput.param get 1.0 end]
    puts  $file "$parameters"

    close $file

}

proc molUP::writeORCAFileAdvanced {path selection} {
    ## Create a file 
	set file [open "$path" wb]

    set molID [lindex $molUP::topMolecule 0]

    ## Write keywords
    puts $file "!B3LYP 6-31G(d,p) SP\n"

    set sel [atomselect [lindex $molUP::topMolecule 0] $selection]
    set indexes [$sel get index]

    ## Write Charge and Multi
    puts $file "* xyz 0 1"

    ## Get coordinates
    set allCoord [$sel get {x y z}]
    set elementInfo [$sel get element]

    ## Get Layer Info
    set layerInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer get $indexes]

    ## Get Freeze Info
    set freezeInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab3.tableLayer get $indexes]
    
    ## Get Charges Info
    set chargesInfoList [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer get $indexes]

  
    ## Write on the file
    set i 0
    foreach atomLayer $layerInfoList atomFreeze $freezeInfoList atomCharge $chargesInfoList atomCoord $allCoord element $elementInfo {
        if {$element == "X"} {
            set element [lindex $atomLayer 1]
            regsub -all {[0-9]*} $element "" element; #Remove numbers from the element name
            if {[string is lower "[string range $element 1 1]"] == 1} {
                set element [string range $element 0 1]
            } else {
                set element [string range $element 0 0]
            }
        } else {

        }

        
        
        set lookForLinkAtom [lsearch $molUP::linkAtomsListIndex $i]

        set xx [lindex $atomCoord 0]
        set yy [lindex $atomCoord 1]
        set zz [lindex $atomCoord 2]

        if {[lindex $atomFreeze 4] == ""} {
            set freeze 0
        } else {
            set freeze [format %.0f [lindex $atomFreeze 4]]
        }

        if {$lookForLinkAtom == -1} {
            puts $file "[format %2s $element] [format "%17s" [format "% f" $xx]] [format "%16s" [format "% f" $yy]] [format "%16s" [format "% f" $zz]]"
        } else {
            set linkAtom [lindex $molUP::linkAtomsList $lookForLinkAtom]
            puts $file "[format %2s $element] [format "%17s" [format "% f" $xx]] [format "%16s" [format "% f" $yy]] [format "%16s" [format "% f" $zz]]"
        }
    
        incr i
    }




    ## Add link atoms
    set connectivity [topo getbondlist order]

    set listD {}
    foreach value $indexes {
        set a [lsearch -index 0 -all $connectivity $value]
        set listA {}
        foreach c $a {
            set d [lindex [lindex $connectivity $c] 1]
            lappend listA $d
        }

        set b [lsearch -index 1 -all $connectivity $value]
        set listB {}
        foreach c $b {
            set d [lindex [lindex $connectivity $c] 0]
            lappend listB $d
        }

        set listC [concat $listA $listB]

        lappend listD $listC

    }

    set linkAtomsList [lsort -unique -real [join $listD]]
    #puts $linkAtomsList
    #puts "indexes $indexes"

    #Get the atoms from the HL that are bonded to link atoms
    molUP::linkAtoms
    set linkAtomsPairList {}
    foreach a $molUP::linkAtomsListIndex b $molUP::linkAtomsList {
        lappend linkAtomsPairList [list $a [lindex $b 1]]
    }

    foreach linkAtom $linkAtomsList {
        if {[lsearch $indexes $linkAtom] == -1} {
            set sel [atomselect [lindex $molUP::topMolecule 0] "index $linkAtom"]

            set atomLayer [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer get $linkAtom]
            set atomFreeze [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab3.tableLayer get $linkAtom]
            set atomCharge [.molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer get $linkAtom]

            #Get the index of the atom in HL
            set hlAtom [lindex [lsearch -index 0 -inline $linkAtomsPairList $linkAtom] 1]

            # Get the coordinates of the link atom and the respective atom in the HL
            set selHL [atomselect [lindex $molUP::topMolecule 0] "index [expr $hlAtom - 1]"]
            set vecHL [join [$selHL get {x y z}]]
            set vecLA [join [$sel get {x y z}]]

            # Interatomic distance between the link atoms and the atom in the HL
            set linkAtomDistance "1.09"

            # Calculate the vector and apply it to move the link atom to the distance above
            set vec [vecsub $vecHL $vecLA]
            set vecLength [veclength $vec]
            set scaling [format %.6f [expr ($vecLength - $linkAtomDistance) / $vecLength]]
            set movingVector [vecscale $scaling $vec]
            set finalPos [vecadd $vecLA $movingVector]

            set xx [lindex $finalPos 0]
            set yy [lindex $finalPos 1]
            set zz [lindex $finalPos 2]

            if {[lindex $atomFreeze 4] == ""} {
                set freeze 0
            } else {
                set freeze [lindex $atomFreeze 4]
            }

            puts $file " H [format "%17s" [format "% f" $xx]] [format "%16s" [format "% f" $yy]] [format "%16s" [format "% f" $zz]]"

            $sel delete
            $selHL delete
        }

    }

    puts $file "*\n"

    close $file
}

proc molUP::connectivityFromVMD {selection} {
    if {$selection == "all"} {
        set list [topo getbondlist order]
        set numberAtoms [[atomselect [lindex $molUP::topMolecule 0] all] num]
        set connectivity ""

        for {set index 1} { $index <= $numberAtoms } { incr index } {
            append connectivity " $index"
            
            set a [lsearch -index 0 -all $list "[expr $index -1]"]

            if {$a != ""} {
                foreach b $a {
                    set atom [expr [lindex [lindex $list $b] 1] + 1]
                    set order [lindex [lindex $list $b] 2]

                    append connectivity " $atom $order"
                }
            } else {}
        
        append connectivity "\n"

        }
        
    } else {
        set list [topo -sel $selection getbondlist order]
        set numberAtoms [[atomselect [lindex $molUP::topMolecule 0] all] num]
        set connectivity ""

        for {set index 1} { $index <= $numberAtoms } { incr index } {
            append connectivity " $index"
            
            set a [lsearch -index 0 -all $list "[expr $index -1]"]

            if {$a != ""} {
                foreach b $a {
                    set atom [expr [lindex [lindex $list $b] 1] + 1]
                    set order [lindex [lindex $list $b] 2]

                    append connectivity " $atom $order"
                }
            } else {}
        
        append connectivity "\n"

        }
    }

    return $connectivity
}


proc molUP::convertGaussianInputConnectToVMD {connectivityList} {
    set connectivity {}
    
    set connectivityList [split $connectivityList "\n"]

    foreach line $connectivityList {
        set lineLength [llength $line]
        if {$lineLength > 1} {
            set numberBonds [expr ($lineLength - 1) / 2]
            set atom1 [expr [lindex $line 0] -1]
            for {set index 1} { $index <= $numberBonds } { incr index } {
                set atom2 [expr [lindex $line [expr $index * 2 - 1]] -1]
                set order [lindex $line [expr $index * 2]]
                lappend connectivity [list $atom1 $atom2 $order]
            }
        }
    }
    return $connectivity
}

proc molUP::linkAtoms {} {
    set connectivity [topo getbondlist]
    set molUP::linkAtomsListIndex {}
    set molUP::linkAtomsList {}

    foreach bond $connectivity {

        set layer1 [$molUP::tableLayer get [lindex $bond 0]]
        set layer2 [$molUP::tableLayer get [lindex $bond 1]]

        if {[lindex $layer1 4] == [lindex $layer2 4]} {
            # Do Nothing
        } elseif {[lindex $layer1 4] == "L" && [lindex $layer2 4] == "H"} {
                lappend molUP::linkAtomsListIndex [lindex $bond 0]
                set llAtoms [lindex [::util::bondedsel [lindex $molUP::topMolecule 0] [lindex $bond 0] [lindex $bond 1] -maxdepth 2] 1]
                set llAtomsName [[atomselect [lindex $molUP::topMolecule 0] "index $llAtoms"] get type]
                set Hlist {}
                foreach atom $llAtomsName {
                    set test [string match "H*" $atom]
                    if {$test == 1} {
                        lappend Hlist $atom 
                    } else {}
                }
                if {$Hlist != ""} {
                    set atomNumber [lindex $bond 1]
                    lappend molUP::linkAtomsList "H-[lindex $Hlist 0] [expr $atomNumber + 1]   0.0000"
                } else {
                    set atomNumber [lindex $bond 1]
                    lappend molUP::linkAtomsList "H-H [expr $atomNumber + 1]   0.0000"
                }
        } elseif {[lindex $layer1 4] == "H" && [lindex $layer2 4] == "L"} {
                lappend molUP::linkAtomsListIndex [lindex $bond 1]
                set llAtoms [lindex [::util::bondedsel [lindex $molUP::topMolecule 0] [lindex $bond 1] [lindex $bond 0] -maxdepth 2] 1]
                set llAtomsName [[atomselect [lindex $molUP::topMolecule 0] "index $llAtoms"] get type]
                set Hlist {}
                foreach atom $llAtomsName {
                    set test [string match "H*" $atom]
                    if {$test == 1} {
                        lappend Hlist $atom 
                    } else {}
                }
                if {$Hlist != ""} {
                    set atomNumber [lindex $bond 0]
                    lappend molUP::linkAtomsList "H-[lindex $Hlist 0] [expr $atomNumber + 1]   0.0000"
                } else {
                    set atomNumber [lindex $bond 0]
                    lappend molUP::linkAtomsList "H-H [expr $atomNumber + 1]   0.0000"
                }
        }
    }
}