module muxVariablebit_2to1 #(parameter BITWIDTH = 64) (in1, in0, sel, out);
	input logic [BITWIDTH-1:0] in1, in0;
	input logic sel;
	output logic [BITWIDTH-1:0] out;
	genvar i;
	
	generate
		for(i = 0; i < BITWIDTH; i++)begin: muxes
			mux_2to1 bitwiseMux(.in1(in1[i]), .in0(in0[i]), .sel(sel), .out(out[i]));
		end
	endgenerate
endmodule

module muxVariablebit_2to1_tb ();
	logic [63:0] in1, in0, out;
	logic sel;
	
	muxVariablebit_2to1 dut(.in1, .in0, .sel, .out);
	
	initial begin // start of the testbench
		in1 = 64'h0101010101010101; #10; // instantiates the output of the mux if the select is 1
		in0 = 0; #10; // instantiates the output of the mux if the select is 0
		sel = 0; #150;
		$display("sel=0, out=%0h (expected %0h)", out, in0); // creates a display to show the intended and actual results if sel is false
		assert (out == in0) else $error("Test 1 failed"); // creates an assertion to generate an error statement if failed
		sel = 1; #150;
		$display("sel=1, out=%0h (expected %0h)", out, in1); // creates a display to show the intended and actual results if sel is true
		assert (out == in1) else $error("Test 2 failed"); // creates an assertion to generate an error statement if failed
	end
endmodule
	