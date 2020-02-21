`timescale 1ns/10ps
module fullAdder(A,B,Cin,Cout,sum);
	input logic A, B, Cin;
	output logic Cout, sum;
	
	logic xorAB, andABC, andAB;
	
	xor #0.05 XAB (xorAB, A, B);
	xor #0.05 XABCin (sum, xorAB, Cin);
	and #0.05 AABCin (andABC, Cin, xorAB);
	and #0.05 AAB (andAB, A,B);
	or #0.05 OAA (Cout, andABC, andAB);
	
endmodule

module fullAdder_testbench();
	logic A,B,Cin;
	logic Cout, sum;
	
	fullAdder dut(.A,.B,.Cin,.Cout,.sum);
	
	initial begin
		A = 0; B = 0; Cin = 0;#10;
		A = 0; B = 0; Cin = 1;#10;
		A = 0; B = 1; Cin = 0;#10;
		A = 0; B = 1; Cin = 1;#10;
		A = 1; B = 0; Cin = 0;#10;
		A = 1; B = 0; Cin = 1;#10;
		A = 1; B = 1; Cin = 0;#10;
		A = 1; B = 1; Cin = 1;#10;
	end
endmodule 