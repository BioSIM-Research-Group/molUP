package provide loadGaussianInputFile 1.0 

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
	set gaussianVMD::structureGaussian [exec sed -n "$lineNumberFirst,$lineNumberLast p" $gaussianVMD::path]


	## Create a temporary folder
	exec mkdir -p .temporary

	## Set actual time
	set gaussianVMD::actualTime [clock seconds]

	## Create a temporary file PDB
	set gaussianVMD::temporaryPDBFile [open ".temporary/[subst $gaussianVMD::fileName]_[subst $gaussianVMD::actualTime].pdb" w]

	## Add a header to the file
	puts $gaussianVMD::temporaryPDBFile "HEADER\n $gaussianVMD::title"

	puts $gaussianVMD::temporaryPDBFile $gaussianVMD::structureGaussian

    #### Organize the structure info
    set allAtoms [split $gaussianVMD::structureGaussian \n]
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
			

			puts $gaussianVMD::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s $atomicSymbol]"
			
			$gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer insert end [list \
	   			"$i" \
	   			"$pdbAtomType" \
	   			"$resname" \
	   			"$resid" \
	   			"$charge"\
	   			]
			   
			$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer insert end [list \
	   			"$i" \
	   			"$pdbAtomType" \
	   			"$resname" \
	   			"$resid" \
	   			"$column5"\
	   			]
	   		
			$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer insert end [list \
	   			"$i" \
	   			"$pdbAtomType" \
	   			"$resname" \
	   			"$resid" \
	   			"$column1"\
	   			]
	   		
			$gaussianVMD::topGui.frame3.tabsAtomList.tab5.frame.tableLayer insert end [list \
	   			"$i" \
	   			"$pdbAtomType" \
	   			"$resname" \
	   			"$resid" \
	   			"$x" \
	   			"$y" \
	   			"$z"\
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
	
	## Add a footer to the file
	  puts $gaussianVMD::temporaryPDBFile "END"

    #### Close the temporary file
	  close $gaussianVMD::temporaryPDBFile
}
    