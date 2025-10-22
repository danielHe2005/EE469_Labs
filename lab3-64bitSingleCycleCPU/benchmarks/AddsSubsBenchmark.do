onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /CPU_toplevel_tb/dut/clk
add wave -noupdate /CPU_toplevel_tb/dut/reset
add wave -noupdate /CPU_toplevel_tb/dut/instrAddress
add wave -noupdate /CPU_toplevel_tb/dut/PCPlus4
add wave -noupdate /CPU_toplevel_tb/dut/brAddress
add wave -noupdate /CPU_toplevel_tb/dut/brPlusPC
add wave -noupdate /CPU_toplevel_tb/dut/PCNext
add wave -noupdate /CPU_toplevel_tb/dut/CondAddr19
add wave -noupdate /CPU_toplevel_tb/dut/BrAddr26
add wave -noupdate /CPU_toplevel_tb/dut/instruction
add wave -noupdate /CPU_toplevel_tb/dut/Aw
add wave -noupdate /CPU_toplevel_tb/dut/Ab
add wave -noupdate /CPU_toplevel_tb/dut/Aa
add wave -noupdate /CPU_toplevel_tb/dut/AbFinal
add wave -noupdate /CPU_toplevel_tb/dut/shamt
add wave -noupdate /CPU_toplevel_tb/dut/Dw
add wave -noupdate /CPU_toplevel_tb/dut/Db
add wave -noupdate /CPU_toplevel_tb/dut/Da
add wave -noupdate /CPU_toplevel_tb/dut/result
add wave -noupdate /CPU_toplevel_tb/dut/mem_data
add wave -noupdate /CPU_toplevel_tb/dut/Imm64Bit
add wave -noupdate /CPU_toplevel_tb/dut/aluBIn
add wave -noupdate /CPU_toplevel_tb/dut/shiftResult
add wave -noupdate /CPU_toplevel_tb/dut/calculatedResult
add wave -noupdate /CPU_toplevel_tb/dut/Imm12
add wave -noupdate /CPU_toplevel_tb/dut/Imm9
add wave -noupdate /CPU_toplevel_tb/dut/aluFlagsIn
add wave -noupdate /CPU_toplevel_tb/dut/flags
add wave -noupdate /CPU_toplevel_tb/dut/BrTaken
add wave -noupdate /CPU_toplevel_tb/dut/UnCondBr
add wave -noupdate /CPU_toplevel_tb/dut/RegWrite
add wave -noupdate /CPU_toplevel_tb/dut/setFlags
add wave -noupdate /CPU_toplevel_tb/dut/MemWrite
add wave -noupdate /CPU_toplevel_tb/dut/MemToReg
add wave -noupdate /CPU_toplevel_tb/dut/ALUSrc
add wave -noupdate /CPU_toplevel_tb/dut/ITypetoB
add wave -noupdate /CPU_toplevel_tb/dut/Reg2Loc
add wave -noupdate /CPU_toplevel_tb/dut/shiftTrue
add wave -noupdate /CPU_toplevel_tb/dut/MemRead
add wave -noupdate /CPU_toplevel_tb/dut/ALUOp
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
WaveRestoreZoom {1149999050 ps} {1150000050 ps}
