module muxVariablebit_4to1 #(parameter BITWIDTH = 64) (in, sel, out);
	input logic [63:0] in [3:0];
	input logic [1:0] sel;
	output logic [63:0] out;
	
	logic [63:0] interOne, interTwo;
	muxVariablebit_2to1 muxL0P1 (.in1(in[3]), .in0(in[2]), .sel(sel[0]), .out(interTwo)); // chooses between input 3 and 2 depending on the bottom bit of sel
	muxVariablebit_2to1 muxL0P2 (.in1(in[1]), .in0(in[0]), .sel(sel[0]), .out(interOne)); // chooses between input 1 and 0 depending on the bottom bit of sel
	muxVariablebit_2to1 muxL1P1 (.in1(interTwo), .in0(interOne), .sel(sel[1]), .out(out)); // chooses between the outcome of the first two muxes depending on the top bit of sel
endmodule

module muxVariablebit_4to1_tb ();
	logic [63:0] out;
	logic [63:0] in [3:0];
	logic [1:0] sel;
	
	muxVariablebit_4to1 dut(.in, .sel, .out);
	
	initial begin // start of the testbench
		in = {64'd14, 64'd17, 64'd18, 0}; #10; // instantiates the inputs to the mux
		sel = 0; #300;
		$display("sel=0, out=%0d (expected %0d)", out, in[0]); // creates a display to show the intended and actual results if sel is 0
		assert (out == in[0]) else $error("Test 1 failed"); // creates an assertion to generate an error statement if failed
		sel = 1; #300;
		$display("sel=1, out=%0d (expected %0d)", out, in[1]); // creates a display to show the intended and actual results if sel is 1
		assert (out == in[1]) else $error("Test 2 failed"); // creates an assertion to generate an error statement if failed
		sel = 2; #300;
		$display("sel=2, out=%0d (expected %0d)", out, in[2]); // creates a display to show the intended and actual results if sel is 2
		assert (out == in[2]) else $error("Test 3 failed"); // creates an assertion to generate an error statement if failed
		sel = 3; #300;
		$display("sel=3, out=%0d (expected %0d)", out, in[3]); // creates a display to show the intended and actual results if sel is 3
		assert (out == in[3]) else $error("Test 3 failed"); // creates an assertion to generate an error statement if failed
	end
endmodule