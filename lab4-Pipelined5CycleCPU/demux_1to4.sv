`timescale 1ps / 1ps
module demux_1to4 (ena, sel, out);
	input logic ena;
	input logic [1:0] sel;
	output logic [3:0] out;
	logic [1:0] notSel;
	
	not #(50) not0(notSel[0], sel[0]);
	not #(50) not1(notSel[1], sel[1]);
	and #(50) out0(out[0], ena, notSel[1], notSel[0]);
	and #(50) out1(out[1], ena, notSel[1], sel[0]);
	and #(50) out2(out[2], ena, sel[1], notSel[0]);
	and #(50) out3(out[3], ena, sel[1], sel[0]);
endmodule

module demux_1to4_tb();
	logic ena;
	logic [1:0] sel;
	logic [3:0] out;
	int i;
	demux_1to4 dut(.ena, .sel, .out);
	
	initial begin
		ena = 0; #100;
		for(i = 0; i < 4; i++)begin // tests that the decoder doesn't output any value if ena is disabled
			sel = i; #100;
			$display("sel=%0d, out[sel]=%0d (expected %0d)", i, out[sel], 0); // creates a display to show the intended and actual results if sel is i
			assert (out[sel] == 0) else $error("MUX failed for sel=%0d: expected %0b, got %0b", i, 0, out[sel]);
		end
		ena = 1; #100;
		for(i = 0; i < 4; i++)begin // tests that the decoder outputs the correct row if ena is enabled
			sel = i; #100;
			$display("sel=%0d, out[sel]=%0d (expected %0d)", i, out[sel], 1); // creates a display to show the intended and actual results if sel is i
			assert (out[sel] == 1) else $error("MUX failed for sel=%0d: expected %0b, got %0b", i, 1, out[sel]);
		end
	end
endmodule