vlib work
vcom ../common/common_pkg.vhd
vcom pulse_clock_crosser.vhd
vcom -pslfile ex2.psl ex2.vhd
vsim ex2
add wave *
run -all
