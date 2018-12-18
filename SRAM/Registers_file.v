module Registers_file(
		input clk,
		input rst,
		input [4:0] src1,
		input [4:0] src2,
		input [4:0] dest,
		input [31:0] Write_val,
		input Write_En,
		output  [31:0] reg1,
		output  [31:0] reg2
	);
	integer i;
	reg [31:0]Mem_reg[0:31];

	always @(negedge clk , posedge rst) begin
		if(rst)begin
			for (i = 0; i < 32; i = i + 1)
                Mem_reg[i] <= i;   
		end
		else if(Write_En && dest != 5'b0)
			Mem_reg[dest] <= Write_val;
	end
	
	assign	 reg1 = Mem_reg[src1] ;
	assign	 reg2 = Mem_reg[src2] ;

	
	
endmodule