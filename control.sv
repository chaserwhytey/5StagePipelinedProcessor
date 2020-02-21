//instruction set[32:21] is taken
`timescale 1ns/10ps

module control(
	input logic [10:0] instruction, 
	input logic zero, overflow, negative, cbz_brTaken,
	output logic [2:0] ALUOp,
	output logic [1:0] ALUSrc, 
	output logic reg2Loc, memToReg, regWrite,memWrite, brTaken, uncondBr, BL, BR, flags, flagSA, memRead, forward, updateFlags); // flagSA == 0, use flags from previous clk cycle
																																			 // flagSA == 1, use flags from current clk cycle
																																			 // flags == 0, do nothing
																																			 // flags == 1, store flags in buffer
																																			
	
	always_comb begin
		if ( instruction[10:5] == 6'b000101) begin // B
			reg2Loc 	= 1'bx;
			memToReg = 1'bx;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= 1'b1;
			uncondBr = 1'b1;
			ALUOp 	= 3'bx;
			BL			= 1'bx;
			BR 		= 1'b0;
			ALUSrc	= 2'bx;
			regWrite = 1'b0;
			flags 	= 1'bx;
			flagSA  = 1'b0;
			forward	= 1'b0;
			updateFlags = 1'b0;
		end else if (instruction[10:3] == 8'b01010100) begin // B.LT
			reg2Loc 	= 1'bx;
			memToReg = 1'bx;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= negative != overflow;
			uncondBr = 1'b0;
			ALUOp 	= 3'bx;
			BL			= 1'bx;
			BR 		= 1'b0;
			ALUSrc	= 2'bx;
			regWrite = 1'b0;
			flags 	= 1'bx;
			flagSA  = 1'b1;
			forward	= 1'b0;
			updateFlags = 1'b0;
		end else if (instruction[10:3] == 8'b10110100) begin // CBZ
			reg2Loc 	= 1'b0;
			memToReg = 1'bx;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= cbz_brTaken;
			uncondBr = 1'b0;
			ALUOp 	= 3'b000; // PASS_B
			BL			= 1'b0;
			BR 		= 1'b0;
			ALUSrc	= 2'b00;
			regWrite = 1'b0;
			flags 	= 1'bx;
			flagSA  = 1'b0;
			forward	= 1'b0;
			updateFlags = 1'b0;
		end else if (instruction[10:5] == 6'b100101) begin //BL
			reg2Loc 	= 1'bx;
			memToReg = 1'bx;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= 1'b1;
			uncondBr = 1'b1;
			ALUOp 	= 3'bx;
			BL			= 1'b1;
			BR 		= 1'b0;
			ALUSrc	= 2'b00;
			regWrite = 1'b1;
			flags 	= 1'bx;
			flagSA  = 1'b0;
			forward	= 1'b1;
			updateFlags = 1'b0;
		end else if (instruction == 11'b11010110000) begin //BR
			reg2Loc 	= 1'b0;
			memToReg = 1'bx;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= 1'bx;
			uncondBr = 1'bx;
			ALUOp 	= 3'bx;
			BL			= 1'b0;
			BR 		= 1'b1;
			ALUSrc	= 2'bxx;
			regWrite = 1'b0;
			flags 	= 1'bx;
			flagSA  = 1'b0;
			forward	= 1'b0;
			updateFlags = 1'b0;
		end else if (instruction[10:1] == 10'b1001000100) begin //ADDI
			reg2Loc 	= 1'bx;
			memToReg = 1'b0;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= 1'b0;
			uncondBr = 1'bx;
			ALUOp 	= 3'b010; //ADD
			BL			= 1'b0;
			BR 		= 1'b0;
			ALUSrc	= 2'b10;
			regWrite = 1'b1;
			flags 	= 1'bx;
			flagSA  = 1'b0;
			forward	= 1'b1;
			updateFlags = 1'b0;
		end else if (instruction == 11'b10101011000) begin //ADDS
			reg2Loc 	= 1'b1;
			memToReg = 1'b0;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= 1'b0;
			uncondBr = 1'bx;
			ALUOp 	= 3'b010; //ADD
			BL			= 1'b0;
			BR 		= 1'b0;
			ALUSrc	= 2'b00;
			regWrite = 1'b1;
			flags 	= 1'b1;
			flagSA  = 1'b0;
			forward	= 1'b1;
			updateFlags = 1'b1;
		end else if (instruction == 11'b11101011000) begin //SUBS
			reg2Loc 	= 1'b1;
			memToReg = 1'b0;
			memWrite = 1'b0;
			memRead	= 1'b0;
			brTaken 	= 1'b0;
			uncondBr = 1'bx;
			ALUOp 	= 3'b011; //subtract
			BL			= 1'b0;
			BR 		= 1'b0;
			ALUSrc	= 2'b00;
			regWrite = 1'b1;
			flags 	= 1'b1;
			flagSA  = 1'b0;
			forward	= 1'b1;		
			updateFlags = 1'b1;
		end else if (instruction == 11'b11111000010) begin //LDUR
			reg2Loc 	= 1'bx;
			memToReg = 1'b1;
			memWrite = 1'b0;
			memRead	= 1'b1;
			brTaken 	= 1'b0;
			uncondBr = 1'bx;
			ALUOp 	= 3'b010; //ADD
			BL			= 1'b0;
			BR 		= 1'b0;
			ALUSrc	= 2'b01;
			regWrite = 1'b1;
			flags 	= 1'b0;
			flagSA  = 1'b0;
			forward	= 1'b1;
			updateFlags = 1'b0;
		end else if (instruction == 11'b11111000000) begin //STUR
			reg2Loc 	= 1'b0;
			memToReg = 1'bx;
			memWrite = 1'b1;
			memRead	= 1'b0;
			brTaken 	= 1'b0;
			uncondBr = 1'bx;
			ALUOp 	= 3'b010; //ADD
			BL			= 1'b0;
			BR 		= 1'b0;
			ALUSrc	= 2'b01;
			regWrite = 1'b0;
			flags 	= 1'b0;
			flagSA  = 1'b0;
			forward	= 1'b0;
			updateFlags = 1'b0;
		end else begin 				//Default
			reg2Loc 	= 1'bx;
			memToReg = 1'bx;
			memWrite = 1'bx;
			memRead	= 1'bx;
			brTaken 	= 1'b0;
			uncondBr = 1'bx;
			ALUOp 	= 1'bx;
			BL			= 1'bx;
			BR 		= 1'b0;
			ALUSrc	= 2'bx;
			regWrite = 1'bx;
			flags 	= 1'bx;
			flagSA  = 1'b0;
			forward	= 1'bx;
			updateFlags = 1'b0;
		end
	end
endmodule 
