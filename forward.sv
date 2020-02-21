`timescale 1ns/10ps
module forward(input logic [4:0] Rn, Rmd, Rd, input logic reset, clk, 
	output logic flag1Rn, flag1Rmd, flag2Rn, flag2Rmd);

//flag 1 means Rd is used in previous instruction
//flag 2 means Rd is used in instruction before previous 
	logic [4:0] RdPrev, RdPrevPrev;
	logic [4:0] compRn, compRmd, compRn2, compRmd2;
	logic comp1, comp2, comp3, comp4;
	logic flag1RnN, flag1RmdN, flag2RnN, flag2RmdN;
	
	bitWiseXNor #(.WIDTH(5)) a1(.A(Rn), .B(RdPrev), .result(compRn));
	bitWiseXNor #(.WIDTH(5)) a2(.A(Rmd), .B(RdPrev), .result(compRmd));
	bitWiseXNor #(.WIDTH(5)) a4(.A(Rn), .B(RdPrevPrev), .result(compRn2));
	bitWiseXNor #(.WIDTH(5)) a5(.A(Rmd), .B(RdPrevPrev), .result(compRmd2));
	
		and_4 a7(.o(comp1), .i(compRn[4:1]));
		and #0.05 and1(flag1RnN, compRn[0], comp1);
	
		and_4 a8(.o(comp2), .i(compRmd[4:1]));
		and #0.05 and2(flag1RmdN, compRmd[0], comp2);
	
		and_4 a10(.o(comp3), .i(compRn2[4:1]));
		and #0.05 and3(flag2RnN, compRn2[0], comp3);
	
		and_4 a11(.o(comp4), .i(compRmd2[4:1]));
		and #0.05 and4(flag2RmdN, compRmd2[0], comp4);
		
		always_comb begin
			if(RdPrev !== 'x && RdPrev !== 5'd31)
			flag1Rn = flag1RnN;
				
			else 
				flag1Rn = 1'b0;
			if(RdPrev !== 'x && RdPrev !== 5'd31)
				flag1Rmd = flag1RmdN;
			else 
				flag1Rmd = 1'b0;

			if(RdPrevPrev !== 'x && RdPrevPrev !== 5'd31)
				flag2Rn = flag2RnN;
			else 
				flag2Rn = 1'b0;

			if(RdPrevPrev !== 'x && RdPrevPrev !== 5'd31)
				flag2Rmd = flag2RmdN;
			else 
				flag2Rmd = 1'b0;
		end
	always_ff@(posedge clk) begin
		if(reset) begin
			RdPrev <= 5'dx;
			RdPrevPrev <= 5'dx;
		end
		else begin 
			RdPrev <= Rd;
			RdPrevPrev <= RdPrev;
		end
	end 
	
endmodule 