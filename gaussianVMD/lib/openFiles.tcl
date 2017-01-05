package provide openFiles 1.0

proc gaussianVMD::openFile {} {
    set fileTypes {
                {{Gaussian Input File (.com)}       {.com}        }
                {{Gaussian Output File (.log) - First Structure}       {.log}        }
                {{Gaussian Output File (.log) - Last Structure}       {.log}        }
                {{Gaussian Output File (.log) - All Optimized Structures}       {.log}        }
                {{Gaussian Output File (.log) - All Structures}       {.log}        }
    }

    set path [tk_getOpenFile -filetypes $fileTypes -defaultextension ".pdb"]
}