transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/controlUnit.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/math.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/register.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/regfile.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/mux_32to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/mux_16to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/demux_1to8.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/demux_1to4.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/decoder5_32.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/D_FF.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/mux_8to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/mux_4to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/mux_2to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/alu.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/adderSubtractor.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/norZeroFlag64bit.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/mux64bit_2to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/CPU_toplevel.sv}
vlog -sv -work work +incdir+C:/469labs/lab3 {C:/469labs/lab3/adderSubtractor64.sv}

