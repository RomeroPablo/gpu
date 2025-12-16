set proj_root [pwd]
set out_dir "$proj_root/artifacts"
file mkdir $out_dir
cd $out_dir

exec xvlog -sv $proj_root/src/sw_pwm.v
exec xvlog -sv $proj_root/sim/_sw_pwm.v

exec xelab -debug typical tb_sw_pwm -s sim_sw_pwm

# Run and capture a WDB for viewing in Vivado/xsim GUI
exec xsim sim_sw_pwm -runall -vcdfile sim_sw_pwm.vcd
