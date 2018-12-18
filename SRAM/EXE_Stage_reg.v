module EXE_Stage_reg
	(
		input clk,
		input rst,
		input Freeze,
		input [31:0] PC_in,
		// From Exe
		input WB_EN_EXE,
		input [1:0] MEM_CMD_EXE,
		input [31:0] ALU_res_EXE,
		input [31:0] src2_val_EXE,
		input [4:0] Dst_EXE,

		// To MEM
		output reg WB_EN_MEM,
		output reg [1:0] MEM_CMD_MEM,
		output reg [31:0] ALU_res_MEM,
		output reg [31:0] src2_val_MEM,
		output reg [4:0] Dst_MEM,
		output reg [31:0] PC,
		output ready,
		inout [15:0 ] SRAM_DQ,
		output [17:0] SRAM_ADDR,
		output SRAM_UB_N,
		output SRAM_LB_N,
		output SRAM_WE_N,
		output SRAM_CE_N,
		output SRAM_OE_N
	);
	always@(posedge clk , posedge rst) 
	begin 
		if(rst)
		begin
			PC <= 31'b0;
			WB_EN_MEM <= 1'b0;
			MEM_CMD_MEM <= 2'b0;
			ALU_res_MEM <= 32'b0;
			src2_val_MEM <= 32'b0;
			Dst_MEM <= 5'b0;
		end	
		else if(!Freeze)
		begin
			PC<= PC_in;
			WB_EN_MEM <= WB_EN_EXE;
			MEM_CMD_MEM <= MEM_CMD_EXE;
			ALU_res_MEM <= ALU_res_EXE;
			src2_val_MEM <= src2_val_EXE;
			Dst_MEM <= Dst_EXE;
		end
	end

endmodule // EXE_Stage_reg