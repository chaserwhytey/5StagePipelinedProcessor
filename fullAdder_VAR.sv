`timescale 1ns/10ps
module fullAdder_VAR #(parameter WIDTH = 64) (A,B,Cin,Cout,sum,Cin_most);
	input logic [WIDTH -1:0] A,B;
	input logic Cin;
	output logic Cout, Cin_most;
	output logic [WIDTH -1:0] sum;
	
	logic [WIDTH-2:0] Cio; 
	genvar i;
	
	fullAdder fa0 (.A(A[0]),.B(B[0]), .Cin, .Cout(Cio[0]),.sum(sum[0]));
	generate
		for (i = 1; i < WIDTH - 1; i++) begin : adders
			fullAdder fa (.A(A[i]),.B(B[i]),.Cin(Cio[i-1]),.Cout(Cio[i]),.sum(sum[i]));
		end
	endgenerate 
	fullAdder falast (.A(A[WIDTH-1]), .B(B[WIDTH-1]), .Cin(Cio[WIDTH-2]), .Cout, .sum(sum[WIDTH-1]));
	assign Cin_most = Cio[WIDTH-2];
endmodule

module fullAdder_VAR_testbench();
	logic [3:0] A,B;
	logic Cin;
	logic Cout;
	logic [3:0] sum;
	logic Cin_most;
	
	fullAdder_VAR #(.WIDTH(4)) dut (.A, .B, .Cin, .Cout, .sum, .Cin_most);
	
	initial begin
		A = 4'b0000; B = 4'b0000; Cin = 0; #10;
		A = 4'b1001; B = 4'b1111; Cin = 1; #10;
		A = 4'b0110; B = 4'b0110; Cin = 0; #10;
		A = 4'b1100; B = 4'b1000; Cin = 0; #10;
		A = 4'b1100; B = 4'b1000; Cin = 1; #10;
		A = 4'b0111; B = 4'b0111; Cin = 1; #10;
		A = 4'b1000; B = 4'b1000; Cin = 1; #10;
		A = 4'b0100; B = 4'b0110; Cin = 0; #10;
		A = 4'b0001; B = 4'b0001; Cin = 0; #10;
	end
endmodule
