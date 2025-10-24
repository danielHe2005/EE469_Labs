// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
`timescale 1ps / 1ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	logic [63:0] carry_wire, sum_wire;
	genvar i;
	
	generate
		adderSubtractor firstAdd(.A(A[0]), .B(B[0]), .Cin(cntrl[0]), .sel(cntrl[0]), .Sum(sum_wire[0]), .Cout(carry_wire[0]));
		for(i = 1; i < 64; i++)begin: adderSub // generates the adder subtractors
			adderSubtractor addSub(.A(A[i]), .B(B[i]), .Cin(carry_wire[i-1]), .sel(cntrl[0]), .Sum(sum_wire[i]), .Cout(carry_wire[i]));
		end
		for(i = 0; i < 64; i++)begin: mux64Bit // generate for the mux output
			logic bit_slice [7:0];
			assign bit_slice[0] = B[i];
			assign bit_slice[2] = sum_wire[i];
			assign bit_slice[3] = sum_wire[i];
			and #(50) bitAnd(bit_slice[4], A[i], B[i]); // bitwise and
			or #(50) bitOr(bit_slice[5], A[i], B[i]); // bitwise or
			xor #(50) bitXor(bit_slice[6], A[i], B[i]); // bitwise xor
			mux_8to1 outControl(.in(bit_slice), .sel(cntrl), .out(result[i]));
		end
	endgenerate
	
	// zero flag
	norZeroFlag64bit zeroFlag(.in(result), .out(zero));
	// negative flag
	assign negative = result[63];
	// overflow flag
	xor #(50) overflowFlag(overflow, carry_wire[62], carry_wire[63]);
	// carry out flag
	assign carry_out = carry_wire[63];
	
endmodule 