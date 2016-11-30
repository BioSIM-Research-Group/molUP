package provide gaussianVMD 1.0

#### Load Packages ###################################################
#lappend auto_path /Users/nunomac/Documents/Dropbox/Code/VMDplugins/vmdGame/Final
# Nota o lappned temn de estar no vmdRC


#### INIT ############################################################
namespace eval gaussianVMD:: {
	namespace export gaussianVMD
	
		#### Load Packages				
		package require gui 									1.0
		package require inputFile 								1.0
		package require getStructure							1.0
		package require convertToPDB							1.0
		package require loadMoleculeVMD							1.0
		package require timeControl								1.0
		package require quit									1.0
		package require loadGaussianInputFile					1.0
		package require loadGaussianOutputFileFirstStructure	1.0
		package require loadGaussianOutputFileLastStructure		1.0
		package require applyToStructure						1.0

		package require Tk
		package require tablelist 
	

		#### Program Variables

		## General
		variable version	    	"0.1.1 (alpha)"
        variable topGui         	".gaussianVMD"
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
		variable time0
		variable time1
		variable loadMode						""
		variable selectionModificationType		""
		variable selectionModificationValue		""
		variable atomSelection					"all"

		#### Images
		variable images 		"logo.gif"
		variable imagesNames 	"logo"

}


## Initiate ###
gaussianVMD::loadImages
gaussianVMD::buildGui

