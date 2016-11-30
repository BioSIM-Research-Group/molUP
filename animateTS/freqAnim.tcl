
##################################################################
##################################################################
# Versão 1.2
#
# Nuno M. F. S. A. Cerqueira
# nscerque@fc.up.pt
#
# nscerqueira 2011
#
##################################################################
##################################################################



## Leitura da Shell
	set File     [lindex $argv 0]
	set from     [lindex $argv 1]
	set to       [lindex $argv 2]
	set incr     [lindex $argv 3]

	if {[lindex $argv 0]== "--help" ||  $File==""} {
		puts  "\n Usage :  freqAnim.tcl  \[a\]  \[b\]  \[c\]  \[d\] \n"
		puts  "           \[a\] :  Input file *.log"
		puts  "           \[b\] :  from (-1.0)"
		puts  "           \[c\] :  to (1.0)"
		puts  "           \[d\] :  increment (+0.1)"
		puts  "\n example: tclsh freqAnim.tcl  Step_1_Nap_Cys_NO3_TS.log  -1.0 1.0 0.1 "
		exit
	}


## Permite Identificar o tipo de atomo
	proc atomID  {atom} {
		set atomID  "H He C  N  O S  Mo Se"
		set atomNum "1 2  6  7  8 16 42 34"
		set atomID [lindex $atomID [lsearch $atomNum  $atom]]
	return $atomID
	}


#### Comeca a ler o ficheiro

set loadFile [open $File r]
set readFile [gets $loadFile]


while {![eof $loadFile]} {


	# Obter a energia
	if {[string first "SCF Done:" $readFile]!=-1} {set scfEnerg [lindex $readFile 4]}


	# obter a estrutura
	if {[string first "Standard orientation:" $readFile]!=-1} {

		# ler o titulo
		for {set i 0 } {$i<=4} {incr i} {set readFile [gets $loadFile]}

		# ler a estrutura
		set atomNumber 0

		while {[string first "---------------------------------------------------------------------" $readFile]==-1} {
			set atom($atomNumber) [lindex $readFile 1] 
			set coordX($atomNumber) [lindex $readFile 3]
			set coordY($atomNumber) [lindex $readFile 4]
			set coordZ($atomNumber) [lindex $readFile 5]
			set readFile [gets $loadFile]
			incr atomNumber
		}

	}


	# obter a frequencia imaginária

	if {[string first "and normal coordinates:" $readFile]!=-1} {

		# ler o titulo
        for {set i 0 } {$i<=2} {incr i} {set readFile [gets $loadFile]}
		set freq [lindex $readFile 2]
		for {set i 0 } {$i<=4} {incr i} {set readFile [gets $loadFile]}
		for {set i 0 } {$i<=1} {incr i} {set readFile [gets $loadFile]}

		for {set i 0} {$i<=[expr $atomNumber -1]} {incr i} {
                        set atomFreq($i) [lindex $readFile 1]
                        set coordXFreq($i) [lindex $readFile 2]
                        set coordYFreq($i) [lindex $readFile 3]
                        set coordZFreq($i) [lindex $readFile 4]
			set readFile [gets $loadFile]
                }

	}

	set readFile [gets $loadFile]

}

close $loadFile


## Cria os ficheiros

set saveFile [open "[file root $File].xyz" w]


	for {set a 0} {$a<=$to} {set a [expr $a+$incr]} {

		puts $saveFile "$atomNumber"
		puts $saveFile "Frequency: $freq"
		for {set i 0} {$i<=[expr $atomNumber-1]} {incr i} {
		set coordXFinal [expr $coordX($i) + $a * $coordXFreq($i)]
		set coordYFinal [expr $coordY($i) + $a * $coordYFreq($i)]
		set coordZFinal [expr $coordZ($i) + $a * $coordZFreq($i)]

		puts $saveFile "[format "%3s" [atomID $atom($i)]]  [format "%8.4f" $coordXFinal] [format "%8.4f" $coordYFinal] [format "%8.4f" $coordZFinal] "
		}

	}


        for {set a $to} {$a>=$from} {set a [expr $a-$incr]} {

                puts $saveFile "$atomNumber"
                puts $saveFile "Frequency: $freq"
                for {set i 0} {$i<=[expr $atomNumber-1]} {incr i} {
                set coordXFinal [expr $coordX($i) + $a* $coordXFreq($i)]
                set coordYFinal [expr $coordY($i) + $a* $coordYFreq($i)]
                set coordZFinal [expr $coordZ($i) + $a* $coordZFreq($i)]

                puts $saveFile "[format "%3s" [atomID $atom($i)]]  [format "%8.4f" $coordXFinal] [format "%8.4f" $coordYFinal] [format "%8.4f" $coordZFinal] "
                }

        }


        for {set a $from} {$a<=0} {set a [expr $a+$incr]} {

                puts $saveFile "$atomNumber"
                puts $saveFile "Frequency: $freq"
                for {set i 0} {$i<=[expr $atomNumber-1]} {incr i} {
                set coordXFinal [expr $coordX($i) + $a * $coordXFreq($i)]
                set coordYFinal [expr $coordY($i) + $a * $coordYFreq($i)]
                set coordZFinal [expr $coordZ($i) + $a * $coordZFreq($i)]

                puts $saveFile "[format "%3s" [atomID $atom($i)]]  [format "%8.4f" $coordXFinal] [format "%8.4f" $coordYFinal] [format "%8.4f" $coordZFinal] "
                }

        }




close  $saveFile


##### Draw vectors in VMD

set saveFile [open "[file root $File].tcl" w]

# open the animation file

puts $saveFile "mol new [file root $File].xyz type xyz first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all"
puts $saveFile {set topLayer [molinfo top]}
puts $saveFile {graphics $topLayer delete all}

puts $saveFile "mol delrep 0 top"
puts $saveFile "mol representation VDW 0.200000 27.000000"
puts $saveFile "mol selection {all}"
puts $saveFile "mol addrep \$topLayer"


puts $saveFile "mol representation DynamicBonds 1.600000 0.200000 21.000000"
puts $saveFile "mol selection {all}"
puts $saveFile "mol addrep \$topLayer"



puts $saveFile {graphics $topLayer color yellow}
update

puts $saveFile {
	proc vmd_draw_arrow {mol start end} {

	 if {[vecdist $start $end]==0} return
      # an arrow is made of a cylinder and a cone
      set middle [vecadd $start [vecscale 0.9 [vecsub $end $start]]]
      set middle 
      graphics $mol cylinder $start $middle radius 0.05
      
      graphics $mol cone $middle $end radius 0.1
}
}



set a 6 
for {set i 0} {$i<=[expr $atomNumber-1]} {incr i} {
		
		set coordStart "{$coordX($i) $coordY($i) $coordZ($i)}"

		set coordXFinal [expr $coordX($i)+ $a * $coordXFreq($i)]
		set coordYFinal [expr $coordY($i)+ $a * $coordYFreq($i)]
		set coordZFinal [expr $coordZ($i)+ $a * $coordZFreq($i)]

		set coordEnd "{$coordXFinal $coordYFinal $coordZFinal}"

		## Draw vectors
		puts $saveFile "vmd_draw_arrow \$topLayer $coordStart $coordEnd"

		}

close $saveFile



puts "Files created:"
puts "          1. [file root $File].xyz - XYZ file with the animation of the imaginary frequency"
puts "          2. [file root $File].tcl - vmd file to draw the arrow of the vectors"


