package provide addAtom 1.0

proc molUP::pickRefAtom {} {
    ## Clear the pickedAtoms variable
	set molUP::pickedAtoms {}
	## Trace the variable to run a command each time a atom is picked
    trace variable ::vmd_pick_atom w molUP::refAtomPicked
	## Activate atom pick
	mouse mode pick
}

proc molUP::refAtomPicked {args} {
  
}