package provide guiCredits 1.0
package require Tk

#### GUI ############################################################
proc molUP::guiCredits {} {

	#### Check if the window exists
	if {[winfo exists $::molUP::credits]} {wm deiconify $::molUP::credits ;return $::molUP::credits}
	toplevel $::molUP::credits

	#### Title of the windows
	wm title $molUP::credits "Credits" ;# titulo da pagina

	#### Change the location of window
	# screen width and height
	set sWidth [expr [winfo vrootwidth  $::molUP::credits] -0]
	set sHeight [expr [winfo vrootheight $::molUP::credits] -50]

	#### Change the location of window
    wm geometry $::molUP::credits 400x200+[expr $sWidth - 400]+100
	$::molUP::credits configure -background {white}
	wm resizable $::molUP::credits 0 0

	## Apply theme
	ttk::style theme use molUPTheme

    #### Information
    pack [ttk::frame $molUP::credits.frame0]
	pack [canvas $molUP::credits.frame0.frame -bg white -width 400 -height 200 -highlightthickness 0] -in $molUP::credits.frame0

	place [message $molUP::credits.frame0.frame.label1 \
		-text "molUP is a user friendly vmd plugin that reads any output or input file from Gaussian09. Several quick representations, tools, and options were included to a perfect user environment. \n molUP was developed by Henrique S. Fernandes and Nuno M.F.S.A. Cerqueira at the Computational Biochemistry Group of the Faculty of Sciences of the University of Porto. \n molUP is free and can be used with any porpose. However, if you use molUP, you should cite us. \n All rights reserved - 2017" \
		-width 380 \
	] -in $molUP::credits.frame0.frame -x 10 -y 10 -width 380 -height 180 -anchor nw -bordermode ignore

	place [ttk::button $molUP::credits.frame0.frame.visitWebsite \
		-text {Web Page} \
		-command {invokeBrowser "https://henriquefernandesblog.wordpress.com/2017/02/08/molup-a-vmd-macgyver-for-gaussian-files/"} \
		-style molUP.TButton \
		] -in $molUP::credits.frame0.frame -x 290 -y 165 -width 100


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