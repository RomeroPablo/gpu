open_hw_manager
connect_hw_server
open_hw_target

set dev [lindex [get_hw_devices] 0]
refresh_hw_device $dev

set_property PROGRAM.FILE {./gpu.bit} $dev
program_hw_devices $dev
