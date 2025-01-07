onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /computer_tb/DUT1/CPU_1/CU_1/clock
add wave -noupdate /computer_tb/DUT1/CPU_1/CU_1/current_state
add wave -noupdate /computer_tb/DUT1/CPU_1/IR_Load
add wave -noupdate /computer_tb/DUT1/CPU_1/IR
add wave -noupdate /computer_tb/DUT1/CPU_1/MAR_Load
add wave -noupdate /computer_tb/DUT1/CPU_1/DP_1/MAR
add wave -noupdate /computer_tb/DUT1/CPU_1/PC_Load
add wave -noupdate /computer_tb/DUT1/CPU_1/PC_inc
add wave -noupdate /computer_tb/DUT1/CPU_1/DP_1/PC
add wave -noupdate /computer_tb/DUT1/CPU_1/A_Load
add wave -noupdate /computer_tb/DUT1/CPU_1/DP_1/A
add wave -noupdate /computer_tb/DUT1/CPU_1/B_Load
add wave -noupdate /computer_tb/DUT1/CPU_1/DP_1/B
add wave -noupdate /computer_tb/DUT1/CPU_1/from_memory
add wave -noupdate /computer_tb/DUT1/CPU_1/to_memory
add wave -noupdate /computer_tb/DUT1/CPU_1/CU_1/Bus1_Sel
add wave -noupdate /computer_tb/DUT1/CPU_1/CU_1/Bus2_Sel
add wave -noupdate /computer_tb/DUT1/CPU_1/DP_1/Bus1
add wave -noupdate /computer_tb/DUT1/CPU_1/DP_1/Bus2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1050 ns}
