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
		output [4:0] DST_MEM_out,
		output Freeze_SRAM,

		inout [15:0 ] SRAM_DQ,
		output [17:0] SRAM_ADDR,
		output SRAM_UB_N,
		output SRAM_LB_N,
		output SRAM_WE_N,
		output SRAM_CE_N,
		output SRAM_OE_N
	);
		assign DST_MEM_out = DST_MEM ;
		assign Alu_result_MEM_out = Alu_result_MEM ;	
		assign WB_EN_MEM_out = WB_EN_MEM ;
		assign Mem_R_EN_muxsrc_out = MEM_CMD_MEM [0] ;

		wire [31:0]Mem_Address;
		wire [63:0] Sram_rdata;

		wire Sram_Ready;
		wire [31:0] Sram_Address;
		wire [31:0] Sram_Wdata;
		wire Sram_write;
		wire Sram_read;

		Sram_Controller inst_Sram_Controller
		(
			.clk        (clk),
			.rst        (rst),
			.wr_en      (Sram_write),
			.rd_en      (Sram_read),
			.address    (Sram_Address),
			.Write_Data (Sram_Wdata),
			.Read_Data  (Sram_rdata),
			.ready      (Sram_Ready),
			.SRAM_DQ    (SRAM_DQ),
			.SRAM_ADDR  (SRAM_ADDR),
			.SRAM_UB_N  (SRAM_UB_N),
			.SRAM_LB_N  (SRAM_LB_N),
			.SRAM_WE_N  (SRAM_WE_N),
			.SRAM_CE_N  (SRAM_CE_N),
			.SRAM_OE_N  (SRAM_OE_N)
		);

		Cache_controller inst_Cache_controller
		(
			.clk			(clk),
			.rst 			(rst),
			// memory stage
			.address 		(Mem_Address),
			.wdata 			(Src2_Val_MEM),
			.MEM_R_EN 		(MEM_CMD_MEM [0]),
			.MEM_W_EN 		(MEM_CMD_MEM [1]),
			.Rdata 			(Data_Mem_out),
			.ready 			(Freeze_SRAM),

			// Sram controller
			.Sram_rdata 	(Sram_rdata),
			.Sram_Ready 	(Sram_Ready),
			.Sram_Address 	(Sram_Address),
			.Sram_Wdata		(Sram_Wdata),
			.Sram_write		(Sram_write),
			.Sram_read 		(Sram_read)
		);
		
		Address_mapping inst_Address_mapping (.Alu_result(Alu_result_MEM), .Mem_Address(Mem_Address));

endmodule // MEM_Stage