`timescale 1ns/10ps

module datapath (
	input logic [31:0] instruction,
	input logic clk, BL, flags, reg2Loc, memToReg, regWrite, memWrite, memRead, reset, flagSA, forward, updateFlags,
	input logic [1:0] ALUSrc,
	input logic [2:0] ALUOp,
	input logic [63:0] PCReg,
	output logic [63:0] regRd,
	output logic zero, overflow, negative, carry_out, cbz_brTaken, p2_updateFlags);
	
	
	logic zeroS, overflowS, negativeS, carry_outS;
	logic zeroA, overflowA, negativeA, carry_outA;
	logic [63:0] dAddr9, p2_dAddr9, ALU_Imm12, p2_ALU_Imm12;
	logic [4:0] Rd, Rm, Rn, Aw, Ab, Rd_X30, Rd_X30_forward, p2_Rd, p3_Rd, p4_Rd;
	logic [63:0] Da, Db, muxA, B, Dw, p2_Da, p2_Db, p3_Db;	
	logic [63:0] result, writeDataReg, memToRegData, read_data, p4_read_data, p3_result, p4_result, p2_PCNext, p3_PCNext, p4_PCNext, p2_forward_result, p3_forward_result, p3_forward_result1;
	
	logic [1:0] p2_ALUSrc;
	logic [2:0] p2_ALUOp;
	logic p2_memWrite, p2_memToReg, p2_regWrite, p2_memRead, p2_BL;
	logic p3_memWrite, p3_memToReg, p3_regWrite, p3_memRead, p3_BL;
	logic p4_memToReg, p4_regWrite, p4_BL;
	
	//level 2 starts here
	assign Rm = instruction[20:16];
	assign Rn = instruction[9:5];
	assign Rd = instruction[4:0];
	
	//forwarding module
	logic flag1Rn, flag1Rmd, flag2Rmd, flag2Rn;
	logic bltFlag, updateBltFlag, notFlagSA, updaterOfFlag, p2_flagSA;
	logic [63:0] DaIn, DbIn, DaI, DbI, not_Db;
	
	
	Xmux2_1 #(.WIDTH(5)) mux_Rd_X30 (.A(Rd), .B(5'd30), .out(Rd_X30), .sel(BL)); // Mux to choose X30 or Rd
	Xmux2_1 #(.WIDTH(5)) mux_Rd_X30_forward (.A(5'bx), .B(Rd_X30), .out(Rd_X30_forward), .sel(forward)); // Mux to choose input to forwarding unit or not
	forward f1(.Rn, .Rmd(Ab), .Rd(Rd_X30_forward), .reset, .clk, .flag1Rn, .flag1Rmd, .flag2Rn, .flag2Rmd);  // We want to use X30 or Rd in 'Rd port' to include if BL wrote 
	
	Xmux2_1 #(.WIDTH(64)) muxFRn(.A(Da), .B(p3_forward_result), .out(DaI), .sel(flag2Rn));
	Xmux2_1 #(.WIDTH(64)) muxFRm(.A(Db), .B(p3_forward_result), .out(DbI), .sel(flag2Rmd));
	
	Xmux2_1 #(.WIDTH(64)) muxFRnn(.A(DaI), .B(p2_forward_result), .out(DaIn), .sel(flag1Rn));
	Xmux2_1 #(.WIDTH(64)) muxFRmm(.A(DbI), .B(p2_forward_result), .out(DbIn), .sel(flag1Rmd));
	Xmux2_1 #(.WIDTH(5)) muxRdRm (.A(Rd), .B(Rm), .out(Ab), .sel(reg2Loc));
	
	regfile reggie(.ReadData1(Da), .ReadData2(Db), .WriteData(writeDataReg), .ReadRegister1(Rn), .ReadRegister2(Ab), 
						.WriteRegister(Aw), .RegWrite(p4_regWrite), .clk(~clk));
	assign regRd = DbIn;
	
	not_VAR #(.WIDTH(64)) not_Dbf (.A(DbIn), .result(not_Db));
	and_64 flag_zero (.o(cbz_brTaken), .i(not_Db)); //brTaken control signal for CBZ instruction, REG/DEC pipeline level
	
	signExtender #(.WIDTHIN(9), .WIDTHOUT(64)) se1 (.SEin(instruction[20:12]), .SEOut(dAddr9));
	signExtender #(.WIDTHIN(12), .WIDTHOUT(64)) se2 (.SEin(instruction[21:10]), .SEOut(ALU_Imm12));
	DFF_VAR #(.WIDTH(64)) p2_Reg_ALUImm12 (.q(p2_ALU_Imm12), .d(ALU_Imm12), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p2_Reg_dAddr9 (.q(p2_dAddr9), .d(dAddr9), .wr_en(1'b1), .reset, .clk);
	
	DFF_VAR #(.WIDTH(1)) p2_Reg_BL ( .q(p2_BL), .d(BL), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p2_Reg_PCNext ( .q(p2_PCNext), .d(PCReg), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p2_Reg_Da (.q(p2_Da), .d(DaIn), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p2_Reg_Db (.q(p2_Db), .d(DbIn), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(9)) p2_Reg_controls (.q({p2_ALUSrc, p2_ALUOp, p2_memWrite, p2_memToReg, p2_regWrite, p2_memRead}), 
	.d({ALUSrc, ALUOp, memWrite, memToReg, regWrite, memRead}), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(1)) updateFlagsReg(.q(p2_updateFlags), .d(updateFlags), .wr_en(1'b1), .reset, .clk);
	
	
	//
	DFF_VAR #(.WIDTH(5)) p2_Reg_Rd (.q(p2_Rd), .d(Rd), .wr_en(1'b1), .reset, .clk);

	//level 3 starts here
	
	


	Xmux2_1 #(.WIDTH(64)) muxers (.A(p2_Db), .B(p2_dAddr9), .out(muxA), .sel(p2_ALUSrc[0]));
	Xmux2_1 #(.WIDTH(64)) muxerz (.A(muxA), .B(p2_ALU_Imm12), .out(B), .sel(p2_ALUSrc[1]));
	alu alu1(.A(p2_Da), .B, .cntrl(p2_ALUOp), .result, .negative(negative), .zero(zero), .overflow(overflow), .carry_out(carry_out));
	Xmux2_1 #(.WIDTH(64)) p2_mux_ALU_BL(.A(result), .B(p2_PCNext), .out(p2_forward_result), .sel(p2_BL));
	
	
	DFF_VAR #(.WIDTH(1)) p3_Reg_BL ( .q(p3_BL), .d(p2_BL), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p3_Reg_PCNext ( .q(p3_PCNext), .d(p2_PCNext), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p3_Ex_Db (.q(p3_Db), .d(p2_Db), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p3_Ex_ALU (.q(p3_result), .d(result), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(4)) p3_Ex_controls (.q({p3_memWrite, p3_memToReg, p3_regWrite, p3_memRead}), 
				.d({p2_memWrite, p2_memToReg, p2_regWrite, p2_memRead}), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(5)) p3_Reg_Rd (.q(p3_Rd), .d(p2_Rd), .wr_en(1'b1), .reset, .clk);

	//level 4 starts here
	datamem memory(.address(p3_result), .write_enable(p3_memWrite), .read_enable(p3_memRead), .write_data(p3_Db), .clk, .xfer_size(4'd8), .read_data);
	Xmux2_1 #(.WIDTH(64)) p3_mux_ALU_BL(.A(p3_result), .B(p3_PCNext), .out(p3_forward_result1), .sel(p3_BL));
	Xmux2_1 #(.WIDTH(64)) p3_mux_ALU_LDURForward(.A(p3_forward_result1), .B(read_data), .out(p3_forward_result), .sel(p3_memRead));//forward data from memory if LDUR


	
	DFF_VAR #(.WIDTH(1)) p4_Reg_BL ( .q(p4_BL), .d(p3_BL), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p5_Reg_PCNext ( .q(p4_PCNext), .d(p3_PCNext), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p4_Mem_memory (.q(p4_read_data), .d(read_data), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(64)) p4_Mem_ALU (.q(p4_result), .d(p3_result), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(2)) p4_Mem_controls (.q({p4_memToReg, p4_regWrite}), .d({p3_memToReg, p3_regWrite}), .wr_en(1'b1), .reset, .clk);
	DFF_VAR #(.WIDTH(5)) p4_Reg_Rd (.q(p4_Rd), .d(p3_Rd), .wr_en(1'b1), .reset, .clk);

	//level 5 stars here
	Xmux2_1 #(.WIDTH(64)) muxerino_memtoReg (.A(p4_result), .B(p4_read_data), .out(memToRegData), .sel(p4_memToReg));
	Xmux2_1 #(.WIDTH(64)) muxerino_BL (.A(memToRegData), .B(p4_PCNext), .out(writeDataReg), .sel(p4_BL));
	
	Xmux2_1 #(.WIDTH(5)) mux30Rd (.A(p4_Rd), .B(5'd30), .out(Aw), .sel(p4_BL));
	
	
	
	// Xmux2_1 #(.WIDTH(1)) muxRegWrite(.A(p4_regWrite), .B(regWrite), .out(TregWrite), .sel(p4_BL));

/*	
	DFF_VAR #(.WIDTH(4)) whatflags (.q({negativeS,zeroS,overflowS,carry_outS}) , .d({negativeA,zeroA,overflowA,carry_outA}) , .wr_en(flags), .reset, .clk);
	
	Xmux2_1 #(.WIDTH(4)) muxflags (.A({negativeS,zeroS,overflowS,carry_outS}), .B({negativeA,zeroA,overflowA,carry_outA}), .out({negative,zero,overflow,carry_out}), .sel(flagSA));
*/
	

	

endmodule
