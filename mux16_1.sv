`timescale 1ns/10ps
module mux16_1 (out,in,sel);
	output logic out;
	input logic [15:0] in;
	input logic [3:0] sel;
	
	logic o1, o2;
	
	mux8_1 m1 (.out(o1), .in(in[7:0]), .sel(sel[2:0]));
	mux8_1 m2 (.out(o2), .in(in[15:8]), .sel(sel[2:0]));
	mux2_1 m3 (.out, .i0(o1), .i1(o2), .sel(sel[3]));
	
endmodule


module mux16_1_testbench();
	logic out;
	logic [15:0] in;
	logic [3:0] sel;
	
	mux16_1 dut (.out, .in, .sel);

	initial begin
		int i, j;
		for (i = 0; i < 256; i++) begin
			for ( j = 0; j < 16; j++) begin
				sel=j; in= i; #10;
			end
		end
	end
endmodule 
	