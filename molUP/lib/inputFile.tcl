package provide inputFile 1.0

#### Browse a file in the system and get the path
proc molUP::onSelect {} {
    set fileTypes {
			{{Gaussian Files}       {.log .com}        }
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
		trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
		molUP::loadGaussianInputFile
		molUP::updateStructures
		trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource

	#### Open a .log file
	} elseif {$molUP::fileExtension == ".log"} {
		set molUP::loadMode [$molUP::openFile.frame.back.selectLoadMode get]

		if {$molUP::loadMode == "Last Structure"} {
			trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
			molUP::loadGaussianOutputFile lastStructure
			molUP::getConnectivityFromInputFile
			molUP::updateStructures
			molUP::energyLastStructure
			trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource

		} elseif {$molUP::loadMode == "First Structure"} {
			trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
			molUP::loadGaussianOutputFile firstStructure
			molUP::getConnectivityFromInputFile
			molUP::updateStructures
			trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource

		} elseif {$molUP::loadMode == "All optimized structures"} {
			trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
			molUP::loadGaussianOutputFile optimizedStructures
			molUP::getConnectivityFromInputFile
			molUP::updateStructures
			molUP::firstProcEnergy
			trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource

		} elseif {$molUP::loadMode == "All structures (may take a long time to load)"} {
			trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
			molUP::loadGaussianOutputFile allStructures
			molUP::getConnectivityFromInputFile
			molUP::updateStructures
			molUP::firstProcEnergyAll
			trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource
		} else {
				set alert [tk_messageBox -message "Please select which structure you want to load." -type ok -icon info]
		}

		## Evaluate Freq Calculation
		molUP::evaluateFreqCalc

	#### Display an error when another type of file is loaded
	} else {
		set alert [tk_messageBox -message "Oops!\nThe file is not supported.\nYou can only load .com or .log files (Gaussian)." -type ok -icon question]
	}

	destroy $molUP::openFile

}

#### Get Blank Lines Numbers
proc molUP::getBlankLines {path numberLine} {
	catch {exec egrep -n -m 8 -e "^ \+$" -e "^$" $path} blankLines
	set eachBlankLine [split $blankLines ":"]
	set lineNumber [lindex $eachBlankLine $numberLine]
	return $lineNumber
}

proc molUP::getConnectivityFromInputFile {} {
	set path [join [list [file dirname $molUP::path] "/" $molUP::fileName ".com"] ""]
	set fileExists [file exists $path]

	mol ssrecalc top
	mol bondsrecalc top
	mol reanalyze top

	display resetview

	if {$fileExists == 1} {
		### Add connectivity to VMD
		set molID [molinfo top]

		set firstLine [expr [molUP::getBlankLines $path 2] + 1]
		set lastLine [expr [molUP::getBlankLines $path 3] - 1]
		catch {exec sed -n "$firstLine,$lastLine p" $path} connectivity

		set firstParam [expr [molUP::getBlankLines $path 3] + 1]
		catch {exec sed -n "$firstParam,\$ p" $path} param

		set molUP::connectivityInputFile $connectivity
		set molUP::parameters $param

		set connectList [molUP::convertGaussianInputConnectToVMD $molUP::connectivityInputFile]
		topo clearbonds
		topo setbondlist $connectList

		display resetview

	} else {
		
	}
}