`timescale 1ns/10ps
module and_4 ( o, i);
	output logic o;
	input logic [3:0] i;
	
	logic a,b;
	
	and #0.05 (a,i[0],i[1]);
	and #0.05 (b, i[2], i[3]);
	and #0.05 (o,a,b);
endmodule 

