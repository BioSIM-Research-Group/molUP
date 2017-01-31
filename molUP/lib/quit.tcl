package provide quit 1.0

### Quit the plugin and remove the temporary files

proc molUP::quit {} \
{
	destroy $molUP::topGui 

	trace remove variable ::vmd_initialize_structure write molUP::updateStructures

}

proc molUP::restart {} \
{	
	destroy $molUP::topGui 

	mol off all

	molUP::buildGui

	trace remove variable ::vmd_initialize_structure write molUP::updateStructures
}