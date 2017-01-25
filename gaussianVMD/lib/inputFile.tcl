package provide inputFile 1.0

#### Browse a file in the system and get the path
proc gaussianVMD::onSelect {} {
    set fileTypes {
            {{Gaussian Input (.com)}       {.com}        }
            {{Gaussian Output (.log)}       {.log}        }
    }
    set gaussianVMD::path [tk_getOpenFile -filetypes $fileTypes] 
    return $gaussianVMD::path
}

#### Get the filename
proc gaussianVMD::rootName {path} {
	set tailName [file tail $gaussianVMD::path]
	set gaussianVMD::fileName [file rootname $tailName]
	return $gaussianVMD::fileName
}

#### Get the file extension
proc gaussianVMD::fileExtension {path} {
	set tailName [file tail $path]
	set gaussianVMD::fileExtension [file extension $tailName]
	return $gaussianVMD::fileExtension
}

#### Open the file
proc gaussianVMD::loadButton {fileExtension} {
	gaussianVMD::fileExtension $gaussianVMD::path
	gaussianVMD::rootName $gaussianVMD::path

	#### Open a .com file
	if {$gaussianVMD::fileExtension == ".com"} {
		gaussianVMD::loadGaussianInputFile

	#### Open a .log file
	} elseif {$gaussianVMD::fileExtension == ".log"} {
		set gaussianVMD::loadMode [$gaussianVMD::openFile.frame.back.selectLoadMode get]

		if {$gaussianVMD::loadMode == "Last Structure"} {
			gaussianVMD::loadGaussianOutputFile lastStructure

		} elseif {$gaussianVMD::loadMode == "First Structure"} {
			gaussianVMD::loadGaussianOutputFile firstStructure
	
		} elseif {$gaussianVMD::loadMode == "All optimized structures"} {
			gaussianVMD::loadGaussianOutputFile optimizedStructures

		} elseif {$gaussianVMD::loadMode == "All structures (may take a long time to load)"} {
			gaussianVMD::loadGaussianOutputFile allStructures

		} else {
				set alert [tk_messageBox -message "Please select which structure you want to load." -type ok -icon info]
		}

	#### Display an error when another type of file is loaded
	} else {
		set alert [tk_messageBox -message "Oops!\nThe file is not supported.\nYou can only load .com or .log files (Gaussian)." -type ok -icon question]
	}

	destroy $gaussianVMD::openFile

}

#### Get Blank Lines Numbers
proc gaussianVMD::getBlankLines {path numberLine} {
	catch {exec egrep -n -e "^ \+$" -e "^$" $path} blankLines
	set eachBlankLine [split $blankLines ":"]
	set lineNumber [lindex $eachBlankLine $numberLine]
	return $lineNumber
}