`timescale 1ps / 1ps
// this module simulates the register file of a single cycle CPU, wherein a 5x32 decoder is used to send the write signals, and the register file
// itself comprises of 32 64 bit registers with X31 being the zero register. These registers are then wired to the 64 32to1 muxes that control the two read ports
module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input logic RegWrite, clk;
	input logic [4:0] WriteRegister, ReadRegister1, ReadRegister2;
	input logic [63:0] WriteData; // the data to be sent in parallel into the designated register
	output logic [63:0] ReadData1, ReadData2; // the data sent out of the muxes for the selected registers to be read
	logic [31:0] decodeToReg; 
	logic [63:0] regToMux [30:0]; // the wires connecting the registers to the muxes
	
	genvar i;
	int j;
	
	decoder5_32 decoder(.ena(RegWrite), .sel(WriteRegister), .out(decodeToReg));
	generate // generate all 31 regular 64 bit registers
		for(i = 0; i < 31; i++)begin: registers
			register #(64) register_component(.in(WriteData), .clk(clk), .reset(1'b0), .writeEnable(decodeToReg[i]), .out(regToMux[i]));
		end
	endgenerate
	generate // generates both of the 32x64bit muxes
		
		
		for(i = 0; i < 64; i++)begin: muxRead1
			logic mux_in [31:0]; 
			always_comb begin // creates the packed 32 bit vector for input into one of the muxes
				mux_in[31] = 1'b0;
				for (int j = 0; j < 31; j++) begin
					mux_in[j] = regToMux[j][i];
				end
			end
			mux_32to1 mux1(.in(mux_in), .sel(ReadRegister1), .out(ReadData1[i]));
		end
		for(i = 0; i < 64; i++)begin: muxRead2
			logic mux_in2 [31:0];
			always_comb begin // creates the packed 
				mux_in2[31] = 1'b0;
				for (int j = 0; j < 31; j++) begin
					mux_in2[j] = regToMux[j][i];
				end
			end
			mux_32to1 mux2(.in(mux_in2), .sel(ReadRegister2), .out(ReadData2[i]));
		end
	endgenerate
endmodule