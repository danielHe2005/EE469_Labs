`timescale 1ns / 10ps
module CPU_toplevel_tb();
	logic clk, reset;
	CPU_toplevel dut(.clk, .reset);
	parameter clk_delay = 100000;
	integer i;

	initial $timeformat(-9, 2, " ns", 10);

	initial begin
		clk <= 0;
		forever #(clk_delay/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for(i = 0; i < 1800; i++)begin
			@(posedge clk);
		end
		// Should also maybe do assertions for checking if nothing is written to spots they shouldn't be written to???
		$display("Program completed at address %0d", dut.instruction);
		/*// Asserts for AddiB benchmark
		assert(dut.register_file.regToMux[0] == 0) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 0, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 1) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 1, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 2) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 2, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == 3) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, 3, dut.register_file.regToMux[3]);
		assert(dut.register_file.regToMux[4] == 4) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 4, 4, dut.register_file.regToMux[4]);
		*/
		/*// Asserts for Subs benchmark
		assert(dut.register_file.regToMux[0] == 1) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 1, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == -1) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, -1, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 2) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 2, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == -3) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, -3, dut.register_file.regToMux[3]);
		assert(dut.register_file.regToMux[4] == -2) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 4, -2, dut.register_file.regToMux[4]);
		assert(dut.register_file.regToMux[5] == -5) $display("X5 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 5, -5, dut.register_file.regToMux[5]);
		assert(dut.register_file.regToMux[6] == 0) $display("X6 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 6, 0, dut.register_file.regToMux[6]);
		assert(dut.register_file.regToMux[7] == -6) $display("X7 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 7, -6, dut.register_file.regToMux[7]);
		assert(dut.flags == 4'b1001) $display("Final flags are correct"); else $error("Expected negative to be %0b, carry out to be %0b, overflow to be %0b, and zero to be %0b, but instead they were %0b, %0b, %0b, and %0b, respectively", 1, 1, 0, 0, dut.flags[0], dut.flags[3], dut.flags[2], dut.flags[1]);
		*/
		/*// Asserts for CbzB benchmark
		assert(dut.register_file.regToMux[0] == 1) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 1, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 0) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 0, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 0) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 0, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == 1) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, 1, dut.register_file.regToMux[3]);
		assert(dut.register_file.regToMux[4] == 31) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 4, 31, dut.register_file.regToMux[4]);
		assert(dut.register_file.regToMux[5] == 0) $display("X5 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 5, 0, dut.register_file.regToMux[5]);
		*/
		/*// Asserts for LdurStur benchmark
		assert(dut.register_file.regToMux[0] == 1) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 1, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 2) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 2, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 3) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 3, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == 8) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, 8, dut.register_file.regToMux[3]);
		assert(dut.register_file.regToMux[4] == 11) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 4, 11, dut.register_file.regToMux[4]);
		assert(dut.register_file.regToMux[5] == 1) $display("X5 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 5, 1, dut.register_file.regToMux[5]);
		assert(dut.register_file.regToMux[6] == 2) $display("X6 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 6, 2, dut.register_file.regToMux[6]);
		assert(dut.register_file.regToMux[7] == 3) $display("X7 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 7, 3, dut.register_file.regToMux[7]);
		assert({dut.data_mem.mem[7],dut.data_mem.mem[6],dut.data_mem.mem[5],dut.data_mem.mem[4],dut.data_mem.mem[3],dut.data_mem.mem[2],dut.data_mem.mem[1],dut.data_mem.mem[0]} == 1) $display("Datamem[0] final value is correct!");
		else $error("Expected Datamem %0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 1, {dut.data_mem.mem[7],dut.data_mem.mem[6],dut.data_mem.mem[5],dut.data_mem.mem[4],dut.data_mem.mem[3],dut.data_mem.mem[2],dut.data_mem.mem[1],dut.data_mem.mem[0]});
		assert({dut.data_mem.mem[15],dut.data_mem.mem[14],dut.data_mem.mem[13],dut.data_mem.mem[12],dut.data_mem.mem[11],dut.data_mem.mem[10],dut.data_mem.mem[9],dut.data_mem.mem[8]} == 2) $display("Datamem[8] final value is correct!");
		else $error("Expected Datamem %0d's final value to be equal to %0d, but instead was %0d, test failed", 8, 2, {dut.data_mem.mem[15],dut.data_mem.mem[14],dut.data_mem.mem[13],dut.data_mem.mem[12],dut.data_mem.mem[11],dut.data_mem.mem[10],dut.data_mem.mem[9],dut.data_mem.mem[8]});
		assert({dut.data_mem.mem[23],dut.data_mem.mem[22],dut.data_mem.mem[21],dut.data_mem.mem[20],dut.data_mem.mem[19],dut.data_mem.mem[18],dut.data_mem.mem[17],dut.data_mem.mem[16]} == 3) $display("Datamem[16] final value is correct!");
		else $error("Expected Datamem %0d's final value to be equal to %0d, but instead was %0d, test failed", 16, 3, {dut.data_mem.mem[23],dut.data_mem.mem[22],dut.data_mem.mem[21],dut.data_mem.mem[20],dut.data_mem.mem[19],dut.data_mem.mem[18],dut.data_mem.mem[17],dut.data_mem.mem[16]});
		*/
		/*// Asserts for Blt benchmark
		assert(dut.register_file.regToMux[0] == 1) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 1, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 1) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 1, dut.register_file.regToMux[1]);
		*/
		/*// Asserts for AndEorLsr benchmark
		assert(dut.register_file.regToMux[0] == 64'h0000000000000ACE) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 64'h0000000000000ACE, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 64'h000000000000000A) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 64'h000000000000000A, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 64'h000000000000000C) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 64'h000000000000000C, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == 0) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, 0, dut.register_file.regToMux[3]);
		*/
		/*// Asserts for forwarding benchmark
		assert(dut.register_file.regToMux[0] == 0) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 0, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 8) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 8, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 0) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 0, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == 5) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, 5, dut.register_file.regToMux[3]);
		assert(dut.register_file.regToMux[4] == 7) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 4, 7, dut.register_file.regToMux[4]);
		assert(dut.register_file.regToMux[5] == 2) $display("X5 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 5, 2, dut.register_file.regToMux[5]);
		assert(dut.register_file.regToMux[6] == -2) $display("X6 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 6, -2, dut.register_file.regToMux[6]);
		assert(dut.register_file.regToMux[7] == -2) $display("X7 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 7, -2, dut.register_file.regToMux[7]);
		assert(dut.register_file.regToMux[8] == 0) $display("X8 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 8, 0, dut.register_file.regToMux[8]);
		assert(dut.register_file.regToMux[9] == 1) $display("X9 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 9, 1, dut.register_file.regToMux[9]);
		assert(dut.register_file.regToMux[10] == -4) $display("X10 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 10, -4, dut.register_file.regToMux[10]);
		assert(dut.register_file.regToMux[14] == 5) $display("X14 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 14, 5, dut.register_file.regToMux[14]);
		assert(dut.register_file.regToMux[15] == 8) $display("X15 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 15, 8, dut.register_file.regToMux[15]);
		assert(dut.register_file.regToMux[16] == 9) $display("X16 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 16, 9, dut.register_file.regToMux[16]);
		assert(dut.register_file.regToMux[17] == 1) $display("X17 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 17, 1, dut.register_file.regToMux[17]);
		assert(dut.register_file.regToMux[18] == 99) $display("X18 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 18, 99, dut.register_file.regToMux[18]);
		assert({dut.data_mem.mem[7],dut.data_mem.mem[6],dut.data_mem.mem[5],dut.data_mem.mem[4],dut.data_mem.mem[3],dut.data_mem.mem[2],dut.data_mem.mem[1],dut.data_mem.mem[0]} == 8) $display("Datamem[0] final value is correct!");
		else $error("Expected Datamem %0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 8, {dut.data_mem.mem[7],dut.data_mem.mem[6],dut.data_mem.mem[5],dut.data_mem.mem[4],dut.data_mem.mem[3],dut.data_mem.mem[2],dut.data_mem.mem[1],dut.data_mem.mem[0]});
		assert({dut.data_mem.mem[15],dut.data_mem.mem[14],dut.data_mem.mem[13],dut.data_mem.mem[12],dut.data_mem.mem[11],dut.data_mem.mem[10],dut.data_mem.mem[9],dut.data_mem.mem[8]} == 5) $display("Datamem[8] final value is correct!");
		else $error("Expected Datamem %0d's final value to be equal to %0d, but instead was %0d, test failed", 8, 5, {dut.data_mem.mem[15],dut.data_mem.mem[14],dut.data_mem.mem[13],dut.data_mem.mem[12],dut.data_mem.mem[11],dut.data_mem.mem[10],dut.data_mem.mem[9],dut.data_mem.mem[8]});
		*/
		/*// Asserts for Sort benchmark
		assert(dut.register_file.regToMux[11] == 1) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 11, 1, dut.register_file.regToMux[11]);
		assert(dut.register_file.regToMux[12] == 2) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 12, 2, dut.register_file.regToMux[12]);
		assert(dut.register_file.regToMux[13] == 3) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 13, 3, dut.register_file.regToMux[13]);
		assert(dut.register_file.regToMux[14] == 4) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 14, 4, dut.register_file.regToMux[14]);
		assert(dut.register_file.regToMux[15] == 5) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 15, 5, dut.register_file.regToMux[15]);
		assert(dut.register_file.regToMux[16] == 6) $display("X5 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 16, 6, dut.register_file.regToMux[16]);
		assert(dut.register_file.regToMux[17] == 7) $display("X6 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 17, 7, dut.register_file.regToMux[17]);
		assert(dut.register_file.regToMux[18] == 8) $display("X7 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 18, 8, dut.register_file.regToMux[18]);
		assert(dut.register_file.regToMux[19] == 9) $display("X8 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 19, 9, dut.register_file.regToMux[19]);
		assert(dut.register_file.regToMux[20] == 10) $display("X9 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 20, 10, dut.register_file.regToMux[20]);
		*/
		// Asserts for CRC16 benchmark
		assert(dut.register_file.regToMux[0] == 64'h000000000000A001) $display("X0 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 0, 64'h000000000000A001, dut.register_file.regToMux[0]);
		assert(dut.register_file.regToMux[1] == 64'h0000000000009476) $display("X1 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 1, 64'h0000000000009476, dut.register_file.regToMux[1]);
		assert(dut.register_file.regToMux[2] == 64'h000000000000000C) $display("X2 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 2, 64'h000000000000000C, dut.register_file.regToMux[2]);
		assert(dut.register_file.regToMux[3] == 64'h0000000000000060) $display("X3 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 3, 64'h0000000000000060, dut.register_file.regToMux[3]);
		assert(dut.register_file.regToMux[4] == 64'h0000000000000008) $display("X4 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 4, 64'h0000000000000008, dut.register_file.regToMux[4]);
		assert(dut.register_file.regToMux[5] == 0) $display("X5 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 5, 0, dut.register_file.regToMux[5]);
		assert(dut.register_file.regToMux[6] == 1) $display("X6 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 6, 1, dut.register_file.regToMux[6]);
		assert(dut.register_file.regToMux[7] == 0) $display("X7 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 7, 0, dut.register_file.regToMux[7]);
		assert(dut.register_file.regToMux[8] == 1) $display("X8 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 8, 1, dut.register_file.regToMux[8]);
		assert(dut.register_file.regToMux[9] == 12) $display("X9 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 9, 12, dut.register_file.regToMux[9]);
		assert(dut.register_file.regToMux[10] == 8) $display("X10 final value is correct!"); else $error("Expected Register X%0d's final value to be equal to %0d, but instead was %0d, test failed", 10, 8, dut.register_file.regToMux[10]);
		
		$stop;
	end
endmodule