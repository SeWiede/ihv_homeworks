vlib work
vcom ../common/common_pkg.vhd
vcom -pslfile ex3.psl ex3.vhd
vsim ex3
add wave *
run -all