vlib work
vcom -2008 ../common/common_pkg.vhd
vcom -2008 -pslfile ex4.psl ex4.vhd
vsim ex4
add wave *
run -all