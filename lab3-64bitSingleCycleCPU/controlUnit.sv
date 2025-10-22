module controlUnit(opcode, BrTaken, UnCondBr, RegWrite, setFlags, MemWrite, MemToReg, ALUSrc, ITypetoB, Reg2Loc, shiftTrue, NegativeFlag, OverflowFlag, ZeroALUFlag, MemRead, ALUOp);
	input logic [10:0] opcode;
	input logic NegativeFlag, OverflowFlag, ZeroALUFlag;
	output logic BrTaken, UnCondBr, RegWrite, setFlags, MemWrite, MemToReg, ALUSrc, ITypetoB, Reg2Loc, shiftTrue, MemRead;
	output logic [2:0] ALUOp;
	
	always_comb begin
		BrTaken = 0;
		MemRead = 0;
		UnCondBr = 0;
		RegWrite = 0;
		setFlags = 0;
		MemWrite = 0;
		MemToReg = 0;
		ALUSrc = 0;
		ITypetoB = 0;
		Reg2Loc = 0;
		shiftTrue = 0;
		ALUOp = 3'b000;
		if((opcode >= 11'h0A0) & (opcode <= 11'h0BF))begin // B Type Instruction, B
			BrTaken = 1;
			UnCondBr = 1;
		end else if(((opcode >= 11'h2A0) & (opcode <= 11'h2A7))|((opcode >= 11'h5A0)&(opcode <= 11'h5AF))) begin // CB Type Instruction
			case(opcode[10:3])
				8'h54: begin // B.LT
						BrTaken = NegativeFlag ^ OverflowFlag;
				end
				8'hB4: begin // CBZ
						BrTaken = ZeroALUFlag;
				end
			endcase
		end else if(((opcode >= 11'h450) & (opcode <= 11'h458))|((opcode >= 11'h4D6)&(opcode <= 11'h558))|((opcode >= 11'h650)&(opcode <= 11'h658))|((opcode >= 11'h69A)&(opcode <= 11'h758)))begin // R Type Instruction
			RegWrite = 1;
			Reg2Loc = 1;
			case(opcode)
				11'h450: begin // AND
						ALUOp = 3'b100;
				end
				11'h558: begin // ADDS
						setFlags = 1;
						ALUOp = 3'b010;
				end
				11'h650: begin // EOR
						ALUOp = 3'b110;
				end
				11'h69A: begin // LSR
						shiftTrue = 1;
				end
				11'h758: begin // SUBS
						setFlags = 1;
						ALUOp = 3'b011;
				end
			endcase
		end else if((opcode >= 11'h488)&(opcode <= 11'h491)) begin // I Type Instruction, ADDI
			RegWrite = 1;
			ALUSrc = 1;
			ITypetoB = 1;
			ALUOp = 3'b010;
		end else if((opcode >= 11'h7C0)&(opcode <= 11'h7C2)) begin // D Type Instruction
			ALUSrc= 1;
			ALUOp = 3'b010;
			case(opcode)
				11'h7C0: begin // STUR
					MemWrite = 1;
				end
				11'h7C2: begin // LDUR
					RegWrite = 1;
					MemRead = 1;
					MemToReg = 1;
				end
			endcase
		end
	end
endmodule

module controlUnit_tb();
	logic [10:0] opcode;
	logic BrTaken, UnCondBr, RegWrite, setFlags, MemWrite, MemToReg, ALUSrc, ITypetoB, Reg2Loc, shiftTrue, NegativeFlag, OverflowFlag, ZeroALUFlag, MemRead;
	logic [3:0] ALUOp;
	controlUnit dut(.opcode, .BrTaken, .UnCondBr, .RegWrite, .setFlags, .MemWrite, .MemToReg, .ALUSrc, .ITypetoB, .Reg2Loc, .shiftTrue, .NegativeFlag, .OverflowFlag, .ZeroALUFlag, .MemRead, .ALUOp);
endmodule