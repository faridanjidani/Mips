module WB_Stage
	(
		input  clk,
		input  rst,
		input  WB_EN_WB,
		input  MEM_R_EN_WB_MUX_Sel,
		input  [4:0] DST_WB,
		input  [31:0] Mem_data_WB,
		input  [31:0] ALU_result_WB,

		output [4:0] DST_WB_out,
		output  WB_EN_WB_out,
		output [31:0] Result_WB_to_IR
	);

	Mux32_2To1 inst_Mux32_2To1
		(
			.mux32_2To1_in1 (Mem_data_WB),
			.mux32_2To1_in2 (ALU_result_WB),
			.mux32_2To1_sel (MEM_R_EN_WB_MUX_Sel),
			.mux32_2To1_out (Result_WB_to_IR)
		);
	assign DST_WB_out = DST_WB ;
	assign WB_EN_WB_out = WB_EN_WB ;	

endmodule // WB_Stage