`timescale 1ns/10ps
module mux64_8x3(input logic [2:0] sel, input logic [63:0] I0,I1,I2,I3,I4,I5,I6,I7,
output logic [63:0] O);
	genvar i; 
	generate
	for(i = 0; i < 64; i++) begin: muxers
		mux8_1 mux64_8_3 (.out(O[i]), .in({I7[i], I6[i], I5[i], I4[i], I3[i], I2[i], I1[i], I0[i]}), .sel);
	end
	endgenerate
endmodule 

module mux64_8x3_testbench ();
	logic [2:0] sel;
	logic [63:0] I0,I1,I2,I3,I4,I5,I6,I7;
	logic [63:0] O;
	
	mux64_8x3 mx (.sel, .I0, .I1, .I2, .I3, .I4, .I5, .I6, .I7, .O);
	
	initial begin
			I1 = 10'd111111;
			I2 = 10'd111112;
			I3 = 10'd111113;
			I4 = 10'd1111114;
			I5 = 10'd103413;
			I6 = 10'd100525234;
			I7 = 10'd10000013432;
			sel = 3'b000; #10;
			sel = 3'b001; #10;
			sel = 3'b010; #10;
			sel = 3'b011; #10;
			sel = 3'b100; #10;
			sel = 3'b101; #10;
			sel = 3'b110; #10;
			sel = 3'b111; #10;
	
	end
endmodule
