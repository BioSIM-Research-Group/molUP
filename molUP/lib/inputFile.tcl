package provide inputFile 1.0

#### Browse a file in the system and get the path
proc molUP::onSelect {} {
    set fileTypes {
            {{Gaussian Input (.com)}       {.com}        }
            {{Gaussian Output (.log)}       {.log}        }
    }
    set molUP::path [tk_getOpenFile -filetypes $fileTypes] 
    return $molUP::path
}

#### Get the filename
proc molUP::rootName {path} {
	set tailName [file tail $molUP::path]
	set molUP::fileName [file rootname $tailName]
	return $molUP::fileName
}

#### Get the file extension
proc molUP::fileExtension {path} {
	set tailName [file tail $path]
	set molUP::fileExtension [file extension $tailName]
	return $molUP::fileExtension
}

#### Open the file
proc molUP::loadButton {fileExtension} {
	molUP::fileExtension $molUP::path
	molUP::rootName $molUP::path

	#### Open a .com file
	if {$molUP::fileExtension == ".com"} {
		molUP::loadGaussianInputFile

	#### Open a .log file
	} elseif {$molUP::fileExtension == ".log"} {
		set molUP::loadMode [$molUP::openFile.frame.back.selectLoadMode get]

		if {$molUP::loadMode == "Last Structure"} {
			molUP::loadGaussianOutputFile lastStructure

		} elseif {$molUP::loadMode == "First Structure"} {
			molUP::loadGaussianOutputFile firstStructure
	
		} elseif {$molUP::loadMode == "All optimized structures"} {
			molUP::loadGaussianOutputFile optimizedStructures

		} elseif {$molUP::loadMode == "All structures (may take a long time to load)"} {
			molUP::loadGaussianOutputFile allStructures

		} else {
				set alert [tk_messageBox -message "Please select which structure you want to load." -type ok -icon info]
		}

	#### Display an error when another type of file is loaded
	} else {
		set alert [tk_messageBox -message "Oops!\nThe file is not supported.\nYou can only load .com or .log files (Gaussian)." -type ok -icon question]
	}

	destroy $molUP::openFile

}

#### Get Blank Lines Numbers
proc molUP::getBlankLines {path numberLine} {
	catch {exec egrep -n -e "^ \+$" -e "^$" $path} blankLines
	set eachBlankLine [split $blankLines ":"]
	set lineNumber [lindex $eachBlankLine $numberLine]
	return $lineNumber
}