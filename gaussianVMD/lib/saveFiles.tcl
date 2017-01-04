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
    set layerInfoList [$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer get anchor end]

    ## Get Freeze Info
    set freezeInfoList [$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer get anchor end]
    
    ## Get Charges Info
    set chargesInfoList [$gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer get anchor end]

    ## Write on the file
    foreach atomLayer $layerInfoList atomFreeze $freezeInfoList atomCharge $chargesInfoList atomCoord $allCoord {
        set initialInfo " [string range [lindex $atomCharge 1] 0 0]-[lindex $atomCharge 1]-[lindex $atomCharge 4](PDBName=[lindex $atomLayer 1],Resname=[lindex $atomLayer 2],ResNum=[lindex $atomLayer 3])"
        puts $file "[format %-60s $initialInfo] [format %-4s [lindex $atomFreeze 4]] [format "%10s" [format %-7s [lindex $atomCoord 0]]] [format "%10s" [format %-7s [lindex $atomCoord 1]]] [format "%10s" [format %-7s [lindex $atomCoord 2]]] [format %-2s [lindex $atomLayer 4]]"
    }

    

    close $file

}