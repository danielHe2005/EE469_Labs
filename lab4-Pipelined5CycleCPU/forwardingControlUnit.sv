module forwardingControlUnit(instructionReg, instructionExec, instructionMem, AForward, BForward);
	input logic [31:0] instructionReg, instructionExec, instructionMem;
	output logic [1:0] AForward, BForward; // 0 for no forwarding, 1 for forwarding from 
	
	always_comb begin
		AForward = 0;
		BForward = 0;
		
		//AForward Control Logic
		if(instructionReg[9:5] != 5'd31)begin
			if((((instructionExec[31:21] >= 11'h488)&(instructionExec[31:21] <= 11'h491))|(((instructionExec[31:21] >= 11'h450) & (instructionExec[31:21] <= 11'h458))|
			((instructionExec[31:21] >= 11'h4D6)&(instructionExec[31:21] <= 11'h558))|((instructionExec[31:21] >= 11'h650)&(instructionExec[31:21] <= 11'h658))|
			((instructionExec[31:21] >= 11'h69A)&(instructionExec[31:21] <= 11'h758))))&(instructionExec[4:0] == instructionReg[9:5]))begin // For Exec->Reg forwarding R and I type
				AForward = 1;
			end else if((((instructionMem[31:21] >= 11'h488)&(instructionMem[31:21] <= 11'h491))|(((instructionMem[31:21] >= 11'h450) & (instructionMem[31:21] <= 11'h458))|
			((instructionMem[31:21] >= 11'h4D6)&(instructionMem[31:21] <= 11'h558))|((instructionMem[31:21] >= 11'h650)&(instructionMem[31:21] <= 11'h658))|
			((instructionMem[31:21] >= 11'h69A)&(instructionMem[31:21] <= 11'h758)))|(instructionMem[31:21] == 11'h7C2))&(instructionMem[4:0] == instructionReg[9:5]))begin // For Mem->Reg forwarding R and I type
				AForward = 2;
			end
		end
		
		// BForward Control Logic
		if(((instructionReg[31:24] == 8'hB4)|(instructionReg[31:24] == 8'hB5)|(instructionReg[31:21] == 11'h7C0))&(instructionReg[4:0] != 5'd31))begin // CBZ and STUR BForward control logic
			if((((instructionExec[31:21] >= 11'h488)&(instructionExec[31:21] <= 11'h491))|(((instructionExec[31:21] >= 11'h450) & (instructionExec[31:21] <= 11'h458))|
				((instructionExec[31:21] >= 11'h4D6)&(instructionExec[31:21] <= 11'h558))|((instructionExec[31:21] >= 11'h650)&(instructionExec[31:21] <= 11'h658))|
				((instructionExec[31:21] >= 11'h69A)&(instructionExec[31:21] <= 11'h758))))&(instructionExec[4:0] == instructionReg[4:0]))begin
				BForward = 1;
			end else if((((instructionMem[31:21] >= 11'h488)&(instructionMem[31:21] <= 11'h491))|(((instructionMem[31:21] >= 11'h450) & (instructionMem[31:21] <= 11'h458))|
				((instructionMem[31:21] >= 11'h4D6)&(instructionMem[31:21] <= 11'h558))|((instructionMem[31:21] >= 11'h650)&(instructionMem[31:21] <= 11'h658))|
				((instructionMem[31:21] >= 11'h69A)&(instructionMem[31:21] <= 11'h758)))|(instructionMem[31:21] == 11'h7C2))&(instructionMem[4:0] == instructionReg[4:0]))begin
				BForward = 2;
			end
		end
		
		if((((instructionReg[31:21] >= 11'h450) & (instructionReg[31:21] <= 11'h458))|((instructionReg[31:21] >= 11'h4D6)&(instructionReg[31:21] <= 11'h558))|((instructionReg[31:21] >= 11'h650)
		&(instructionReg[31:21] <= 11'h658))|((instructionReg[31:21] >= 11'h69A)&(instructionReg[31:21] <= 11'h758)))&(instructionReg[20:16] != 5'd31))begin
			if((((instructionExec[31:21] >= 11'h488)&(instructionExec[31:21] <= 11'h491))|(((instructionExec[31:21] >= 11'h450) & (instructionExec[31:21] <= 11'h458))|
				((instructionExec[31:21] >= 11'h4D6)&(instructionExec[31:21] <= 11'h558))|((instructionExec[31:21] >= 11'h650)&(instructionExec[31:21] <= 11'h658))|
				((instructionExec[31:21] >= 11'h69A)&(instructionExec[31:21] <= 11'h758))))&(instructionExec[4:0] == instructionReg[20:16]))begin
				BForward = 1;
			end else if((((instructionMem[31:21] >= 11'h488)&(instructionMem[31:21] <= 11'h491))|(((instructionMem[31:21] >= 11'h450) & (instructionMem[31:21] <= 11'h458))|
				((instructionMem[31:21] >= 11'h4D6)&(instructionMem[31:21] <= 11'h558))|((instructionMem[31:21] >= 11'h650)&(instructionMem[31:21] <= 11'h658))|
				((instructionMem[31:21] >= 11'h69A)&(instructionMem[31:21] <= 11'h758)))|(instructionMem[31:21] == 11'h7C2))&(instructionMem[4:0] == instructionReg[20:16]))begin
				BForward = 2;
			end
		end
	end
endmodule