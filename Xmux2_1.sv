module Xmux2_1 #(parameter WIDTH = 64) (
	input logic [WIDTH - 1:0] A, B, 
	output logic[WIDTH - 1:0] out, 
	input logic sel);
	
	genvar i;
	generate
		for(i = 0; i < WIDTH; i++) begin : muxers
			mux2_1 mxxx (.out(out[i]), .i0(A[i]), .i1(B[i]), .sel);
		end
	endgenerate
endmodule
