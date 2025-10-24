`timescale 1ps / 1ps
// 2 to 1 mux that picks between in1 if sel is true and in0 if sel is false
module mux_2to1 (in1, in0, sel, out);
	input logic in1, in0;
	input logic sel;
	output logic out;
	logic temp1, temp2, notSel;
	
	not #(50) not1(notSel, sel);
	and #(50) and1(temp1, in0, notSel); // deals with if sel is 0
	and #(50) and2(temp2, in1, sel); // deals with if sel is 1
	or #(50) or1(out, temp1, temp2);
endmodule

module mux_2to1_tb ();
	logic in1, in0, out;
	logic sel;
	
	mux_2to1 dut(.in1, .in0, .sel, .out);
	
	initial begin // start of the testbench
		in1 = 1; #10; // instantiates the output of the mux if the select is 1
		in0 = 0; #10; // instantiates the output of the mux if the select is 0
		sel = 0; #150;
		$display("sel=0, out=%0d (expected %0d)", out, in0); // creates a display to show the intended and actual results if sel is false
		assert (out == in0) else $error("Test 1 failed"); // creates an assertion to generate an error statement if failed
		sel = 1; #150;
		$display("sel=1, out=%0d (expected %0d)", out, in1); // creates a display to show the intended and actual results if sel is true
		assert (out == in1) else $error("Test 2 failed"); // creates an assertion to generate an error statement if failed
	end
endmodule
	
	