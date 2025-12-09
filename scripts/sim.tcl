# compile HDL
xvlog ./src/top.v
xvlog ./src/top_tb.v

# elaborate (build simulation model)
xelab top_tb -s sim_top

# run simulation
xsim sim_top -runall
