`timescale 1ps / 1ps
module library_top(in_mux, sel_mux, out_mux, ena_decoder, clock, in_register, out_register, clk, writeEnable, reset, sel_decoder, out_decoder, divided_clocks); // used to define a top level for this library
	input logic in_mux [63:0];
	input logic [5:0] sel_mux;
	output logic out_mux, out_register;
	input logic ena_decoder, clock, in_register, clk, writeEnable, reset;
	input logic [4:0] sel_decoder;
	output logic [31:0] out_decoder, divided_clocks;
	
	mux_64to1 mux_wrapper(.in(in_mux), .sel(sel_mux), .out(out_mux));
	decoder5_32 decoder_wrapper(.ena(ena_decoder), .sel(sel_decoder), .out(out_decoder));
	clock_divider cdiv_wrapper(.clock, .divided_clocks);
	register #(1) register_wrapper(.in(in_register), .clk, .reset, .writeEnable, .out(out_register));
endmodule

