package provide changeStructureData 1.6.2

proc molUP::changeResname {selection value} {
    set molID [lindex $molUP::topMolecule 0]

    set sel [atomselect $molID "$selection"]
    $sel set resname $value     ; # Apply new resname to the selection

    set index [$sel get index]
    foreach atom $index {
        .molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab2.tableLayer configcells [subst $atom],2 -text [subst $value]
        .molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab3.tableLayer configcells [subst $atom],2 -text [subst $value]
        .molUP.frame0.major.mol$molID.tabs.tabResults.tabs.tab4.tableLayer configcells [subst $atom],2 -text [subst $value]
    }

    $sel delete

}