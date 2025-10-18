/* this module creates a full adder that adds or subtracts two 64 bit values, depending on the sel
Inputs:
	A: the first 64 bit input value
	B: the second 64 bit input value
	Cin: the carry in to the 64 bit full adder/subtractor
	sel: one bit control value that determines either A+B as the operation when sel is zero or A-B as the operation when sel is 1
Outputs:
	Sum: the result of the operation
	Cout: the carry out of the 64 bit add/subtract
*/
module adderSubtractor64(A, B, Cin, sel, Sum, Cout);
	input logic [63:0] A, B;
	input logic Cin, sel;
	output logic [63:0] Sum;
	output logic Cout;
	genvar i;
	logic [63:0] Carry_Wire;
	
	
	generate
		adderSubtractor firstAdd(.A(A[0]), .B(B[0]), .Cin(Cin), .sel(sel), .Sum(Sum[0]), .Cout(Carry_Wire[0]));
		for(i = 1; i < 64; i++)begin: adderSub // generates the adder subtractors
			adderSubtractor addSub(.A(A[i]), .B(B[i]), .Cin(Carry_Wire[i-1]), .sel(sel), .Sum(Sum[i]), .Cout(Carry_Wire[i]));
		end
	endgenerate
	
endmodule

module adderSubtractor64_tb();
	logic [63:0] A, B;
	logic	Cin, sel;
	logic [63:0] Sum;
	logic Cout;
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