`timescale 1ns/10ps
module dec5_32(a,en,out);
	output logic [31:0] out;
	input logic [4:0] a;
	input logic en;
	
	logic [1:0] dec_to_en;
	
	dec1_2 dec1 (.a(a[4]), .en, .out(dec_to_en));
	
	dec4_16 dec2 (.a(a[3:0]), .en(dec_to_en[0]), .out(out[15:0]));
	dec4_16 dec3 (.a(a[3:0]), .en(dec_to_en[1]), .out(out[31:16]));
	
endmodule

module dec5_32_testbench();

	logic [31:0] out;
	logic [4:0] a;
	logic en;
	
	dec5_32 dut (.a, .en, .out);
	
	initial begin
		int i;
		for ( i = 0; i < 32; i++) begin
			a = i; en = 0; #10;
		end
		
		for ( i = 0; i < 32; i++) begin
			a = i; en = 1; #10;
		end
	end
endmodule
	