transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/register.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/mux_32to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/mux_16to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/mux_8to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/mux_4to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/mux_2to1.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/demux_1to8.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/demux_1to4.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/decoder5_32.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/D_FF.sv}
vlog -sv -work work +incdir+C:/469labs/lab1 {C:/469labs/lab1/regfile.sv}

