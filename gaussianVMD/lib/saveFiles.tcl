package provide saveFiles 1.0

proc gaussianVMD::savePDB {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{PDB (.pdb)}       {.pdb}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".pdb"]

        if {$path != ""} {
            animate write pdb [list $path] beg 0 end 0 skip 1 top
        } else {}
    }

    destroy $::gaussianVMD::saveFile
}


proc gaussianVMD::saveXYZ {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{XYZ (.xyz)}       {.xyz}        }
        }
        set path [tk_getSaveFile -filetypes $fileTypes -defaultextension ".xyz"]

        if {$path != ""} {
            animate write xyz [list $path] beg 0 end 0 skip 1 top
        } else {}
    }

    destroy $::gaussianVMD::saveFile
}

proc gaussianVMD::saveGaussian {} {
    
    set molExists [mol list]
    
    if {$molExists == "ERROR) No molecules loaded."} {
        set alert [tk_messageBox -message "No molecules loaded." -type ok -icon error]
    } else {

        set fileTypes {
                {{Gaussian Input File (.com)}       {.com}        }
        }
        set path [tk_getSaveFile -title "Save file as Gaussian Input" -filetypes $fileTypes -defaultextension ".com"]

        if {$path != ""} {
            gaussianVMD::writeGaussianFile $path
        } else {}

    }

    destroy $::gaussianVMD::saveFile

}

proc gaussianVMD::writeGaussianFile {path} {
    ## Create a file 
	set file [open "$path" w]

    #set frameNumber [molinfo top get frame]
    #animate write xyz [list $path.tmp] beg $frameNumber end $frameNumber skip 1 top

    ## Write Header
    puts $file "%mem=4000MB\n%NProc=4"

    ## Write keywords
    puts $file "$gaussianVMD::keywordsCalc\n"

    ## Write title
    puts $file "$gaussianVMD::title\n"

    ## Write Charge and Multi
    puts $file "$gaussianVMD::chargesMultip"

    ## Get coordinates
    set allSelection [atomselect top "all"]
    set allCoord [$allSelection get {x y z}]

    ## Get Layer Info
    set layerInfoList [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer get anchor end]

    ## Get Freeze Info
    set freezeInfoList [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer get anchor end]
    
    ## Get Charges Info
    set chargesInfoList [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer get anchor end]

    ## Add link atoms (hydrogens)
    gaussianVMD::linkAtoms

    ## Write on the file
    set i 0
    foreach atomLayer $layerInfoList atomFreeze $freezeInfoList atomCharge $chargesInfoList atomCoord $allCoord {
        set lookForLinkAtom [lsearch $gaussianVMD::linkAtomsListIndex $i]

        set xx [lindex $atomCoord 0]
        set yy [lindex $atomCoord 1]
        set zz [lindex $atomCoord 2]

        if {$lookForLinkAtom == -1} {
            set initialInfo " [string range [lindex $atomCharge 1] 0 0]-[lindex $atomCharge 1]-[lindex $atomCharge 4](PDBName=[lindex $atomLayer 1],ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s [lindex $atomFreeze 4]] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]"
        } else {
            set linkAtom [lindex $gaussianVMD::linkAtomsList $lookForLinkAtom]

            set initialInfo " [string range [lindex $atomCharge 1] 0 0]-[lindex $atomCharge 1]-[lindex $atomCharge 4](PDBName=[lindex $atomLayer 1],ResName=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
            puts $file "[format %-60s $initialInfo] [format %-4s [lindex $atomFreeze 4]] [format "%10s" [format "% f" $xx]] [format "%10s" [format "% f" $yy]] [format "%10s" [format "% f" $zz]] [format %-2s [lindex $atomLayer 4]]$linkAtom"
        }
    
        incr i
    }


    if {$gaussianVMD::connectivityInputFile == ""} {
        ## Get and write connectivity
        gaussianVMD::connectivity $file
    } else {
        puts $file $gaussianVMD::connectivityInputFile
    }

    close $file

}



proc gaussianVMD::connectivity {file} {
    set connectivity [topo getbondlist order]

    puts $file ""

    set i 0
    puts -nonewline $file " [expr $i + 1]"

    foreach bond $connectivity {
        if {[lindex $bond 0] == $i } {
            puts -nonewline $file " [expr [lindex $bond 1] + 1] [lindex $bond 2]"
        } else {
            while {[lindex $bond 0] != $i} {
                incr i
                puts -nonewline $file "\n [expr $i + 1]"   
            }
        }
    }

    set sel [atomselect top "all"]
    set numberOfAtoms [$sel num]

    if {$numberOfAtoms > $i} {
        incr i
        while {$numberOfAtoms > $i} {
                puts -nonewline $file "\n [expr $i + 1]"
                incr i   
            }
    }
}


proc gaussianVMD::linkAtoms {} {
    set connectivity [topo getbondlist]
    set gaussianVMD::linkAtomsListIndex {}
    set gaussianVMD::linkAtomsList {}

    foreach bond $connectivity {

        set layer1 [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer get [lindex $bond 0]]
        set layer2 [$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer get [lindex $bond 1]]

        if {[lindex $layer1 4] == [lindex $layer2 4]} {
            # Do Nothing
        } elseif {[lindex $layer1 4] == "L" && [lindex $layer2 4] == "H"} {
                lappend gaussianVMD::linkAtomsListIndex [lindex $bond 0]
                set atomSymbol [string range [lindex $layer1 1] 0 0]
                set atomNumber [lindex $bond 1]
                lappend gaussianVMD::linkAtomsList "H-H$atomSymbol [expr $atomNumber + 1]"
        } elseif {[lindex $layer1 4] == "H" && [lindex $layer2 4] == "L"} {
                lappend gaussianVMD::linkAtomsListIndex [lindex $bond 1]
                set atomSymbol [string range [lindex $layer1 1] 0 0]
                set atomNumber [lindex $bond 0]
                lappend gaussianVMD::linkAtomsList "H-H$atomSymbol [expr $atomNumber + 1]"
        }
    }
}