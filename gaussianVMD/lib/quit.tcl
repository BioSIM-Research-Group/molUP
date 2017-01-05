package provide quit 1.0

### Quit the plugin and remove the temporary files

proc gaussianVMD::quit {} \
{
	destroy $gaussianVMD::topGui 

	removeTemporaryFiles
}

proc gaussianVMD::restart {} \
{
	destroy $gaussianVMD::topGui 

	removeTemporaryFiles

	gaussianVMD::buildGui
}


proc removeTemporaryFiles {} \
{
	exec rm -rf .temporary
}