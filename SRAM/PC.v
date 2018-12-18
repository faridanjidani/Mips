module PC
	( 
		input clk, 
		input rst,
		input Freeze,
		input [31:0]PC_in,
		output reg [31:0] PC
	);
	
	always@(posedge clk , posedge rst) 
	begin 
		if(rst) 
			PC<= 31'b0;
		else if(!Freeze)
			PC<= PC_in;
	end
endmodule  // PC 