#### Procedures to convert structures to PDB files ####

package provide convertToPDB 1.0

#### ONIOM structure
proc gaussianVMD::convertToPDB {} {

	  set gaussianVMD::numberAtoms [llength $gaussianVMD::atomicSymbolList]
	  set indexSearch [expr $gaussianVMD::numberAtoms - 1]

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

}


proc gaussianVMD::convertToPDBMultiStructures {} {

	  set gaussianVMD::numberAtoms [llength $gaussianVMD::atomicSymbolList]

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

	  }

	  ## Add a footer to the file
	  puts $gaussianVMD::temporaryPDBFile "END"

}


proc gaussianVMD::convertToPDBLastStructure {} {

	  set gaussianVMD::numberAtoms [llength $gaussianVMD::atomicSymbolList]
	  set indexSearch [expr $gaussianVMD::numberAtoms - 1]

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

}