`timescale 1ns/10ps
module dec2_4 (a,en,out);
	output logic [3:0] out;
	input logic [1:0] a;
	input logic en;
	
	logic [1:0] en_to_dec;
	
	dec1_2 dec1 (.a(a[1]), .en, .out(en_to_dec));
	
	dec1_2 dec2 (.a(a[0]), .en(en_to_dec[0]), .out(out[1:0]));
	dec1_2 dec3 (.a(a[0]), .en(en_to_dec[1]), .out(out[3:2]));
	
endmodule

module dec2_4_testbench ();
	logic [3:0] out;
	logic [1:0] a;
	logic en;
	
	dec2_4 dut (.a, .en, .out);
	
		
	initial begin
		a = 0; en = 0; #10;
		a = 1; 		   #10;
		a = 2; 		   #10;
		a = 3; 		   #10;
		
		a = 0; en = 1; #10;
		a = 1;			#10;
		a = 2;			#10;
		a = 3;			#10;
	end
endmodule 