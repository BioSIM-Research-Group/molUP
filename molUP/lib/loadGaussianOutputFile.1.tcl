package provide loadGaussianOutputFile 2.0 



### This procedure load a gaussian input file and converts it to PDB
proc molUP::loadGaussianOutputFile {option} {
    
	## Clear Structure
	set molUP::structureReadyToLoad {}

    # Get Title, Calculations keywords, Charge and Multiplicity
	molUP::globalInfoOutputFile

	#### Number of Atoms
	set molUP::numberAtoms [molUP::numberAtomsFirstStructure]

	##############################################################
	##############################################################
    #### Get the first Structure
    if {$option == "firstStructure"} {

		## Get the number of columns
		set numberColumns [llength [lindex $molUP::structureGaussian 0]]

		if {$numberColumns == 4} {
			molUP::readSmallModelStructure
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]

		} elseif {$numberColumns > 4} {
			molUP::readOniomStructure
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]

		} else {
			molUP::guiError "The file has a strange structure. The file cannot be openned."

		}

		molUP::createMolecule
		

		##############################################################
		##############################################################
		##### Get the last structure
    } elseif {$option == "lastStructure"} {

		#### Get the coordinates of the last structure
		#### Get line of last structure
		set lineBeforeLastStructure [split [exec grep -n " Number     Number       Type             X           Y           Z" $molUP::path | tail -n 1] ":"]
		set firstLineLastStructure [expr [lindex $lineBeforeLastStructure 0] + 2]
		set lastLineLastStructure [expr $firstLineLastStructure - 1 + $molUP::numberAtoms]

		## Read all information about the last structure
		catch {exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $molUP::path} structureLastGaussian

		#### Organize the structure info
    	set allAtomsLastStructureCoord [split $structureLastGaussian \n]

		## Get the number of columns
		set numberColumns [llength [lindex $molUP::structureGaussian 0]]

		if {$numberColumns == 4} {
			molUP::readSmallModelStructureLastStructure $allAtomsLastStructureCoord
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]
		} elseif {$numberColumns > 4} {
			molUP::readOniomStructureLastStructure $allAtomsLastStructureCoord
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]

		} else {
			molUP::guiError "The file has a strange structure. The file cannot be openned."

		}

		molUP::createMolecule




		##############################################################
		##############################################################
		##### Get optimized structures    
    } elseif {$option == "optimizedStructures"} {

		#### Get the lines of all structures and optimized tag
		set structuresAndOptimized [split [exec grep -n -e "Optimized Parameters" -e " Number     Number       Type             X           Y           Z" $molUP::path] \n]
		
		#### Search for optimized Lines
		set optimizedLines [lsearch -all $structuresAndOptimized "*Optimized Parameters*"]

		#### Evaluate the presence of optimized structures
		if {$optimizedLines != ""} {
			
			#### Create a list with the first line of each optimized structures
			set optimizedStructuresFirstLines {}
			foreach optimizedLine $optimizedLines {
				set optBeforeFirstLine [lindex $structuresAndOptimized [expr $optimizedLine - 1]]
				set optFirstLine [split $optBeforeFirstLine ":"]
				set optFirstLine1 [expr [lindex $optFirstLine 0] + 2]

				lappend optimizedStructuresFirstLines $optFirstLine1
			}

			set numberOfStructures [llength $optimizedStructuresFirstLines]
			set structureNumber 0

			foreach structure $optimizedStructuresFirstLines {
				set firstLineLastStructure $structure
				set lastLineLastStructure [expr $firstLineLastStructure - 1 + $molUP::numberAtoms]
			
				## Read all information about the last structure
				catch {exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $molUP::path} structureLastGaussian
			
				#### Organize the structure info
    			set allAtomsLastStructureCoord [split $structureLastGaussian \n]

				if {$structureNumber == "0"} {
					incr structureNumber
					set numberColumns [llength [lindex $molUP::structureGaussian 0]]

					if {$numberColumns == 4} {
						molUP::readSmallModelStructureLastStructure $allAtomsLastStructureCoord
						variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]
					} elseif {$numberColumns > 4} { 
						molUP::readOniomStructureLastStructure $allAtomsLastStructureCoord
						variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]
					} else {
						molUP::guiError "The file has a strange structure. The file cannot be openned."
					}

					molUP::createMolecule

				} else {
					#### Write the remaining structures
					molUP::readRemainingStructuresOpt $allAtomsLastStructureCoord
				}
		
			}

			
		
		} else {
			#### Put the last structure if no optimized structure was found
			molUP::loadGaussianOutputFile lastStructure
			molUP::guiError "No optimized structure found, therefore the last structure was loaded." "Error"
		}

        




		##############################################################
		##############################################################
		##### Get all structures 
    } elseif {$option == "allStructures"} {
		#### Number of Atoms
		set linesBeforeAllStructures [split [exec grep -n " Number     Number       Type             X           Y           Z" $molUP::path | cut -f1 -d:] \n]
		set firstLinesAllStructures ""
		foreach line $linesBeforeAllStructures {
			lappend firstLinesAllStructures [expr $line + 2]
		}

		set structureNumber 0

		foreach structure $firstLinesAllStructures {
			set firstLineLastStructure $structure
			set lastLineLastStructure [expr $firstLineLastStructure - 1 + $molUP::numberAtoms]

			## Read all information about the last structure
		    catch {exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $molUP::path} structureLastGaussian

			#### Organize the structure info
    		set allAtomsLastStructureCoord [split $structureLastGaussian \n]

			if {$structureNumber == "0"} {
				incr structureNumber
				set numberColumns [llength [lindex $molUP::structureGaussian 0]]

				if {$numberColumns == 4} {
					molUP::readSmallModelStructureLastStructure $allAtomsLastStructureCoord
					variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]
				} elseif {$numberColumns > 4} {
					molUP::readOniomStructureLastStructure $allAtomsLastStructureCoord
					variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]
				} else {
					molUP::guiError "The file has a strange structure. The file cannot be openned."
				}  


				molUP::createMolecule

			} else {
				#### Write the remaining structures
				molUP::readRemainingStructuresOpt $allAtomsLastStructureCoord
			}
		
		}

    } else {}

}
    

proc molUP::globalInfoOutputFile {} {
	    
		#### Get the title line
		set titleFirstLine [exec grep -n -m 6 -e "^ -" $molUP::path | cut -f1 -d:]
		set titleFirstLine1 [expr [lindex $titleFirstLine 4] + 1]
		set titleLastLine1 [expr [lindex $titleFirstLine 5] - 1]
		set molUP::title [exec sed -n "$titleFirstLine1,$titleLastLine1 p" $molUP::path]

		#### Keywords of the calculations
		set keywordFirstLine1 [expr [lindex $titleFirstLine 2] + 1]
		set keywordLastLine1 [expr [lindex $titleFirstLine 3] - 1]
		set molUP::keywordsCalc [exec sed -n "$keywordFirstLine1,$keywordLastLine1 p" $molUP::path]

		#### Get the charge and Multiplicity
		set linesChargesMulti [exec head -n 300 $molUP::path | grep -e "^ Charge ="]
		set linesChargesMultiSplit [split $linesChargesMulti "\n"]
		set molUP::chargesMultip ""
		set i 0
		foreach line $linesChargesMultiSplit {
			set charge [string range $line 9 11]
			set multiplicity [string index $line 28]
			append molUP::chargesMultip $charge " " $multiplicity
			incr $i
		}
}


proc molUP::readRemainingStructuresOpt {allAtomsLastStructureCoord} {
	animate dup top

	set structure {}
	foreach atomCoord $allAtomsLastStructureCoord {
		set coord {}
		lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5

		lappend coord $columnCoord3 $columnCoord4 $columnCoord5
		lappend structure $coord
	}

	[atomselect top all] set {x y z} $structure
	
}

proc molUP::evaluateFreqCalc {} {
	#### Evaluate if a freq calculation was performed
	set freqCalcTrue [catch {exec egrep -m 1 "frequencies" $molUP::path}]
	if {$freqCalcTrue == "0"} {
		molUP::readFreq
	} else {}
}

proc molUP::numberAtomsFirstStructure {} {
	set lineBeforeStructure [split [exec head -n 300 $molUP::path | grep -n " Charge =" | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -m 2 "^ $" $molUP::path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]
	set numberAtoms [expr $lastLineStructure - $firstLineStructure + 1]
	
	#### Grep the initial structure
	catch {exec sed -n "$firstLineStructure,$lastLineStructure p" $molUP::path} molUP::structureGaussian
	set molUP::structureGaussian [split $molUP::structureGaussian \n]

	return $numberAtoms
}


############################################################################
################## First Structure #########################################
############################################################################
proc molUP::readOniomStructure {} {
		set i 0
		set molUP::structureReadyToLoad {}
		set molUP::structureReadyToLoadCharges {}
		set molUP::structureReadyToLoadLayer {}
		set molUP::structureReadyToLoadFreeze {}

		set index 0
    	foreach atom $molUP::structureGaussian {
    		lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
            
			## Atom information
			set atomInfo {}
			set atomInfoCharges {}
			set atomInfoLayer {}
			set atomInfoFreeze {}

    		incr i
			set test [regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol gaussianAtomType charge pdbAtomType resname resid]
    		
			# Trying to get information when no charge information is provided
			if {$test == 0} {
				set test [regexp {(\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol gaussianAtomType pdbAtomType resname resid]
				set charge "0.000000"
			} else {}

			# Trying to get information when no charge and gaussianAtomType information is provided
			if {$test == 0} {
				set test [regexp {(\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol pdbAtomType resname resid]
				set charge "0.000000"
				set gaussianAtomType "X"
			} else {}
            
			## Correction for charge signal
    		if {[string match "*--*" $column0]==1} {
    			set charge [expr $charge * -1] } else {
    		 }
            set charge [format %.6f $charge]
            
			## Add information about atom
			lappend atomInfo [format %.6f $column2] [format %.6f $column3] [format %.6f $column4] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname [scan $resid %i] $column5 $column1 $charge
			
			if {$charge == ""} {
				set charge 0.000000
			}
			lappend atomInfoCharges $index [string trim $gaussianAtomType "-"] $resname [scan $resid %i] [format %.6f $charge]
			lappend atomInfoLayer $index $pdbAtomType $resname [scan $resid %i] $column5
			lappend atomInfoFreeze $index $pdbAtomType $resname [scan $resid %i] $column1
            
			## Add Atom information to structure
			lappend molUP::structureReadyToLoad $atomInfo
			lappend molUP::structureReadyToLoadCharges $atomInfoCharges
			lappend molUP::structureReadyToLoadLayer $atomInfoLayer
			lappend molUP::structureReadyToLoadFreeze $atomInfoFreeze

			incr index
    	}
}

proc molUP::readSmallModelStructure {} {
		set i 0
		set molUP::structureReadyToLoad {}
		set molUP::structureReadyToLoadCharges {}
		set molUP::structureReadyToLoadLayer {}
		set molUP::structureReadyToLoadFreeze {}

		set index 0
    	foreach atom $molUP::structureGaussian {
    		lassign $atom column0 column1 column2 column3
            
			## Atom information
			set atomInfo {}
			set atomInfoCharges {}
			set atomInfoLayer {}
			set atomInfoFreeze {}

    		incr i

			set resname "MOL"
			set resid "1"
			set pdbAtomType $column0
			set gaussianAtomType $column0
			set atomicSymbol $column0
            
			## Add information about atom
    		lappend atomInfo [format %.6f $column1] [format %.6f $column2] [format %.6f $column3] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname $resid
            

			set charge 0.000000
			lappend atomInfoCharges $index [string trim $gaussianAtomType "-"] $resname $resid [format %.6f $charge]
			lappend atomInfoLayer $index $pdbAtomType $resname $resid ""
			lappend atomInfoFreeze $index $pdbAtomType $resname $resid ""

			## Add Atom information to structure
			lappend molUP::structureReadyToLoad $atomInfo
			lappend molUP::structureReadyToLoadCharges $atomInfoCharges
			lappend molUP::structureReadyToLoadLayer $atomInfoLayer
			lappend molUP::structureReadyToLoadFreeze $atomInfoFreeze


			incr index
    	}
}




############################################################################
################### Last Structure #########################################
############################################################################
proc molUP::readOniomStructureLastStructure {lastStructure} {
		set i 0
		set molUP::structureReadyToLoad {}
		set molUP::structureReadyToLoadCharges {}
		set molUP::structureReadyToLoadLayer {}
		set molUP::structureReadyToLoadFreeze {}

		set index 0
    	foreach atom $molUP::structureGaussian coord $lastStructure {
    		lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
			lassign $coord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
            
			## Atom information
			set atomInfo {}
			set atomInfoCharges {}
			set atomInfoLayer {}
			set atomInfoFreeze {}

    		incr i
    		set test [regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol gaussianAtomType charge pdbAtomType resname resid]
    		
			if {$test == 0} {
				regexp {(\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol gaussianAtomType pdbAtomType resname resid
				set charge "0.000000"
			} else {}
            
			## Correction for charge signal
    		if {[string match "*--*" $column0]==1} {
    			set charge [expr $charge * -1] } else {
    		 }
            set charge [format %.6f $charge]
            
			## Add information about atom
    		lappend atomInfo [format %.6f $columnCoord3] [format %.6f $columnCoord4] [format %.6f $columnCoord5] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname [scan $resid %i] $column5 $column1 $charge
            
			if {$charge == ""} {
				set charge 0.000000
			}
			lappend atomInfoCharges $index [string trim $gaussianAtomType "-"] $resname [scan $resid %i] [format %.6f $charge]
			lappend atomInfoLayer $index $pdbAtomType $resname [scan $resid %i] $column5
			lappend atomInfoFreeze $index $pdbAtomType $resname [scan $resid %i] $column1


			## Add Atom information to structure
			lappend molUP::structureReadyToLoad $atomInfo
			lappend molUP::structureReadyToLoadCharges $atomInfoCharges
			lappend molUP::structureReadyToLoadLayer $atomInfoLayer
			lappend molUP::structureReadyToLoadFreeze $atomInfoFreeze

			incr index
    	}
}

proc molUP::readSmallModelStructureLastStructure {lastStructure} {
		set i 0
		set molUP::structureReadyToLoad {}
		set molUP::structureReadyToLoadCharges {}
		set molUP::structureReadyToLoadLayer {}
		set molUP::structureReadyToLoadFreeze {}

		set index 0
    	foreach atom $molUP::structureGaussian coord $lastStructure {
    		lassign $atom column0 column1 column2 column3
			lassign $coord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
            
			## Atom information
			set atomInfo {}
			set atomInfoCharges {}
			set atomInfoLayer {}
			set atomInfoFreeze {}

    		incr i

			set resname "MOL"
			set resid "1"
			set pdbAtomType $column0
			set gaussianAtomType $column0
			set atomicSymbol $column0
            
			## Add information about atom
    		lappend atomInfo [format %.6f $columnCoord3] [format %.6f $columnCoord4] [format %.6f $columnCoord5] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname $resid
            
			set charge 0.000000

			lappend atomInfoCharges $index [string trim $gaussianAtomType "-"] $resname $resid [format %.6f $charge]
			lappend atomInfoLayer $index $pdbAtomType $resname $resid ""
			lappend atomInfoFreeze $index $pdbAtomType $resname $resid ""

			## Add Atom information to structure
			lappend molUP::structureReadyToLoad $atomInfo
			lappend molUP::structureReadyToLoadCharges $atomInfoCharges
			lappend molUP::structureReadyToLoadLayer $atomInfoLayer
			lappend molUP::structureReadyToLoadFreeze $atomInfoFreeze

			incr index
    	}
}