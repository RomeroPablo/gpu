set proj_root [pwd]
set dut [lindex $argv 0]

if {$dut eq ""} {
puts "error: missing dut name"
exit 1
}

set out_dir "$proj_root/artifacts/${dut}"
file mkdir $out_dir
cd $out_dir

set src_file "$proj_root/src/${dut}.v"
set tb_file "$proj_root/sim/_${dut}.v"
set top "tb_${dut}"
set sim "sim_${dut}"

set env(SIM_VCD_NAME) "${sim}.vcd"

exec xvlog -sv $src_file
exec xvlog -sv $tb_file
exec xelab -debug typical $top -s $sim
exec xsim $sim -wdb ${sim}.wdb -tclbatch $proj_root/tcl/dump_vcd.tcl

exit
