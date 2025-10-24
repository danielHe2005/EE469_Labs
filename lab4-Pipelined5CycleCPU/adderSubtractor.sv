/* This module adds or subtracts two one bit values, depending on sel
Inputs:
	A: the first 1 bit input
	B: the second 1 bit input
	Cin: the carry in
	sel: the control logic that determines whether to add or subtract. Zero means add and one means subtract
Outputs:
	Sum: the result of the operation
	Cout: the carry out of the operation
*/
`timescale 1ps / 1ps
module adderSubtractor(A, B, Cin, sel, Sum, Cout);
	input logic A, B, Cin, sel;
	output logic Sum, Cout;
	logic notB, B_Final, C_inter1, C_inter2, C_inter3;
	
	not #(50) b_inverse(notB, B);
	mux_2to1 b_or_inverse(.in1(notB), .in0(B), .sel(sel), .out(B_Final));
	
	xor #(50) sumLogic(Sum, A, B_Final, Cin);
	and #(50) and1(C_inter1, A, B_Final);
	and #(50) and2(C_inter2, A, Cin);
	and #(50) and3(C_inter3, B_Final, Cin);
	or #(50) or1(Cout, C_inter1, C_inter2, C_inter3);
	
endmodule

module adderSubtractor_tb();
	logic A, B, Cin, sel;
	logic Sum, Cout;
	int i;
	adderSubtractor dut(.A, .B, .Cin, .sel, .Sum, .Cout);
	
	initial begin
		for(i = 0; i < 16; i++)begin
			{A, B, Cin, sel} = i; #500;
			$display("Testing that A:%0b, B:%0b, Cin:%0b, sel:%0b results in the correct output", A, B, Cin, sel);
			if(sel)begin
				assert (int'(A+(~B&1'b1)+Cin) == int'({Cout, Sum})) else $error("Out is not %0b, and is instead %0b, test failed!", (A+(~B&1'b1)+Cin), {Cout, Sum});
			end else begin
				assert (int'(A+B+Cin) == int'({Cout, Sum})) else $error("Out is not %0b, and is instead %0b, test failed!", (A+B+Cin), {Cout, Sum});
			end
		end
	end
endmodule