package provide quit 1.0

### Quit the plugin and remove the temporary files

proc gaussianVMD::quit {} \
{
	destroy $gaussianVMD::topGui 

	trace remove variable ::vmd_initialize_structure write gaussianVMD::updateStructures
}

proc gaussianVMD::restart {} \
{	
	destroy $gaussianVMD::topGui 

	mol off all

	gaussianVMD::buildGui

	trace remove variable ::vmd_initialize_structure write gaussianVMD::updateStructures
}