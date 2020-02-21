`timescale 1ns/10ps
module not_VAR #(parameter WIDTH = 64) (A,result);
	input logic [WIDTH-1:0] A;
	output logic [WIDTH-1:0] result;
	genvar i;
	generate
		for (i=0; i< WIDTH; i++) begin : noters 
			not #0.05 noot (result[i], A[i]);
		end
	endgenerate
endmodule

module not_VAR_testbench();
	logic [63:0] A;
	logic [63:0] result;
	
	not_VAR #(.WIDTH(64)) dut (.A, .result);
	
	initial begin
		for (int i = 0; i < 1000; i++) begin
			A = i; #10;
		end
	end
endmodule
