onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ex2/clock
add wave -noupdate /ex2/state
add wave -noupdate /ex2/output
add wave -noupdate /ex2/eventCounter
add wave -noupdate /ex2/transCounter
add wave -noupdate /ex2/output_transaction
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {850000 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {941541 ps}
