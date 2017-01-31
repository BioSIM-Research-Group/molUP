package provide loadGaussianInputFile 1.0 

### This procedure load a gaussian input file and converts it to PDB
proc molUP::loadGaussianInputFile {} {
    
    #### Get the title line
	set lineNumberTitle [expr [molUP::getBlankLines $molUP::path 0] + 1]
	set molUP::title [exec sed -n "$lineNumberTitle p" $molUP::path]

	#### Get the Charge and Multiplicity
	set lineNumberCharge [expr [molUP::getBlankLines $molUP::path 1] + 1]
	set molUP::chargesMultip [exec sed -n "$lineNumberCharge p" $molUP::path]

	#### Keywords of the calculations
	set lineNumberKeyword [expr [molUP::getBlankLines $molUP::path 0] - 1]
	set molUP::keywordsCalc [exec sed -n "$lineNumberKeyword p" $molUP::path]

	#### Number of Atoms
	set lineNumberFirst [expr [molUP::getBlankLines $molUP::path 1] + 2]
	set lineNumberLast [expr [molUP::getBlankLines $molUP::path 2] - 1]
	set molUP::numberAtoms [expr $lineNumberLast - $lineNumberFirst + 1]
	
	## Get the Initial Structure
	catch {exec sed -n "$lineNumberFirst,$lineNumberLast p" $molUP::path} molUP::structureGaussian

	## Get connectivity information about structure
	set lineNumberConnect [expr $lineNumberLast + 1]
	catch {exec sed -n "$lineNumberConnect,$ p" $molUP::path} molUP::connectivityInputFile

	## Set actual time
	set molUP::actualTime [clock seconds]

	## Create a temporary folder
	catch {exec mktemp -d} molUP::tmpFolder
	exec mkdir -p $molUP::tmpFolder/[subst $molUP::actualTime]


	## Create a temporary file PDB
	set molUP::temporaryPDBFile [open "$molUP::tmpFolder/[subst $molUP::actualTime]/[subst $molUP::fileName].pdb" w]

	## Add a header to the file
	puts $molUP::temporaryPDBFile "HEADER\n $molUP::title"

    #### Organize the structure info
    set allAtoms [split $molUP::structureGaussian \n]

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

			puts $molUP::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s $atomicSymbol]"

			$molUP::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer insert end [list \
		   			"$i" \
		   			"$column0" \
		   			"X" \
		   			"0" \
		   			""\
		   			]
				   
				$molUP::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer insert end [list \
		   			"$i" \
		   			"$column0" \
		   			"X" \
		   			"0" \
		   			"L"\
		   			]
				   
				$molUP::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer insert end [list \
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
		
		#### Read an input file that has 9 columns

		set i 0
		foreach atom $allAtoms {

				lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8

		    	#### Condition to distinguish between ONIOM and simple calculations
				incr i
				regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
				atomicSymbol gaussianAtomType charge pdbAtomType resname resid

				regexp {(\S+)\.+(\S+)} $column2 -> xbefore xafter
		    	set x $xbefore\.[format %.3s $xafter]
		    	regexp {(\S+)\.+(\S+)} $column3 -> ybefore yafter
		    	set y $ybefore\.[format %.3s $yafter]
		    	regexp {(\S+)\.+(\S+)} $column4 -> zbefore zafter
		    	set z $zbefore\.[format %.3s $zafter]

				if {[string match "*--*" $column0]==1} {
					set charge [expr $charge * -1] } else {
				 }
				set charge [format %.6f $charge]

				puts $molUP::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s $atomicSymbol]"

				$molUP::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer insert end [list \
		   			"$i" \
		   			"[lindex [split $gaussianAtomType "-"] 0]" \
		   			"$resname" \
		   			"$resid" \
		   			"$charge"\
		   			]
				   
				$molUP::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer insert end [list \
		   			"$i" \
		   			"$pdbAtomType" \
		   			"$resname" \
		   			"$resid" \
		   			"$column5"\
		   			]
				   
				$molUP::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer insert end [list \
		   			"$i" \
		   			"$pdbAtomType" \
		   			"$resname" \
		   			"$resid" \
		   			"$column1"\
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
				set column4				""
				set column5				""
				set column6				""
				set column7				""
				set column8				""

		}

	} else {
		molUP::guiError "The file has a strange structure. The file cannot be openned."
	}

	
	## Add a footer to the file
	  puts $molUP::temporaryPDBFile "END"

    #### Close the temporary file
	  close $molUP::temporaryPDBFile



	## Deactivate the ability to load a new molecule
	set molUP::openNewFileMode "NO"
}
    