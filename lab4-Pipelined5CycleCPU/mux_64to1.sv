`timescale 1ps / 1ps
// 64 to 1 mux that chooses between one of sixty four choices in a 64 element array "in" depending on the sel input
module mux_64to1 (in, sel, out);
	input logic in [63:0];
	input logic [5:0] sel;
	output logic out;
	logic interOne, interTwo;
	mux_32to1 muxL0P1 (.in(in[63:32]), .sel(sel[4:0]), .out(interTwo)); // chooses between input 63-32 depending on the bottom 5 bit of sel
	mux_32to1 muxL0P2 (.in(in[31:0]), .sel(sel[4:0]), .out(interOne)); // chooses between input 31-0 depending on the bottom 5 bit of sel
	mux_2to1 muxL1P1 (.in1(interTwo), .in0(interOne), .sel(sel[5]), .out(out)); // chooses between the outcome of the first two muxes depending on the top bit of sel
endmodule