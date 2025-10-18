`timescale 1ps / 1ps
module norZeroFlag64bit(in, out);
	input logic [63:0] in;
	output logic out;
	logic [15:0] inter1;
	logic [3:0] inter2;
	genvar i;
	
	generate
		for(i = 0; i < 16; i++)begin: outerOr
			or #(50) outer1(inter1[i], in[i*4], in[(i*4) + 1], in[(i*4) + 2], in[(i*4) + 3]); 
		end
		for(i = 0; i < 4; i++)begin: outerOr2
			or #(50) outer2(inter2[i], inter1[i*4], inter1[(i*4) + 1], inter1[(i*4) + 2], inter1[(i*4) + 3]);
		end
	endgenerate
	nor #(50) finalOr(out, inter2[0], inter2[1], inter2[2], inter2[3]);
endmodule

module norZeroFlag64bit_tb();
	logic [63:0] in;
	logic out;
	norZeroFlag64bit dut(.in, .out);
	
	initial begin
		in = 64'd0; #150;
		$display("Testing to see that when all bits of in are zero, the output is true");
		assert(out == 1) else $error("The output was not true when input was all zero, test failed!");
		in = {64{1'b1}}; #150;
		$display("Testing to see that when all bits are one, the output is false");
		assert(out == 0) else $error("The output was true when input was all ones, test failed!");
		in = 16; #150;
		$display("Testing to see that when not all bits are zero, the output is false");
		assert(out == 0) else $error("The output was true when input was not all zeros, test failed!");
		in = 0; #150;
		$display("Testing to see that when all bits of in are zero, the output is true");
		assert(out == 1) else $error("{The output was not true when input was all zeros, test failed!");
	end
endmodule