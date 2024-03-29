package provide molUP 1.7.1

#### INIT ############################################################
namespace eval molUP:: {
	namespace export molUP
	
		#### Load Packages				
		package require guiMolUP 								1.6.0
		package require guiBondModif							1.5.1
		package require guiAngleModif							1.5.1
		package require guiDihedModif							1.5.1
		package require guiOpenFile								1.5.1
		package require guiSaveFile								1.5.1
		package require guiError								1.5.1
		package require guiChargeMulti							1.5.1
		package require guiCalcSetup							1.5.1
		package require guiCredits								1.5.2
		package require guiChangelog							1.5.1
		package require guiInfo 								1.5.1
		package require guiMethodology							1.5.1
		package require guiBADparam								1.5.1
		package require guiModRedundant							1.5.1
		package require guiOpenMultiFile 						1.5.1
		package require guiDeleteAtoms							1.5.4
		package require guiAddAtoms								1.5.1
		package require guiAddMolecule 							1.5.3
		
		package require inputFile 								1.6.8
		package require timeControl								1.5.1
		package require quit									1.5.1
		package require loadGaussianInputFile					1.6.3
		package require loadGaussianOutputFile					1.6.6
		package	require editStructure							1.5.2
		package require modify									1.5.1
		package require saveFiles								1.7.0
		package require readFreq								1.6.7
		package require energy									1.5.1
		package require plot									1.5.1
		package require addDeleteAtoms							1.5.4
		package require publication								1.5.2
		package require loadPrmtop								1.5.1
		package require loadPrmtopTerminal  					1.7.1
		package require updateChargesFromFile					1.5.2
		package require changeStructureData						1.6.2


		package require Tk
		package require tablelist
		package require topotools
		package require balloon
		
		# Theme
		package require gaussianTheme							1.5.1

		#### Program Variables
		## General
		variable version	    	"1.7.1"

		#GUI
        variable topGui         	".molUP"
		variable bondModif         	".molUP.bondModif"
		variable angleModif        	".molUP.angleModif"
		variable dihedModif        	".molUP.dihedModif"
		variable openFile        	".molUP.openFile"
		variable openMultiFile		".molUP.openMultiFile"
		variable saveFile        	".molUP.saveFile"
		variable error	        	".molUP.error"
		variable chargeMulti	    ".molUP.chargeMulti"
		variable calcSetup			".molUP.calcSetup"
		variable credits			".molUP.credits"
		variable changelog			".molUP.changelog"
		variable citeMolUP			".molUP.publication"
		variable citations			".molUP.citations"
		variable info				".molUP.info"
		variable methodology		".molUP.methodology"
		variable saveKeywordsInput	".molUP.saveKeywordsInput"
		variable modRedundant		".molUP.modRedundant"
		variable deleteAtoms		".molUP.deleteAtoms"
		variable addAtoms			".molUP.addAtoms"
		variable periodicTable		".molUP.addAtoms.periodicTable"
		variable addMolecule		".molUP.addAtoms.addMolecule"
		variable updateCharges		".molUP.updateCharges"

		global path
		variable path 				"/"
		variable fileName			""
		variable fileExtension		""
		variable title 				"molUP is awesome"
		variable actualTitle		"molUP is awesome"
		variable chargesMultip		""
		variable keywordsCalc		"%mem=7000MB\n%NProc=4\n%chk=name.chk\n# "
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
		variable customSelection1		""
		variable customSelection2		""
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
		variable nFreqToRead 5
		variable vectorThreshold 0
		variable saveAdvancedOptions "All"
		variable atomSelectionSave "all"
		variable addAtomElement	"H"
		variable moveAtomPosRectInitial	{}
		variable atomSelectionDeleteAtoms ""


		variable chargeAll	0
		variable chargeHL	0
		variable chargeML	0
		variable chargeLL	0
		variable multiplicityValue		1
		variable multiplicityValue1		1
		variable multiplicityValue2		1

		variable normalTermination	"NO"
		variable stopLine 1


		variable graphicsID ""
    	variable pickedAtomsBAD {}

		## grep, sed, head, cut, and tail
		if {[string first "Windows" $::tcl_platform(os)] != -1} {
			variable sed "$molUPpath/windowsDependencies/sed.exe"
			variable head "$molUPpath/windowsDependencies/head.exe"
			variable cut "$molUPpath/windowsDependencies/cut.exe"
			variable tail "$molUPpath/windowsDependencies/tail.exe"
			variable grep "$molUPpath/windowsDependencies/grep.exe"
		} elseif {[string first "Darwin" $::tcl_platform(os)] != -1} {
			catch {exec ggrep} debug
			if {[string match "*no such file or directory*" $debug] == 1 } {
				puts "ERROR-ERROR-ERROR - molUP - ERROR-ERROR-ERROR\nPlease, install GNU-grep. In Terminal, run the following commands:\n/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\"\nbrew install grep\n\nIf you have already Homebrew installed on your machine, the first command is not required. Simply run:\nbrew install grep"
			}
			catch {exec gsed} debug
			if {[string match "*no such file or directory*" $debug] == 1 } {
				puts "ERROR-ERROR-ERROR - molUP - ERROR-ERROR-ERROR\nPlease, install GNU-grep. In Terminal, run the following commands:\n/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)\"\nbrew install gnu-sed\n\nIf you have already Homebrew installed on your machine, the first command is not required. Simply run:\nbrew install gnu-sed"
			}
			variable sed "gsed"
			variable head "head"
			variable cut "cut"
			variable tail "tail"
			variable grep "ggrep"
		} else {
			variable sed "sed"
			variable head "head"
			variable cut "cut"
			variable tail "tail"
			variable grep "grep"
		}
		
}

proc molUP::start {} {
	encoding system utf-8
	if {[winfo exists $::molUP::topGui]} {
		wm deiconify $::molUP::topGui
		return $::molUP::topGui
		}

	### Reload keywords to color tag text
	molUP::readKeywordsTags

	### Open the GUI
	molUP::buildGui
	update
	return $::molUP::topGui
}
