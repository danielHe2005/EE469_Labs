`timescale 1ps / 1ps
// 16 to 1 mux that chooses between one of sixteen choices in a 16 element array "in" depending on the sel input
module mux_16to1 (in, sel, out);
	input logic in [15:0];
	input logic [3:0] sel;
	output logic out;
	logic interOne, interTwo;
	mux_8to1 muxL0P1 (.in(in[15:8]), .sel(sel[2:0]), .out(interTwo)); // chooses between input 15-8 depending on the bottom 3 bit of sel
	mux_8to1 muxL0P2 (.in(in[7:0]), .sel(sel[2:0]), .out(interOne)); // chooses between input 7-0 depending on the bottom 3 bit of sel
	mux_2to1 muxL1P1 (.in1(interTwo), .in0(interOne), .sel(sel[3]), .out(out)); // chooses between the outcome of the first two muxes depending on the top bit of sel
endmodule

module mux_16to1_tb ();
	logic out;
	logic in [15:0];
	logic [3:0] sel;
	int i;
	
	mux_16to1 dut(.in, .sel, .out);
	
	initial begin // start of the testbench
		in = {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0}; #10; // instantiates the inputs to the mux
		
		for (int i = 0; i < 16; i++) begin
			sel = i;
      #600; // let signals propagate

      // auto-generated assertion in a loop
		$display("sel=%0d, out=%0d (expected %0d)", i, out, in[i]); // creates a display to show the intended and actual results if sel is i
      assert (out == in[i]) else $error("MUX failed for sel=%0d: expected %0b, got %0b", i, in[i], out);
    end
	end
endmodule