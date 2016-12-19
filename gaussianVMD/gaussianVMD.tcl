package provide gaussianVMD 1.0

#### Load Packages ###################################################
#lappend auto_path /Users/nunomac/Documents/Dropbox/Code/VMDplugins/vmdGame/Final
# Nota o lappned temn de estar no vmdRC


#### INIT ############################################################
namespace eval gaussianVMD:: {
	namespace export gaussianVMD
	
		#### Load Packages				
		package require gui 									1.0
		package require guiBondModif							1.0
		
		package require inputFile 								1.0
		package require getStructure							1.0
		package require convertToPDB							1.0
		package require loadMoleculeVMD							1.0
		package require timeControl								1.0
		package require quit									1.0
		package require loadGaussianInputFile					1.0
		package require loadGaussianOutputFile					1.0
		package require loadGaussianOutputFileFirstStructure	1.0
		package require loadGaussianOutputFileLastStructure		1.0
		package require applyToStructure						1.0
		package	require editStructure							1.0
		package require modify									1.0


		package require Tk
		package require tablelist 
		package require Thread
	

		#### Program Variables

		## General
		variable version	    	"0.1.5 (alpha)"
        variable topGui         	".gaussianVMD"
		variable bondModif         	".gaussianVMD.bondModif"
		global path
		variable path 				"/"
		variable fileName			""
		variable fileExtension		""
		variable title 				"Gaussian for VMD is a very good plugin :)"
		variable chargesMultip		""
		variable keywordsCalc		"# "
		variable structureGaussian	""
		variable loadingProgress	"0.0"
		variable atomicSymbolList 		
		variable gaussianAtomTypeList	
		variable pdbAtomTypeList	 	
		variable resnameList		 	
		variable residList		 		
		variable chargeList 			
		variable freezeList				
		variable xxList					
		variable yyList					
		variable zzList					
		variable atomDesigList			
		variable linkAtomList			
		variable linkAtomNumbList	
		variable linkAtomValueList
		variable numberAtoms
		variable numberStructures
		variable actualTime
		variable temporaryPDBFile
		variable temporaryXYZFile
		variable time0
		variable time1
		variable loadMode						""
		variable selectionModificationType		""
		variable selectionModificationValueOniom		""
		variable selectionModificationValueFreeze		""
		variable atomSelectionONIOM				"none"
		variable atomSelectionFreeze			"none"
		variable HLrep		"0"
		variable MLrep		"0"
		variable LLrep		"0"
		variable unfreezeRep	"0"
		variable freezeRep		"0"
		variable allRep			"1"
		variable proteinRep		"0"
		variable nonproteinRep	"0"
		variable waterRep		"0"
		variable pickedAtoms	{}
		variable atom1BondSel	"none"
		variable atom2BondSel	"none"
		variable atom1BondOpt	"Fixed Atom"
		variable atom2BondOpt	"Move Atom"
		variable BondDistance	"0.01"
		variable initialBondDistance	"0.01"

		#### Images
		variable images 		"logo.gif bondEdit.gif angleEdit.gif dihedralEdit.gif energyProfile.gif savePDB.gif saveGaussian.gif"
		variable imagesNames 	"logo bondEdit angleEdit dihedralEdit energyProfile savePDB saveGaussian"
		


}


## Initiate ###
gaussianVMD::loadImages
gaussianVMD::buildGui

