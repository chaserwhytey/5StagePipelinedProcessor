`timescale 1ns/10ps
module DFF_VAR #(parameter WIDTH = 8) (q,d,wr_en,reset,clk);
	output logic [WIDTH - 1 : 0] q;
	input logic [WIDTH - 1 : 0] d;
	input logic reset, clk, wr_en;
	
	logic [WIDTH - 1 : 0] mux_out;
	
	initial assert (WIDTH > 0);
	
	genvar i;
	
	generate 
		for (i = 0; i < WIDTH; i++) begin : eachDff
			mux2_1 m2_1 (.out(mux_out[i]), .i0(q[i]), .i1(d[i]), .sel(wr_en));
			D_FF dFF (.q(q[i]), .d(mux_out[i]), .reset, .clk);
		end
	endgenerate 
endmodule

module DFF_VAR_testbench();
	logic [7 : 0] q;
	logic [7 : 0] d;
	logic reset, clk, wr_en;

	DFF_VAR #(.WIDTH(8)) dut (.q, .d, .wr_en, .reset, .clk);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin			
																		@(posedge clk);
		d <= 250;													@(posedge clk);
		d <= 50;														@(posedge clk);
		d <= 150;													@(posedge clk);
		d <= 30;														@(posedge clk);
		d <= 51;														@(posedge clk);
		d <= 30;														@(posedge clk);
		d <= 22;														@(posedge clk);
		d <= 60;	wr_en <= 1'b1;									@(posedge clk);
		d <= 160;	wr_en <= 1'b1;									@(posedge clk);
		d <= 20;	wr_en <= 1'b1;									@(posedge clk);
		d <= 30;	wr_en <= 1'b1;									@(posedge clk);
		d <= 40;	wr_en <= 1'b1;									@(posedge clk);
		d <= 50;	wr_en <= 1'b1;									@(posedge clk);
		d <= 60;	wr_en <= 1'b1;									@(posedge clk);
		d <= 70;	wr_en <= 1'b1;									@(posedge clk);
		d <= 240;	wr_en <= 1'b1;									@(posedge clk);
		d <= 190;	wr_en <= 1'b1;									@(posedge clk);
		$stop;
	end
endmodule
	