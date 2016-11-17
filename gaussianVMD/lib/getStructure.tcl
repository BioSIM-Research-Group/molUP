package provide getStructure 1.0

### Get the structure from the Gaussian File

proc gaussianVMD::organizeStructureData {} {

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

}


