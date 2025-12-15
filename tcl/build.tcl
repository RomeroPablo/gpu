read_verilog {src/top.v src/io_pwm.v src/display.v}

read_xdc xdc/basys3.xdc

synth_design -top top -part xc7a35tcpg236-1

opt_design
place_design
route_design

write_bitstream -force top.bit

set clkinfo [file join [pwd] clockInfo.txt]
if {[file exists $clkinfo]} {
      file delete -force $clkinfo
}

exit
