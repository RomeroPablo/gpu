if {[info exists ::env(SIM_VCD_NAME)] && $::env(SIM_VCD_NAME) ne ""} {
    set vcd_name $::env(SIM_VCD_NAME)
} else {
    set vcd_name "dump.vcd"
}

open_vcd $vcd_name
log_vcd *
run all
close_vcd
quit
