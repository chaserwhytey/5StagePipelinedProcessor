`timescale 1ns/10ps
module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	output logic [63:0] ReadData1, ReadData2;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	input logic RegWrite, clk;
	
	logic [31:0] register_wr_en;
	logic [31:0] [63:0] register_64X32;
	logic [63:0] [31:0] register_col;
	
	dec5_32 dec (.a(WriteRegister), .en(RegWrite), .out(register_wr_en) );
	
	DFF_VAR #(.WIDTH(64)) dFF31 (.q(register_64X32[31][63:0]), .d(64'b0), .wr_en(1'b1), .reset(1'b0), .clk);
	 
	genvar i,j;
	generate
		for (i = 0; i < 31; i++) begin : registers
			DFF_VAR #(.WIDTH(64)) dFF (.q(register_64X32[i][63:0]), .d(WriteData), .wr_en(register_wr_en[i]), .reset(1'b0), .clk);
		end
	endgenerate
	
	integer k, z;
	always_comb begin
		for (k = 0; k < 64; k++) begin
			for (z =0; z <32; z++) begin
				register_col[k][z] = register_64X32[z][k];
			end
		end
	end
	
	generate
		for (i = 0; i < 64; i++) begin : mux64X32X1
			mux32_1 m1 (.out(ReadData1[i]), .in(register_col[i][31:0]) ,.sel(ReadRegister1));
			mux32_1 m2 (.out(ReadData2[i]), .in(register_col[i][31:0]) ,.sel(ReadRegister2));
		end
	endgenerate
	
	 
endmodule
