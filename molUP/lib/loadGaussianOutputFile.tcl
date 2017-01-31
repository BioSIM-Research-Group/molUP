package provide loadGaussianOutputFile 1.0 

### This procedure load a gaussian input file and converts it to PDB
proc molUP::loadGaussianOutputFile {option} {
    
	#### Evaluate if a freq calculation was performed
	
	set freqCalcTrue [catch {exec grep "frequencies" $molUP::path}]

	puts $freqCalcTrue

	if {$freqCalcTrue == "0"} {
		molUP::readFreq

	} else {
		# Do nothing
	}



    # option tells the procedure to get the first, the last, the optimizred or all structures
	molUP::globalInfoOutputFile

	#### Number of Atoms
	set lineBeforeStructure [split [exec head -n 300 $molUP::path | grep -n " Charge =" | tail -n 1] ":"]
	set firstLineStructure [expr [lindex $lineBeforeStructure 0] + 1]
	set lineAfterStructure [split [exec egrep -n -m 2 "^ $" $molUP::path | tail -n 1] ":"]
	set lastLineStructure [expr [lindex $lineAfterStructure 0] - 1]
	set molUP::numberAtoms [expr $lastLineStructure - $firstLineStructure + 1]

	#### Grep the initial structure
	set molUP::structureGaussian [exec sed -n "$firstLineStructure,$lastLineStructure p" $molUP::path]
	
	## Set actual time
	set molUP::actualTime [clock seconds]

	## Create a temporary folder
	catch {exec mktemp -d} molUP::tmpFolder
	exec mkdir -p $molUP::tmpFolder/[subst $molUP::actualTime]

	## Create a temporary file PDB
	set molUP::temporaryPDBFile [open "$molUP::tmpFolder/[subst $molUP::actualTime]/[subst $molUP::fileName].pdb" w]

	## Add a header to the file
	puts $molUP::temporaryPDBFile "HEADER\n $molUP::title"

    ####
    if {$option == "firstStructure"} {

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
		
		#### Load the molecule on VMD
		molUP::loadMolecule $molUP::fileName $molUP::actualTime normal


    } elseif {$option == "lastStructure"} {

		#### Get the coordinates of the last structure
		#### Number of Atoms
		set lineBeforeLastStructure [split [exec grep -n " Number     Number       Type             X           Y           Z" $molUP::path | tail -n 1] ":"]
		set firstLineLastStructure [expr [lindex $lineBeforeLastStructure 0] + 2]
		set lastLineLastStructure [expr $firstLineLastStructure - 1 + $molUP::numberAtoms]

		## Read all information about the last structure
		set structureLastGaussian [exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $molUP::path]

		#### Organize the structure info
    	set allAtomsLastStructureCoord [split $structureLastGaussian \n]


		#### Organize the structure info
        set allAtoms [split $molUP::structureGaussian \n]

		set numberColumns [llength [lindex $allAtoms 0]]

		if {$numberColumns == 4} {

		#### Read an input file that has 4 columns

			foreach atom $allAtoms atomCoord $allAtomsLastStructureCoord {
        
    			lassign $atom column0 column1 column2 column3
				lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
            
    	    	#### Condition to distinguish between ONIOM and simple calculations
    			incr i
            
				set resname "XXX"
				set resid "1"
				set pdbAtomType $column0
				set column5 "A"
				set atomicSymbol $column0

    			regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    	    	set x $xbefore\.[format %.3s $xafter]
    	    	regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    	    	set y $ybefore\.[format %.3s $yafter]
    	    	regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
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
    			set column4				""
    			set column5				""
    			set column6				""
    			set column7				""
    			set column8				""
            
    	}	  



		} elseif {$numberColumns > 4} {
		
		#### Read an input file that has 9 columns

    	set i 0
    	foreach atom $allAtoms atomCoord $allAtomsLastStructureCoord {
        
    			lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
				lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
            
    	    	#### Condition to distinguish between ONIOM and simple calculations
    			incr i
    			regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    			atomicSymbol gaussianAtomType charge pdbAtomType resname resid
            
    			regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    	    	set x $xbefore\.[format %.3s $xafter]
    	    	regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    	    	set y $ybefore\.[format %.3s $yafter]
    	    	regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
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
		
		#### Load the molecule on VMD
		molUP::loadMolecule $molUP::fileName $molUP::actualTime normal

        
    } elseif {$option == "optimizedStructures"} {


		#### Create a temporary file PDB
		set molUP::temporaryXYZFile [open "$molUP::tmpFolder/[subst $molUP::actualTime]/[subst $molUP::fileName].xyz" w]

		#### Get the lines of all structures and optimized tag
		set structuresAndOptimized [split [exec grep -n -e "Optimized Parameters" -e " Number     Number       Type             X           Y           Z" $molUP::path] \n]
		
		#### Search for optimized Lines
		set optimizedLines [lsearch -all $structuresAndOptimized "*Optimized Parameters*"]

		if {$optimizedLines != ""} {
			#### Create a list with the first line of each optimized structures
			set optimizedStructuresFirstLines []
			foreach optimizedLine $optimizedLines {
				set optBeforeFirstLine [lindex $structuresAndOptimized [expr $optimizedLine + 1]]
				set optFirstLine [split $optBeforeFirstLine ":"]
				set optFirstLine1 [expr [lindex $optFirstLine 0] + 2]

				lappend optimizedStructuresFirstLines $optFirstLine1
			}

			set numberOfStructures [llength $optimizedStructuresFirstLines]

			set structureNumber 0

			foreach structure $optimizedStructuresFirstLines {
				set firstLineLastStructure $structure
				set lastLineLastStructure [expr $firstLineLastStructure - 1 + $molUP::numberAtoms]
			
				## Read all information about the last structure
				set structureLastGaussian [exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $molUP::path]
			
				#### Organize the structure info
    			set allAtomsLastStructureCoord [split $structureLastGaussian \n]

				if {$structureNumber == "0"} {
				
				#### Organize the structure info
        		set allAtoms [split $molUP::structureGaussian \n]

				set numberColumns [llength [lindex $allAtoms 0]]

				if {$numberColumns == 4} {

				#### Read an input file that has 4 columns
					set i 0
    			foreach atom $allAtoms atomCoord $allAtomsLastStructureCoord {
				
    					lassign $atom column0 column1 column2 column3
						lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
					
    			    	#### Condition to distinguish between ONIOM and simple calculations
    					incr i
    					
						set resname "XXX"
						set resid "1"
						set pdbAtomType $column0
						set column5 "A"
						set atomicSymbol $column0
					
    					regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    			    	set x $xbefore\.[format %.3s $xafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    			    	set y $ybefore\.[format %.3s $yafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
    			    	set z $zbefore\.[format %.3s $zafter]
					 
					 
    					puts $molUP::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s 	$atomicSymbol]"
					
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
    					set column4				""
    					set column5				""
    					set column6				""
    					set column7				""
    					set column8				""
					
    			}	


				} elseif {$numberColumns > 4} {
		
				#### Read an input file that has 9 columns

    			set i 0
    			foreach atom $allAtoms atomCoord $allAtomsLastStructureCoord {
				
    					lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
						lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
					
    			    	#### Condition to distinguish between ONIOM and simple calculations
    					incr i
    					regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    					atomicSymbol gaussianAtomType charge pdbAtomType resname resid
					
    					regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    			    	set x $xbefore\.[format %.3s $xafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    			    	set y $ybefore\.[format %.3s $yafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
    			    	set z $zbefore\.[format %.3s $zafter]
					
    					if {[string match "*--*" $column0]==1} {
    						set charge [expr $charge * -1] } else {
    					 }
						set charge [format %.6f $charge]
					 
    					puts $molUP::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s 	$atomicSymbol]"
					
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

				  set linesBeforeAllStructures ""
				  set firstLinesAllStructures ""

				  incr structureNumber

			} else {
				#### Write the remaining structures
				set i 0
				
				puts $molUP::temporaryXYZFile "[subst $molUP::numberAtoms]\n[subst $molUP::fileName]"

				foreach atomCoord $allAtomsLastStructureCoord {
					lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5

    				incr i
				
    				regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    			    set x $xbefore\.[format %.3s $xafter]
    			    regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    			    set y $ybefore\.[format %.3s $yafter]
    			    regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
    			    set z $zbefore\.[format %.3s $zafter]

					
					puts $molUP::temporaryXYZFile "[format %2s $columnCoord1] [format %17s $x] [format %17s $y] [format %17s $z]"

				}

			}
		
		}

        #### Close the temporary file
    	  close $molUP::temporaryPDBFile
		  close $molUP::temporaryXYZFile
		

		#### Load the molecule on VMD
		if {$numberOfStructures > 1} {
			molUP::loadMolecule $molUP::fileName $molUP::actualTime allStructures
		} else {
			molUP::loadMolecule $molUP::fileName $molUP::actualTime normal
		}



		} else {
			#### Put the last structure
			molUP::loadGaussianOutputFile lastStructure

		}
		

		#### Read Energies
		molUP::energy
        
    } elseif {$option == "allStructures"} {
        
		## Create a temporary file PDB
		set molUP::temporaryXYZFile [open "$molUP::tmpFolder/[subst $molUP::actualTime]/[subst $molUP::fileName].xyz" w]

		#### Get the coordinates of the last structure
		#### Number of Atoms
		set linesBeforeAllStructures [split [exec grep -n " Number     Number       Type             X           Y           Z" $molUP::path | cut -f1 -d:] \n]
		set firstLinesAllStructures ""
		foreach line $linesBeforeAllStructures {
			lappend firstLinesAllStructures [expr $line + 2]
		}

		set structureNumber 0

		foreach structure $firstLinesAllStructures {
			
			set firstLineLastStructure $structure

			set lastLineLastStructure [expr $firstLineLastStructure - 1 + $molUP::numberAtoms]

			## Read all information about the last structure
			set structureLastGaussian [exec sed -n "$firstLineLastStructure,$lastLineLastStructure p" $molUP::path]

			#### Organize the structure info
    		set allAtomsLastStructureCoord [split $structureLastGaussian \n]


			if {$structureNumber == "0"} {
				
				#### Organize the structure info
        		set allAtoms [split $molUP::structureGaussian \n]

				set numberColumns [llength [lindex $allAtoms 0]]

				if {$numberColumns == 4} {

				#### Read an input file that has 4 columns
				set i 0
    			foreach atom $allAtoms atomCoord $allAtomsLastStructureCoord {
				
    					lassign $atom column0 column1 column2 column3
						lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
					
    			    	#### Condition to distinguish between ONIOM and simple calculations
    					incr i
    					
						set resname "XXX"
						set resid "1"
						set pdbAtomType $column0
						set column5 "A"
						set atomicSymbol $column0
					
    					regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    			    	set x $xbefore\.[format %.3s $xafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    			    	set y $ybefore\.[format %.3s $yafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
    			    	set z $zbefore\.[format %.3s $zafter]
					 
					 
    					puts $molUP::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s 	$atomicSymbol]"
					
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
    					set column4				""
    					set column5				""
    					set column6				""
    					set column7				""
    					set column8				""
					
    			}	


				} elseif {$numberColumns > 4} {
		
				#### Read an input file that has 9 columns


    			set i 0
    			foreach atom $allAtoms atomCoord $allAtomsLastStructureCoord {
				
    					lassign $atom column0 column1 column2 column3 column4 column5 column6 column7 column8
						lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5
					
    			    	#### Condition to distinguish between ONIOM and simple calculations
    					incr i
    					regexp {(\S+)[-](\S+)[-](\S+)[(]PDBName=(\S+),ResName=(\S+),ResNum=(\S+)[)]} $column0 -> \
    					atomicSymbol gaussianAtomType charge pdbAtomType resname resid
					
    					regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    			    	set x $xbefore\.[format %.3s $xafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    			    	set y $ybefore\.[format %.3s $yafter]
    			    	regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
    			    	set z $zbefore\.[format %.3s $zafter]
					
    					if {[string match "*--*" $column0]==1} {
    						set charge [expr $charge * -1] } else {
    					 }
						set charge [format %.6f $charge]
					 
    					puts $molUP::temporaryPDBFile "[format %-4s "ATOM"] [format %6s $i] [format %-4s $pdbAtomType][format %4s $resname] [format %-1s $column5] [format %-7s $resid] [format %7s $x] [format %7s $y] [format %7s $z] [format %5s "1.00"] [format %-8s "00.00"] [format %8s 	$atomicSymbol]"
					
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

				  set linesBeforeAllStructures ""
				  set firstLinesAllStructures ""

				  incr structureNumber

			} else {
				#### Write the remaining structures
				set i 0
				
				puts $molUP::temporaryXYZFile "[subst $molUP::numberAtoms]\n[subst $molUP::fileName]"

				foreach atomCoord $allAtomsLastStructureCoord {
					lassign $atomCoord columnCoord0 columnCoord1 columnCoord2 columnCoord3 columnCoord4 columnCoord5

    				incr i

    				regexp {(\S+)\.+(\S+)} $columnCoord3 -> xbefore xafter
    			    set x $xbefore\.[format %.3s $xafter]
    			    regexp {(\S+)\.+(\S+)} $columnCoord4 -> ybefore yafter
    			    set y $ybefore\.[format %.3s $yafter]
    			    regexp {(\S+)\.+(\S+)} $columnCoord5 -> zbefore zafter
    			    set z $zbefore\.[format %.3s $zafter]

					
					puts $molUP::temporaryXYZFile "[format %2s $columnCoord1] [format %17s $x] [format %17s $y] [format %17s $z]"

				}

			}
		
		}

        #### Close the temporary file
    	  close $molUP::temporaryPDBFile
		  close $molUP::temporaryXYZFile
		
		#### Load the molecule on VMD
		molUP::loadMolecule $molUP::fileName $molUP::actualTime allStructures



    } else {

	}	


	## Deactivate the ability to load a new molecule
	set molUP::openNewFileMode "NO"

}
    

proc molUP::globalInfoOutputFile {} {
	    
		#### Get the title line
		set titleFirstLine [exec grep -n -m 6 -e "^ -" $molUP::path | cut -f1 -d:]
		set titleFirstLine1 [expr [lindex $titleFirstLine 4] + 1]
		set titleLastLine1 [expr [lindex $titleFirstLine 5] - 1]
		set molUP::title [exec sed -n "$titleFirstLine1,$titleLastLine1 p" $molUP::path]

		#### Keywords of the calculations
		set keywordFirstLine1 [expr [lindex $titleFirstLine 2] + 1]
		set keywordLastLine1 [expr [lindex $titleFirstLine 3] - 1]
		set molUP::keywordsCalc [exec sed -n "$keywordFirstLine1,$keywordLastLine1 p" $molUP::path]

		#### Get the charge and Multiplicity
		set linesChargesMulti [exec head -n 300 $molUP::path | grep -e "^ Charge ="]
		set linesChargesMultiSplit [split $linesChargesMulti "\n"]
		set molUP::chargesMultip ""
		set i 0
		foreach line $linesChargesMultiSplit {
			set charge [string range $line 9 11]
			set multiplicity [string index $line 28]
			append molUP::chargesMultip $charge " " $multiplicity
			incr $i
		}
}