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

	wm geometry $::gaussianVMD::topGui 400x$sHeight+$x+25
	$::gaussianVMD::topGui configure -background {white}
	wm resizable $::gaussianVMD::topGui 0 0

	# Procedure when the window is closed
	wm protocol $::gaussianVMD::topGui WM_DELETE_WINDOW {gaussianVMD::quit}

	## Apply theme
	ttk::style theme use gaussianVMDTheme
	
	##########################################################


	#### Top Section
	pack [ttk::frame $gaussianVMD::topGui.frame0]
	pack [canvas $gaussianVMD::topGui.frame0.topSection -bg #ededed -width 400 -height 50 -highlightthickness 0] -in $gaussianVMD::topGui.frame0 

	place [ttk::frame $gaussianVMD::topGui.frame0.topSection.topMenu -width 400 -style gaussianVMD.menuBar.TFrame] -in $gaussianVMD::topGui.frame0.topSection -x 0 -y 0 -width 400 -height 35

	place [ttk::menubutton $gaussianVMD::topGui.frame0.topSection.topMenu.file -text "File" -menu $gaussianVMD::topGui.frame0.topSection.topMenu.file.menu \
			-style gaussianVMD.menuBar.TMenubutton \
			] -in $gaussianVMD::topGui.frame0.topSection.topMenu -x 5 -y 5 -height 25 -width 50
    
	menu $gaussianVMD::topGui.frame0.topSection.topMenu.file.menu -tearoff 0
	$gaussianVMD::topGui.frame0.topSection.topMenu.file.menu add command -label "Open" -command {gaussianVMD::guiOpenFile}
	$gaussianVMD::topGui.frame0.topSection.topMenu.file.menu add command -label "Save" -command {gaussianVMD::guiSaveFile}
	$gaussianVMD::topGui.frame0.topSection.topMenu.file.menu add command -label "Restart" -command {gaussianVMD::restart}
	$gaussianVMD::topGui.frame0.topSection.topMenu.file.menu add command -label "Quit" -command {gaussianVMD::quit}

	place [ttk::menubutton $gaussianVMD::topGui.frame0.topSection.topMenu.tools -text "Tools" -menu $gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu \
			-style gaussianVMD.menuBar.TMenubutton \
			] -in $gaussianVMD::topGui.frame0.topSection.topMenu -x 54 -y 5 -height 25 -width 60
	
	menu $gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu -tearoff 0
	$gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu add command -label "Reset view" -command {display reset view}
	$gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu add command -label "Center atom" -command {mouse mode center}
	$gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu add command -label "Delete all labels" -command {gaussianVMD::deleteAllLabels}
	$gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu add command -label "Mouse mode: Rotate" -command {mouse mode rotate}
	$gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu add command -label "Mouse mode: Translate" -command {mouse mode translate}
	$gaussianVMD::topGui.frame0.topSection.topMenu.tools.menu add command -label "Mouse mode: Scale" -command {mouse mode scale}

	place [ttk::menubutton $gaussianVMD::topGui.frame0.topSection.topMenu.structure -text "Structure" -menu $gaussianVMD::topGui.frame0.topSection.topMenu.structure.menu \
			-style gaussianVMD.menuBar.TMenubutton \
			] -in $gaussianVMD::topGui.frame0.topSection.topMenu -x 120 -y 5 -height 25 -width 80
	
	menu $gaussianVMD::topGui.frame0.topSection.topMenu.structure.menu -tearoff 0
	$gaussianVMD::topGui.frame0.topSection.topMenu.structure.menu add command -label "Modify bond" -command {gaussianVMD::bondModifInitialProc}
	$gaussianVMD::topGui.frame0.topSection.topMenu.structure.menu add command -label "Modify angle" -command {gaussianVMD::angleModifInitialProc}
	$gaussianVMD::topGui.frame0.topSection.topMenu.structure.menu add command -label "Modify dihedral" -command {gaussianVMD::dihedModifInitialProc}


	place [ttk::menubutton $gaussianVMD::topGui.frame0.topSection.topMenu.about -text "About" -menu $gaussianVMD::topGui.frame0.topSection.topMenu.about.menu \
			-style gaussianVMD.menuBar.TMenubutton \
			] -in $gaussianVMD::topGui.frame0.topSection.topMenu -x 320 -y 5 -height 25 -width 70

	menu $gaussianVMD::topGui.frame0.topSection.topMenu.about.menu -tearoff 0
	$gaussianVMD::topGui.frame0.topSection.topMenu.about.menu add command -label "Help" -command {gaussianVMD::guiError "This feature is not available yet."}
	$gaussianVMD::topGui.frame0.topSection.topMenu.about.menu add command -label "Credits" -command {gaussianVMD::guiCredits}


	#### Molecule Selection
	pack [canvas $gaussianVMD::topGui.frame0.molSelection -bg #ededed -width 400 -height 35 -highlightthickness 0] -in $gaussianVMD::topGui.frame0

	place [ttk::label $gaussianVMD::topGui.frame0.molSelection.label \
			-style gaussianVMD.gray.TLabel \
			-text {Molecule } ] -in $gaussianVMD::topGui.frame0.molSelection -x 5 -y 2

	variable topMolecule "No molecule"
	variable molinfoList {}
	trace variable ::vmd_initialize_structure w gaussianVMD::updateStructures
	place [ttk::combobox $gaussianVMD::topGui.frame0.molSelection.combo \
			-textvariable gaussianVMD::topMolecule \
			-style gaussianVMD.TCombobox \
			-values "$gaussianVMD::molinfoList" \
			-state readonly \
			] -in $gaussianVMD::topGui.frame0.molSelection -x 70 -y 0 -width 325
	bind $gaussianVMD::topGui.frame0.molSelection.combo <<ComboboxSelected>> {gaussianVMD::activateMolecule}
	
	
	set majorHeight [expr $sHeight - 230]
	
	#### Major Tabs
	pack [canvas $gaussianVMD::topGui.frame0.major -bg #ededed -width 400 -height $majorHeight -highlightthickness 0] -in $gaussianVMD::topGui.frame0
	set major $gaussianVMD::topGui.frame0.major

	place [ttk::notebook $major.tabs \
		-style gaussianVMD.major.TNotebook
		] -in $major -x 0 -y 0 -width 400 -height $majorHeight
	$major.tabs add [frame $major.tabs.tabResults -background #b3dbff -relief flat] -text "Results"
	$major.tabs add [frame $major.tabs.tabInput -background #b3dbff -relief flat] -text "Input"
	
	
	#####################################################
	#####################################################
	################# TAB INPUT #########################
	#####################################################
	#####################################################
	#### Job Title
	set tInput $major.tabs.tabInput
	place [ttk::label $tInput.jobTitleLabel \
		-style gaussianVMD.cyan.TLabel \
		-text {Job Title:} ] -in $tInput -x 5 -y 5
	
	place [ttk::entry $tInput.jobTitleEntry \
		-style gaussianVMD.TEntry \
		-textvariable gaussianVMD::title ] -in $tInput -x 70 -y 5 -width 320

	#### Multiplicity and Gaussian Calculations Setup
	place [ttk::button $tInput.chargeMulti \
		    -text "Charge and Multiplicity" \
			-command {gaussianVMD::guiChargeMulti}] -in $tInput -x 5 -y 35 -width 190

	place [ttk::button $tInput.calcSetup \
		    -text "Calculation Setup" \
			-command {gaussianVMD::guiError "This feature is not available yet."} ] -in $tInput -x 205 -y 35 -width 190



	#####################################################
	#####################################################
	################# TAB RESULTS #######################
	#####################################################
	#####################################################

	set resultsHeight [expr $majorHeight - 30 - 30]

	set tResults $major.tabs.tabResults
	place [ttk::notebook $tResults.tabs \
		-style gaussianVMD.results.TNotebook \
		] -in $tResults -x 0 -y 0 -width 400 -height [expr $resultsHeight + 30]

	# Tabs Names
	$tResults.tabs add [frame $tResults.tabs.tab2 -background #ccffcc -relief flat] -text "Layer"
	$tResults.tabs add [frame $tResults.tabs.tab3 -background #ccffcc -relief flat] -text "Freeze"
	$tResults.tabs add [frame $tResults.tabs.tab4 -background #ccffcc -relief flat] -text "Charges"

	# Choose active tab
	$tResults.tabs select $tResults.tabs.tab2

	
	# Charges Tab
	place [tablelist::tablelist $tResults.tabs.tab4.tableLayer \
			-showeditcursor true \
			-columns {0 "Index" center 0 "Gaussian Atom" center 0 "Resname" center 0 "Resid" center 0 "Charges" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $tResults.tabs.tab4.yscb set] \
			-xscrollcommand [list $tResults.tabs.tab4.xscb set] \
			-selectmode extended \
			-height 14 \
			-state normal \
			-borderwidth 0 \
			-relief flat \
			] -in $tResults.tabs.tab4 -x 0 -y 0 -width 375 -height [expr $resultsHeight - 60]

	place [ttk::scrollbar $tResults.tabs.tab4.yscb \
			-orient vertical \
			-command [list $tResults.tabs.tab4.tableLayer yview]\
			] -in $tResults.tabs.tab4 -x 375 -y 0 -width 20 -height [expr $resultsHeight - 60]

	place [ttk::scrollbar $tResults.tabs.tab4.xscb \
			-orient horizontal \
			-command [list $tResults.tabs.tab4.tableLayer xview]\
			] -in $tResults.tabs.tab4 -x 0 -y [expr $resultsHeight - 60] -height 20 -width 375

	place [ttk::button $tResults.tabs.tab4.clearSelection \
			-text "Clear Selection" \
			-command {gaussianVMD::clearSelection charges} \
			-style gaussianVMD.blue.TButton \
			] -in $tResults.tabs.tab4 -x 8 -y [expr $resultsHeight - 40 + 8] -width 375

	$tResults.tabs.tab4.tableLayer configcolumns 0 -labelrelief raised 0 -labelbackground #b3dbff 0 -labelborderwidth 1
	$tResults.tabs.tab4.tableLayer configcolumns 1 -labelrelief raised 1 -labelbackground #b3dbff 1 -labelbd 1
	$tResults.tabs.tab4.tableLayer configcolumns 2 -labelrelief raised 2 -labelbackground #b3dbff 2 -labelbd 1
	$tResults.tabs.tab4.tableLayer configcolumns 3 -labelrelief raised 3 -labelbackground #b3dbff 3 -labelbd 1
	$tResults.tabs.tab4.tableLayer configcolumns 4 -editable true 4 -labelrelief raised 4 -labelbackground #b3dbff 4 -labelbd 1

	bind $tResults.tabs.tab4.tableLayer <<TablelistSelect>> {gaussianVMD::changeRepCurSelection charges}
#
#	# Layer Tab
#	place [tablelist::tablelist $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer\
#			-showeditcursor true \
#			-columns {0 "Index" center 0 "PDB Atom" center 0 "Resname" center 0 "Resid" center 0 "Layer" center} \
#			-stretch all \
#			-background white \
#			-yscrollcommand [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.yscb set] \
#			-xscrollcommand [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.xscb set] \
#			-selectmode extended \
#			-height 14 \
#			-state normal \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 0 -y 0 -width 370 -height 240
#
#	place [ttk::scrollbar $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.yscb \
#			-orient vertical \
#			-command [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer yview]\
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 370 -y 0 -width 20 -height 240
#
#	place [ttk::scrollbar $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.xscb \
#			-orient horizontal \
#			-command [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer xview]\
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 0 -y 240 -height 20 -width 370
#
#	place [ttk::label $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.selectionLabel \
#			-text {Atom selection (Change ONIOM layer):} \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 5 -y 265 -width 380
#
#	place [ttk::entry $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.selection \
#			-textvariable gaussianVMD::atomSelectionONIOM \
#			-style gaussianVMD.TEntry \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 5 -y 290 -width 375
#
#	place [ttk::combobox $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.selectModificationValue \
#			-textvariable gaussianVMD::selectionModificationValueOniom \
#			-style gaussianVMD.comboBox.TCombobox \
#			-values "[list "H" "M" "L"]" \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 5 -y 320 -width 118
#
#	place [ttk::button $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.selectionApply \
#			-text "Apply" \
#			-command {gaussianVMD::applyToStructure oniom} \
#			-style gaussianVMD.TButton \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 133 -y 320 -width 118
#
#	place [ttk::button $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.clearSelection \
#			-text "Clear Selection" \
#			-command {gaussianVMD::clearSelection oniom} \
#			-style gaussianVMD.TButton \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2 -x 261 -y 320 -width 118
#
#	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer configcolumns 4 -editable true
#
#	bind $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer <<TablelistSelect>> {gaussianVMD::changeRepCurSelection oniom}
#
#	
#	# Freeze Tab
#	place [tablelist::tablelist $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer\
#			-showeditcursor true \
#			-columns {0 "Index" center 0 "PDB Atom" center 0 "Resname" center 0 "Resid" center 0 "Freeze" center} \
#			-stretch all \
#			-background white \
#			-yscrollcommand [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.yscb set] \
#			-xscrollcommand [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.xscb set] \
#			-selectmode extended \
#			-height 14 \
#			-state normal \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 0 -y 0 -width 370 -height 240
#
#	place [ttk::scrollbar $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.yscb \
#			-orient vertical \
#			-command [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer yview]\
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 370 -y 0 -width 20 -height 240
#
#	place [ttk::scrollbar $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.xscb \
#			-orient horizontal \
#			-command [list $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer xview]\
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 0 -y 240 -height 20 -width 370
#
#	place [ttk::label $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.selectionLabel \
#			-text {Atom selection (Change freezing state):} \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 5 -y 265 -width 380
#
#	place [ttk::entry $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.selection \
#			-textvariable gaussianVMD::atomSelectionFreeze\
#			-style gaussianVMD.TEntry \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 5 -y 290 -width 375
#
#	place [ttk::combobox $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.selectModificationValue \
#			-textvariable gaussianVMD::selectionModificationValueFreeze \
#			-style gaussianVMD.comboBox.TCombobox \
#			-values "[list "0" "-1" "-2" "-3"]" \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 5 -y 320 -width 118
#
#	place [ttk::button $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.selectionApply \
#			-text "Apply" \
#			-command {gaussianVMD::applyToStructure freeze} \
#			-style gaussianVMD.TButton \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 133 -y 320 -width 118
#
#	place [ttk::button $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.clearSelection \
#			-text "Clear Selection" \
#			-command {gaussianVMD::clearSelection freeze} \
#			-style gaussianVMD.TButton \
#			] -in $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3 -x 261 -y 320 -width 118
#
#	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer configcolumns 4 -editable true
#
#	bind $gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer <<TablelistSelect>> {gaussianVMD::changeRepCurSelection freeze}
#
	pack [canvas $gaussianVMD::topGui.frame0.rep -bg #ededed -width 400 -height 105 -highlightthickness 0 -relief raised] -in $gaussianVMD::topGui.frame0
	set rep $gaussianVMD::topGui.frame0.rep

	place [ttk::label $rep.quickRepLabel \
			-text {Representations} \
			-style gaussianVMD.grayCenter.TLabel \
			] -in $rep -x 0 -y 5 -width 400

	place [ttk::checkbutton $rep.showHL \
			-text "High Layer" \
			-variable gaussianVMD::HLrep \
			-command {gaussianVMD::onOffRepresentation 2} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 5 -y 30 -width 123

	place [ttk::checkbutton $rep.showML \
			-text "Medium Layer" \
			-variable gaussianVMD::MLrep \
			-command {gaussianVMD::onOffRepresentation 3} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 138 -y 30 -width 123

	place [ttk::checkbutton $rep.showLL \
			-text "Low Layer" \
			-variable gaussianVMD::LLrep \
			-command {gaussianVMD::onOffRepresentation 4} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 271 -y 30 -width 123

	place [ttk::checkbutton $rep.unfreeze \
			-text "Unfreeze" \
			-variable gaussianVMD::unfreezeRep \
			-command {gaussianVMD::onOffRepresentation 8} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 5 -y 55 -width 123

	place [ttk::checkbutton $rep.freezeMinusOne \
			-text "Freeze" \
			-variable gaussianVMD::freezeRep \
			-command {gaussianVMD::onOffRepresentation 9} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 138 -y 55 -width 123

	place [ttk::checkbutton $rep.all \
			-text "All" \
			-variable gaussianVMD::allRep \
			-command {gaussianVMD::onOffRepresentation 13} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 271 -y 55 -width 123

	place [ttk::checkbutton $rep.protein \
			-text "Protein" \
			-variable gaussianVMD::proteinRep \
			-command {gaussianVMD::onOffRepresentation 5} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 5 -y 80 -width 123

	place [ttk::checkbutton $rep.nonProtein \
			-text "Non-Protein" \
			-variable gaussianVMD::nonproteinRep \
			-command {gaussianVMD::onOffRepresentation 6} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 138 -y 80 -width 123

	place [ttk::checkbutton $rep.water \
			-text "Water" \
			-variable gaussianVMD::waterRep \
			-command {gaussianVMD::onOffRepresentation 7} \
			-style gaussianVMD.TCheckbutton \
			] -in $rep -x 271 -y 80 -width 123





	#### Toolbar Menu Bootom
	pack [canvas $gaussianVMD::topGui.frame0.bottomToolbar -bg #b3dbff -width 400 -height 40 -highlightthickness 0 -relief raised] -in $gaussianVMD::topGui.frame0
	place [ttk::frame $gaussianVMD::topGui.frame0.bottomToolbar.frame -style gaussianVMD.menuBar.TFrame] -in $gaussianVMD::topGui.frame0.bottomToolbar -x 0 -y 0 -width 400 -height 40

	set tbar $gaussianVMD::topGui.frame0.bottomToolbar.frame
	place [ttk::button $tbar.resetView \
			-text "Reset View" \
			-command {display resetview} \
			-style gaussianVMD.reset.TButton \
			] -in $tbar -x 17 -y 5 -width 30
	tooltip::tooltip $tbar.resetView "Reset View"

	place [ttk::button $tbar.centerAtom \
			-text "Center atom" \
			-command {mouse mode center} \
			-style gaussianVMD.center.TButton \
			] -in $tbar -x 57 -y 5 -width 30
	tooltip::tooltip $tbar.centerAtom "Center atom"

	place [ttk::button $tbar.deleteAllLabels \
			-text "Delete all labels" \
			-command {gaussianVMD::deleteAllLabels} \
			-style gaussianVMD.deleteAllLabels.TButton \
			] -in $tbar -x 97 -y 5 -width 30
	tooltip::tooltip $tbar.deleteAllLabels "Delete all labels"

	place [ttk::button $tbar.mouseModeRotate \
			-text "Mouse mode: Rotate" \
			-command {mouse mode rotate} \
			-style gaussianVMD.mouseModeRotate.TButton \
			] -in $tbar -x 145 -y 5 -width 30
	tooltip::tooltip $tbar.mouseModeRotate "Mouse mode: Rotate"

	place [ttk::button $tbar.mouseModeTranslate \
			-text "Mouse mode: Translate" \
			-command {mouse mode translate} \
			-style gaussianVMD.mouseModeTranslate.TButton \
			] -in $tbar -x 185 -y 5 -width 30
	tooltip::tooltip $tbar.mouseModeTranslate "Mouse mode: Translate"

	place [ttk::button $tbar.mouseModeScale \
			-text "Mouse mode: Scale" \
			-command {mouse mode scale} \
			-style gaussianVMD.mouseModeScale.TButton \
			] -in $tbar -x 225 -y 5 -width 30
	tooltip::tooltip $tbar.mouseModeScale "Mouse mode: Scale"

	place [ttk::button $tbar.bondEdit \
			-text "Modify bond" \
			-command {gaussianVMD::bondModifInitialProc} \
			-style gaussianVMD.bondEdit.TButton \
			] -in $tbar -x 273 -y 5 -width 30
	tooltip::tooltip $tbar.bondEdit "Modify bond"

	place [ttk::button $tbar.angleEdit \
			-text "Modify angle" \
			-command {gaussianVMD::angleModifInitialProc} \
			-style gaussianVMD.angleEdit.TButton \
			] -in $tbar -x 313 -y 5 -width 30
	tooltip::tooltip $tbar.angleEdit "Modify angle"

	place [ttk::button $tbar.dihedralEdit \
			-text "Modify dihedral" \
			-command {gaussianVMD::dihedModifInitialProc} \
			-style gaussianVMD.dihedralEdit.TButton \
			] -in $tbar -x 353 -y 5 -width 30
	tooltip::tooltip $tbar.dihedralEdit "Modify dihedral"

}



proc gaussianVMD::getMolinfoList {} {
	set gaussianVMD::molinfoList {}
	
	set a [molinfo top]

	if {$a == -1} {
		set gaussianVMD::topMolecule "No molecule"
	} else {
		set gaussianVMD::topMolecule "[molinfo top] : [molinfo top get name]"

		set list [molinfo list]
		foreach mol $list {
			set molDetails "$mol : [molinfo $mol get name]"
			lappend gaussianVMD::molinfoList $molDetails
		}
	}

	$gaussianVMD::topGui.frame0.molSelection.combo configure -values $gaussianVMD::molinfoList
}


proc gaussianVMD::activateMolecule {} {
	## Set molecule to top
	mol top [lindex $gaussianVMD::topMolecule 0]

	## Delete previous info
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer delete 0 end
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer delete 0 end
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer delete 0 end

	## Add info to tables
	set sel [atomselect top all]
	set index [$sel get index]
	set type [$sel get type]
	set name [$sel get name]
	set resname [$sel get resname]
	set resid [$sel get resid]


	# Index
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer insertlist end $index
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer insertlist end $index
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer insertlist end $index

	# Atom Type
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer columnconfigure 1 -text $type
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer columnconfigure 1 -text $name
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer columnconfigure 1 -text $name

	# Resname
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer columnconfigure 2 -text $resname
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer columnconfigure 2 -text $resname
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer columnconfigure 2 -text $resname
	
	# Resid
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer columnconfigure 3 -text $resid
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer columnconfigure 3 -text $resid
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer columnconfigure 3 -text $resid

	# Specific
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab4.tableLayer columnconfigure 4 -text [$sel get charge] -formatcommand {format %.8s}
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab2.tableLayer columnconfigure 4 -text [$sel get altloc]
	$gaussianVMD::topGui.frame0.tabs.tabsAtomList.tab3.tableLayer columnconfigure 4 -text [$sel get user]
}

proc gaussianVMD::updateStructures {args} {
	set gaussianVMD::allRep "1"

	gaussianVMD::getMolinfoList
	gaussianVMD::activateMolecule
	gaussianVMD::addSelectionRep
}