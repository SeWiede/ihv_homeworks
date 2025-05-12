vlib work
vcom ../common/common_pkg.vhd
vcom -pslfile ex1.psl ex1.vhd
vsim ex1
add wave *
run -all