`timescale 1ns/10ps
module dec1_2 (a,en, out);
	output logic [1:0] out;
	input logic a, en;
	
	logic nota;
	
	not #0.05 n1 (nota, a);
	and #0.05 a1 (out[0], en, nota);
	and #0.05 a2 (out[1], en, a);
endmodule

module dec1_2_testbench();
	logic [1:0] out;
	logic a, en;
	
	dec1_2 dut (.a, .en, .out);
	
	initial begin
		a = 0; en = 0; #10;
		a = 1; 		   #10;
		a = 0; en = 1; #10;
		a = 1;			#10;
	end
endmodule 