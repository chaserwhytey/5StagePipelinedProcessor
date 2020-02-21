`timescale 1ns/10ps
module and_64(o,i);
	output logic o;
	input logic [63:0] i;
	
	logic a,b,c,d;
	
	and_16 a0 (.o(a), .i(i[15:0]));
	and_16 a1 (.o(b), .i(i[31:16]));
	and_16 a2 (.o(c), .i(i[47:32]));
	and_16 a3 (.o(d), .i(i[63:48]));
	
	and_4 a4 (.o, .i({d,c,b,a}));

endmodule
