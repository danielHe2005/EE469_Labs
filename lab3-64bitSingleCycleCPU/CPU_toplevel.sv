module CPU_toplevel(clk, reset);

	input logic clk, reset;
	// Instruction Fetch Datapath Logic
	logic [63:0] instrAddress, PCPlus4, brAddress, brPlusPC, PCNext;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [31:0] instruction;
	
	// Execution/Store Datapath logic
	logic [4:0] Aw, Ab, Aa, AbFinal;
	logic [5:0] shamt;
	logic [63:0] Dw, Db, Da, result, mem_data, Imm64Bit, aluBIn, shiftResult, calculatedResult;
	logic [11:0] Imm12; // Used in I type operations
	logic [8:0] Imm9; // Used in LDUR and STUR operations
	logic [3:0] aluFlagsIn, flags;
	
	// control logic
	logic BrTaken, UnCondBr, RegWrite, setFlags, MemWrite, MemToReg, ALUSrc, ITypetoB, Reg2Loc, shiftTrue, MemRead;
	logic [3:0] ALUOp;
	
	assign Ab = instruction[20:16];
	assign Aa = instruction[9:5];
	assign Aw = instruction[4:0];
	assign shamt = instruction[15:10];
	assign BrAddr26 = instruction[25:0];
	assign CondAddr19 = instruction[23:5];
	assign Imm12 = instruction[21:10];
	assign Imm9 = instruction[20:12];
	
	// Control Unit
	controlUnit c_unit(.opcode(instruction[31:21]), .BrTaken, .UnCondBr, .RegWrite, .setFlags, .MemWrite, .MemToReg, .ALUSrc, .ITypetoB, .Reg2Loc, .shiftTrue, .NegativeFlag(flags[0]), .OverflowFlag(flags[2]), .ZeroALUFlag(aluFlagsIn[1]), .MemRead, .ALUOp);
	
	// Execution/Store Datapath
	muxVariablebit_2to1 #(5) AbMux(.in1(Ab), .in0(Aw), .sel(Reg2Loc), .out(AbFinal));
	regfile register_file(.ReadData1(Da), .ReadData2(Db), .WriteData(Dw), .ReadRegister1(Aa), .ReadRegister2(AbFinal), .WriteRegister(Aw), .RegWrite, .clk); // Register File
	muxVariablebit_2to1 aluBInMux(.in1(Imm64Bit), .in0(Db), .sel(ALUSrc), .out(aluBIn));
	muxVariablebit_2to1 aluImmMux(.in1({{52{Imm12[11]}},Imm12}), .in0({{55{Imm9[8]}},Imm9}), .sel(ITypetoB), .out(Imm64Bit));
	alu ALU(.A(Da), .B(Db), .cntrl(ALUOp), .result, .negative(aluFlagsIn[0]), .zero(aluFlagsIn[1]), .overflow(aluFlagsIn[2]), .carry_out(aluFlagsIn[3])); // ALU, negative is bit zero, zero is bit one, overflow is bit 2, and carry_out is bit 3
	register #(4) flag_reg(.in(aluFlagsIn), .clk, .reset, .writeEnable(setFlags), .out(flags)); // Flags Register
	shifter shiftModule(.value(Da), .direction(1'b1), .distance(shamt), .result(shiftResult));
	muxVariablebit_2to1 shiftMux(.in1(shiftResult), .in0(result), .sel(shiftTrue), .out(calculatedResult));
	
	// Data memory
	datamem data_mem(.address(result), .write_enable(MemWrite), .read_enable(MemRead), .write_data(Db), .clk, .xfer_size(4'b1000), .read_data(mem_data)); // Data Memory, 4 for the xfer_size to ensure it's byte addressed???
	
	muxVariablebit_2to1 writeMux(.in1(mem_data), .in0(calculatedResult), .sel(MemToReg), .out(Dw));
	
	// Instruction Fetch Datapath
	register #(64) PC(.in(PCNext), .clk(clk), .reset, .writeEnable(1'b1), .out(instrAddress)); // Program Counter
	instructmem instruction_mem(.address(instrAddress), .instruction(instruction), .clk(clk)); // Instruction Memory
	adderSubtractor64(.A(instrAddress), .B(64'h0000000000000004), .Cin(1'b0), .sel(1'b0), .Sum(PCPlus4)); // PC + 4
	adderSubtractor64(.A(instrAddress), .B(brAddress), .Cin(1'b0), .sel(1'b0), .Sum(brPlusPC)); // PC + Branch Address
	muxVariablebit_2to1 branchMux(.in1(brPlusPC), .in0(PCPlus4), .sel(BrTaken), .out(PCNext));
	muxVariablebit_2to1 condBranchMux(.in1({{36{BrAddr26[25]}},BrAddr26,2'b00}), .in0({{43{CondAddr19[18]}},CondAddr19,2'b00}), .sel(UnCondBr), .out(brAddress));
	
endmodule