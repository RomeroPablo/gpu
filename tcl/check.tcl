read_verilog {src/top.v src/sw_pwm.v src/display.v}

read_xdc xdc/basys3.xdc

synth_design -top top -part xc7a35tcpg236-1

exit
