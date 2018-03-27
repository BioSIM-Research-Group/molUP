package provide guiAddMolecule 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiAddMolecule {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::addMolecule]} {wm deiconify $::molUP::addMolecule ;return $::molUP::addMolecule}
	toplevel $::molUP::addMolecule
	wm attributes $::molUP::addMolecule -topmost yes

	#### Title of the windows
	wm title $molUP::addMolecule "Add Molecule" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::addMolecule] -0]
	set sHeight [expr [winfo vrootheight $::molUP::addMolecule] -50]

	#### Change the location of window
    wm geometry $::molUP::addMolecule 400x400+[expr $sWidth / 2 - 400]+200
	$::molUP::addMolecule configure -background {white}
	wm resizable $::molUP::addMolecule 0 0

	## Apply theme
	ttk::style theme use molUPTheme


    #### Information
	grid columnconfigure $molUP::addMolecule  0   -weight 1
    grid rowconfigure $molUP::addMolecule     1   -weight 1

	# Frame 0
	grid [ttk::frame $molUP::addMolecule.frame0] -in $molUP::addMolecule -row 0 -column 0 -sticky news

    # Initial Label
    grid [ttk::label $molUP::addMolecule.frame0.label \
		            -text "Select a molecule/fragment and pick an atom to place it." \
					-style molUP.TLabel \
		            ] -in $molUP::addMolecule.frame0 -row 0 -column 0 -sticky news -padx 20 -pady 10

	# Add Button
	grid [ttk::button $molUP::addMolecule.frame0.addButton \
		            -text "Add" \
					-command {molUP::addFragment} \
					-state disabled \
					-style molUP.TButton \
		            ] -in $molUP::addMolecule.frame0 -row 0 -column 1 -sticky news -padx [list 0 10]


	# Frame 1
	grid [ttk::frame $molUP::addMolecule.frame1] -in $molUP::addMolecule -row 1 -column 0 -sticky news

    # Tree View    
	grid [ttk::treeview  $molUP::addMolecule.frame1.tree \
			-yscroll "$molUP::addMolecule.frame1.treeVSB set" \
			-show tree \
			] -in $molUP::addMolecule.frame1 -row 0 -column 0 -sticky news -padx [list 10 0] -pady [list 0 10]
	
	bind $molUP::addMolecule.frame1.tree <<TreeviewSelect>> {
		set selection [$molUP::addMolecule.frame1.tree selection]

		set category [$molUP::addMolecule.frame1.tree parent $selection]
        set molecule [$molUP::addMolecule.frame1.tree item $selection -text]

		if {$category != ""} {
			set category [$molUP::addMolecule.frame1.tree item $category -text]

			# Enable Add button
			$molUP::addMolecule.frame0.addButton configure -state normal -command "molUP::applyAddMolecule [subst $category] [subst $molecule]"
		} else {
			set category ""
			set molecule ""

			# Disable Add button
			$molUP::addMolecule.frame0.addButton configure -state disabled -command ""
		}
	}


	grid [ttk::scrollbar $molUP::addMolecule.frame1.treeVSB \
			-orient vertical \
			-command "$molUP::addMolecule.frame1.tree yview" \
			] -in $molUP::addMolecule.frame1 -row 0 -column 1 -sticky ns -padx [list 0 10] -pady [list 0 10]

	grid columnconfigure $molUP::addMolecule.frame1  0   -weight 1
    grid rowconfigure $molUP::addMolecule.frame1     0   -weight 1


	# Fill the tree
	molUP::addMoleculePopulateTree
}



# Procedure to collect molecules
proc molUP::addMoleculePopulateTree {} {
	## Get the directories
	set dirs [glob -tails -type d -directory "$::molUPpath/molecules" *]
	set i 0
	foreach dir $dirs {
		# Add the dir to the tree
		$molUP::addMolecule.frame1.tree insert "" end -id $i -text $dir

		# Get subdirs
		set subdirs [glob -tails -type d -directory "$::molUPpath/molecules/$dir" *]

		foreach subdir $subdirs {
			$molUP::addMolecule.frame1.tree insert $i end -text "$subdir"
		}

		incr i
	}
}

# Add a certain molecule 
proc molUP::applyAddMolecule {category molecule} {
	mouse mode pick
	
	trace variable ::vmd_pick_atom w molUP::applyAddMoleculeA

	variable addMolCategory $category
	variable addMolMolecule $molecule

	# Close the GUI
	destroy $molUP::addMolecule
}

proc molUP::applyAddMoleculeA {args} {
	variable addAtomMolID $::vmd_pick_mol

	# Set up the variables
	set category $molUP::addMolCategory
	set molecule $molUP::addMolMolecule

	set filePath [open "$::molUPpath/molecules/$category/$molecule/mol.txt" r]
	set content [split [read $filePath] "\n"]
	close $filePath

	set coords true
	set listAddedAtoms {}
	foreach line $content {

		if {$line == ""} {
			set coords false
		}

		if {$coords == "true"} {
			# Add Atoms
			set freeAtoms [atomselect top "occupancy 0"]
    		set index [lindex [$freeAtoms get index] 0]
			lappend listAddedAtoms $index
    		$freeAtoms delete
    		set atomAdded [atomselect top "index $index"]

			# Make the atom Visible
    		$atomAdded set occupancy 1

			# Set informations about the atom
    		$atomAdded set element "[lindex $line 0]"
    		$atomAdded set name "[lindex $line 1]"
    		$atomAdded set type "[lindex $line 2]"
    		$atomAdded set charge "[lindex $line 4]"
    		$atomAdded set resname "[lindex $line 3]"
    		$atomAdded set resid "999"
    		$atomAdded set user "0"
    		$atomAdded set altloc "L"
			$atomAdded set x "[lindex $line 5]"
			$atomAdded set y "[lindex $line 6]"
			$atomAdded set z "[lindex $line 7]"


			set newLineTable [list [$atomAdded get index] [$atomAdded get element] [$atomAdded get name] [$atomAdded get type] [$atomAdded get resname] [$atomAdded get resid] [format %.6f [$atomAdded get charge]] [$atomAdded get altloc] [format %.0f [$atomAdded get user]] $::vmd_pick_atom $::vmd_pick_mol]
    		$molUP::addAtoms.frame0.frame.table insert end $newLineTable
			
		} else {
			# Add Connectivity
			if {$line != ""} {
				topo addbond [lindex $listAddedAtoms [lindex $line 0]] [lindex $listAddedAtoms [lindex $line 1]]
			}

		}
	}


	$molUP::addAtoms.frame0.frame.table selection clear anchor end
    $molUP::addAtoms.frame0.frame.table selection set [expr [$molUP::addAtoms.frame0.frame.table size] - [llength $listAddedAtoms]] end
    catch {molUP::addAtomMove}

	# Move Molecule
	set molUP::addAtomR 1
	molUP::addAtomMoveCommand

	# Remove Trace
	trace remove variable ::vmd_pick_atom write molUP::applyAddMoleculeA

}
