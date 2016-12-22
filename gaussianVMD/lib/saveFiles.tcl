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

    animate write xyz [list $path.tmp] beg 0 end 0 skip 1 top

    ## Write Header
    puts $file "%mem=4000MB\n%NProc=4"

    ## Write keywords
    puts $file "$gaussianVMD::keywordsCalc\n"

    ## Write title
    puts $file "$gaussianVMD::title\n"

    ## Write Charge and Multi
    puts $file "$gaussianVMD::chargesMultip"

    close $file

}