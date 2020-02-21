`timescale 1ns/10ps

module CPU(clk, reset);	
		input logic clk;
		input logic reset;
		logic [63:0] PCReg, regRd;
		logic [31:0] instruction, p1_instruction;

		logic negative, zero, overflow, carry_out; // ALU flags 		
		logic reg2Loc, memToReg, regWrite, memWrite, memRead, brTaken, uncondBr, BL, BR, flags, flagSA, cbz_brTaken, forward, updateFlags, p2_updateFlags; // Control logics
		logic [1:0] ALUSrc; // Control logic
		logic [2:0] ALUOp;  // Control logic
		
		instructionDP pcer(.clk, .reset, .brTaken, .uncondBr, .BR, .flagSA, .p2_updateFlags, .negative, .overflow, .instruction, .rData(regRd), .PCReg); 
		DFF_VAR #(.WIDTH(32)) p1_IF (.q(p1_instruction), .d(instruction), .wr_en(1'b1), .reset, .clk);
		
		control controllerOfStuff(.instruction(p1_instruction[31:21]), .zero, .overflow, .negative, 
		.cbz_brTaken, .reg2Loc, .ALUSrc, .memToReg, .regWrite, .memWrite, .brTaken, .uncondBr, .ALUOp, .BL, .BR, .flags, .flagSA, .memRead, .forward, .updateFlags);

		datapath reg_mem_dp  ( .instruction(p1_instruction), .clk, .BL, .flags, .reg2Loc, .memToReg, 
		.regWrite, .memWrite, .memRead, .reset, .flagSA, .forward, .updateFlags, .ALUSrc, .ALUOp, .PCReg, .regRd, .zero, .overflow, .negative, .carry_out, .cbz_brTaken, .p2_updateFlags);
		
endmodule 

module CPU_testbench();
	logic clk;
	logic reset;
	
	CPU dut (.clk, .reset);
	
	parameter CLOCK_PERIOD=1000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for (int i = 0; i <= 800; i++) begin
			@(posedge clk);
		end
		$stop;
	end
endmodule
