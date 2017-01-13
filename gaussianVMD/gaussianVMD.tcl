package provide gaussianVMD 1.0

#### Load Packages ###################################################
# Nota o lappned temn de estar no vmdRC


#### INIT ############################################################
namespace eval gaussianVMD:: {
	namespace export gaussianVMD
	
		#### Load Packages				
		package require gui 									1.0
		package require guiBondModif							1.0
		package require guiAngleModif							1.0
		package require guiDihedModif							1.0
		package require guiOpenFile								1.0
		package require guiSaveFile								1.0
		package require guiError								1.0
		package require guiChargeMulti							1.0
		
		package require inputFile 								1.0
		package require getStructure							1.0
		package require loadMoleculeVMD							1.0
		package require timeControl								1.0
		package require quit									1.0
		package require loadGaussianInputFile					1.0
		package require loadGaussianOutputFile					1.0
		package	require editStructure							1.0
		package require modify									1.0
		package require saveFiles								1.0

		package require Tk
		package require tablelist

		# Theme
		package require ttk::theme::clearlooks					0.1

		#### Program Variables

		## General
		variable version	    	"0.3 (beta)"

		#GUI
        variable topGui         	".gaussianVMD"
		variable bondModif         	".gaussianVMD.bondModif"
		variable angleModif        	".gaussianVMD.angleModif"
		variable dihedModif        	".gaussianVMD.dihedModif"
		variable openFile        	".gaussianVMD.openFile"
		variable saveFile        	".gaussianVMD.saveFile"
		variable error	        	".gaussianVMD.error"
		variable chargeMulti	    ".gaussianVMD.chargeMulti"

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
		variable showNegChargedResidues	"0"
		variable showPosChargedResidues	"0"
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
		variable atom1AngleSel	"none"
		variable atom2AngleSel	"none"
		variable atom3AngleSel	"none"
		variable atom1AngleOpt	"Fixed Atom"
		variable atom2AngleOpt	""
		variable atom3AngleOpt	"Move Atom"
		variable atom1DihedSel	"none"
		variable atom2DihedSel	"none"
		variable atom3DihedSel	"none"
		variable atom4DihedSel	"none"
		variable atom1DihedOpt	"Fixed Atom"
		variable atom2DihedOpt	""
		variable atom3DihedOpt	""
		variable atom4DihedOpt	"Move Atom"
		variable BondDistance			"0.01"
		variable initialBondDistance	"0.01"
		variable AngleValue				"0.00"
		variable initialAngleValue		"0.00"
		variable DihedValue				"0.00"
		variable initialDihedValue		"0.00"
		variable initialSelection {}
		variable initialSelectionX {}
		variable initialSelectionY {}
		variable initialSelectionZ {}
		variable pos1
		variable pos2
		variable pos3
		variable pos4
		variable normvec
		variable linkAtomsList		{}
		variable linkAtomsListIndex	{}
		variable saveOptions	"Gaussian Input File (.com)"

		variable chargeAll	0
		variable chargeHL	0
		variable chargeML	0
		variable chargeLL	0
		variable multiplicityValue	1

		#### Images
		#variable images 		"logo.gif"
		#variable imagesNames 	"logo"
		


}


## Initiate ###
#gaussianVMD::loadImages
gaussianVMD::buildGui

