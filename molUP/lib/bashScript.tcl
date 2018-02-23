######## Run molUP from bash ########
### Available for macOS and Linux ###
#####################################
############### Setup ###############
# Create a bash alias on your .bashrc or .bash_profile
# Example: alias molUP='vmd -e "<path of this file>" -args'
############ How to use? ############
# molUP <Gaussian filename>
#####################################
# Do not change the following lines #
#####################################
molUP::start
set molUP::path "[lindex $argv 0]"
if {$molUP::path != ""} {
    set fileExtension [molUP::fileExtension "$molUP::path"]
    molUP::loadBash $fileExtension
}
#####################################