package provide timeControl 1.5.1

proc molUP::duration { secs } {
     set timeatoms [ list ]
     if { [ catch {
        foreach div { 86400 3600 60 1 } \
                mod { 0 24 60 60 } \
               name { day hour min sec } {
           set n [ expr {$secs / $div} ]
           if { $mod > 0 } { set n [ expr {$n % $mod} ] }
           if { $n > 1 } {
              lappend timeatoms "$n ${name}s"
           } elseif { $n == 1 } {
             lappend timeatoms "$n ${name}"
           }
        }
     } err ] } {
        return -code error "duration: $err"
     }
     return [ join $timeatoms ]
}


proc molUP::tempo {time0 time1} {
       ## transformar o tempo num integer
       scan "$time0" "%dh %dm %ds   %s %s %s" h0 m0 s0 mt0 d0 y0
       scan "$time1" "%dh %dm %ds   %s %s %s" h1 m1 s1 mt1 d1 y1
       set time0 [clock scan "$h0:$m0:$s0 $mt0 $d0 $y0"]
       set time1 [clock scan "$h1:$m1:$s1 $mt1 $d1 $y1"]
       ## contas de diferença do tempo
       set timeD [expr abs ($time0-$time1)]
       set timeDiff "1 secs"
       if {$timeD!=0} {set timeDiff [molUP::duration $timeD]}
       return $timeDiff
}

proc molUP::t0 {} {
    set molUP::time0 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
}

proc molUP::t1 {} {
    set molUP::time1 [clock format [clock seconds] -format "%Hh %Mm %Ss   %d %b %y"]
    set result [molUP::tempo $molUP::time0 $molUP::time1]
    puts "Duration: $result"
}

