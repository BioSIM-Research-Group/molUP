package provide quit 1.0

### Quit the plugin and remove the temporary files

proc gaussianVMD::quit {} \
{
	destroy $gaussianVMD::topGui 

	removeTemporaryFiles
}


proc removeTemporaryFiles {} \
{
	exec rm -r .temporary
}