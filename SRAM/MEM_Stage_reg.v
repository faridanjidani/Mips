module MEM_Stage_reg
	(
		input clk,
		input rst,
		input Freeze,
		input WB_EN_MEM,
		input MEM_R_EN_MEM,
		input [4:0]DST_MEM,
		input [31:0] Mem_data_out,
		input [31:0] ALU_result_MEM,

		output reg WB_EN_WB,
		output reg MEM_R_EN_WB,
		output reg [4:0] DST_WB,
		output reg [31:0] Mem_data_WB,
		output reg [31:0] ALU_result_WB
	);
	always@(posedge clk , posedge rst) 
	begin 
		if(rst)
			begin
				WB_EN_WB<=  1'b0;
				MEM_R_EN_WB<= 1'b0;
				DST_WB<= 5'b0;
				Mem_data_WB<= 32'b0 ;
				ALU_result_WB<= 32'b0;
		end
			
		else if(!Freeze)
			begin
				WB_EN_WB<=  WB_EN_MEM;
				MEM_R_EN_WB<= MEM_R_EN_MEM ;
				DST_WB<= DST_MEM ;
				Mem_data_WB<= Mem_data_out ;
				ALU_result_WB<= ALU_result_MEM ;
			end
	end

endmodule // MEM_Stage_reg