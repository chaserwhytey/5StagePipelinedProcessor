module signExtender #(parameter WIDTHIN = 16, WIDTHOUT = 64) (
	input logic[WIDTHIN - 1:0] SEin , 
	output logic [WIDTHOUT - 1:0] SEOut);
	
	logic [WIDTHOUT-WIDTHIN -1 :0] mux_out;
	genvar i;
	generate
		for (i = 0; i < WIDTHOUT - WIDTHIN; i++) begin : setting
			mux2_1 set1or0 (.out(mux_out[i[WIDTHOUT-WIDTHIN-1:0]]), 
								 .i0(1'b0),         
								 .i1(1'b1),
								 .sel(SEin[WIDTHIN-1]));
		end
	endgenerate
		
		
	assign SEOut[WIDTHIN-1:0] = SEin[WIDTHIN-1:0];
	assign SEOut[WIDTHOUT-1: WIDTHIN] = mux_out;
endmodule
