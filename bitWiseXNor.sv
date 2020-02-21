`timescale 1ns/10ps
module bitWiseXNor #(parameter WIDTH = 64) (input logic [WIDTH - 1:0] A, B, 
output logic [WIDTH - 1:0] result);
	genvar i;
	generate
		for (i = 0; i < WIDTH; i++) begin : orrers
			xnor #0.05 xnor1(result[i], A[i], B[i]);
		end
	endgenerate
endmodule 