module CPU_toplevel_tb();
	logic clk, reset;
	CPU_toplevel dut(.clk, .reset);
	parameter clk_delay = 10000;
	initial begin
		clk <= 0;
		forever #(clk_delay/2) clk <= ~clk;
	end
	
	initial begin
		
	end
endmodule