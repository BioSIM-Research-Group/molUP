package provide guiAddAtoms 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiAddAtoms {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::addAtoms]} {wm deiconify $::molUP::addAtoms ;return $::molUP::addAtoms}
	toplevel $::molUP::addAtoms
	wm attributes $::molUP::addAtoms -topmost yes

	#### Title of the windows
	wm title $molUP::addAtoms "Add Atoms" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::addAtoms] -0]
	set sHeight [expr [winfo vrootheight $::molUP::addAtoms] -50]

	#### Change the location of window
    wm geometry $::molUP::addAtoms 600x400+[expr $sWidth - 600]+100
	$::molUP::addAtoms configure -background {white}
	wm resizable $::molUP::addAtoms 0 0

    # Stop Tracing
	trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource

	# Actual molecule 
	set actualMol [molinfo top]

	set viewPoint [molinfo $actualMol get {center_matrix rotate_matrix scale_matrix global_matrix}]

    catch {mol new atoms 1000} mol
    animate dup $mol

	molinfo $actualMol set {center_matrix rotate_matrix scale_matrix global_matrix} $viewPoint
	molinfo $mol set {center_matrix rotate_matrix scale_matrix global_matrix} $viewPoint

	mol rename $mol "molUP_adding_atoms..."
	set selection [atomselect $mol "all"]
	$selection set occupancy 0
	mol representation Licorice 0.300000 15.000000 15.000000
	mol selection "occupancy 1"
	mol addrep $mol


	## Apply theme
	ttk::style theme use molUPTheme

	wm protocol $::molUP::addAtoms WM_DELETE_WINDOW {molUP::addAtomsGuiCloseSave}


    #### Information
	pack [ttk::frame $molUP::addAtoms.frame0]
	pack [canvas $molUP::addAtoms.frame0.frame -bg white -width 600 -height 400 -highlightthickness 0] -in $molUP::addAtoms.frame0 

    # Add Atom Button
    place [ttk::button $molUP::addAtoms.frame0.frame.addAtom \
		            -text "Add Atom" \
		            -command {molUP::guiPeriodicTable} \
					-style molUP.TButton \
		            ] -in $molUP::addAtoms.frame0.frame -x 10 -y 10 -width 75

    # Add Fragment Button
    place [ttk::button $molUP::addAtoms.frame0.frame.addFrag \
		            -text "Add Molecule/Fragment" \
		            -command {molUP::guiAddMolecule} \
					-style molUP.TButton \
		            ] -in $molUP::addAtoms.frame0.frame -x 95 -y 10 -width 190

    # Load external Molecular Button
   #place [ttk::button $molUP::addAtoms.frame0.frame.loadExternal \
		            -text "Add External Molecule" \
		            -command {} \
					-style molUP.TButton \
		            ] -in $molUP::addAtoms.frame0.frame -x 255 -y 10 -width 175

    place [tablelist::tablelist $molUP::addAtoms.frame0.frame.table \
			-showeditcursor true \
			-columns {0 "Index" center 0 "Element" center 0 "PDB Type" center 0 "Gaussian Type" center 0 "Resname" center 0 "Resid" center 0 "Charge" center 0 "Layer" center 0 "Freeze" center 0 "Anchor Index" center 0 "Anchor Mol" center} \
			-stretch all \
			-background white \
			-yscrollcommand [list $molUP::addAtoms.frame0.frame.yscb set] \
			-xscrollcommand [list $molUP::addAtoms.frame0.frame.xscb set] \
			-selectmode extended \
			-height 14 \
			-state normal \
			-borderwidth 0 \
			-relief flat \
			] -in $molUP::addAtoms.frame0.frame -x 10 -y 40 -width 560 -height 100

	bind $molUP::addAtoms.frame0.frame.table <<TablelistSelect>> {catch {molUP::addAtomMove}}
	$molUP::addAtoms.frame0.frame.table configcolumns 1 -editable 1 2 -editable 1 3 -editable 1 4 -editable 1 5 -editable 1 6 -editable 1 7 -editable 1 8 -editable 1
	$molUP::addAtoms.frame0.frame.table configure -editendcommand {molUP::applyAddAtomModification}

    place [ttk::scrollbar $molUP::addAtoms.frame0.frame.yscb \
			-orient vertical \
			-command [list $molUP::addAtoms.frame0.frame.table yview]\
			] -in $molUP::addAtoms.frame0.frame -x 570 -y 40 -width 20 -height 100

	place [ttk::scrollbar $molUP::addAtoms.frame0.frame.xscb \
			-orient horizontal \
			-command [list $molUP::addAtoms.frame0.frame.table xview]\
			] -in $molUP::addAtoms.frame0.frame -x 10 -y 140 -height 20 -width 560


	# Headers to define each part of the manipulation tools
	place [ttk::label $molUP::addAtoms.frame0.frame.moveLabel \
		    -text "Move" \
			-anchor center \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 0 -y 170 -width 300

	place [ttk::label $molUP::addAtoms.frame0.frame.rotateLabel \
		    -text "Rotate" \
			-anchor center \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 300 -y 170 -width 300


	# Manipulation of the atom - Translation
	place [ttk::label $molUP::addAtoms.frame0.frame.radiusLabel \
		    -text "Distance (Angstrom):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 10 -y 220 -width 120

	place [scale $molUP::addAtoms.frame0.frame.radius \
				-length 280 \
				-from 0.01 \
				-to 30.00 \
				-resolution 0.01 \
				-variable {molUP::addAtomR} \
				-command {molUP::addAtomMoveCommand} \
				-orient horizontal \
				-showvalue 1 \
				-state disabled \
			] -in $molUP::addAtoms.frame0.frame -x 130 -y 200 -width 160

	place [ttk::label $molUP::addAtoms.frame0.frame.angleAlabel \
		    -text "Angle A (Degrees):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 10 -y 260 -width 120

	place [scale $molUP::addAtoms.frame0.frame.angleA \
				-length 280 \
				-from 0.0 \
				-to 360.0 \
				-resolution 0.1 \
				-variable {molUP::addAtomAngleA} \
				-command {molUP::addAtomMoveCommand} \
				-orient horizontal \
				-showvalue 1 \
				-state disabled \
			] -in $molUP::addAtoms.frame0.frame -x 130 -y 240 -width 160

	
	place [ttk::label $molUP::addAtoms.frame0.frame.angleBlabel \
		    -text "Angle B (Degrees):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 10 -y 300 -width 120

	place [scale $molUP::addAtoms.frame0.frame.angleB \
				-length 280 \
				-from 0.0 \
				-to 360.0 \
				-resolution 0.1 \
				-variable {molUP::addAtomAngleB} \
				-command {molUP::addAtomMoveCommand} \
				-orient horizontal \
				-showvalue 1 \
				-state disabled \
			] -in $molUP::addAtoms.frame0.frame -x 130 -y 280 -width 160

	place [ttk::button $molUP::addAtoms.frame0.frame.deleteAtom \
		            -text "Delete" \
		            -command {molUP::addAtomDelete} \
					-style molUP.TButton \
					-state disabled \
		            ] -in $molUP::addAtoms.frame0.frame -x 515 -y 300 -width 75

	# Manipulation of the atom - Rotation
	place [ttk::label $molUP::addAtoms.frame0.frame.angleAlabelRot \
		    -text "Angle A (Degrees):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 310 -y 220 -width 120

	place [scale $molUP::addAtoms.frame0.frame.angleARot \
				-length 280 \
				-from 0.0 \
				-to 360.0 \
				-resolution 0.1 \
				-command {molUP::addAtomRotateCommand x} \
				-orient horizontal \
				-showvalue 1 \
				-state disabled \
			] -in $molUP::addAtoms.frame0.frame -x 430 -y 200 -width 160

	
	place [ttk::label $molUP::addAtoms.frame0.frame.angleBlabelRot \
		    -text "Angle B (Degrees):" \
			-style molUP.white.TLabel \
		    ] -in $molUP::addAtoms.frame0.frame -x 310 -y 260 -width 120

	place [scale $molUP::addAtoms.frame0.frame.angleBRot \
				-length 280 \
				-from 0.0 \
				-to 360.0 \
				-resolution 0.1 \
				-command {molUP::addAtomRotateCommand y} \
				-orient horizontal \
				-showvalue 1 \
				-state disabled \
			] -in $molUP::addAtoms.frame0.frame -x 430 -y 240 -width 160

	# Buttons to Apply and Cancel
    place [ttk::button $molUP::addAtoms.frame0.frame.apply \
		            -text "Finish & Add Atoms" \
		            -command {molUP::addAtomGuiApply} \
					-style molUP.TButton \
		            ] -in $molUP::addAtoms.frame0.frame -x 355 -y 360 -width 150
				
	place [ttk::button $molUP::addAtoms.frame0.frame.cancel \
		            -text "Cancel" \
		            -command {molUP::addAtomsGuiCloseSave} \
					-style molUP.TButton \
		            ] -in $molUP::addAtoms.frame0.frame -x 515 -y 360 -width 75

}

proc molUP::addAtomsGuiCloseSave {} {
	# Remove the adding molecule
	mol delete top

    mouse mode rotate
    
    set molExists [mol list]
    if {$molExists == "ERROR) No molecules loaded."} {
    } else {
        mol modselect 9 top "none"
    }

    destroy $::molUP::addAtoms

    # Re-Activate tracing
	trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource
}

proc molUP::addAtomGuiApply {} {
	# Mouse mode rotate
	mouse mode rotate

	# Stop Tracing
	trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource

	# Get the molid of the template molecule
	set molUP::addAtomMolID [lindex $molUP::topMolecule 0]

	# Merge the Molecules
	set addingAtomID [molinfo top]
    set selection1 [atomselect top "occupancy 1"]
    set selection2 [atomselect $molUP::addAtomMolID "all"]
	set selections [list [subst $selection2] [subst $selection1]]
	# Get the name of the top molecule
	set molName [molinfo $molUP::addAtomMolID get name]

	set mol [molUP::mergeMolecules $selections]

	$selection1 delete
	$selection2 delete

	# Get Parameters
    set parameters [.molUP.frame0.major.mol$molUP::addAtomMolID.tabs.tabInput.param get 1.0 end]

	# Update structures 
	molUP::updateStructuresFromOtherSource

	# Apply Parameters
    set molIDnew [molinfo top]
    .molUP.frame0.major.mol$molIDnew.tabs.tabInput.param insert end $parameters

	# Re-Activate tracing
	trace variable ::vmd_initialize_structure w molUP::updateStructuresFromOtherSource

	# Rename de molecule to the initial name
	mol rename top "[subst $molName]"

	# Delete the originary molecule
	mol delete $molUP::addAtomMolID
	mol delete $addingAtomID

	# Close the GUI
	destroy $::molUP::addAtoms
}


proc molUP::guiPeriodicTable {} {
	#### Check if the window exists
	if {[winfo exists $::molUP::periodicTable]} {wm deiconify $::molUP::periodicTable ;return $::molUP::periodicTable}
	toplevel $::molUP::periodicTable
	wm attributes $::molUP::periodicTable -topmost yes

	#### Title of the windows
	wm title $molUP::periodicTable "Periodic Table" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::periodicTable] -0]
	set sHeight [expr [winfo vrootheight $::molUP::periodicTable] -50]

	#### Change the location of window
    wm geometry $::molUP::periodicTable 600x350+[expr $sWidth / 2 - 600]+200
	$::molUP::periodicTable configure -background {white}
	wm resizable $::molUP::periodicTable 0 0

    # Stop Tracing
	trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource


	## Apply theme
	ttk::style theme use molUPTheme


    #### Information
	pack [ttk::frame $molUP::periodicTable.frame0]
	pack [canvas $molUP::periodicTable.frame0.frame -bg white -width 600 -height 350 -highlightthickness 0] -in $molUP::periodicTable.frame0 


	# Create the Periodic Table list
	set periodicTable [list \
		[list "H" 1 1] [list "He" 1 18] \
		[list "Li" 2 1] [list "Be" 2 2] [list "B" 2 13] [list "C" 2 14] [list "N" 2 15] [list "O" 2 16] [list "F" 2 17] [list "Ne" 2 18] \
		[list "Na" 3 1] [list "Mg" 3 2] [list "Al" 3 13] [list "Si" 3 14] [list "P" 3 15] [list "S" 3 16] [list "Cl" 3 17] [list "Ar" 3 18] \
		[list "K" 4 1] [list "Ca" 4 2] [list "Sc" 4 3] [list "Ti" 4 4] [list "V" 4 5] [list "Cr" 4 6] [list "Mn" 4 7] [list "Fe" 4 8] [list "Co" 4 9] [list "Ni" 4 10] [list "Cu" 4 11] [list "Zn" 4 12] [list "Ga" 4 13] [list "Ge" 4 14] [list "As" 4 15] [list "Se" 4 16] [list "Br" 4 17] [list "Kr" 4 18] \
		[list "Rb" 5 1] [list "Sr" 5 2] [list "Y" 5 3] [list "Zr" 5 4] [list "Nb" 5 5] [list "Mo" 5 6] [list "Tc" 5 7] [list "Ru" 5 8] [list "Rh" 5 9] [list "Pd" 5 10] [list "Ag" 5 11] [list "Cd" 5 12] [list "In" 5 13] [list "Sn" 5 14] [list "Sb" 5 15] [list "Te" 5 16] [list "I" 5 17] [list "Xe" 5 18] \
		[list "Cs" 6 1] [list "Ba" 6 2] [list "La" 6 3] [list "Hf" 6 4] [list "Ta" 6 5] [list "W" 6 6] [list "Re" 6 7] [list "Os" 6 8] [list "Ir" 6 9] [list "Pt" 6 10] [list "Au" 6 11] [list "Hg" 6 12] [list "Tl" 6 13] [list "Pb" 6 14] [list "Bi" 6 15] [list "Po" 6 16] [list "At" 6 17] [list "Rd" 6 18] \
		[list "Fr" 7 1] [list "Ra" 7 2] [list "Ac" 7 3] [list "Rf" 7 4] [list "Db" 7 5] [list "Sg" 7 6] [list "Bh" 7 7] [list "Hs" 7 8] [list "Mt" 7 9] [list "Ds" 7 10] [list "Rg" 7 11] [list "Cn" 7 12] [list "Uut" 7 13] [list "Fl" 7 14] [list "Uup" 7 15] [list "Lv" 7 16] [list "Uus" 7 17] [list "Uuo" 7 18] \
		[list "Ce" 9 3] [list "Pr" 9 4] [list "Nd" 9 5] [list "Pm" 9 6] [list "Sm" 9 7] [list "Eu" 9 8] [list "Gd" 9 9] [list "Tb" 9 10] [list "Dy" 9 11] [list "Ho" 9 12] [list "Er" 9 13] [list "Tm" 9 14] [list "Yb" 9 15] [list "Lu" 9 16] \
		[list "Th" 10 3] [list "Pa" 10 4] [list "U" 10 5] [list "Np" 10 6] [list "Pu" 10 7] [list "Am" 10 8] [list "Cm" 10 9] [list "Bk" 10 10] [list "Cf" 10 11] [list "Es" 10 12] [list "Fm" 10 13] [list "Md" 10 14] [list "No" 10 15] [list "Lr" 10 16] \
		]

	# Place the initial label
	place [ttk::label $molUP::periodicTable.frame0.frame.title \
		    -text "Select the atom to add. Then pick an atom to anchor the new atom." \
			-style molUP.white.TLabel \
		    ] -in $molUP::periodicTable.frame0.frame -x 30 -y 10 -width 380

	# Place the periodic Table
	set i 1
	foreach element $periodicTable {
		place [ttk::button $molUP::periodicTable.frame0.frame.$i \
		            -text "[lindex $element 0]" \
		            -command "molUP::addAtomElement [subst [lindex $element 0]]" \
					-style molUP.TButton \
		            ] -in $molUP::periodicTable.frame0.frame -x [expr [lindex $element 2] * 25 + [lindex $element 2] * 5] -y [expr [lindex $element 1] * 25 + [lindex $element 1] * 5 + 20] -width 25
	
	
	incr i
	
	}

}