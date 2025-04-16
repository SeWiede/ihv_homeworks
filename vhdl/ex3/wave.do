onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ex3/clock
add wave -noupdate /ex3/rx_electrical
add wave -noupdate /ex3/rx_electrical_int
add wave -noupdate /ex3/tx_electrical
add wave -noupdate /ex3/tx_optical_int
add wave -noupdate /ex3/rx_optical
add wave -noupdate /ex3/rx_optical_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
