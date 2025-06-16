
file delete -force work

vlib work

#
# Compile the UUT
#
set cmd "vlog -F ../uut/files.f"
eval $cmd

#
# Compile the Agents
#
set tb_name avmm_mem
set agent_list {\ 
    avmm \
}
foreach  ele $agent_list {
puts "baaar"
  if {$ele != " "} {
    set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
    append cmd $ele " ../tb/" $ele "/" $ele "_pkg.sv ../tb/" $ele "/" $ele "_if.sv"
    eval $cmd
  }
}

#
# Compile rest of the testbench
#
set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/avmm_mem +incdir+../tb/"
append cmd $tb_name " ../tb/" $tb_name "/" $tb_name "_pkg.sv"
eval $cmd

set cmd  "vlog -sv +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_test/ ../tb/" $tb_name "_test/" $tb_name "_test_pkg.sv"
eval $cmd

set cmd  "vlog -sv -timescale 1ns/1ps +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_tb ../tb/" $tb_name "_tb/" $tb_name "_th.sv"
eval $cmd

set cmd  "vlog -sv -timescale 1ns/1ps +incdir+../tb/include +incdir+../tb/"
append cmd $tb_name "_tb ../tb/" $tb_name "_tb/" $tb_name "_tb.sv"
eval $cmd

# Turn on coverage export
coverage save -onexit avmm_mem.ucdb

# Run simulation
vsim avmm_mem_tb +UVM_TESTNAME=avmm_mem_test -voptargs=+acc -solvefaildebug -uvmcontrol=all -classdebug
log -r /*
run -all

