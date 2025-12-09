read_verilog ./src/top.v

read_xdc ./constr/basys3.xdc

synth_design -top top -part xc7a35tcpg236-1

opt_design
place_design
route_design

write_bitstream -force top.bit
