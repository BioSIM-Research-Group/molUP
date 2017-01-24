package provide loadGaussianInputFile 2.0 

### This procedure load a gaussian input file and converts it to PDB
proc gaussianVMD::loadGaussianInputFile {} {
    
    #### Get the title line
	set lineNumberTitle [expr [gaussianVMD::getBlankLines $gaussianVMD::path 0] + 1]
	set gaussianVMD::title [exec sed -n "$lineNumberTitle p" $gaussianVMD::path]

	#### Get the Charge and Multiplicity
	set lineNumberCharge [expr [gaussianVMD::getBlankLines $gaussianVMD::path 1] + 1]
	set gaussianVMD::chargesMultip [exec sed -n "$lineNumberCharge p" $gaussianVMD::path]

	#### Keywords of the calculations
	set lineNumberKeyword [expr [gaussianVMD::getBlankLines $gaussianVMD::path 0] - 1]
	set gaussianVMD::keywordsCalc [exec sed -n "$lineNumberKeyword p" $gaussianVMD::path]

	#### Number of Atoms
	set lineNumberFirst [expr [gaussianVMD::getBlankLines $gaussianVMD::path 1] + 2]
	set lineNumberLast [expr [gaussianVMD::getBlankLines $gaussianVMD::path 2] - 1]
	set gaussianVMD::numberAtoms [expr $lineNumberLast - $lineNumberFirst + 1]
	
	## Get the Initial Structure
	catch {exec sed -n "$lineNumberFirst,$lineNumberLast p" $gaussianVMD::path} gaussianVMD::structureGaussian

	## Get connectivity information about structure
	set lineNumberConnect [expr $lineNumberLast + 1]
	catch {exec sed -n "$lineNumberConnect,$ p" $gaussianVMD::path} gaussianVMD::connectivityInputFile

    #### Organize the structure info
    set gaussianVMD::structureGaussian [split $gaussianVMD::structureGaussian \n]
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


	#### Select top Molecule
	gaussianVMD::getMolinfoList
	gaussianVMD::activateMolecule
}
    