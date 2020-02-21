`timescale 1ns/10ps
module mux8_1(out, in, sel);
	output logic out;
	input logic [7:0] in;
	input logic [2:0] sel;
	
	logic o1, o2;
	
	mux4_1 m1 (.out(o1), .in(in[3:0]), .sel(sel[1:0]));
	mux4_1 m2 (.out(o2), .in(in[7:4]), .sel(sel[1:0]));
	mux2_1 m3 (.out, .i0(o1), .i1(o2), .sel(sel[2]));
	
endmodule

module mux8_1_testbench();
	logic out;
	logic [7:0] in;
	logic [2:0] sel;
	
	mux8_1 dut (.out, .in, .sel);

	initial begin
		int i;
		for (i = 0; i < 256; i++) begin
		
			sel=3'b000; in= i; #10;
			sel=3'b001; in= i; #10;
			sel=3'b010; in= i; #10;
			sel=3'b011; in= i; #10;
			sel=3'b100; in= i; #10;
			sel=3'b101; in= i; #10;
			sel=3'b110; in= i; #10;
			sel=3'b111; in= i; #10;
		end
	end
endmodule 
	