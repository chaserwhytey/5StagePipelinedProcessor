`timescale 1ns/10ps
module bitWiseXor #(parameter WIDTH = 64) (input logic [WIDTH - 1:0] A, B, 
output logic [WIDTH - 1:0] result);
	genvar i;
	generate
		for (i = 0; i < WIDTH; i++) begin : xorrers
			xor #0.05 xor1(result[i], A[i], B[i]);
		end
	endgenerate
endmodule 

module bitWiseXor_testbench();
	logic [63:0] A, B, result;
	
	bitWiseXor #(.WIDTH(64)) dut(.A, .B, .result);
	
	
	initial begin
		int i;
		for (i = 0; i < 16; i++) begin
			A = i * 64'd69;
			B = i * 64'd72;
		end
	end
endmodule
