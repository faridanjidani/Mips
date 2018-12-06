module WB_Stage_reg
	(
		input clk,
		input rst,
		input [31:0] PC_in,
		output reg [31:0] PC
	);
	always@(posedge clk , posedge rst) 
	begin 
		if(rst) 
			PC<= 31'b0;
		else
			PC<= PC_in;
	end

endmodule // WB_Stage_reg