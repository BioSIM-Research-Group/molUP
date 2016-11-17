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
		gaussianVMD::loadMolecule $gaussianVMD::fileName $gaussianVMD::actualTime

	#### Open a .log file
	} elseif {$gaussianVMD::fileExtension == ".log"} {
		set gaussianVMD::loadMode [$gaussianVMD::topGui.frame1.selectLoadMode get]

		if {$gaussianVMD::loadMode == "Last Structure"} {
			gaussianVMD::loadGaussianOutputFile $gaussianVMD::path
			gaussianVMD::loadGaussianOutputFileLastStructure $gaussianVMD::path
			gaussianVMD::loadMolecule $gaussianVMD::fileName $gaussianVMD::actualTime

		} elseif {$gaussianVMD::loadMode == "First Structure"} {
			gaussianVMD::loadGaussianOutputFile $gaussianVMD::path
			gaussianVMD::loadGaussianOutputFileInitialStructure $gaussianVMD::path
			gaussianVMD::loadMolecule $gaussianVMD::fileName $gaussianVMD::actualTime
			
		} elseif {$gaussianVMD::loadMode == "All optimized structures"} {


		} elseif {$gaussianVMD::loadMode == "All structures (may take a long time to load)"} {
			gaussianVMD::loadGaussianOutputFile $gaussianVMD::path
			gaussianVMD::loadGaussianOutputFileAllStructures $gaussianVMD::path
			gaussianVMD::loadMolecule $gaussianVMD::fileName $gaussianVMD::actualTime

		} else {
				set alert [tk_messageBox -message "Please select which structure you want to load." -type ok -icon info]
		}

	#### Display an error when another type of file is loaded
	} else {
		set alert [tk_messageBox -message "Oops!\nThe file is not supported.\nYou can only load .com or .log files (Gaussian)." -type ok -icon question]
	}
}





#### Get Blank Lines Numbers
proc gaussianVMD::getBlankLines {path numberLine} {
	set blankLines [exec grep -n "^$" $path]
	set eachBlankLine [split $blankLines ":"]
	set lineNumber [lindex $eachBlankLine $numberLine]
	return $lineNumber
}


#### Load a Gaussian ouput file
proc gaussianVMD::loadGaussianOutputFile {path} {
	#### Get the title line
	set gaussianVMD::title [exec sed -n "/^ ----------------------------$/,/^ ----------------------------$/{/^ ----------------------------$/b;/^ ----------------------------$/b;p}" $path]

	#### Keywords of the calculations
	set gaussianVMD::keywordsCalc [exec sed -n "/^ ----------------------------------------------------------------------$/,/^ ----------------------------------------------------------------------$/{/^ ----------------------------------------------------------------------$/b;/^ ----------------------------------------------------------------------$/b;p}" $path]

	#### Get the charge and Multiplicity
	set linesChargesMulti [exec grep "^ Charge =" $path]
	set linesChargesMultiSplit [split $linesChargesMulti "\n"]
	set gaussianVMD::chargesMultip ""
	set i 0
	foreach line $linesChargesMultiSplit {
		set charge [string range $line 9 11]
		set multiplicity [string index $line 28]
		append gaussianVMD::chargesMultip $charge " " $multiplicity
		incr $i
	}
}


#### Load all structure of the Output file
proc gaussianVMD::loadGaussianOutputFileAllStructures {path} {
	#### Number of Atoms
	set lineBeforeStructure [split [exec grep -n " Charge =" $path | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -B 1 "^ $" $path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]

	#### Grep the initial structure
	set gaussianVMD::structureGaussian [exec sed -n "$firstLineStructure,$lastLineStructure p" $path]

	#### Get Information about the structure of the system
	gaussianVMD::organizeStructureData

	#### Convert the file to PDB
	gaussianVMD::convertToPDB

	#### Get the remaining spatial coordinates from the output file
	set gaussianVMD::numberAtoms [expr $lastLineStructure - $firstLineStructure + 1]
	set lineIntiateAllStructures [exec egrep -n " Number     Number       Type             X           Y           Z" $path | cut -f1 -d:]
	set gaussianVMD::numberStructures [llength $lineIntiateAllStructures]

	for {set i 1} { $i <= $gaussianVMD::numberStructures } { incr i } {
		#### Clean the coordinates lists
		set gaussianVMD::xxList ""
		set gaussianVMD::yyList ""
		set gaussianVMD::zzList ""

		#### Get the spatial coordinates
		set firstLineStructure [expr [lindex $lineIntiateAllStructures $i] + 2]
		set lastLineStructure [expr $firstLineStructure + $gaussianVMD::numberAtoms]
		set coordinatesStructure [exec sed -n "$firstLineStructure,$lastLineStructure p" $path]
		set allAtoms [split $coordinatesStructure \n]
		foreach atom $allAtoms {
			lassign $atom column0 column1 column2 columnxx columnyy columnzz	
			lappend gaussianVMD::xxList $columnxx
			lappend gaussianVMD::yyList $columnyy
			lappend gaussianVMD::zzList $columnzz
		}

		#### Convert to a PDB file
		gaussianVMD::convertToPDBMultiStructures
	}
}

#### Load the first structure of a output file
proc gaussianVMD::loadGaussianOutputFileInitialStructure {path} {
	#### Number of Atoms
	set lineBeforeStructure [split [exec grep -n " Charge =" $path | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -B 1 "^ $" $path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]

	#### Grep the initial structure
	set gaussianVMD::structureGaussian [exec sed -n "$firstLineStructure,$lastLineStructure p" $path]

	#### Get Information about the structure of the system
	gaussianVMD::organizeStructureData

	#### Convert the file to PDB
	gaussianVMD::convertToPDB

}

#### Load the last structure of a PDB file
proc gaussianVMD::loadGaussianOutputFileLastStructure {path} {
	#### Number of Atoms
	set lineBeforeStructure [split [exec grep -n " Charge =" $path | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -B 1 "^ $" $path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]

	#### Grep the initial structure
	set gaussianVMD::structureGaussian [exec sed -n "$firstLineStructure,$lastLineStructure p" $path]

	#### Get Information about the structure of the system
	gaussianVMD::organizeStructureData

	#### Get the last spatial coordinates from the output file
	set gaussianVMD::numberAtoms [expr $lastLineStructure - $firstLineStructure + 1]
	set lineIntiateAllStructures [exec egrep -n " Number     Number       Type             X           Y           Z" $path | cut -f1 -d:]
	set gaussianVMD::numberStructures [llength $lineIntiateAllStructures]

	#### Clean the coordinates lists
	set gaussianVMD::xxList ""
	set gaussianVMD::yyList ""
	set gaussianVMD::zzList ""

	#### Get the spatial coordinates
	set firstLineStructure [expr [lindex $lineIntiateAllStructures $gaussianVMD::numberStructures] + 2]
	set lastLineStructure [expr $firstLineStructure + $gaussianVMD::numberAtoms]
	set coordinatesStructure [exec sed -n "$firstLineStructure,$lastLineStructure p" $path]
	set allAtoms [split $coordinatesStructure \n]
	foreach atom $allAtoms {
		lassign $atom column0 column1 column2 columnxx columnyy columnzz	
		lappend gaussianVMD::xxList $columnxx
		lappend gaussianVMD::yyList $columnyy
		lappend gaussianVMD::zzList $columnzz
	}

	#### Convert to a PDB file
	gaussianVMD::convertToPDBLastStructure

}
