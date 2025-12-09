# read HDL
read_verilog ./src/top.v

# read constraints
read_xdc ./constraints/basys3.xdc

# synthesize
synth_design -top top -part xc7a35tcpg236-1

# optimize, place, route
opt_design
place_design
route_design

# write bitstream
write_bitstream -force top.bit
