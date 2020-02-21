`timescale 1ns/10ps

module instructionDP(
	input logic clk, reset, brTaken, uncondBr, BR, flagSA, p2_updateFlags, negative, overflow, 
	input logic [63:0] rData,
	output logic [31:0] instruction, 
	output logic [63:0] PCReg);
	
	logic[63:0] PC, PCNext, PCONext, PCActualNext, PCActualActualNext, condAddr19, brAddr26, brShift, p2_condAddr19, p2_brAddr26;

	logic negative1, negative2, overflow1, overflow2, zero1, zero2, carry_out1, carry_out2, bltFlag, updateBltFlag, takeBranch, mtakeBranch, bltFlagAndFlagSA, notFlagSA, flagSAUpdate;

	alu alu1(.A(PC), .B(64'd4), .cntrl(3'b010), .result(PCNext), .negative(negative1), .zero(zero1), .overflow(overflow1), .carry_out(carry_out1));

	instructmem pcer(.address(PC), .instruction, .clk);

	signExtender #(.WIDTHIN(21), .WIDTHOUT(64)) se1 (.SEin({instruction[23:5], 2'd0}), .SEOut(condAddr19)); // SignExtend and multiply by 4 by shifing 2bits left

	signExtender #(.WIDTHIN(28), .WIDTHOUT(64)) se2 (.SEin({instruction[25:0], 2'd0}), .SEOut(brAddr26));   // SignExtend and multiply by 4 by shifting 2bits left
		
	DFF_VAR #(.WIDTH(64)) p2_brAddr269 (.q(p2_brAddr26), .d(brAddr26), .wr_en(1'b1), .reset, .clk);
	
	DFF_VAR #(.WIDTH(64)) p2_condAddr1969 (.q(p2_condAddr19), .d(condAddr19), .wr_en(1'b1), .reset, .clk);

	Xmux2_1 #(.WIDTH(64)) muxing (.A(p2_condAddr19), .B(p2_brAddr26), .out(brShift), .sel(uncondBr));

	alu alu2(.A(brShift), .B(PC), .cntrl(3'b010), .result(PCONext), .negative(negative2), .zero(zero2), .overflow(overflow2), .carry_out(carry_out2));

	Xmux2_1 #(.WIDTH(64)) muxting (.A(PCNext), .B(PCONext - 64'd4), .out(PCActualNext), .sel(takeBranch));
	
	//mux for BR Rd
	Xmux2_1 #(.WIDTH(64)) muxorz (.A(PCActualNext), .B(rData), .out(PCActualActualNext), .sel(BR)); 
	assign PCReg = PC;
	
	
	xor #0.05 xor1(updateBltFlag, negative, overflow);
	not #0.05 not1(notFlagSA, flagSA);
	and #0.05 FlagSAandupdating(flagSAUpdate, flagSA, p2_updateFlags);
	//Xmux2_1 #(.WIDTH(1)) updaterOfBlt(.A(brTaken), .B(1'b0), .out(updateBltFlag), .sel(flagSA));

	DFF_VAR #(.WIDTH(1)) updateblt(.q(bltFlag), .d(updateBltFlag), .wr_en(p2_updateFlags), .reset, .clk);
	//DFF_VAR #(.WIDTH(1)) flagSAp2(.q(p2_flagSA), .d(flagSA), .wr_en(1'b1), .reset, .clk);
	Xmux2_1 #(.WIDTH(1)) whichBLTorbrTaken(.A(brTaken), .B(bltFlag), .out(mtakeBranch), .sel(flagSA)); 
	Xmux2_1 #(.WIDTH(1)) whetherBLTBranchTaken(.A(mtakeBranch), .B(brTaken), .out(takeBranch), .sel(flagSAUpdate)); 

	
	always_ff@(posedge clk) begin
		if(reset) begin
			PC <= 0;
		end
		else begin
			PC <= PCActualActualNext;
		end

	end
endmodule

module instructionDP_testbench ();
	logic clk, reset, brTaken, uncondBr, BR;
	logic [63:0] rData;
	logic [31:0] instruction; 
	logic [63:0] PCReg;
	
	instructionDP iDP (
		.clk, .reset, .brTaken, .uncondBr, .BR,
		.rData,
		.instruction, 
		.PCReg);
		
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0;	brTaken <=1; uncondBr <= 1; BR <= 0; rData <= 64'd543; @(posedge clk);  //B
		brTaken <=1; uncondBr <= 0; BR <= 0; rData <= 64'd543; @(posedge clk);  // B.LT (true)
		brTaken <=0; uncondBr <= 0; BR <= 0; rData <= 64'd543; @(posedge clk);  // B.LT (false)
		brTaken <=1; uncondBr <= 0; BR <= 0; rData <= 64'd543; @(posedge clk);  // CBZ (true)
		brTaken <=0; uncondBr <= 0; BR <= 0; rData <= 64'd543; @(posedge clk);  // CBZ (false)
		brTaken <=1; uncondBr <= 1; BR <= 0; rData <= 64'd543; @(posedge clk);  // BL
		brTaken <='x; uncondBr <= 'x; BR <= 1; rData <= 64'd543; @(posedge clk); //BR
		brTaken <=0; uncondBr <= 'x; BR <= 0; rData <= 64'd543; @(posedge clk);  // ADDI, ADDS, SUBS, LDUR, STUR
		$stop;
	end
endmodule
		
		
		
		
		
		
		
		
		