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
	$::gaussianVMD::topGui configure -background {white}
	wm resizable $::gaussianVMD::topGui 0 0

	###########################################################
    #### FRAME 0 - initial logo
    grid [ttk::frame $gaussianVMD::topGui.frame0] -row 0 -column 0 -padx 5 -pady 10 -sticky news
    
    grid [canvas $gaussianVMD::topGui.frame0.title -height 90 -width [expr $wWidth * 2 - 10] -bg "white"  -highlightthickness 0] -in $gaussianVMD::topGui.frame0 -row 0 -column 0 -sticky news
    	$gaussianVMD::topGui.frame0.title create text [expr $wWidth + 30] 45 -text "Gaussian for VMD" -font {Arial 30} -fill "black"
	
	$gaussianVMD::topGui.frame0.title create image 50 45 -image $gaussianVMD::logo

	###########################################################
    #### FRAME 1 - Load a file
    grid [ttk::frame $gaussianVMD::topGui.frame1] -row 1 -column 0 -padx 5 -pady 2 -sticky news
		
		grid [ttk::label $gaussianVMD::topGui.frame1.pathEntryLabel \
		    -text {Choose a file to load: } \
			-style gaussianVMD.TLabel \
		    ] -in $gaussianVMD::topGui.frame1 -row 0 -column 0 -padx 2 -pady 2 -sticky news

		grid [ttk::entry $gaussianVMD::topGui.frame1.pathEntry \
		    -textvariable gaussianVMD::path \
		    -width 12 \
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

	###########################################################
	#### FRAME 2 - Informations abou the file
	grid [ttk::frame $gaussianVMD::topGui.frame2] -row 3 -column 0 -padx 5 -pady 2 -sticky news
		#### Job Title
		grid [ttk::label $gaussianVMD::topGui.frame2.jobTitleLabel \
			    -text {Job title:} \
				-style gaussianVMD.TLabel \
			    ] -in $gaussianVMD::topGui.frame2 -row 0 -column 0 -padx 10 -pady 0 -sticky nws -columnspan 2

		grid [ttk::entry $gaussianVMD::topGui.frame2.jobTitle \
			-textvariable gaussianVMD::title \
		    -width 45 \
		    -font {Arial 12} \
		    ] -in $gaussianVMD::topGui.frame2 -row 1 -column 0 -padx 10 -pady 5 -sticky news -columnspan 2

		#### Charges and Multiplicty
		grid [ttk::label $gaussianVMD::topGui.frame2.chargesMultiplictyLabel \
			    -text {Charge and Multiplicity:} \
				-style gaussianVMD.TLabel \
			    ] -in $gaussianVMD::topGui.frame2 -row 3 -column 0 -padx 10 -pady 0 -sticky nws

		grid [ttk::entry $gaussianVMD::topGui.frame2.chargesMultiplicty \
			-textvariable gaussianVMD::chargesMultip \
		    -width 23\
		    -font {Arial 12} \
		    ] -in $gaussianVMD::topGui.frame2 -row 4 -column 0 -padx 10 -pady 5 -sticky news

		#### Keywords of the calculations
		grid [ttk::label $gaussianVMD::topGui.frame2.keywordsCalcLabel \
			    -text {Keywords:} \
				-style gaussianVMD.TLabel \
			    ] -in $gaussianVMD::topGui.frame2 -row 3 -column 1 -padx 10 -pady 0 -sticky nws

		grid [ttk::entry $gaussianVMD::topGui.frame2.keywordsCalc \
			-textvariable gaussianVMD::keywordsCalc \
		    -width 23 \
		    -font {Arial 12} \
		    ] -in $gaussianVMD::topGui.frame2 -row 4 -column 1 -padx 10 -pady 5 -sticky news


	###########################################################
	#### Tabs to present the atom list
	#### Atom List - Table
	grid [ttk::frame $gaussianVMD::topGui.frame3] -row 5 -column 0 -padx 5 -pady 0 -sticky news
		grid [ttk::notebook $gaussianVMD::topGui.frame3.tabsAtomList] -in $gaussianVMD::topGui.frame3 -row 0 -column 0
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab1] -text "Charges"
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab2] -text "Layer"
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab3] -text "Freeze"
			$gaussianVMD::topGui.frame3.tabsAtomList add [frame $gaussianVMD::topGui.frame3.tabsAtomList.tab4] -text "Coordinates"
			$gaussianVMD::topGui.frame3.tabsAtomList select $gaussianVMD::topGui.frame3.tabsAtomList.tab1

		### Charges
		grid [ttk::frame $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame] -row 0 -column 0  -padx 0 -pady 0

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer\
				 -showeditcursor true \
				 -columns {0 "Index" center 0 "Atom" center 0 "Resname" center 0 "Resid" center 0 "Charges" center} \
				 -stretch all \
				 -background white \
				 -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.yscb set] \
				 -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.xscb set] \
				 -selectmode extended \
				 -movablecolumns true \
				 ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news -columnspan 3

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse -columnspan 3

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news -columnspan 3

			$gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer configcolumns 4 -editable true

    	bind $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.tableLayer <<TablelistSelect>> gaussianVMD::changeRepCurSelection


					##### - Atom Selection
					grid [ttk::label $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.selectionLabel \
										-text {Quick representantion:} \
										-style gaussianVMD.TLabel
									    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 2 -column 0 -padx 2 -pady 2 -sticky news

					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.showHL \
							    -text "High Layer" \
								-variable gaussianVMD::HLrep \
								-command {gaussianVMD::onOffRepresentation 2} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 3 -column 0 -sticky news

					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.showML \
							    -text "Medium Layer" \
								-variable gaussianVMD::MLrep \
								-command {gaussianVMD::onOffRepresentation 3} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 3 -column 1 -sticky news
					
					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.showLL \
							    -text "Low Layer" \
								-variable gaussianVMD::LLrep \
								-command {gaussianVMD::onOffRepresentation 4} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 3 -column 2 -sticky news
					
					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.unfreeze \
							    -text "Unfreeze" \
								-variable gaussianVMD::unfreezeRep \
								-command {gaussianVMD::onOffRepresentation 8} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 4 -column 0 -sticky news

					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.freezeMinusOne \
							    -text "Freeze" \
								-variable gaussianVMD::freezeRep \
								-command {gaussianVMD::onOffRepresentation 9} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 4 -column 1 -sticky news
					
					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.all \
							    -text "All" \
								-variable gaussianVMD::allRep \
								-command {gaussianVMD::onOffRepresentation 0} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 4 -column 2 -sticky news
					
					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.protein \
							    -text "Protein" \
								-variable gaussianVMD::proteinRep \
								-command {gaussianVMD::onOffRepresentation 5} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 5 -column 0 -sticky news

					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.nonProtein \
							    -text "Non-Protein" \
								-variable gaussianVMD::nonproteinRep \
								-command {gaussianVMD::onOffRepresentation 6} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 5 -column 1 -sticky news
					
					grid [ttk::checkbutton $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame.water \
							    -text "Water" \
								-variable gaussianVMD::waterRep \
								-command {gaussianVMD::onOffRepresentation 7} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab1.frame -row 5 -column 2 -sticky news

		## ONIOM Layer
		grid [ttk::frame $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame] -row 0 -column 0  -padx 0 -pady 0

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer \
			     -columns {0 "Index" center 0 "Atom" center 0 "Resname" center 0 "Resid" center 0 "Layer" center} \
		         -stretch all \
		         -background white \
		         -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.yscb set] \
				 -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.xscb set] \
				 -selectmode extended \
				 -editstartcommand gaussianVMD::oniomLayer \
		         ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news



			$gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.tableLayer columnconfigure 4 \
				-sortmode real \
				-editable true \
				-editwindow ttk::combobox

							#### FRAME - Atom Selection
							grid [ttk::label $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.selectionLabel \
										-text {Atom selection (Change ONIOM layer):} \
										-style gaussianVMD.TLabel
									    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 2 -column 0 -padx 2 -pady 2 -sticky news
									
							grid [ttk::entry $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.selection \
									-textvariable gaussianVMD::atomSelection \
								    -width 45 \
								    -font {Arial 12} \
								    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 3 -column 0 -sticky news
													
							grid [ttk::combobox $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frameselectModificationValue \
							    -textvariable $gaussianVMD::selectionModificationValue \
							    -width 20 \
								-values "[list "0" "-1" "-2" "-3"]"
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 4 -column 0 -sticky news 
							
							grid [ttk::button $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame.selectionApply \
							    -text "Apply" \
								-command {gaussianVMD::applyToStructure} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab2.frame -row 5 -column 0 -sticky news


		## Freeze Status
		grid [ttk::frame $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame] -row 0 -column 0  -padx 0 -pady 0

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer \
				 -columns {0 "Index" center 0 "Atom" center 0 "Resname" center 0 "Resid" center 0 "Freeze" center} \
			     -stretch all \
			     -background white \
			     -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.yscb set] \
	             -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.xscb set] \
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news
		
							#### FRAME - Atom Selection
							grid [ttk::label $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.selectionLabel \
										-text {Atom selection (Change freezing state):} \
										-style gaussianVMD.TLabel
									    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 2 -column 0 -padx 2 -pady 2 -sticky news
									
							grid [ttk::entry $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.selection \
									-textvariable gaussianVMD::atomSelection \
								    -width 45 \
								    -font {Arial 12} \
								    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 3 -column 0 -sticky news
													
							grid [ttk::combobox $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frameselectModificationValue \
							    -textvariable $gaussianVMD::selectionModificationValue \
							    -width 20 \
								-values "[list "H" "M" "L"]"
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 4 -column 0 -sticky news 
							
							grid [ttk::button $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame.selectionApply \
							    -text "Apply" \
								-command {gaussianVMD::applyToStructure} \
							    ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab3.frame -row 5 -column 0 -sticky news

		## Coordinates
		grid [ttk::frame $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame] -row 0 -column 0  -padx 0 -pady 0

			grid [tablelist::tablelist $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer \
				 -columns {0 "Index" center 0 "Atom" center 0 "Resname" center 0 "Resid" center 0 "X" center 0 "Y" center 0 "Z" center} \
			     -stretch all \
			     -background white \
			     -yscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.yscb set] \
	             -xscrollcommand [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.xscb set] \
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame -row 0 -column 0 -padx 0 -pady 0 -ipadx 95 -sticky news

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.yscb \
			     -orient vertical \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer yview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame -row 0 -column 1 -padx 0 -pady 0 -sticky nse

			grid [ttk::scrollbar $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.xscb \
			     -orient horizontal \
			     -command [list $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame.tableLayer xview]\
			     ] -in $gaussianVMD::topGui.frame3.tabsAtomList.tab4.frame -row 1 -column 0 -padx 0 -pady 0 -sticky news





		
		#### Energetic Profile
		grid [ttk::frame $gaussianVMD::topGui.frame6] -row 9 -column 0 -padx 5 -pady 4 -sticky news		    

			grid [ttk::button $gaussianVMD::topGui.frame6.seeEnergy \
		    	-text "Energetic Profile" \
		    	-command {} \
		    	] -in $gaussianVMD::topGui.frame6 -row 0 -column 0 -sticky news

			grid [ttk::button $gaussianVMD::topGui.frame6.manipulateStructure \
		    	-text "Structure Manipulation" \
		    	-command {} \
		    	] -in $gaussianVMD::topGui.frame6 -row 0 -column 1 -sticky news



	#### Last FRAME - Save The Files
	grid [ttk::frame $gaussianVMD::topGui.frameLast] -row 10 -column 0 -padx 5 -pady 2 -sticky news

		grid [ttk::label $gaussianVMD::topGui.frameLast.savePDBLabel \
			    -text {Save as PDB File:} \
			    -style gaussianVMD.TLabel
			    ] -in $gaussianVMD::topGui.frameLast -row 0 -column 0 -padx 2 -pady 2 -sticky news


		grid [ttk::button $gaussianVMD::topGui.frameLast.savePDB \
		    -text "Save" \
		    -command gaussianVMD::onSelect \
		    ] -in $gaussianVMD::topGui.frameLast -row 0 -column 1 -sticky news



		grid [ttk::label $gaussianVMD::topGui.frameLast.saveGaussianLabel \
			    -text {Save as Gaussian Input (.com) File:} \
				-style gaussianVMD.TLabel
			    ] -in $gaussianVMD::topGui.frameLast -row 1 -column 0 -padx 2 -pady 2 -sticky news


		grid [ttk::button $gaussianVMD::topGui.frameLast.saveGaussian \
		    -text "Save" \
		    -command gaussianVMD::onSelect \
		    ] -in $gaussianVMD::topGui.frameLast -row 1 -column 1 -sticky news

		grid [ttk::button $gaussianVMD::topGui.frameLast.quit \
		    -text "Quit" \
		    -command gaussianVMD::quit \
		    ] -in $gaussianVMD::topGui.frameLast -row 2 -column 0 -columnspan 2 -pady 10 -sticky news

		grid [ttk::label $gaussianVMD::topGui.frameLast.copyright \
		    -text "Developed by Henrique S. Fernandes - henriquefer11@gmail.com - 2016 v $gaussianVMD::version" \
		    -font {Arial 9} \
		    -foreground {gray} \
		    ] -in $gaussianVMD::topGui.frameLast -row 3 -column 0 -columnspan 2 -padx 5 -pady 10 -sticky ne


}





####### Style

ttk::style configure gaussianVMD.TLabel \
	-foreground {steel blue} \
	-font {Arial 14} \
	-background {red}




proc gaussianVMD::loadImages {} {
	foreach file $gaussianVMD::images keyword $gaussianVMD::imagesNames {
		variable $keyword [image create photo -format gif -file img/$file] 
	}
}