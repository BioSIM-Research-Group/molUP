package provide gui 1.0

proc molUP::buildGui {} {

	#### Window Configuration ##########################################

	#### Check if the window exists
	if {[winfo exists $::molUP::topGui]} {wm deiconify $::molUP::topGui ;return $::molUP::topGui}
	toplevel $::molUP::topGui

	#### Title of the windows
	wm title $molUP::topGui "molUP v$molUP::version " ;

	#### Change the location of window
	set sWidth [expr [winfo vrootwidth  $::molUP::topGui] -0]
	set sHeight [expr [winfo vrootheight $::molUP::topGui] -100]

	## window width and height
	set wWidth [winfo reqwidth $::molUP::topGui]
	set wHeight [winfo reqheight $::molUP::topGui]
	
	display reposition 0 [expr ${sHeight} - 15]
	display resize [expr $sWidth - 400] ${sHeight}

	set x [expr $sWidth - 2*($wWidth)]

	wm geometry $::molUP::topGui 400x$sHeight+$x+25
	$::molUP::topGui configure -background {white}
	wm resizable $::molUP::topGui 0 0

	## Procedure when the window is closed
	wm protocol $::molUP::topGui WM_DELETE_WINDOW {molUP::quit}

	## Apply theme
	ttk::style theme use molUPTheme
	


	####################################################################################################################
	####################################################################################################################
	####################################################################################################################




	#### Background ##########################################
	pack [ttk::frame $molUP::topGui.frame0]
	

	## Top Menu Bar ##########################################
	pack [canvas $molUP::topGui.frame0.topSection -bg #ededed -width 400 -height 50 -highlightthickness 0] -in $molUP::topGui.frame0 
	place [ttk::frame $molUP::topGui.frame0.topSection.topMenu -width 400 -style molUP.menuBar.TFrame] -in $molUP::topGui.frame0.topSection -x 0 -y 0 -width 400 -height 35
	
	place [ttk::menubutton $molUP::topGui.frame0.topSection.topMenu.file -text "File" -menu $molUP::topGui.frame0.topSection.topMenu.file.menu \
			-style molUP.menuBar.TMenubutton \
			] -in $molUP::topGui.frame0.topSection.topMenu -x 5 -y 5 -height 25 -width 50  
	menu $molUP::topGui.frame0.topSection.topMenu.file.menu -tearoff 0
	$molUP::topGui.frame0.topSection.topMenu.file.menu add command -label "Open" -command {molUP::guiOpenFile}
	$molUP::topGui.frame0.topSection.topMenu.file.menu add command -label "Save" -command {molUP::guiSaveFile}
	#$molUP::topGui.frame0.topSection.topMenu.file.menu add command -label "Close" -command {molUP::quit}
	#$molUP::topGui.frame0.topSection.topMenu.file.menu add command -label "Close VMD" -command {exec exit}

	place [ttk::menubutton $molUP::topGui.frame0.topSection.topMenu.tools -text "Tools" -menu $molUP::topGui.frame0.topSection.topMenu.tools.menu \
			-style molUP.menuBar.TMenubutton \
			] -in $molUP::topGui.frame0.topSection.topMenu -x 54 -y 5 -height 25 -width 60
	menu $molUP::topGui.frame0.topSection.topMenu.tools.menu -tearoff 0
	$molUP::topGui.frame0.topSection.topMenu.tools.menu add command -label "Reset view" -command {display resetview}
	$molUP::topGui.frame0.topSection.topMenu.tools.menu add command -label "Center atom" -command {mouse mode center}
	$molUP::topGui.frame0.topSection.topMenu.tools.menu add command -label "Delete all labels" -command {molUP::deleteAllLabels}
	$molUP::topGui.frame0.topSection.topMenu.tools.menu add command -label "Mouse mode: Rotate" -command {mouse mode rotate}
	$molUP::topGui.frame0.topSection.topMenu.tools.menu add command -label "Mouse mode: Translate" -command {mouse mode translate}
	$molUP::topGui.frame0.topSection.topMenu.tools.menu add command -label "Mouse mode: Scale" -command {mouse mode scale}

	place [ttk::menubutton $molUP::topGui.frame0.topSection.topMenu.structure -text "Structure" -menu $molUP::topGui.frame0.topSection.topMenu.structure.menu \
			-style molUP.menuBar.TMenubutton \
			] -in $molUP::topGui.frame0.topSection.topMenu -x 120 -y 5 -height 25 -width 80
	menu $molUP::topGui.frame0.topSection.topMenu.structure.menu -tearoff 0
	$molUP::topGui.frame0.topSection.topMenu.structure.menu add command -label "Modify bond" -command {molUP::bondModifInitialProc}
	$molUP::topGui.frame0.topSection.topMenu.structure.menu add command -label "Modify angle" -command {molUP::angleModifInitialProc}
	$molUP::topGui.frame0.topSection.topMenu.structure.menu add command -label "Modify dihedral" -command {molUP::dihedModifInitialProc}


	place [ttk::menubutton $molUP::topGui.frame0.topSection.topMenu.about -text "About" -menu $molUP::topGui.frame0.topSection.topMenu.about.menu \
			-style molUP.menuBar.TMenubutton \
			] -in $molUP::topGui.frame0.topSection.topMenu -x 320 -y 5 -height 25 -width 70
	menu $molUP::topGui.frame0.topSection.topMenu.about.menu -tearoff 0
	$molUP::topGui.frame0.topSection.topMenu.about.menu add command -label "Help" -command {molUP::guiError "This feature is not available yet." "Available soon"}
	$molUP::topGui.frame0.topSection.topMenu.about.menu add command -label "Credits" -command {molUP::guiCredits}
	$molUP::topGui.frame0.topSection.topMenu.about.menu add command -label "Changelog" -command {molUP::guiChangelog}
	$molUP::topGui.frame0.topSection.topMenu.about.menu add command -label "Check for updates" -command {molUP::guiError "No updates available." "Updates"}


	## Molecule Selection #############################################
	pack [canvas $molUP::topGui.frame0.molSelection -bg #ededed -width 400 -height 35 -highlightthickness 0] -in $molUP::topGui.frame0

	place [ttk::label $molUP::topGui.frame0.molSelection.label \
			-style molUP.gray.TLabel \
			-text {Molecule } ] -in $molUP::topGui.frame0.molSelection -x 5 -y 2

	variable topMolecule "No molecule"
	variable molinfoList {}
	global ::vmd_molecule
	trace add variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
	place [ttk::combobox $molUP::topGui.frame0.molSelection.combo \
			-textvariable molUP::topMolecule \
			-style molUP.TCombobox \
			-values "$molUP::molinfoList" \
			-state readonly \
			] -in $molUP::topGui.frame0.molSelection -x 70 -y 0 -width 325
	bind $molUP::topGui.frame0.molSelection.combo <<ComboboxSelected>> {molUP::selectMolecule}

	
	## Results section ################################################ 
	set molUP::majorHeight [expr $sHeight - 230]
	pack [canvas $molUP::topGui.frame0.major -bg #ededed -width 400 -height $molUP::majorHeight -highlightthickness 0] -in $molUP::topGui.frame0
	

	## Representantions ################################################
	pack [canvas $molUP::topGui.frame0.rep -bg #ededed -width 400 -height 105 -highlightthickness 0 -relief raised] -in $molUP::topGui.frame0
	set rep $molUP::topGui.frame0.rep

	place [ttk::label $rep.quickRepLabel \
			-text {Representations} \
			-style molUP.grayCenter.TLabel \
			] -in $rep -x 0 -y 5 -width 400

	place [ttk::checkbutton $rep.showHL \
			-text "High Layer" \
			-variable molUP::HLrep \
			-command {molUP::onOffRepresentation 1} \
			-style molUP.TCheckbutton \
			] -in $rep -x 5 -y 30 -width 123

	place [ttk::checkbutton $rep.showML \
			-text "Medium Layer" \
			-variable molUP::MLrep \
			-command {molUP::onOffRepresentation 2} \
			-style molUP.TCheckbutton \
			] -in $rep -x 138 -y 30 -width 123

	place [ttk::checkbutton $rep.showLL \
			-text "Low Layer" \
			-variable molUP::LLrep \
			-command {molUP::onOffRepresentation 3} \
			-style molUP.TCheckbutton \
			] -in $rep -x 271 -y 30 -width 123

	place [ttk::checkbutton $rep.unfreeze \
			-text "Unfreeze" \
			-variable molUP::unfreezeRep \
			-command {molUP::onOffRepresentation 7} \
			-style molUP.TCheckbutton \
			] -in $rep -x 5 -y 55 -width 123

	place [ttk::checkbutton $rep.freezeMinusOne \
			-text "Freeze" \
			-variable molUP::freezeRep \
			-command {molUP::onOffRepresentation 8} \
			-style molUP.TCheckbutton \
			] -in $rep -x 138 -y 55 -width 123

	place [ttk::checkbutton $rep.all \
			-text "All" \
			-variable molUP::allRep \
			-command {molUP::onOffRepresentation 12} \
			-style molUP.TCheckbutton \
			] -in $rep -x 271 -y 55 -width 123

	place [ttk::checkbutton $rep.protein \
			-text "Protein" \
			-variable molUP::proteinRep \
			-command {molUP::onOffRepresentation 4} \
			-style molUP.TCheckbutton \
			] -in $rep -x 5 -y 80 -width 123

	place [ttk::checkbutton $rep.nonProtein \
			-text "Non-Protein" \
			-variable molUP::nonproteinRep \
			-command {molUP::onOffRepresentation 5} \
			-style molUP.TCheckbutton \
			] -in $rep -x 138 -y 80 -width 123

	place [ttk::checkbutton $rep.water \
			-text "Water" \
			-variable molUP::waterRep \
			-command {molUP::onOffRepresentation 6} \
			-style molUP.TCheckbutton \
			] -in $rep -x 271 -y 80 -width 123


	#### Toolbar Menu Bootom ################################################
	pack [canvas $molUP::topGui.frame0.bottomToolbar -bg #b3dbff -width 400 -height 40 -highlightthickness 0 -relief raised] -in $molUP::topGui.frame0
	place [ttk::frame $molUP::topGui.frame0.bottomToolbar.frame -style molUP.menuBar.TFrame] -in $molUP::topGui.frame0.bottomToolbar -x 0 -y 0 -width 400 -height 40

	set tbar $molUP::topGui.frame0.bottomToolbar.frame
	place [ttk::button $tbar.resetView \
			-text "Reset View" \
			-command {display resetview} \
			-style molUP.reset.TButton \
			] -in $tbar -x 17 -y 5 -width 30
	balloon $tbar.resetView -text "Reset View"

	place [ttk::button $tbar.centerAtom \
			-text "Center atom" \
			-command {mouse mode center} \
			-style molUP.center.TButton \
			] -in $tbar -x 57 -y 5 -width 30
	balloon $tbar.centerAtom -text "Center atom"

	place [ttk::button $tbar.deleteAllLabels \
			-text "Delete all labels" \
			-command {molUP::deleteAllLabels} \
			-style molUP.deleteAllLabels.TButton \
			] -in $tbar -x 97 -y 5 -width 30
	balloon $tbar.deleteAllLabels -text "Delete all labels"

	place [ttk::button $tbar.mouseModeRotate \
			-text "Mouse mode: Rotate" \
			-command {mouse mode rotate} \
			-style molUP.mouseModeRotate.TButton \
			] -in $tbar -x 145 -y 5 -width 30
	balloon $tbar.mouseModeRotate -text "Mouse mode: Rotate"

	place [ttk::button $tbar.mouseModeTranslate \
			-text "Mouse mode: Translate" \
			-command {mouse mode translate} \
			-style molUP.mouseModeTranslate.TButton \
			] -in $tbar -x 185 -y 5 -width 30
	balloon $tbar.mouseModeTranslate -text "Mouse mode: Translate"

	place [ttk::button $tbar.mouseModeScale \
			-text "Mouse mode: Scale" \
			-command {mouse mode scale} \
			-style molUP.mouseModeScale.TButton \
			] -in $tbar -x 225 -y 5 -width 30
	balloon $tbar.mouseModeScale -text "Mouse mode: Scale"

	place [ttk::button $tbar.bondEdit \
			-text "Modify bond" \
			-command {molUP::bondModifInitialProc} \
			-style molUP.bondEdit.TButton \
			] -in $tbar -x 273 -y 5 -width 30
	balloon $tbar.bondEdit -text "Modify bond"

	place [ttk::button $tbar.angleEdit \
			-text "Modify angle" \
			-command {molUP::angleModifInitialProc} \
			-style molUP.angleEdit.TButton \
			] -in $tbar -x 313 -y 5 -width 30
	balloon $tbar.angleEdit -text "Modify angle"

	place [ttk::button $tbar.dihedralEdit \
			-text "Modify dihedral" \
			-command {molUP::dihedModifInitialProc} \
			-style molUP.dihedralEdit.TButton \
			] -in $tbar -x 353 -y 5 -width 30
	balloon $tbar.dihedralEdit -text "Modify dihedral"




	#### Place results of current molecules ################################################	
	set molAlreadyLoaded [molinfo list]
	if {$molAlreadyLoaded == ""} {
		place [ttk::label $molUP::topGui.frame0.major.labelEmpty \
			-text "No molecule loaded." \
			-style molUP.gray.TLabel \
			] -in $molUP::topGui.frame0.major -x 125 -y [expr $molUP::majorHeight / 2]
	} else {
		# Launch a wait window
		molUP::guiError "Pleasy wait a moment...\nThis window closes automatically when all the tasks have finished." "Wait a moment..."
		
		foreach mol $molAlreadyLoaded {
			molUP::resultSection $mol $molUP::topGui.frame0.major $molUP::majorHeight
			set molUP::allRep "1"
			molUP::getMolinfoList
			molUP::collectMolInfo
			molUP::addSelectionRep
			molUP::activateMolecule $mol
		}
		
		# Pack TOP molecule
		set molID [molinfo top]
		pack $molUP::topGui.frame0.major.mol$molID
		
		# Destroy waiting window
		destroy $::molUP::error
	}

}

proc molUP::getMolinfoList {} {
	set molUP::molinfoList {}
	
	set a [molinfo top]

	if {$a == -1} {
		set molUP::topMolecule "No molecule"
	} else {
		set molUP::topMolecule "[molinfo top] : [molinfo top get name]"

		set list [molinfo list]
		foreach mol $list {
			set molDetails "$mol : [molinfo $mol get name]"
			lappend molUP::molinfoList $molDetails
		}
	}

	$molUP::topGui.frame0.molSelection.combo configure -values $molUP::molinfoList
}

proc molUP::selectMolecule {} {
	set mol [lindex $molUP::topMolecule 0]
	mol top $mol

	# Update charges
	molUP::getChargesSum none

	set molList [molinfo list]
	foreach molecule $molList {
		pack forget $molUP::topGui.frame0.major.mol$molecule
	}

	pack $molUP::topGui.frame0.major.mol$mol

	mol off all
	mol on $mol

	## Update representantion on/off status
	set molUP::HLrep [mol showrep $mol 1]
	set molUP::MLrep [mol showrep $mol 2]
	set molUP::LLrep [mol showrep $mol 3]
	set molUP::unfreezeRep [mol showrep $mol 7]
	set molUP::freezeRep [mol showrep $mol 8]
	set molUP::allRep [mol showrep $mol 12]
	set molUP::proteinRep [mol showrep $mol 4]
	set molUP::nonproteinRep [mol showrep $mol 5]
	set molUP::waterRep [mol showrep $mol 6]

}


proc molUP::activateMolecule {molID} {
	## Set molecule to top
	mol top [lindex $molUP::topMolecule 0]

	## Delete previous info
	$molUP::tableCharges delete 0 end
	$molUP::tableLayer delete 0 end
	$molUP::tableFreeze delete 0 end

	## Add info to tables
	set sel [atomselect top all]
	set index [$sel get index]
	set type [$sel get type]
	set name [$sel get name]
	set resname [$sel get resname]
	set resid [$sel get resid]


	# Index
	$molUP::tableCharges insertlist end $index
	$molUP::tableLayer insertlist end $index
	$molUP::tableFreeze insertlist end $index

	# Atom Type
	$molUP::tableCharges columnconfigure 1 -text $type
	$molUP::tableLayer columnconfigure 1 -text $name
	$molUP::tableFreeze columnconfigure 1 -text $name

	# Resname
	$molUP::tableCharges columnconfigure 2 -text $resname
	$molUP::tableLayer columnconfigure 2 -text $resname
	$molUP::tableFreeze columnconfigure 2 -text $resname
	
	# Resid
	$molUP::tableCharges columnconfigure 3 -text $resid
	$molUP::tableLayer columnconfigure 3 -text $resid
	$molUP::tableFreeze columnconfigure 3 -text $resid

	# Specific
	$molUP::tableCharges columnconfigure 4 -text [$sel get charge] -formatcommand {format %.5s}
	$molUP::tableFreeze columnconfigure 4 -text [$sel get user]
	$molUP::tableLayer columnconfigure 4 -text [$sel get altloc]
	
	#### Update input information
	set pos [lsearch $molUP::moleculeInfo "molID[molinfo top]"]
	set molUP::actualTitle [lindex $molUP::moleculeInfo [expr $pos +1]]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.keywordsText delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.keywordsText insert end [lindex $molUP::moleculeInfo [expr $pos +2]]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect insert end [lindex $molUP::moleculeInfo [expr $pos +4]]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param insert end [lindex $molUP::moleculeInfo [expr $pos +5]]

}


proc molUP::activateMoleculeNEW {molID} {
	## Set molecule to top
	mol top [lindex $molUP::topMolecule 0]

	## Delete previous info
	$molUP::tableCharges delete 0 end
	$molUP::tableLayer delete 0 end
	$molUP::tableFreeze delete 0 end

	$molUP::tableCharges insertlist end $molUP::structureReadyToLoadCharges
	$molUP::tableLayer insertlist end $molUP::structureReadyToLoadLayer
	$molUP::tableFreeze insertlist end $molUP::structureReadyToLoadFreeze

	#### Update input information
	set pos [lsearch $molUP::moleculeInfo "molID[molinfo top]"]
	set molUP::actualTitle [lindex $molUP::moleculeInfo [expr $pos +1]]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.keywordsText delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.keywordsText insert end [lindex $molUP::moleculeInfo [expr $pos +2]]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect insert end [lindex $molUP::moleculeInfo [expr $pos +4]]
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param insert end [lindex $molUP::moleculeInfo [expr $pos +5]]

}


proc molUP::updateStructures {} {

	# Launch a wait window
	molUP::guiError "Pleasy wait a moment...\nThis window closes automatically when all the tasks have finished." "Wait a moment..."
	
	set previousMol [molinfo list]
	foreach a $previousMol {
		pack forget $molUP::topGui.frame0.major.mol$a
	}

	set mol [lindex [molinfo list] end]
	molUP::resultSection $mol $molUP::topGui.frame0.major $molUP::majorHeight

	# Pack TOP molecule
	pack $molUP::topGui.frame0.major.mol$mol
	

	set molUP::allRep "1"
	molUP::getMolinfoList
	molUP::collectMolInfo
	molUP::activateMoleculeNEW $mol
	molUP::selectMolecule
	molUP::addSelectionRep

	molUP::guiChargeMulti $molUP::chargeMultiFrame

	molUP::checkTags .molUP.frame0.major.mol$mol.tabs.tabInput.keywordsText
		
	# Destroy waiting window
	destroy $::molUP::error
}

proc molUP::updateStructuresFromOtherSource {args} {

	# Launch a wait window
	molUP::guiError "Pleasy wait a moment...\nThis window closes automatically when all the tasks have finished." "Wait a moment..."
	
	set previousMol [molinfo list]
	foreach a $previousMol {
		pack forget $molUP::topGui.frame0.major.mol$a
	}

	set mol [lindex [molinfo list] end]
	molUP::resultSection $mol $molUP::topGui.frame0.major $molUP::majorHeight

	# Pack TOP molecule
	pack $molUP::topGui.frame0.major.mol$mol
	

	set molUP::allRep "1"
	molUP::getMolinfoList
	molUP::collectMolInfo
	molUP::activateMolecule $mol
	molUP::selectMolecule
	molUP::addSelectionRep

	molUP::guiChargeMulti $molUP::chargeMultiFrame

	molUP::checkTags .molUP.frame0.major.mol$mol.tabs.tabInput.keywordsText
		
	# Destroy waiting window
	destroy $::molUP::error
}


proc molUP::collectMolInfo {} {
	### Structure molID, title, keywords, charges/Milti, connectivity, parameters

	if {$molUP::connectivity == ""} {
		set molUP::connectivity [molUP::connectivityFromVMD]
	}

	lappend molUP::moleculeInfo "molID[molinfo top]" $molUP::title $molUP::keywordsCalc $molUP::chargesMultip $molUP::connectivity $molUP::parameters
	
	### Clear variables
	set molUP::title "Gaussian for VMD is a very good plugin :)"
	set molUP::keywordsCalc "%mem=7000MB\n%NProc=4\n%chk=name.chk\n\n# "
	set molUP::chargesMultip ""
	set molUP::connectivity ""
	set molUP::parameters ""

}


proc molUP::textSearch {w string tag} {
   $w tag remove search 0.0 end
   if {$string == ""} {
	return
   }
   set cur 1.0
   while 1 {
	set cur [$w search -nocase -count length $string $cur end]
	if {$cur == ""} {
	    break
	}
	$w tag add $tag $cur "$cur + $length char"
	set cur [$w index "$cur + $length char"]
   }
}

proc molUP::checkTags {pathName} {
	set calcTypes [list opt freq irc scf]
	foreach word $calcTypes {
		molUP::textSearch $pathName $word calcTypes
	}
	$pathName tag configure calcTypes -foreground red

	set oniom [list oniom]
	foreach word $oniom {
		molUP::textSearch $pathName $word oniom
	}
	$pathName tag configure oniom -foreground blue

	set functional [list uff dreiding amber]
	foreach word $functional {
		molUP::textSearch $pathName $word functional
	}
	$pathName tag configure functional -foreground grey

	set functionalSE [list pm6 am1 pddg pm3 pm3mm pm7 indo cndo]
	foreach word $functionalSE {
		molUP::textSearch $pathName $word functionalSE
	}
	$pathName tag configure functionalSE -foreground green

	set functionalDFT [list hf b3lyp lsda bpv86 b3pw91 mpw1pw91 pbepbe hseh1pbe hcth tpsstpss wb97xd mp2 mp4 ccsd bd casscf]
	foreach word $functionalDFT {
		molUP::textSearch $pathName $word functionalDFT
	}
	$pathName tag configure functionalDFT -foreground orange

	set basisset [list sto-3g * ** + ++ 3-21 6-31g 6-31+g 6-31++g (d (2d (3d (df (2df (3df ,p ,2p ,3p ,pd ,2pd ,3pd 6-311g 6-311+g 6-311++g cc-pvdz cc-pvtz cc-pvqz lanl2dz lanl2mb sdd dgdzvp dgdzvp2 dgdzvp gen genecp]
	foreach word $basisset {
		molUP::textSearch $pathName $word basisset
	}
	$pathName tag configure basisset -foreground "deep pink"

}



proc molUP::rebond {} {
	mol bondsrecalc top
	mol reanalyze top

	set molID [molinfo top]

	set connectivity [molUP::connectivityFromVMD]

	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect delete 1.0 end
	$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect insert end $connectivity
}

proc molUP::applyNewConnectivity {} {
	set molID [molinfo top]
	set molUP::connectivity [.molUP.frame0.major.mol$molID.tabs.tabInput.connect get 1.0 end]

	set connectList [molUP::convertGaussianInputConnectToVMD $molUP::connectivity]
	topo clearbonds
	topo setbondlist $connectList

}



proc molUP::resultSection {molID frame majorHeight} {
	pack [canvas $frame.mol$molID -bg #ededed -width 400 -height $molUP::majorHeight -highlightthickness 0] -in $frame

	set major $frame.mol$molID

	place [ttk::notebook $major.tabs \
		-style molUP.major.TNotebook
		] -in $major -x 0 -y 0 -width 400 -height $molUP::majorHeight
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
		-style molUP.cyan.TLabel \
		-text {Job Title} ] -in $tInput -x 5 -y 5
	
	place [text $tInput.jobTitleEntry \
		-yscrollcommand "$tInput.yscb0 set" \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		] -in $tInput -x 5 -y 30 -width 375 -height 25
	$tInput.jobTitleEntry insert end $molUP::title

	place [ttk::scrollbar $tInput.yscb0 \
			-orient vertical \
			-command [list $tInput.keywordsText yview]\
			] -in $tInput -x 380 -y 30 -width 15 -height 25

	place [ttk::label $tInput.keywordsLabel \
		-style molUP.cyan.TLabel \
		-text {Keyword calculations} ] -in $tInput -x 5 -y 60

	place [text $tInput.keywordsText \
		-yscrollcommand "$tInput.yscb set" \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		] -in $tInput -x 5 -y 85 -width 375 -height 80
	$tInput.keywordsText insert end $molUP::keywordsCalc
	
	bind $tInput.keywordsText <KeyPress> "molUP::checkTags $tInput.keywordsText"


	place [ttk::scrollbar $tInput.yscb \
			-orient vertical \
			-command [list $tInput.keywordsText yview]\
			] -in $tInput -x 380 -y 85 -width 15 -height 80

	set resultsHeight [expr $molUP::majorHeight - 30 - 30]
	set heightBox [expr ($resultsHeight - 405 - 25 - 10) / 2]

	#### Connectivity 
	place [ttk::label $tInput.connectLabel \
		-style molUP.cyan.TLabel \
		-text {Connectivity} ] -in $tInput -x 5 -y 380

	place [ttk::button $tInput.loadConnect \
		-style molUP.TButton \
		-command molUP::loadConnectivityFromOtherInputFile \
		-text {Load} ] -in $tInput -x 130 -y 378 -width 80
	
	place [ttk::button $tInput.applyNewConnectivity \
		-style molUP.TButton \
		-command molUP::applyNewConnectivity \
		-text {Apply} ] -in $tInput -x 220 -y 378 -width 80

	place [ttk::button $tInput.rebond \
		-style molUP.TButton \
		-command molUP::rebond \
		-text {Rebond} ] -in $tInput -x 310 -y 378 -width 80

	place [text $tInput.connect \
		-yscrollcommand "$tInput.yscb1 set" \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		] -in $tInput -x 5 -y 405 -width 375 -height $heightBox

	place [ttk::scrollbar $tInput.yscb1 \
			-orient vertical \
			-command [list $tInput.connect yview]\
			] -in $tInput -x 380 -y 405 -width 15 -height $heightBox

	#### Parameters 
	place [ttk::label $tInput.paramLabel \
		-style molUP.cyan.TLabel \
		-text {Other information (Parameters, Modredundant...)} ] -in $tInput -x 5 -y [expr 405 + $heightBox + 10]

	place [text $tInput.param \
		-yscrollcommand "$tInput.yscb2 set" \
		-bd 1 \
		-highlightcolor #017aff \
		-highlightthickness 1 \
		] -in $tInput -x 5 -y [expr 405 + $heightBox + 10 + 25] -width 375 -height $heightBox

	place [ttk::scrollbar $tInput.yscb2 \
			-orient vertical \
			-command [list $tInput.connect yview]\
			] -in $tInput -x 380 -y [expr 405 + $heightBox + 10 + 25] -width 15 -height $heightBox



	#####################################################
	#####################################################
	################# TAB RESULTS #######################
	#####################################################
	#####################################################

	set tResults $major.tabs.tabResults
	place [ttk::notebook $tResults.tabs \
		-style molUP.results.TNotebook \
		] -in $tResults -x 0 -y 0 -width 400 -height [expr $resultsHeight + 30]

	# Tabs Names
	$tResults.tabs add [frame $tResults.tabs.tab2 -background #ccffcc -relief flat] -text "Layer"
	$tResults.tabs add [frame $tResults.tabs.tab3 -background #ccffcc -relief flat] -text "Freeze"
	$tResults.tabs add [frame $tResults.tabs.tab4 -background #ccffcc -relief flat] -text "Charges"

	# Choose active tab
	$tResults.tabs select $tResults.tabs.tab2

	
	# Charges Tab
	variable tableCharges $tResults.tabs.tab4.tableLayer
	place [tablelist::tablelist $tResults.tabs.tab4.tableLayer \
			-showeditcursor true \
			-columns {0 "Index" center 0 "Gaussian Atom Type" center 0 "Resname" center 0 "Resid" center 0 "Charges" center} \
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
			-command {molUP::clearSelection charges} \
			-style molUP.blue.TButton \
			] -in $tResults.tabs.tab4 -x 8 -y [expr $resultsHeight - 40 + 8] -width 375

	$tResults.tabs.tab4.tableLayer configcolumns 0 -labelrelief raised 0 -labelbackground #b3dbff 0 -labelborderwidth 1
	$tResults.tabs.tab4.tableLayer configcolumns 1 -labelrelief raised 1 -labelbackground #b3dbff 1 -labelbd 1
	$tResults.tabs.tab4.tableLayer configcolumns 2 -labelrelief raised 2 -labelbackground #b3dbff 2 -labelbd 1
	$tResults.tabs.tab4.tableLayer configcolumns 3 -labelrelief raised 3 -labelbackground #b3dbff 3 -labelbd 1
	$tResults.tabs.tab4.tableLayer configcolumns 4 -editable true 4 -labelrelief raised 4 -labelbackground #b3dbff 4 -labelbd 1

	bind $tResults.tabs.tab4.tableLayer <<TablelistSelect>> {molUP::changeRepCurSelection charges}


	# Layer Tab
	variable tableLayer $tResults.tabs.tab2.tableLayer
	place [tablelist::tablelist $tResults.tabs.tab2.tableLayer \
			-showeditcursor true \
			-columns {0 "Index" center 0 "PDB Atom Type" center 0 "Resname" center 0 "Resid" center 0 "Layer" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $tResults.tabs.tab2.yscb set] \
			-xscrollcommand [list $tResults.tabs.tab2.xscb set] \
			-selectmode extended \
			-height 14 \
			-state normal \
			-borderwidth 0 \
			-relief flat \
			] -in $tResults.tabs.tab2 -x 0 -y 0 -width 375 -height [expr $resultsHeight - 120]

	place [ttk::scrollbar $tResults.tabs.tab2.yscb \
			-orient vertical \
			-command [list $tResults.tabs.tab2.tableLayer yview]\
			] -in $tResults.tabs.tab2 -x 375 -y 0 -width 20 -height [expr $resultsHeight - 120]

	place [ttk::scrollbar $tResults.tabs.tab2.xscb \
			-orient horizontal \
			-command [list $tResults.tabs.tab2.tableLayer xview]\
			] -in $tResults.tabs.tab2 -x 0 -y [expr $resultsHeight - 120] -height 20 -width 375

	place [ttk::label $tResults.tabs.tab2.selectionLabel \
			-text {Atom selection (Change ONIOM layer):} \
			-style molUP.lightGreen.TLabel \
			] -in $tResults.tabs.tab2 -x 5 -y [expr $resultsHeight - 100 + 5] -width 370

	place [ttk::entry $tResults.tabs.tab2.selection \
			-textvariable molUP::atomSelectionONIOM \
			-style molUP.TEntry \
			] -in $tResults.tabs.tab2 -x 5 -y [expr $resultsHeight - 100 + 35] -width 375
	#balloon $tResults.tabs.tab2.selection -text "You can also select atoms dragging in the list above"

	place [ttk::combobox $tResults.tabs.tab2.selectModificationValue \
			-textvariable molUP::selectionModificationValueOniom \
			-style molUP.green.TCombobox \
			-values "[list "H" "M" "L"]" \
			-state readonly \
			] -in $tResults.tabs.tab2 -x 5 -y [expr $resultsHeight - 100 + 65] -width 118
	#balloon $tResults.tabs.tab2.selectModificationValue -text "Choose a ONIOM layer - (H) High Layer, (M) Medium Layer and (L) Low Layer"

	place [ttk::button $tResults.tabs.tab2.selectionApply \
			-text "Apply" \
			-command {molUP::applyToStructure oniom} \
			-style molUP.blue.TButton \
			] -in $tResults.tabs.tab2 -x 133 -y [expr $resultsHeight - 100 + 65] -width 118

	place [ttk::button $tResults.tabs.tab2.clearSelection \
			-text "Clear Selection" \
			-command {molUP::clearSelection oniom} \
			-style molUP.blue.TButton \
			] -in $tResults.tabs.tab2 -x 261 -y [expr $resultsHeight - 100 + 65] -width 118

	$tResults.tabs.tab2.tableLayer configcolumns 0 -labelrelief raised 0 -labelbackground #b3dbff 0 -labelborderwidth 1
	$tResults.tabs.tab2.tableLayer configcolumns 1 -labelrelief raised 1 -labelbackground #b3dbff 1 -labelbd 1
	$tResults.tabs.tab2.tableLayer configcolumns 2 -labelrelief raised 2 -labelbackground #b3dbff 2 -labelbd 1
	$tResults.tabs.tab2.tableLayer configcolumns 3 -labelrelief raised 3 -labelbackground #b3dbff 3 -labelbd 1
	$tResults.tabs.tab2.tableLayer configcolumns 4 -editable true 4 -labelrelief raised 4 -labelbackground #b3dbff 4 -labelbd 1

	bind $tResults.tabs.tab2.tableLayer <<TablelistSelect>> {molUP::changeRepCurSelection oniom}

	
	# Freeze Tab
	variable tableFreeze $tResults.tabs.tab3.tableLayer
	place [tablelist::tablelist $tResults.tabs.tab3.tableLayer\
			-showeditcursor true \
			-columns {0 "Index" center 0 "PDB Atom Type" center 0 "Resname" center 0 "Resid" center 0 "Freeze" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $tResults.tabs.tab3.yscb set] \
			-xscrollcommand [list $tResults.tabs.tab3.xscb set] \
			-selectmode extended \
			-height 14 \
			-state normal \
			-borderwidth 0 \
			-relief flat \
			] -in $tResults.tabs.tab3 -x 0 -y 0 -width 375 -height [expr $resultsHeight - 120]

	place [ttk::scrollbar $tResults.tabs.tab3.yscb \
			-orient vertical \
			-command [list $tResults.tabs.tab3.tableLayer yview]\
			] -in $tResults.tabs.tab3 -x 375 -y 0 -width 20 -height [expr $resultsHeight - 120]

	place [ttk::scrollbar $tResults.tabs.tab3.xscb \
			-orient horizontal \
			-command [list $tResults.tabs.tab3.tableLayer xview]\
			] -in $tResults.tabs.tab3 -x 0 -y [expr $resultsHeight - 120] -height 20 -width 375

	place [ttk::label $tResults.tabs.tab3.selectionLabel \
			-text {Atom selection (Change freezing state):} \
			-style molUP.lightGreen.TLabel \
			] -in $tResults.tabs.tab3 -x 5 -y [expr $resultsHeight - 100 + 5] -width 370

	place [ttk::entry $tResults.tabs.tab3.selection \
			-textvariable molUP::atomSelectionFreeze\
			-style molUP.TEntry \
			] -in $tResults.tabs.tab3 -x 5 -y [expr $resultsHeight - 100 + 35] -width 375
	#balloon $tResults.tabs.tab3.selection -text "You can also select atoms dragging in the list above"

	place [ttk::combobox $tResults.tabs.tab3.selectModificationValue \
			-textvariable molUP::selectionModificationValueFreeze \
			-style molUP.green.TCombobox \
			-values "[list "0" "-1" "-2" "-3"]" \
			] -in $tResults.tabs.tab3 -x 5 -y [expr $resultsHeight - 100 + 65] -width 118
	#balloon $tResults.tabs.tab3.selectModificationValue -text "Choose freeze option"

	place [ttk::button $tResults.tabs.tab3.selectionApply \
			-text "Apply" \
			-command {molUP::applyToStructure freeze} \
			-style molUP.TButton \
			] -in $tResults.tabs.tab3 -x 133 -y [expr $resultsHeight - 100 + 65] -width 118

	place [ttk::button $tResults.tabs.tab3.clearSelection \
			-text "Clear Selection" \
			-command {molUP::clearSelection freeze} \
			-style molUP.TButton \
			] -in $tResults.tabs.tab3 -x 261 -y [expr $resultsHeight - 100 + 65] -width 118

	$tResults.tabs.tab3.tableLayer configcolumns 0 -labelrelief raised 0 -labelbackground #b3dbff 0 -labelborderwidth 1
	$tResults.tabs.tab3.tableLayer configcolumns 1 -labelrelief raised 1 -labelbackground #b3dbff 1 -labelbd 1
	$tResults.tabs.tab3.tableLayer configcolumns 2 -labelrelief raised 2 -labelbackground #b3dbff 2 -labelbd 1
	$tResults.tabs.tab3.tableLayer configcolumns 3 -labelrelief raised 3 -labelbackground #b3dbff 3 -labelbd 1
	$tResults.tabs.tab3.tableLayer configcolumns 4 -editable true 4 -labelrelief raised 4 -labelbackground #b3dbff 4 -labelbd 1

	bind $tResults.tabs.tab3.tableLayer <<TablelistSelect>> {molUP::changeRepCurSelection freeze}



	#### Charge and Multiplicity
	place [ttk::frame $tInput.chargeMulti \
		] -in $tInput -x 0 -y 170 -width 400 -height 200
	variable chargeMultiFrame $tInput.chargeMulti
	


	pack forget $frame.mol$molID
}



proc molUP::loadConnectivityFromOtherInputFile {} {
	 set fileTypes {
                {{Gaussian Input File (.com)}       {.com}        }
        }
        set path [tk_getOpenFile -filetypes $fileTypes -defaultextension ".com" -title "Choose a Gaussian Input File..."]
		set molID [molinfo top]
        if {$path != ""} {
            set firstConnect [expr [molUP::getBlankLines $path 2] + 1]
			set lastConnect [expr [molUP::getBlankLines $path 3] - 1]
			catch {exec sed -n "$firstConnect,$lastConnect p" $path} connectivity
			$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect delete 1.0 end
			$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.connect insert end $connectivity

			set firstParam [expr [molUP::getBlankLines $path 3] + 1]
			catch {exec sed -n "$firstParam,\$ p" $path} param
			$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param delete 1.0 end
			$molUP::topGui.frame0.major.mol$molID.tabs.tabInput.param insert end $param

			molUP::applyNewConnectivity

        } else {}
}