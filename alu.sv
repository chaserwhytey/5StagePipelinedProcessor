`timescale 1ns/10ps
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	logic [1:0] Cin_most; // Cin of the most significant bit 
								 // 0: carry in from addition
								 // 1: carry out from subtraction
	logic [63:0] notB; 
	logic [63:0] ALU_PASS_B, ALU_ADD, ALU_SUBTRACT, ALU_AND, ALU_OR, ALU_XOR; // Result for each alu operation 
	logic [1:0] carry_out_add_sub; // 0: carry out from addtion
											 // 1: carry out from subtraction
	logic result_Cout, result_Cin;
	logic [63:0] notresult;
	
	assign ALU_PASS_B = B;
	
	fullAdder_VAR #(.WIDTH(64)) alu_add (.A, .B, .Cin(1'b0), .Cout(carry_out_add_sub[0]) , .sum(ALU_ADD) , .Cin_most(Cin_most[0]));
	
	not_VAR #(.WIDTH(64)) Bnot (.A(B), .result(notB));
	fullAdder_VAR #(.WIDTH(64)) alu_subtract (.A, .B(notB), .Cin(1'b1), .Cout(carry_out_add_sub[1]), .sum(ALU_SUBTRACT) , .Cin_most(Cin_most[1]));
	
	bitWiseAnd #(.WIDTH(64)) alu_and (.A, .B, .result(ALU_AND));
	bitWiseOr #(.WIDTH(64)) alu_or (.A, .B, .result(ALU_OR));
	bitWiseXor #(.WIDTH(64)) alu_xir (.A, .B, .result(ALU_XOR));
	
	mux64_8x3 mux_alus (.sel(cntrl), .I0(ALU_PASS_B), .I1(64'dx), .I2(ALU_ADD), .I3(ALU_SUBTRACT), .I4(ALU_AND), .I5(ALU_OR), .I6(ALU_XOR), .I7(64'd0), .O(result)); //mux that selects which ALU result
	
	mux2_1 mux_Cout (.out(result_Cout), .i0(carry_out_add_sub[0]), .i1(carry_out_add_sub[1]), .sel(cntrl[0])); // mux that selects which Carry out
	mux2_1 mux_Cin (.out(result_Cin), .i0(Cin_most[0]), .i1(Cin_most[1]), .sel(cntrl[0])); // mux that selects which Carry in of the most significant bit
	
	
	assign negative = result[63]; // sets negative flag
	xor #0.05 flag_overflow (overflow, result_Cout, result_Cin); // sets overflow flag
	assign carry_out = result_Cout; // sets carry_out flag
	
	not_VAR #(.WIDTH(64)) notresu ( .A(result), .result(notresult));
	and_64 flag_zero (.o(zero), .i(notresult)); // sets zero flag
	
	
	//parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	
	
	
	
endmodule

