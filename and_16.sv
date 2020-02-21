`timescale 1ns/10ps
module and_16 (o, i);
	output logic o;
	input logic [15:0] i;
	
	logic a,b,c,d;
	
	and_4 a0 (.o(a), .i(i[3:0]));
	and_4 a1 (.o(b), .i(i[7:4]));
	and_4 a2 (.o(c), .i(i[11:8]));
	and_4 a3 (.o(d), .i(i[15:12]));
	
	and_4 a4 (.o, .i({d,c,b,a}));
endmodule
