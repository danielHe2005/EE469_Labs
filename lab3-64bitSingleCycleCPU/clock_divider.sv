`timescale 1ps / 1ps
/* Rhiannon Garnier
Daniel He
04/25/2025
EE271
Lab5*/

/* clock_divider takes in a clock signal (single-bit clock), divides the clock cycle 
and outputs 32 divided clock signals (32-bit divided_clocks) of varying frequency.  */
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ...
// [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks = 32'b0;
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule

// clock_divider_testbench() tests the clock divider module by feeding it lots of clock 
// cycles and testing each of the 32 divided clock signals.
module clock_divider_testbench();
	logic clock;
	logic [31:0] divided_clocks;
	
	clock_divider dut (.clock, .divided_clocks);
	
	// clock setup
		parameter clock_period = 100;
		
		initial begin
			clock <= 0;
			forever #(clock_period /2) clock <= ~clock;
					
		end //initial
	
	initial begin
		
		// A for-loop can be leveraged to
		// efficiently run many cycles here ......
		
		for(int i = 0; i < 2**30; i++) begin
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
			@(posedge clock);	
			@(posedge clock);
		end
		
		$stop;
	end
endmodule