package provide quit 1.0

### Quit the plugin and remove the temporary files

proc molUP::quit {} \
{
	trace remove variable ::vmd_initialize_structure write molUP::updateStructures
	trace remove variable ::vmd_initialize_structure write molUP::updateStructuresFromOtherSource
	
	destroy $molUP::topGui

}