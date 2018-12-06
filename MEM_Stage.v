module MEM_Stage
	(
		input clk,
		input rst,
		input WB_EN_MEM,
		input [1:0] MEM_CMD_MEM, // mem -> [0] mem read, [1] mem write 
		input [31:0] Alu_result_MEM,
		input [31:0] Src2_Val_MEM,
		input [4:0]DST_MEM,

		output WB_EN_MEM_out,
		output Mem_R_EN_muxsrc_out,
		output [31:0] Data_Mem_out,
		output [31:0] Alu_result_MEM_out,
		output [4:0] DST_MEM_out
	);
		assign DST_MEM_out = DST_MEM ;
		assign Alu_result_MEM_out = Alu_result_MEM ;	
		assign WB_EN_MEM_out = WB_EN_MEM ;
		assign Mem_R_EN_muxsrc_out = MEM_CMD_MEM [0] ;

		wire [31:0]Mem_Address;

		Data_Mem inst_Data_Mem
		(
			.clk      (clk),
			.rst      (rst),
			.St_value (Src2_Val_MEM),
			.Address  (Mem_Address),
			.Mem_W_EN (MEM_CMD_MEM [1]),
			.Mem_R_EN (MEM_CMD_MEM [0]),
			.Mem_out  (Data_Mem_out)
		);

		Address_mapping inst_Address_mapping (.Alu_result(Alu_result_MEM), .Mem_Address(Mem_Address));




endmodule // MEM_Stage