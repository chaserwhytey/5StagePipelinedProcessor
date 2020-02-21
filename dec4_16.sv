`timescale 1ns/10ps
module dec4_16(a,en,out);
	output logic [15:0] out;
	input logic [3:0] a;
	input logic en;
	
	logic [3:0] dec_to_en;
	
	dec2_4 dec1 (.a(a[3:2]), .en, .out(dec_to_en));
	
	dec2_4 dec2 (.a(a[1:0]), .en(dec_to_en[0]), .out(out[3:0]));
	dec2_4 dec3 (.a(a[1:0]), .en(dec_to_en[1]), .out(out[7:4]));
	dec2_4 dec4 (.a(a[1:0]), .en(dec_to_en[2]), .out(out[11:8]));
	dec2_4 dec5 (.a(a[1:0]), .en(dec_to_en[3]), .out(out[15:12]));
	
endmodule

module dec4_16_testbench();

	logic [15:0] out;
	logic [3:0] a;
	logic en;
	
	dec4_16 dut (.a, .en, .out);
		
	initial begin
		int i;
		for (i = 0; i < 16; i++) begin 
			a = i; en = 0; #10;
		end
		
		for (i = 0; i < 16; i++) begin 
			a = i; en = 1; #10;
		end
	end
endmodule 