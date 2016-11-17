package provide gui 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::buildGui {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::topGui]} {wm deiconify $::gaussianVMD::topGui ;return $::gaussianVMD::topGui}
	toplevel $::gaussianVMD::topGui

	#### Title of the windows
	wm title $gaussianVMD::topGui "Gaussian for VMD v$gaussianVMD::version " ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::topGui] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::topGui] -50]

	#window wifth and height
	set wWidth [winfo reqwidth $::gaussianVMD::topGui]
	set wHeight [winfo reqheight $::gaussianVMD::topGui]
	
	display reposition 0 [expr ${sHeight} - 15]
	display resize [expr $sWidth - 400] ${sHeight}

	#wm geometry window $gaussianVMD::topGui 400x590
	set x [expr $sWidth - 2*($wWidth)]

	wm geometry $::gaussianVMD::topGui 400x${sHeight}+$x+25


    #### FRAME 0 - initial logo
    grid [frame $gaussianVMD::topGui.frame0 -bg black] -row 0 -column 0 -padx 1 -pady 1 -sticky news
    
    grid [canvas $gaussianVMD::topGui.frame0.title -height 45 -width [expr $wWidth * 2] -bg "mint cream"  -highlightthickness 0] -in $gaussianVMD::topGui.frame0 -row 0 -column 0 -sticky news
    	$gaussianVMD::topGui.frame0.title create text $wWidth 20 -text "Gaussian for VMD" -font {Helvetival 20} -fill "light sea green"


    #### FRAME 1 - Load a file
    grid [frame $gaussianVMD::topGui.frame1 -background white] -row 1 -column 0 -padx 1 -pady 5 -sticky news
		
		grid [ttk::label $gaussianVMD::topGui.frame1.pathEntryLabel \
		    -text {Choose a file to load: } \
		    -font {Helvetical 13} \
		    -foreground {light sea green} \
		    ] -in $gaussianVMD::topGui.frame1 -row 0 -column 0 -padx 2 -pady 2 -sticky news

		grid [ttk::entry $gaussianVMD::topGui.frame1.pathEntry \
		    -textvariable gaussianVMD::path \
		    -width 11 \
		    ] -in $gaussianVMD::topGui.frame1 -row 0 -column 1 -sticky news

		grid [ttk::button $gaussianVMD::topGui.frame1.buttonBrowseFile \
		    -text "Browse" \
		    -command gaussianVMD::onSelect \
		    ] -in $gaussianVMD::topGui.frame1 -row 0 -column 2 -sticky news

		grid [ttk::button $gaussianVMD::topGui.frame1.buttonLoadFile \
		    -text "Load" \
		    -command {gaussianVMD::loadButton $gaussianVMD::fileExtension} \
		    ] -in $gaussianVMD::topGui.frame1 -row 0 -column 3 -sticky news

		grid [ttk::combobox $gaussianVMD::topGui.frame1.selectLoadMode \
		    -textvariable $gaussianVMD::loadMode \
		    -width 45 \
			-state readonly \
		    -values "[list "Last Structure" "First Structure" "All optimized structures" "All structures (may take a long time to load)"]"
		    ] -in $gaussianVMD::topGui.frame1 -row 1 -column 0 -columnspan 4 -sticky news
		
		$gaussianVMD::topGui.frame1.selectLoadMode set "Last Structure"

		grid [frame $gaussianVMD::topGui.frame1.end \
			-background white \
			] -in $gaussianVMD::topGui.frame1 -row 2 -column 0 -padx 2 -pady 10 -sticky news



	#### FRAME 2 - Informations abou the file
	grid [frame $gaussianVMD::topGui.frame2 -background "white"] -row 3 -column 0 -padx 5 -pady 5 -sticky news
		#### Job Title
		grid [label $gaussianVMD::topGui.frame2.jobTitleLabel \
			    -text {Job title:} \
			    -font {Helvetical 16} \
			    -background {white} \
			    -foreground {light sea green} \
			    ] -in $gaussianVMD::topGui.frame2 -row 0 -column 0 -padx 10 -pady 0 -sticky nws

		grid [entry $gaussianVMD::topGui.frame2.jobTitle \
			-textvariable gaussianVMD::title \
		    -background {white} \
		    -width 45 \
		    -font {Helvetical 12} \
		    ] -in $gaussianVMD::topGui.frame2 -row 1 -column 0 -padx 10 -pady 5 -sticky news


		grid [ttk::separator $gaussianVMD::topGui.frame2.sep1] -in $gaussianVMD::topGui.frame2 -row 2 -column 0 -padx 10 -pady 5 -sticky news

		#### Charges and Multiplicty
		grid [label $gaussianVMD::topGui.frame2.chargesMultiplictyLabel \
			    -text {Charge and Multiplicity:} \
			    -font {Helvetical 16} \
			    -background {white} \
			    -foreground {light sea green} \
			    ] -in $gaussianVMD::topGui.frame2 -row 3 -column 0 -padx 10 -pady 0 -sticky nws

		grid [entry $gaussianVMD::topGui.frame2.chargesMultiplicty \
			-textvariable gaussianVMD::chargesMultip \
		    -width 45 \
		    -background {white} \
		    -font {Helvetical 12} \
		    ] -in $gaussianVMD::topGui.frame2 -row 4 -column 0 -padx 10 -pady 5 -sticky news


		grid [ttk::separator $gaussianVMD::topGui.frame2.sep2] -in $gaussianVMD::topGui.frame2 -row 5 -column 0 -padx 10 -pady 5 -sticky news


		#### Keywords of the calculations
		grid [label $gaussianVMD::topGui.frame2.keywordsCalcLabel \
			    -text {Keywords:} \
			    -font {Helvetical 16} \
			    -background {white} \
			    -foreground {light sea green} \
			    ] -in $gaussianVMD::topGui.frame2 -row 6 -column 0 -padx 10 -pady 0 -sticky nws

		grid [entry $gaussianVMD::topGui.frame2.keywordsCalc \
			-textvariable gaussianVMD::keywordsCalc \
		    -width 45 \
		    -background {white} \
		    -font {Helvetical 12} \
		    ] -in $gaussianVMD::topGui.frame2 -row 7 -column 0 -padx 10 -pady 5 -sticky news

		grid [ttk::separator $gaussianVMD::topGui.frame2.sep3] -in $gaussianVMD::topGui.frame2 -row 8 -column 0 -padx 10 -pady 5 -sticky news

		#### Link 0 Options
		##grid [text $gaussianVMD::topGui.frame2.linkZeroLabel -height 5 -width 55 -background white -relief solid -wrap word] -in $gaussianVMD::topGui.frame2 -row 9 -column 0 -padx 2 -pady 2 -sticky news

		

	#### Tabs to present the atom list
	#### Atom List - Table
	grid [frame $gaussianVMD::topGui.frame3 -background "white"] -row 5 -column 0 -padx 0 -pady 5 -sticky news
		grid [ttk::notebook $gaussianVMD::topGui.frame3.tabsAtomList] -in $gaussianVMD::topGui.frame3 -row 0 -column 0
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab1] -text "Charges"
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab2] -text "Layer"
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab3] -text "Freeze"
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab4] -text "Coordinates"
			$gaussianVMD::topGui.frame3.tabsAtomList select $gaussianVMD::topGui.frame3.tabsAtomList.tab1

		### Charges
		grid [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame] -row 0 -column 0  -padx 2 -pady 2

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer\
				 -columns {0 "Index" 0 "Atom" 0 "Resname" 0 "Resid" 0 "Charges"} \
				 -stretch all \
				 -background white \
				 -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.yscb set] \
				 -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.xscb set] \
				 ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news


		## ONIOM Layer
		grid [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame] -row 0 -column 0  -padx 2 -pady 2

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer \
			     -columns {0 "Index" 0 "Atom" 0 "Resname" 0 "Resid" 0 "Layer"} \
		         -stretch all \
		         -background white \
		         -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.yscb set] \
				 -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.xscb set] \
		         ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news


		## Freeze Status
		grid [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame] -row 0 -column 0  -padx 2 -pady 2

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer \
				 -columns {0 "Index" 0 "Atom" 0 "Resname" 0 "Resid" 0 "Freeze"} \
			     -stretch all \
			     -background white \
			     -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.yscb set] \
	             -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.xscb set] \
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news
		

		## Coordinates
		grid [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame] -row 0 -column 0  -padx 2 -pady 2

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer \
				 -columns {0 "Index" 0 "Atom" 0 "Resname" 0 "Resid" 0 "X" 0 "Y" 0 "Z"} \
			     -stretch all \
			     -background white \
			     -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.yscb set] \
	             -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.xscb set] \
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news


		### Load Button add the lines to the table


	#### FRAME - Atom Selection
	grid [frame $gaussianVMD::topGui.frame4 -background white] -row 7 -column 0 -padx 5 -pady 5 -sticky news
		grid [label $gaussianVMD::topGui.frame4.selectionLabel \
				    -text {Atom Selection:} \
				    -font {Helvetical 16} \
				    -background {white} \
				    -foreground {light sea green} \
				    ] -in $gaussianVMD::topGui.frame4 -row 0 -column 0 -padx 2 -pady 2 -sticky news

		grid [entry $gaussianVMD::topGui.frame4.selection \
				-textvariable "teste" \
			    -width 45 \
			    -font {Helvetical 12} \
			    ] -in $gaussianVMD::topGui.frame4 -row 1 -column 0 -sticky news

	grid [frame $gaussianVMD::topGui.frame5 -background white] -row 8 -column 0 -padx 5 -pady 0 -sticky news		    
		
		grid [ttk::combobox $gaussianVMD::topGui.frame5.selectModification \
		    -textvariable $gaussianVMD::selectionModificationType \
		    -width 10 \
			-state readonly \
		    -values "[list "Freeze" "Layer"]"
		    ] -in $gaussianVMD::topGui.frame5 -row 0 -column 1 -sticky news

		grid [ttk::combobox $gaussianVMD::topGui.frame5.selectModificationValue \
		    -textvariable $gaussianVMD::selectionModificationValue \
		    -width 20 \
		    -values "[list "0" "-1" "-2" "-3" "High Layer" "Medium Layer" "Low Layer"]"
		    ] -in $gaussianVMD::topGui.frame5 -row 0 -column 2 -sticky news 

		grid [button $gaussianVMD::topGui.frame5.selectionApply \
		    -text "Apply" \
		    -command {gaussianVMD::loadButton $gaussianVMD::fileExtension} \
		    ] -in $gaussianVMD::topGui.frame5 -row 0 -column 3 -sticky news



	#### Last FRAME - Save The Files
	grid [frame $gaussianVMD::topGui.frameLast -background white] -row 10 -column 0 -padx 5 -pady 25 -sticky news

		grid [label $gaussianVMD::topGui.frameLast.savePDBLabel \
			    -text {Save as PDB File:} \
			    -font {Helvetical 13} \
			    -background {white} \
			    -foreground {light sea green} \
			    ] -in $gaussianVMD::topGui.frameLast -row 0 -column 0 -padx 2 -pady 2 -sticky news


		grid [button $gaussianVMD::topGui.frameLast.savePDB \
		    -text "Save" \
		    -command gaussianVMD::onSelect \
		    ] -in $gaussianVMD::topGui.frameLast -row 0 -column 1 -sticky news



		grid [label $gaussianVMD::topGui.frameLast.saveGaussianLabel \
			    -text {Save as Gaussian Input (.com) File:} \
			    -font {Helvetical 13} \
			    -background white \
			    -foreground {light sea green} \
			    ] -in $gaussianVMD::topGui.frameLast -row 1 -column 0 -padx 2 -pady 2 -sticky news


		grid [button $gaussianVMD::topGui.frameLast.saveGaussian \
		    -text "Save" \
		    -command gaussianVMD::onSelect \
		    ] -in $gaussianVMD::topGui.frameLast -row 1 -column 1 -sticky news

		grid [button $gaussianVMD::topGui.frameLast.quit \
		    -text "Quit" \
		    -command gaussianVMD::quit \
		    -background white \
		    ] -in $gaussianVMD::topGui.frameLast -row 2 -column 0  -pady 10 -sticky news

		grid [label $gaussianVMD::topGui.frameLast.copyright \
		    -text "Developed by Henrique S. Fernandes - 2016 v $gaussianVMD::version" \
		    -font {Helvetical 8} \
		    -background {white} \
		    -foreground {gray} \
		    ] -in $gaussianVMD::topGui.frameLast -row 3 -column 0 -padx 5 -pady 10 -sticky ne


}

