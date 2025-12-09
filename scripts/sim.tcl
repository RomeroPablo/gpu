xvlog ./src/top.v
xvlog ./sim/top_tb.v

xelab top_tb -s sim_top

xsim sim_top -runall
