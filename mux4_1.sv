`timescale 1ns/10ps
module mux4_1 (out, in, sel);
	output logic out;
	input logic [3:0] in;
	input logic [1:0] sel;
	
	logic o1, o2;
	
	mux2_1 m1 (.out(o1), .i0(in[0]), .i1(in[1]), .sel(sel[0]));
	mux2_1 m2 (.out(o2), .i0(in[2]), .i1(in[3]), .sel(sel[0]));
	mux2_1 m3 (.out, .i0(o1), .i1(o2), .sel(sel[1]));
	
endmodule

module mux4_1_testbench();
	logic out;
	logic [3:0] in;
	logic [1:0] sel;
	
	mux4_1 dut (.out, .in, .sel);

	initial begin
		int i;
		for (i = 0; i < 16; i++) begin
		
			sel=2'b00; in= i; #10;
			sel=2'b01; in= i; #10;
			sel=2'b10; in= i; #10;
			sel=2'b11; in= i; #10;
		end
	end
endmodule 
