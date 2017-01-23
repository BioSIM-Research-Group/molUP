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

	## Set actual time
	set gaussianVMD::actualTime [clock seconds]

	## Create a temporary folder
	catch {exec mktemp -d} gaussianVMD::tmpFolder
	exec mkdir -p $gaussianVMD::tmpFolder/[subst $gaussianVMD::actualTime]


	## Create a temporary file PDB
	set gaussianVMD::temporaryPDBFile [open "$gaussianVMD::tmpFolder/[subst $gaussianVMD::actualTime]/[subst $gaussianVMD::fileName].pdb" w]

	## Add a header to the file
	puts $gaussianVMD::temporaryPDBFile "HEADER\n $gaussianVMD::title"

    #### Organize the structure info
    set allAtoms [split $gaussianVMD::structureGaussian \n]

	set numberColumns [llength [lindex $allAtoms 0]]

	if {$numberColumns == 4} {

		#### Read an input file that has 4 columns

		set i 0
		foreach atom $allAtoms {
			lassign $atom column0 column1 column2 column3

			incr i

			set resname "XXX"
			set resid "1"
			set pdbAtomType $column0
			set column5 "A"
			set atomicSymbol $column0

			regexp {(\S+)\.+(\S+)} $column1 -> xbefore xafter
		    set x $xbefore\.[format %.3s $xafter]
		    regexp {(\S+)\.+(\S+)} $column2 -> ybefore yafter
		    set y $ybefore\.[format %.3s $yafter]
		    regexp {(\S+)\.+(\S+)} $column3 -> zbefore zafter
		    set z $zbefore\.[format %.3s $zafter]

			puts $gaussianVMD::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s $atomicSymbol]"

			$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer insert end [list \
		   			"$i" \
		   			"$column0" \
		   			"X" \
		   			"0" \
		   			""\
		   			]
				   
				$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer insert end [list \
		   			"$i" \
		   			"$column0" \
		   			"X" \
		   			"0" \
		   			"L"\
		   			]
				   
				$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer insert end [list \
		   			"$i" \
		   			"$column0" \
		   			"X" \
		   			"0" \
		   			"0"\
		   			]

				set atomicSymbol 		""
				set gaussianAtomType 	"" 
				set charge				""
				set pdbAtomType			""
				set resname				""
				set resid				""
				set x					""
				set y					""
				set z					""
				set column0				""
				set column1				""
				set column2				""
				set column3				""
		}

	} elseif {$numberColumns > 4} {
		
		## Create a new molecule
		mol new atoms $gaussianVMD::numberAtoms

		#### Read an input file that has 9 columns

		variable structureList {}

		set i 0
		foreach atom $allAtoms {

				lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8

				set atomInfo {}

		    	#### Condition to distinguish between ONIOM and simple calculations
				incr i
				regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
				atomicSymbol gaussianAtomType charge pdbAtomType resname resid

				if {[string match "*--*" $column0]==1} {
					set charge [expr $charge * -1] } else {
				 }
				set charge [format %.6f $charge]

				lappend atomInfo [format %.6f $column2] [format %.6f $column3] [format %.6f $column4] $atomicSymbol $pdbAtomType $pdbAtomType $resname $resid

				$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer insert end [list \
		   			"$i" \
		   			"[lindex [split $gaussianAtomType "-"] 0]" \
		   			"$resname" \
		   			"$resid" \
		   			"$charge"\
		   			]
				   
				$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer insert end [list \
		   			"$i" \
		   			"$pdbAtomType" \
		   			"$resname" \
		   			"$resid" \
		   			"$column5"\
		   			]
				   
				$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer insert end [list \
		   			"$i" \
		   			"$pdbAtomType" \
		   			"$resname" \
		   			"$resid" \
		   			"$column1"\
		   			]
			
			lappend gaussianVMD::structureList $atomInfo
			
		}

		animate dup top
		[atomselect top all] set {x y z element name type resname resid} $gaussianVMD::structureList
		
		mol selection all
		mol color Name
		mol addrep top

		mol ssrecalc top
		mol bondsrecalc top
		mol reanalyze top
		display resetview

	} else {
		gaussianVMD::guiError "The file has a strange structure. The file cannot be openned."
	}

	
	## Add a footer to the file
	  puts $gaussianVMD::temporaryPDBFile "END"

    #### Close the temporary file
	  close $gaussianVMD::temporaryPDBFile



	## Deactivate the ability to load a new molecule
	set gaussianVMD::openNewFileMode "NO"
}
    