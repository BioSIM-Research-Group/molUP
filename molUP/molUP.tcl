package provide molUP 1.0

#### INIT ############################################################
namespace eval molUP:: {
	namespace export molUP
	
		#### Load Packages				
		package require gui 									1.0
		package require guiBondModif							1.0
		package require guiAngleModif							1.0
		package require guiDihedModif							1.0
		package require guiOpenFile								1.0
		package require guiSaveFile								1.0
		package require guiError								1.0
		package require guiChargeMulti							1.0
		package require guiCalcSetup							1.0
		package require guiCredits								1.0
		package require guiChangelog							1.0
		
		package require inputFile 								1.0
		package require timeControl								1.0
		package require quit									1.0
		package require loadGaussianInputFile					2.0
		package require loadGaussianOutputFile					2.0
		package	require editStructure							1.0
		package require modify									1.0
		package require saveFiles								1.0
		package require readFreq								1.0
		package require energy									1.0
		package require plot									1.0
		package require addAtom									1.0


		package require Tk
		package require tablelist
		package require topotools
		package require balloon
		
		# Theme
		package require gaussianTheme							1.0

		#### Program Variables
		## General
		variable version	    	"0.2.1"

		#GUI
        variable topGui         	".molUP"
		variable bondModif         	".molUP.bondModif"
		variable angleModif        	".molUP.angleModif"
		variable dihedModif        	".molUP.dihedModif"
		variable openFile        	".molUP.openFile"
		variable saveFile        	".molUP.saveFile"
		variable error	        	".molUP.error"
		variable chargeMulti	    ".molUP.chargeMulti"
		variable calcSetup			".molUP.calcSetup"
		variable credits			".molUP.credits"
		variable changelog			".molUP.changelog"

		global path
		variable path 				"/"
		variable fileName			""
		variable fileExtension		""
		variable title 				"molUP is awesome"
		variable actualTitle		"molUP is awesome"
		variable chargesMultip		""
		variable keywordsCalc		"%mem=7000MB\n%NProc=4\n%chk=name.chk\n\n# "
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
		variable connectivityInputFile ""
		variable connectivity ""
		variable parameters ""
		variable openNewFileMode "YES"
		variable tmpFolder ""
		variable structureReadyToLoad {}
		variable structureReadyToLoadCharges {}
		variable structureReadyToLoadLayer {}
		variable structureReadyToLoadFreeze {}
		variable moleculeInfo {}
		variable majorHeight
		variable freqVectorColor 		"1 red"
		variable colorList {{0 blue} {1 red} {2 gray} {3 orange} {4 yellow} {5 tan} {6 silver} {7 green} {8 white} {9 pink} {10 cyan} {11 purple} {12 lime} {13 mauve} {14 ochre} {15 iceblue} {16 black} {17 yellow2} {18 yellow3} {19 green2} {20 green3} {21 cyan2} {22 cyan3} {23 blue2} {24 blue3} {25 violet} {26 violet2} {27 magenta} {28 magenta2} {29 red2} {30 red3} {31 orange1} {32 orange3}}
		variable pathsFreq {}
		variable vectorThreshold 0
		variable saveAdvancedOptions "All"
		variable atomSelectionSave "all"


		variable chargeAll	0
		variable chargeHL	0
		variable chargeML	0
		variable chargeLL	0
		variable multiplicityValue		1
		variable multiplicityValue1		1
		variable multiplicityValue2		1
		
}

proc molUP::start {} {
	if {[winfo exists $::molUP::topGui]} {wm deiconify $::molUP::topGui ;return $::molUP::topGui}

	molUP::buildGui
	update
	return $::molUP::topGui
}

## Initiate ###
#molUP::buildGui