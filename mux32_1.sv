`timescale 1ns/10ps
module mux32_1 (out,in,sel);
	output logic out;
	input logic [31:0] in;
	input logic [4:0] sel;
	
	logic o1, o2;
	
	mux16_1 m1 (.out(o1), .in(in[15:0]), .sel(sel[3:0]));
	mux16_1 m2 (.out(o2), .in(in[31:16]), .sel(sel[3:0]));
	mux2_1 m3 (.out, .i0(o1), .i1(o2), .sel(sel[4]));
	
endmodule

module mux32_1_testbench();
	logic out;
	logic [31:0] in;
	logic [4:0] sel;
	
	mux32_1 dut (.out, .in, .sel);

	initial begin
		int i;
		for (i = 0; i < 32; i++) begin
			sel=i; in= 4330; #10;
			sel=i; in= 433023; #10;
			sel=i; in= 4330454; #10;
		end
	end
endmodule 
