proc read_freq {file} { 
	global freq_list
	global freq_line

	set a [split [exec egrep -n "Frequencies --" $file] "\n"]

	foreach line  $a {
        	set freq_list [lappend freq_list "[lindex $line 3] [lindex $line 4] [lindex $line 5]"]
        	set freq_line [lappend freq_line [lindex [split [lindex $line 0] ":"] 0]]
	}
}



proc search_freq {freq_value freq_list freq_line} {

	set line 0
	set answer ""
	foreach a $freq_list {
		set pos [lsearch $a $freq_value]
		if {$pos !=-1} {set answer "$line $pos"}
		incr line 
	}

return $answer
}

proc extract_freq_coord {file where} {
	global freq_list
        global freq_line

	set vectors [exec sed -n "[expr [lindex $freq_line [lindex $where 0]] +5], [expr [lindex $freq_line [expr [lindex $where 0]+1]]-3] p" $file]
	set vectors_split [split $vectors "\n"]

	set columnX [expr [lindex $where 1] +2 + [lindex $where 1]*2]
	set columnY [expr [lindex $where 1] +3 + [lindex $where 1]*2]
	set columnZ [expr [lindex $where 1] +4 + [lindex $where 1]*2]

	set freq_vector ""
	foreach a $vectors_split {
		set freq_vector [lappend list "[lindex $a 0] [lindex $a $columnX] [lindex $a $columnY] [lindex $a $columnZ]"]
	}

return $freq_vector
}


proc move_freq {molecule_example constant freq_vector}  {

	set newMolecule ""
	foreach molecule $molecule_example vector $freq_vector {

        	if {[lindex $molecule 0]==[lindex $vector 0]} {
                	set newX [expr [lindex $molecule 1] + $constant*[lindex $vector 1]]
                	set newY [expr [lindex $molecule 2] + $constant*[lindex $vector 2]]
                	set newZ [expr [lindex $molecule 3] + $constant*[lindex $vector 3]]

                	set newMolecule [lappend newMolecule "[lindex $molecule 0] $newX $newY $newZ"]
        	} else { set newMolecule [lappend newMolecule $molecule]}
	}

	return $newMolecule
}


##### START

set freq_list ""
set freq_line ""
set file "TS.out"
set freq_search "-890.9532"

##  search freq values
# so lê uma vez
read_freq $file

## extract data
# Só se acciona quando a freq é seleccionada ou no inicio depende da memoria
set where [search_freq $freq_search $freq_list $freq_line]

puts "Coordinates for freq: $freq_search "
set freq_vector [extract_freq_coord $file $where]


## Move atoms in a movie
# sempre que uma freq é seleccionada 

#nomenclature # atomnumber X Y Z
set molecule_example "{1 0.00 0.00 0.00} {2 0.06 -0.16 -0.01} {3 -0.06 0.05 -0.01} {4 -0.03 0.16 0.00} {5 0.00 0.00 0.00} {6 0.00 0.00 0.00} {7 0.09 -0.09 0.00} {8 0.03 -0.02 -0.02} {9 -0.03 -0.03 0.03} {10 0.01 0.01 0.00} {11 0.02 -0.01 0.02} {12 0.00 0.01 0.00} {13 -0.03 -0.02 -0.04} {14 0.12 -0.12 0.00} {15 -0.06 0.11 0.01} {16 -0.87 -0.29 -0.04} {17 -0.01 0.13 0.03}"
set constant 2


for {set i -1 } {$i <=1} {set i [expr $i+0.25]} {
	set newMolecule [move_freq $molecule_example $i $freq_vector]
	puts "$newMolecule \n"
}


puts "Done"
