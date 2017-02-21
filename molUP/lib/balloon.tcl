package provide balloon 1.0
 
 namespace eval ::balloon {
   proc this {} "return [namespace current];";
 
   variable state;
 
   array unset state;
   array set state {};
 
   proc balloon {w args} {
     variable state;
 
     if {[info exists state($w.background)]} {
       foreach var [array names $w.*] {
         set [lindex [split $var "."] end] $state($var);
       }
     } else {
       set background   lightyellow;
       set dismissdelay 5000;
       set foreground   black;
       set label        "";
       set showdelay    500;
       set text         "";
       set textvariable "";
     }
 
     foreach {option value} $args {
       set var  [string range $option 1 end];
 
       switch -exact -- $option {
         -bg         -
         -background -
         -fg         -
         -foreground {
           if {[string match "f*" $var]} {
             set var  foreground;
           } else {
             set var  background;
           }
 
           if {[catch {winfo rgb $parent $value;}]} {
             error "expected valid $var colour name or value, but got \"$value\"";
           }
         }
         -dismissdelay -
         -showdelay    {
           if {![string is integer -strict $value]} {
             error "expected integer delay value in ms, but got \"$value\"";
           }
         }
         -label        {}
         -text         {}
         -textvariable {}
         default  {
           error "bad option \"$option\": must be -background, -dismissdelay, -foreground, -label, -showdelay, or -text";
         }
       }
 
       set $var  $value;
     }
 
     array unset state $w.*;
 
     if {$showdelay == -1} {
       bind $w <Any-Enter> {};
       bind $w <Any-Leave> {};
       return;
     }

     set state($w.background)   $background;
     set state($w.foreground)   $foreground;
     set state($w.dismissdelay) $dismissdelay;
     set state($w.label)        $label;
     set state($w.showdelay)    $showdelay;
     set state($w.text)         $text;
     set state($w.textvariable) $textvariable;
 
 # FIX by [Vitus Wagner]
    if {$showdelay} {
      bind $w <Any-Enter> [list \
         after \
           $showdelay \
           [concat [namespace code showCB] %W] \
       ];
       bind $w <Any-Leave> [concat [namespace code destroyCB] %W];
     }
 
     return;
   }
 
   proc destroyCB {w} {
     variable state;
 
     catch {destroy $w.balloon;};
 
     if {[info exists state($w.id)] && ($state($w.id) != "")} {
       catch {after cancel $state($w.id);};
 
       set state($w.id)  "";
     }
 
     return;
   }
 
   proc showCB {w} {
     if {[eval winfo containing [winfo pointerxy .]] != $w} {
       return;
     }
     
     variable state;
 
     set top    $w.balloon;
     set width  0;
     set height 0;
 
     catch {destroy $top;}

    if {!$state($w.showdelay)} {
      return;
    }
 
     toplevel $top \
       -relief      solid \
       -background  $state($w.foreground) \
       -borderwidth 1;
 
     wm withdraw         $top;
     wm overrideredirect $top 1;
     wm sizefrom         $top program;
     wm resizable        $top 0 0;
 
     if {$state($w.label) != ""} {
       pack [label $top.label \
         -text       $state($w.label) \
         -background $state($w.background) \
         -foreground $state($w.foreground) \
         -font       {{San Serif} 8 bold} \
         -anchor     w \
         -justify    left \
       ] -side top -fill x -expand 0;
 
       update idletasks;
 
       set width  [winfo reqwidth $top.label];
       set height [winfo reqheight $top.label];
     }
 
     if {($state($w.text) != "") ||
         ($state($w.textvariable) != "")} {
       if {$state($w.textvariable) != ""} {
         upvar 0 $state($w.textvariable) textvariable;
 
         set state($w.text) $textvariable;
       }
       
       pack [message $top.text \
         -text       $state($w.text) \
         -background $state($w.background) \
         -foreground $state($w.foreground) \
         -font       {{San Serif} 8} \
         -aspect     10000 \
         -justify    left \
       ] -side top -fill x -expand 0;
 
       update idletasks;
 
       catch {
         if {$width < [winfo reqwidth $top.text]} {
           set width [winfo reqwidth $top.text];
         }
 
         incr height [winfo reqheight $top.text];
       }
     }
 
     catch {
       update idletasks;
 
       if {[winfo pointerx $w]+$width > [winfo screenwidth $w]} {
         set x [expr {[winfo screenwidth $w] - 10 - $width}];
       } else {
         set x [expr {[winfo pointerx $w] + 10}];
       }
       
       wm geometry $top \
         ${width}x${height}+${x}+[expr {[winfo pointery $w]+10}];
       wm deiconify $top;
 
       raise $top;
 
       set state($w.id) [after \
         $state($w.dismissdelay) \
         [concat [namespace code destroyCB] $w] \
       ];
     }
 
     return;
   }
 
   namespace export -clear balloon;
 }
 
 namespace import -force ::balloon::*;