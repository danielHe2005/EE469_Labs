`timescale 1ps / 1ps
module decoder5_32(ena, sel, out);
	input logic ena;
	input logic [4:0] sel;
	output logic [31:0] out;
	logic [7:0] inter;
	demux_1to8 top3Bit(ena, sel[4:2], inter);
	
	genvar i;
	generate
		for(i = 0; i < 8; i++)begin: decodeArray
			demux_1to4 demux(inter[i], sel[1:0], out[(((i+1)*4)-1):(i*4)]);
		end
	endgenerate
endmodule

module decoder5_32_tb();
	logic ena;
	logic [4:0] sel;
	logic [31:0] out;
	int i;
	decoder5_32 dut(.ena, .sel, .out);
	
	initial begin
		ena = 0; #200;
		for(i = 0; i < 32; i++)begin // tests that the decoder doesn't output any value if ena is disabled
			sel = i; #200;
			$display("sel=%0d, out[sel]=%0d (expected %0d)", i, out[sel], 0); // creates a display to show the intended and actual results if sel is i
			assert (out[sel] == 0) else $error("MUX failed for sel=%0d: expected %0b, got %0b", i, 0, out[sel]);
		end
		ena = 1; #200;
		for(i = 0; i < 32; i++)begin // tests that the decoder outputs the correct row if ena is enabled
			sel = i; #200;
			$display("sel=%0d, out[sel]=%0d (expected %0d)", i, out[sel], 1); // creates a display to show the intended and actual results if sel is i
			assert (out[sel] == 1) else $error("MUX failed for sel=%0d: expected %0b, got %0b", i, 1, out[sel]);
		end
	end
endmodule