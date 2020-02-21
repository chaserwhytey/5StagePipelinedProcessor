`timescale 1ns/10ps
module mux2_1(out, i0, i1, sel);
	output logic out;
	input logic i0, i1, sel;
	
	logic out_1, out_2, n_sel;
	
	and #0.05 a1 (out_1, i1, sel);
	not #0.05 n1 (n_sel, sel);
	and #0.05 a2 (out_2, i0, n_sel);
	or #0.05 o1 (out, out_1, out_2);
		
	// assign out = (i1 & sel) | (i0 & ~sel);
endmodule

module mux2_1_testbench();
	logic i0, i1, sel;
	logic out;

	mux2_1 dut (.out, .i0, .i1, .sel);

	initial begin
		sel=0; i0=0; i1=0; #10;	
		sel=0; i0=0; i1=1; #10;
		sel=0; i0=1; i1=0; #10;
		sel=0; i0=1; i1=1; #10;
		sel=1; i0=0; i1=0; #10;
		sel=1; i0=0; i1=1; #10;
		sel=1; i0=1; i1=0; #10;
		sel=1; i0=1; i1=1; #10;
	end
endmodule 
