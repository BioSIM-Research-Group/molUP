package provide loadGaussianOutputFile 2.0 



### This procedure load a gaussian input file and converts it to PDB
proc gaussianVMD::loadGaussianOutputFile {option} {
    
	## Clear Structure
	set gaussianVMD::structureReadyToLoad {}

	## Evaluate Freq Calculation
	gaussianVMD::evaluateFreqCalc

    # Get Title, Calculations keywords, Charge and Multiplicity
	gaussianVMD::globalInfoOutputFile

	#### Number of Atoms
	set gaussianVMD::numberAtoms [gaussianVMD::numberAtomsFirstStructure]

	##############################################################
	##############################################################
    #### Get the first Structure
    if {$option == "firstStructure"} {

		## Get the number of columns
		set numberColumns [llength [lindex $gaussianVMD::structureGaussian 0]]

		if {$numberColumns == 4} {
			gaussianVMD::readSmallModelStructure
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]

		} elseif {$numberColumns > 4} {
			gaussianVMD::readOniomStructure
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]

		} else {
			gaussianVMD::guiError "The file has a strange structure. The file cannot be openned."

		}

		#### Load and prepara structure on VMD
		## Create a new Molecule
		mol new atoms $gaussianVMD::numberAtoms
		## Change the name
		mol rename top "[subst $gaussianVMD::fileName]"
		## Create a frame
		animate dup top
		## Add the info
		[atomselect top all] set $gaussianVMD::attributes $gaussianVMD::structureReadyToLoad
		## Create the first representantion
		mol selection all
		mol color Name
		mol addrep top
		## Place connectivity
		mol ssrecalc top
		mol bondsrecalc top
		mol reanalyze top
		display resetview

		#### Add Representations
		gaussianVMD::addSelectionRep	
		




		##############################################################
		##############################################################
		##### Get the last structure
    } elseif {$option == "lastStructure"} {

		#### Get the coordinates of the last structure
		#### Get line of last structure
		set lineBeforeLastStructure [split [exec grep -n " Number     Number       Type             X           Y           Z" $gaussianVMD::path | tail -n 1] ":"]
		set firstLineLastStructure [expr [lindex $lineBeforeLastStructure 0] + 2]
		set lastLineLastStructure [expr $firstLineLastStructure - 1 + $gaussianVMD::numberAtoms]

		## Read all information about the last structure
		catch {exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $gaussianVMD::path} structureLastGaussian

		#### Organize the structure info
    	set allAtomsLastStructureCoord [split $structureLastGaussian \n]

		## Get the number of columns
		set numberColumns [llength [lindex $gaussianVMD::structureGaussian 0]]

		if {$numberColumns == 4} {
			gaussianVMD::readSmallModelStructureLastStructure $allAtomsLastStructureCoord
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]
		} elseif {$numberColumns > 4} {
			gaussianVMD::readOniomStructureLastStructure $allAtomsLastStructureCoord
			variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]

		} else {
			gaussianVMD::guiError "The file has a strange structure. The file cannot be openned."

		}

		#### Load and prepara structure on VMD
		## Create a new Molecule
		mol new atoms $gaussianVMD::numberAtoms
		## Change the name
		mol rename top "[subst $gaussianVMD::fileName]"
		## Create a frame
		animate dup top
		## Add the info
		[atomselect top all] set $gaussianVMD::attributes $gaussianVMD::structureReadyToLoad
		## Create the first representantion
		mol selection all
		mol color Name
		mol addrep top
		## Place connectivity
		mol ssrecalc top
		mol bondsrecalc top
		mol reanalyze top
		display resetview

		#### Add Representations
		gaussianVMD::addSelectionRep




		

		##############################################################
		##############################################################
		##### Get optimized structures    
    } elseif {$option == "optimizedStructures"} {

		#### Get the lines of all structures and optimized tag
		set structuresAndOptimized [split [exec grep -n -e "Optimized Parameters" -e " Number     Number       Type             X           Y           Z" $gaussianVMD::path] \n]
		
		#### Search for optimized Lines
		set optimizedLines [lsearch -all $structuresAndOptimized "*Optimized Parameters*"]

		#### Evaluate the presence of optimized structures
		if {$optimizedLines != ""} {
			
			#### Create a list with the first line of each optimized structures
			set optimizedStructuresFirstLines {}
			foreach optimizedLine $optimizedLines {
				set optBeforeFirstLine [lindex $structuresAndOptimized [expr $optimizedLine + 1]]
				set optFirstLine [split $optBeforeFirstLine ":"]
				set optFirstLine1 [expr [lindex $optFirstLine 0] + 2]

				lappend optimizedStructuresFirstLines $optFirstLine1
			}

			set numberOfStructures [llength $optimizedStructuresFirstLines]
			set structureNumber 0

			foreach structure $optimizedStructuresFirstLines {
				set firstLineLastStructure $structure
				set lastLineLastStructure [expr $firstLineLastStructure - 1 + $gaussianVMD::numberAtoms]
			
				## Read all information about the last structure
				catch {exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $gaussianVMD::path} structureLastGaussian
			
				#### Organize the structure info
    			set allAtomsLastStructureCoord [split $structureLastGaussian \n]

				if {$structureNumber == "0"} {
					incr structureNumber
					set numberColumns [llength [lindex $gaussianVMD::structureGaussian 0]]

					if {$numberColumns == 4} {
						gaussianVMD::readSmallModelStructureLastStructure $allAtomsLastStructureCoord
						variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]
					} elseif {$numberColumns > 4} { 
						gaussianVMD::readOniomStructureLastStructure $allAtomsLastStructureCoord
						variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]
					} else {
						gaussianVMD::guiError "The file has a strange structure. The file cannot be openned."
					}

					#### Load and prepara structure on VMD
					## Create a new Molecule
					mol new atoms $gaussianVMD::numberAtoms
					## Change the name
					mol rename top "[subst $gaussianVMD::fileName]"
					## Create a frame
					animate dup top
					## Add the info
					[atomselect top all] set $gaussianVMD::attributes $gaussianVMD::structureReadyToLoad
					## Create the first representantion
					mol selection all
					mol color Name
					mol addrep top
					## Place connectivity
					mol ssrecalc top
					mol bondsrecalc top
					mol reanalyze top
					display resetview
				
					#### Add Representations
					gaussianVMD::addSelectionRep

				} else {
					#### Write the remaining structures
					gaussianVMD::readRemainingStructuresOpt $allAtomsLastStructureCoord
				}
		
			}

		#### Read Energies
		gaussianVMD::energy
		
		} else {
			#### Put the last structure if no optimized structure was found
			gaussianVMD::loadGaussianOutputFile lastStructure
			gaussianVMD::guiError "No optimized structure found, therefore the last structure was loaded."
		}

        




		##############################################################
		##############################################################
		##### Get all structures 
    } elseif {$option == "allStructures"} {
		#### Number of Atoms
		set linesBeforeAllStructures [split [exec grep -n " Number     Number       Type             X           Y           Z" $gaussianVMD::path | cut -f1 -d:] \n]
		set firstLinesAllStructures ""
		foreach line $linesBeforeAllStructures {
			lappend firstLinesAllStructures [expr $line + 2]
		}

		set structureNumber 0

		foreach structure $firstLinesAllStructures {
			set firstLineLastStructure $structure
			set lastLineLastStructure [expr $firstLineLastStructure - 1 + $gaussianVMD::numberAtoms]

			## Read all information about the last structure
		    catch {exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $gaussianVMD::path} structureLastGaussian

			#### Organize the structure info
    		set allAtomsLastStructureCoord [split $structureLastGaussian \n]

			if {$structureNumber == "0"} {
				incr structureNumber
				set numberColumns [llength [lindex $gaussianVMD::structureGaussian 0]]

				if {$numberColumns == 4} {
					gaussianVMD::readSmallModelStructureLastStructure $allAtomsLastStructureCoord
					variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid"]
				} elseif {$numberColumns > 4} {
					gaussianVMD::readOniomStructureLastStructure $allAtomsLastStructureCoord
					variable attributes [list "x" "y" "z" "element" "name" "type" "resname" "resid" "altloc" "user" "charge"]
				} else {
					gaussianVMD::guiError "The file has a strange structure. The file cannot be openned."
				}  


				#### Load and prepara structure on VMD
				## Create a new Molecule
				mol new atoms $gaussianVMD::numberAtoms
				## Change the name
				mol rename top "[subst $gaussianVMD::fileName]"
				## Create a frame
				animate dup top
				## Add the info
				[atomselect top all] set $gaussianVMD::attributes $gaussianVMD::structureReadyToLoad
				## Create the first representantion
				mol selection all
				mol color Name
				mol addrep top
				## Place connectivity
				mol ssrecalc top
				mol bondsrecalc top
				mol reanalyze top
				display resetview
			
				#### Add Representations
				gaussianVMD::addSelectionRep

			} else {
				#### Write the remaining structures
				gaussianVMD::readRemainingStructuresOpt $allAtomsLastStructureCoord
			}
		
		}

		#### Read Energies
		gaussianVMD::energy

    } else {}

	#### Select top Molecule
	gaussianVMD::getMolinfoList
	gaussianVMD::activateMolecule

}
    

proc gaussianVMD::globalInfoOutputFile {} {
	    
		#### Get the title line
		set titleFirstLine [exec grep -n -m 6 -e "^ -" $gaussianVMD::path | cut -f1 -d:]
		set titleFirstLine1 [expr [lindex $titleFirstLine 4] + 1]
		set titleLastLine1 [expr [lindex $titleFirstLine 5] - 1]
		set gaussianVMD::title [exec sed -n "$titleFirstLine1,$titleLastLine1 p" $gaussianVMD::path]

		#### Keywords of the calculations
		set keywordFirstLine1 [expr [lindex $titleFirstLine 2] + 1]
		set keywordLastLine1 [expr [lindex $titleFirstLine 3] - 1]
		set gaussianVMD::keywordsCalc [exec sed -n "$keywordFirstLine1,$keywordLastLine1 p" $gaussianVMD::path]

		#### Get the charge and Multiplicity
		set linesChargesMulti [exec head -n 300 $gaussianVMD::path | grep -e "^ Charge ="]
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


proc gaussianVMD::readRemainingStructuresOpt {allAtomsLastStructureCoord} {
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

proc gaussianVMD::evaluateFreqCalc {} {
	#### Evaluate if a freq calculation was performed
	set freqCalcTrue [catch {exec grep "frequencies" $gaussianVMD::path}]
	if {$freqCalcTrue == "0"} {
		gaussianVMD::readFreq
	} else {}
}

proc gaussianVMD::numberAtomsFirstStructure {} {
	set lineBeforeStructure [split [exec head -n 300 $gaussianVMD::path | grep -n " Charge =" | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -m 2 "^ $" $gaussianVMD::path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]
	set numberAtoms [expr $lastLineStructure - $firstLineStructure + 1]
	
	#### Grep the initial structure
	catch {exec sed -n "$firstLineStructure,$lastLineStructure p" $gaussianVMD::path} gaussianVMD::structureGaussian
	set gaussianVMD::structureGaussian [split $gaussianVMD::structureGaussian \n]

	return $numberAtoms
}


############################################################################
################## First Structure #########################################
############################################################################
proc gaussianVMD::readOniomStructure {} {
		set i 0
		set gaussianVMD::structureReadyToLoad {}
    	foreach atom $gaussianVMD::structureGaussian {
    		lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
            
			## Atom information
			set atomInfo {}

    		incr i
    		regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol gaussianAtomType charge pdbAtomType resname resid
            
			## Correction for charge signal
    		if {[string match "*--*" $column0]==1} {
    			set charge [expr $charge * -1] } else {
    		 }
            set charge [format %.6f $charge]
            
			## Add information about atom
			lappend atomInfo [format %.6f $column2] [format %.6f $column3] [format %.6f $column4] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname $resid $column5 $column1 $charge
            
			## Add Atom information to structure
			lappend gaussianVMD::structureReadyToLoad $atomInfo
    	}
}

proc gaussianVMD::readSmallModelStructure {} {
		set i 0
		set gaussianVMD::structureReadyToLoad {}
    	foreach atom $gaussianVMD::structureGaussian {
    		lassign $atom column0 column1 column2 column3
            
			## Atom information
			set atomInfo {}

    		incr i

			set resname "XXX"
			set resid "1"
			set pdbAtomType $column0
			set gaussianAtomType $column0
			set atomicSymbol $column0
            
			## Add information about atom
    		lappend atomInfo [format %.6f $column1] [format %.6f $column2] [format %.6f $column3] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname $resid
            
			## Add Atom information to structure
			lappend gaussianVMD::structureReadyToLoad $atomInfo
    	}
}




############################################################################
################### Last Structure #########################################
############################################################################
proc gaussianVMD::readOniomStructureLastStructure {lastStructure} {
		set i 0
		set gaussianVMD::structureReadyToLoad {}
    	foreach atom $gaussianVMD::structureGaussian coord $lastStructure {
    		lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
			lassign $coord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
            
			## Atom information
			set atomInfo {}

    		incr i
    		regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    		atomicSymbol gaussianAtomType charge pdbAtomType resname resid
            
			## Correction for charge signal
    		if {[string match "*--*" $column0]==1} {
    			set charge [expr $charge * -1] } else {
    		 }
            set charge [format %.6f $charge]
            
			## Add information about atom
    		lappend atomInfo [format %.6f $columnCoord3] [format %.6f $columnCoord4] [format %.6f $columnCoord5] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname $resid $column5 $column1 $charge
            
			## Add Atom information to structure
			lappend gaussianVMD::structureReadyToLoad $atomInfo
    	}
}

proc gaussianVMD::readSmallModelStructureLastStructure {lastStructure} {
		set i 0
		set gaussianVMD::structureReadyToLoad {}
    	foreach atom $gaussianVMD::structureGaussian coord $lastStructure {
    		lassign $atom column0 column1 column2 column3
			lassign $coord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
            
			## Atom information
			set atomInfo {}

    		incr i

			set resname "XXX"
			set resid "1"
			set pdbAtomType $column0
			set gaussianAtomType $column0
			set atomicSymbol $column0
            
			## Add information about atom
    		lappend atomInfo [format %.6f $columnCoord3] [format %.6f $columnCoord4] [format %.6f $columnCoord5] $atomicSymbol $pdbAtomType [string trim $gaussianAtomType "-"] $resname $resid
            
			## Add Atom information to structure
			lappend gaussianVMD::structureReadyToLoad $atomInfo
    	}
}