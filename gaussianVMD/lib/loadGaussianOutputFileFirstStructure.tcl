package provide loadGaussianOutputFileFirstStructure 1.0

### This procedure load a gaussian input file and converts it to PDB
proc gaussianVMD::loadGaussianOutputFileFirstStructure {} {
    
    #### Get the title line
	set gaussianVMD::title [exec sed -n "/^ ----------------------------$/,/^ ----------------------------$/{/^ ----------------------------$/b;/^ ----------------------------$/b;p}" $gaussianVMD::path]

	#### Keywords of the calculations
	set gaussianVMD::keywordsCalc [exec sed -n "/^ ----------------------------------------------------------------------$/,/^ ----------------------------------------------------------------------$/{/^ ----------------------------------------------------------------------$/b;/^ ----------------------------------------------------------------------$/b;p}" $gaussianVMD::path]

	#### Get the charge and Multiplicity
	set linesChargesMulti [exec grep "^ Charge =" $gaussianVMD::path]
	set linesChargesMultiSplit [split $linesChargesMulti "\n"]
	set gaussianVMD::chargesMultip ""
	set i 0
	foreach line $linesChargesMultiSplit {
		set charge [string range $line 9 11]
		set multiplicity [string index $line 28]
		append gaussianVMD::chargesMultip $charge " " $multiplicity
		incr $i
	}

    #### Number of Atoms
	set lineBeforeStructure [split [exec grep -n " Charge =" $gaussianVMD::path | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -B 1 "^ $" $gaussianVMD::path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]

	#### Grep the initial structure
	set gaussianVMD::structureGaussian [exec sed -n "$firstLineStructure,$lastLineStructure p" $gaussianVMD::path]

	#### Organize the structure info
    set allAtoms [split $gaussianVMD::structureGaussian \n]
	foreach atom $allAtoms {
		lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
		for {set i 0} {$i < 9} {incr i} {
			lappend [subst columns$i] [subst $[subst column$i]]
		}

	    #### Condition to distinguish between ONIOM and simple calculations
		if {$column5 != ""} {

			if {[string match "*--*" $column0]==1} {

				regexp {(\S+)[-](\S+)[-][-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
					 atomicSymbol gaussianAtomType charge pdbAtomType resname resid
					lappend gaussianVMD::atomicSymbolList 			$atomicSymbol
					lappend gaussianVMD::gaussianAtomTypeList		$gaussianAtomType
					lappend gaussianVMD::pdbAtomTypeList	 		$pdbAtomType
					lappend gaussianVMD::resnameList		 		$resname
					lappend gaussianVMD::residList		 			$resid
					lappend gaussianVMD::chargeList 				-$charge
					lappend gaussianVMD::freezeList					$column1
					lappend gaussianVMD::xxList						$column2			
					lappend gaussianVMD::yyList						$column3
					lappend gaussianVMD::zzList						$column4
					lappend gaussianVMD::atomDesigList				$column5
					lappend gaussianVMD::linkAtomList				$column6
					lappend gaussianVMD::linkAtomNumbList			$column7
					lappend gaussianVMD::linkAtomValueList			$column8	

			} else {
					regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
					 atomicSymbol gaussianAtomType charge pdbAtomType resname resid
					lappend gaussianVMD::atomicSymbolList 			$atomicSymbol
					lappend gaussianVMD::gaussianAtomTypeList		$gaussianAtomType
					lappend gaussianVMD::pdbAtomTypeList	 		$pdbAtomType
					lappend gaussianVMD::resnameList		 		$resname
					lappend gaussianVMD::residList		 			$resid
					lappend gaussianVMD::chargeList 				$charge
					lappend gaussianVMD::freezeList					$column1
					lappend gaussianVMD::xxList						$column2			
					lappend gaussianVMD::yyList						$column3
					lappend gaussianVMD::zzList						$column4
					lappend gaussianVMD::atomDesigList				$column5
					lappend gaussianVMD::linkAtomList				$column6
					lappend gaussianVMD::linkAtomNumbList			$column7
					lappend gaussianVMD::linkAtomValueList			$column8
			}
		} else {

			lappend gaussianVMD::atomicSymbolList 			$column0
			lappend gaussianVMD::xxList						$column1			
			lappend gaussianVMD::yyList						$column2
			lappend gaussianVMD::zzList						$column3
			lappend gaussianVMD::gaussianAtomTypeList		""
			lappend gaussianVMD::pdbAtomTypeList	 		""
			lappend gaussianVMD::resnameList		 		""
			lappend gaussianVMD::residList		 			""
			lappend gaussianVMD::chargeList 				""
			lappend gaussianVMD::freezeList					""
			lappend gaussianVMD::atomDesigList				""
			lappend gaussianVMD::linkAtomList				""
			lappend gaussianVMD::linkAtomNumbList			""
			lappend gaussianVMD::linkAtomValueList			""
		}
	}

	#### Convert the information to a PDB file
    set gaussianVMD::numberAtoms [llength $gaussianVMD::atomicSymbolList]

	## Create a temporary folder
	exec mkdir -p .temporary

	## Set actual time
	set gaussianVMD::actualTime [clock seconds]

	## Create a temporary file PDB
	set gaussianVMD::temporaryPDBFile [open ".temporary/[subst $gaussianVMD::fileName]_[subst $gaussianVMD::actualTime].pdb" w]

	## Add a header to the file
	puts $gaussianVMD::temporaryPDBFile "HEADER\n $gaussianVMD::title"

	## Add the structure to the file
	for {set i 0} {$i < $gaussianVMD::numberAtoms} {incr i} {
	  	
	  	set xx [regexp {(\S+)\.+(\S+)} [lindex $gaussianVMD::xxList $i] -> xbefore xafter]
	    set x $xbefore\.[format %.3s $xafter]
	    set yy [regexp {(\S+)\.+(\S+)} [lindex $gaussianVMD::yyList $i] -> ybefore yafter]
	    set y $ybefore\.[format %.3s $yafter]
	    set zz [regexp {(\S+)\.+(\S+)} [lindex $gaussianVMD::zzList $i] -> zbefore zafter]
	    set z $zbefore\.[format %.3s $zafter]


	   	puts $gaussianVMD::temporaryPDBFile "[format %-4s "ATOM"] [format %6s [expr $i + 1]] [format %-4s [lindex $gaussianVMD::pdbAtomTypeList $i]][format %4s [lindex $gaussianVMD::resnameList $i]] [format %-1s [lindex $gaussianVMD::atomDesigList $i]] [format %-7s [lindex $gaussianVMD::residList $i]] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s [lindex $gaussianVMD::atomicSymbolList $i]]"

	   	$gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer insert end [list \
	   	"[expr $i + 1]" \
	   	"[lindex $gaussianVMD::pdbAtomTypeList $i]" \
	   	"[lindex $gaussianVMD::resnameList $i]" \
	   	"[lindex $gaussianVMD::residList $i]" \
	   	"[lindex $gaussianVMD::chargeList $i]"\
	   	]

	   	$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer insert end [list \
	   	"[expr $i + 1]" \
	   	"[lindex $gaussianVMD::pdbAtomTypeList $i]" \
	   	"[lindex $gaussianVMD::resnameList $i]" \
	   	"[lindex $gaussianVMD::residList $i]" \
	   	"[lindex $gaussianVMD::atomDesigList $i]"\
	   	]

	   	$gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer insert end [list \
	   	"[expr $i + 1]" \
	   	"[lindex $gaussianVMD::pdbAtomTypeList $i]" \
	   	"[lindex $gaussianVMD::resnameList $i]" \
	   	"[lindex $gaussianVMD::residList $i]" \
	   	"[lindex $gaussianVMD::freezeList $i]"\
	   	]

	   	$gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer insert end [list \
	   	"[expr $i + 1]" \
	   	"[lindex $gaussianVMD::pdbAtomTypeList $i]" \
	   	"[lindex $gaussianVMD::resnameList $i]" \
	   	"[lindex $gaussianVMD::residList $i]" \
	   	"[lindex $gaussianVMD::xxList $i]" \
	   	"[lindex $gaussianVMD::yyList $i]" \
	   	"[lindex $gaussianVMD::zzList $i]"\
	   	]
	  }

	  ## Add a footer to the file
	  puts $gaussianVMD::temporaryPDBFile "END"

    #### Close the temporary file
	  close $gaussianVMD::temporaryPDBFile
}
    
