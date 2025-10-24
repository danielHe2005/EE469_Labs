`timescale 1ps / 1ps
module CPU_toplevel(clk, reset);

	input logic clk, reset;
	// Instruction Fetch Datapath Logic
	logic [63:0] instrAddress, PCPlus4, brAddress, brPlusPC, PCNext;
	logic [18:0] CondAddr19;
	logic [25:0] BrAddr26;
	logic [31:0] instruction;
	
	// Execution/Store Datapath Logic
	logic [4:0] Aw, Ab, Aa, AbFinal;
	logic [5:0] shamt;
	logic [63:0] Dw, Db, Da, result, mem_data, Imm64Bit, aluBIn, shiftResult, calculatedResult;
	logic [11:0] Imm12; // Used in I type operations
	logic [8:0] Imm9; // Used in LDUR and STUR operations
	logic [3:0] aluFlagsIn, flags;
	
	// Pipelined Processor Register Logic
	logic invertedClock, zeroCBZ;
	logic [4:0] AwPass;
	logic [31:0] instrFetchtoDecodePipe, instrDecodetoExecPipe, instrExectoMemPipe, instrMemtoWrPipe;	
	logic [63:0] BDecodetoExecPipe, ADecodetoExecPipe, ALUExectoMemPipe, writebackMemtoWrPipe, DbDecodetoExecPipe, DinExectoMemPipe, DaFinal, DbFinal, PCFetchtoDecodePipe;
	logic [63:0] AForwardIn [3:0];
	logic [63:0] BForwardIn [3:0];
	assign AForwardIn[0] = Da;
	assign AForwardIn[1] = calculatedResult;
	assign AForwardIn[2] = Dw;
	assign BForwardIn[0] = Db;
	assign BForwardIn[1] = calculatedResult;
	assign BForwardIn[2] = Dw;
	
	// Pipelined Processor Control Logic
	logic RegWriteDecodetoExecPipe, RegWriteExectoMemPipe, RegWriteMemtoWrPipe, setFlagsDecodetoExecPipe, MemWriteDecodetoExecPipe, MemWriteExectoMemPipe, MemtoRegDecodetoExecPipe, MemtoRegExectoMemPipe,
	shiftTrueDecodetoExecPipe, MemReadDecodetoExecPipe, MemReadExectoMemPipe;
	logic [2:0] ALUOpDecodetoExecPipe;
	logic [1:0] AForward, BForward;
	
	// Control Logic
	logic BrTaken, UnCondBr, RegWrite, setFlags, MemWrite, MemToReg, ALUSrc, ITypetoB, Reg2Loc, shiftTrue, MemRead;
	logic [2:0] ALUOp;
	
	assign Ab = instrFetchtoDecodePipe[20:16];
	assign Aa = instrFetchtoDecodePipe[9:5];
	assign Aw = instrMemtoWrPipe[4:0];
	assign AwPass = instrFetchtoDecodePipe[4:0];
	assign shamt = instrDecodetoExecPipe[15:10];
	assign BrAddr26 = instrFetchtoDecodePipe[25:0]; // Check these!!!
	assign CondAddr19 = instrFetchtoDecodePipe[23:5];
	assign Imm12 = instrFetchtoDecodePipe[21:10];
	assign Imm9 = instrFetchtoDecodePipe[20:12];
	
	// Inverted clock
	not #(50) invertClock(invertedClock, clk);
	
	// Control Unit
	controlUnit c_unit(.opcode(instrFetchtoDecodePipe[31:21]), .BrTaken, .UnCondBr, .RegWrite, .setFlags, .MemWrite, .MemToReg, .ALUSrc, .ITypetoB, .Reg2Loc, .shiftTrue, .NegativeFlag(flags[0]), .OverflowFlag(flags[2]), .ZeroALUFlag(zeroCBZ), .MemRead, .ALUOp);
	forwardingControlUnit fc_unit(.instructionReg(instrFetchtoDecodePipe), .instructionExec(instrDecodetoExecPipe), .instructionMem(instrExectoMemPipe), .AForward, .BForward);
	
	// Execution/Store Datapath
	muxVariablebit_2to1 #(5) AbMux(.in1(Ab), .in0(AwPass), .sel(Reg2Loc), .out(AbFinal));
	regfile register_file(.ReadData1(Da), .ReadData2(Db), .WriteData(writebackMemtoWrPipe), .ReadRegister1(Aa), .ReadRegister2(AbFinal), .WriteRegister(Aw), .RegWrite(RegWriteMemtoWrPipe), .clk(invertedClock)); // Register File
	muxVariablebit_4to1 forwardingA(.in(AForwardIn), .sel(AForward), .out(DaFinal));
	muxVariablebit_4to1 forwardingB(.in(BForwardIn), .sel(BForward), .out(DbFinal));
	muxVariablebit_2to1 aluBInMux(.in1(Imm64Bit), .in0(DbFinal), .sel(ALUSrc), .out(aluBIn));
	muxVariablebit_2to1 aluImmMux(.in1({{52{1'b0}},Imm12}), .in0({{55{Imm9[8]}},Imm9}), .sel(ITypetoB), .out(Imm64Bit));
	alu ALU(.A(ADecodetoExecPipe), .B(BDecodetoExecPipe), .cntrl(ALUOpDecodetoExecPipe), .result, .negative(aluFlagsIn[0]), .zero(aluFlagsIn[1]), .overflow(aluFlagsIn[2]), .carry_out(aluFlagsIn[3])); // ALU, negative is bit zero, zero is bit one, overflow is bit 2, and carry_out is bit 3
	register #(4) flag_reg(.in(aluFlagsIn), .clk(invertedClock), .reset, .writeEnable(setFlagsDecodetoExecPipe), .out(flags)); // Flags Register
	shifter shiftModule(.value(ADecodetoExecPipe), .direction(1'b1), .distance(shamt), .result(shiftResult));
	muxVariablebit_2to1 shiftMux(.in1(shiftResult), .in0(result), .sel(shiftTrueDecodetoExecPipe), .out(calculatedResult));
	
	// Data memory
	datamem data_mem(.address(ALUExectoMemPipe), .write_enable(MemWriteExectoMemPipe), .read_enable(MemReadExectoMemPipe), .write_data(DinExectoMemPipe), .clk, .xfer_size(4'd8), .read_data(mem_data)); // Data Memory, 4 for the xfer_size to ensure it's byte addressed???
	
	muxVariablebit_2to1 writeMux(.in1(mem_data), .in0(ALUExectoMemPipe), .sel(MemtoRegExectoMemPipe), .out(Dw));
	
	// Instruction Fetch Datapath
	register #(64) PC(.in(PCNext), .clk(clk), .reset, .writeEnable(1'b1), .out(instrAddress)); // Program Counter
	instructmem instruction_mem(.address(instrAddress), .instruction(instruction), .clk(clk)); // Instruction Memory
	adderSubtractor64 PCAdd4(.A(instrAddress), .B(64'h0000000000000004), .Cin(1'b0), .sel(1'b0), .Sum(PCPlus4)); // PC + 4
	adderSubtractor64 PCAddBranch(.A(PCFetchtoDecodePipe), .B(brAddress), .Cin(1'b0), .sel(1'b0), .Sum(brPlusPC)); // PC + Branch Address
	muxVariablebit_2to1 branchMux(.in1(brPlusPC), .in0(PCPlus4), .sel(BrTaken), .out(PCNext));
	muxVariablebit_2to1 condBranchMux(.in1({{36{BrAddr26[25]}},BrAddr26,2'b00}), .in0({{43{CondAddr19[18]}},CondAddr19,2'b00}), .sel(UnCondBr), .out(brAddress));
	
	//Early CBZ Calculate
	norZeroFlag64bit zeroFlagCBZ(.in(DbFinal), .out(zeroCBZ));
	
	// Data Pipeline registers
	register #(32) instrForward1(.in(instruction), .clk, .reset, .writeEnable(1'b1), .out(instrFetchtoDecodePipe));
	register #(32) instrForward2(.in(instrFetchtoDecodePipe), .clk, .reset, .writeEnable(1'b1), .out(instrDecodetoExecPipe));
	register #(32) instrForward3(.in(instrDecodetoExecPipe), .clk, .reset, .writeEnable(1'b1), .out(instrExectoMemPipe));
	register #(32) instrForward4(.in(instrExectoMemPipe), .clk, .reset, .writeEnable(1'b1), .out(instrMemtoWrPipe));
	
	register #(64) PCFetchtoDecode(.in(instrAddress), .clk, .reset, .writeEnable(1'b1), .out(PCFetchtoDecodePipe));
	
	register #(64) BDecodetoExec(.in(aluBIn), .clk, .reset, .writeEnable(1'b1), .out(BDecodetoExecPipe));
	register #(64) ADecodetoExec(.in(DaFinal), .clk, .reset, .writeEnable(1'b1), .out(ADecodetoExecPipe));
	register #(64) DbDecodetoExec(.in(DbFinal), .clk, .reset, .writeEnable(1'b1), .out(DbDecodetoExecPipe));
	
	register #(64) ALUExectoMem(.in(calculatedResult), .clk, .reset, .writeEnable(1'b1), .out(ALUExectoMemPipe));
	register #(64) DinExectoMem(.in(DbDecodetoExecPipe), .clk, .reset, .writeEnable(1'b1), .out(DinExectoMemPipe));
	
	register #(64) writebackMemtoWr(.in(Dw), .clk, .reset, .writeEnable(1'b1), .out(writebackMemtoWrPipe));
	
	// Control Pipeline registers
	register #(1) RegWriteDecodetoExec(.in(RegWrite), .clk, .reset, .writeEnable(1'b1), .out(RegWriteDecodetoExecPipe)); // Pipeline for RegWrite
	register #(1) RegWriteExectoMem(.in(RegWriteDecodetoExecPipe), .clk, .reset, .writeEnable(1'b1), .out(RegWriteExectoMemPipe));
	register #(1) RegWriteMemtoWr(.in(RegWriteExectoMemPipe), .clk, .reset, .writeEnable(1'b1), .out(RegWriteMemtoWrPipe));
	
	register #(1) setFlagsDecodetoExec(.in(setFlags), .clk, .reset, .writeEnable(1'b1), .out(setFlagsDecodetoExecPipe)); // Pipeline for setFlags
	
	register #(1) MemWriteDecodetoExec(.in(MemWrite), .clk, .reset, .writeEnable(1'b1), .out(MemWriteDecodetoExecPipe)); // Pipeline for MemWrite
	register #(1) MemWriteExectoMem(.in(MemWriteDecodetoExecPipe), .clk, .reset, .writeEnable(1'b1), .out(MemWriteExectoMemPipe));
	
	register #(1) MemtoRegDecodetoExec(.in(MemToReg), .clk, .reset, .writeEnable(1'b1), .out(MemtoRegDecodetoExecPipe)); // Pipeline for MemWrite
	register #(1) MemtoRegExectoMem(.in(MemtoRegDecodetoExecPipe), .clk, .reset, .writeEnable(1'b1), .out(MemtoRegExectoMemPipe));
	
	register #(1) shiftTrueDecodetoExec(.in(shiftTrue), .clk, .reset, .writeEnable(1'b1), .out(shiftTrueDecodetoExecPipe)); // Pipeline for shiftTrue
	
	register #(3) ALUOpDecodetoExec(.in(ALUOp), .clk, .reset, .writeEnable(1'b1), .out(ALUOpDecodetoExecPipe)); // Pipeline for ALUOp
	
	register #(1) MemReadDecodetoExec(.in(MemRead), .clk, .reset, .writeEnable(1'b1), .out(MemReadDecodetoExecPipe)); // Pipeline for MemRead
	register #(1) MemReadExectoMem(.in(MemReadDecodetoExecPipe), .clk, .reset, .writeEnable(1'b1), .out(MemReadExectoMemPipe));
endmodule