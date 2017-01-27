package provide guiCredits 1.0
package require Tk

#### GUI ############################################################
proc gaussianVMD::guiCredits {} {

	#### Check if the window exists
	if {[winfo exists $::gaussianVMD::credits]} {wm deiconify $::gaussianVMD::credits ;return $::gaussianVMD::credits}
	toplevel $::gaussianVMD::credits

	#### Title of the windows
	wm title $gaussianVMD::credits "Credits" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::gaussianVMD::credits] -0]
	set sHeight [expr [winfo vrootheight $::gaussianVMD::credits] -50]

	#### Change the location of window
    wm geometry $::gaussianVMD::credits 400x200+[expr $sWidth - 400]+100
	$::gaussianVMD::credits configure -background {white}
	wm resizable $::gaussianVMD::credits 0 0

	## Apply theme
	ttk::style theme use gaussianVMDTheme

    #### Information
    pack [ttk::frame $gaussianVMD::credits.frame0]
	pack [canvas $gaussianVMD::credits.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $gaussianVMD::credits.frame0

	place [message $gaussianVMD::credits.frame0.frame.label1 \
		-text "Gaussian for VMD is a user friendly vmd plugin that reads any output or input file from Gaussian09. Several quick representations, tools, and options were included to a perfect user environment. \n Gaussian for VMD was developed by Henrique S. Fernandes and Nuno M.F.S.A. Cerqueira at the Computational Biochemistry Group of the Faculty of Sciences of the University of Porto. \n Gaussian for VMD is free and can be used with any porpose. However, if you use Gaussian for VMD, you should cite us. \n All rights reserved - 2017" \
		-width 380 \
	] -in $gaussianVMD::credits.frame0.frame -x 10 -y 10 -width 380 -height 180 -anchor nw -bordermode ignore

	place [ttk::button $gaussianVMD::credits.frame0.frame.visitWebsite \
		-text {Web Page} \
		-command {invokeBrowser "https://henriquefernandesblog.wordpress.com"} \
		-style gaussianVMD.TButton \
		] -in $gaussianVMD::credits.frame0.frame -x 290 -y 165 -width 100


}


proc invokeBrowser {url} {
  # open is the OS X equivalent to xdg-open on Linux, start is used on Windows
  set commands {xdg-open open start}
  foreach browser $commands {
    if {$browser eq "start"} {
      set command [list {*}[auto_execok start] {}]
    } else {
      set command [auto_execok $browser]
    }
    if {[string length $command]} {
      break
    }
  }

  if {[string length $command] == 0} {
    return -code error "couldn't find browser"
  }
  if {[catch {exec {*}$command $url &} error]} {
    return -code error "couldn't execute '$command': $error"
  }
}