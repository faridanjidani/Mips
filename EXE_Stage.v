module EXE_Stage
	(
		input clk,
		input rst,
		input sw,
		// From ID reg
		input [31:0] PC_in,
		input WB_EN_EXE,
		input [1:0] MEM_CMD_EXE,
		input [5:0] EXE_CMD_EXE,
		input [31:0] Val1_EXE,
		input [31:0] Val2_EXE,
		input [31:0] Reg2_EXE,
		input [4:0] Dst_EXE,
		// for hazard
		input [4:0] Src1_EXE,
		input [4:0] Src2_EXE,
		input [4:0] Dst_MEM ,
		input [4:0] Dst_WB ,
		input [31:0] Result_Alu_Mem,
		input [31:0] Result_WB_to_IR,
		input WB_EN_WB_out,
		input WB_EN_MEM_out,
		input is_immediate_EXE,
		// To EXE reg
		output [31:0] PC,
		output WB_EN_out_EXE,
		output [1:0] MEM_CMD_out_EXE,
		output [31:0] ALU_res_out_EXE,
		output [31:0] src2_val_out_EXE,
		output [4:0] Dst_EXE_out_EXE,
		output PC_src_out_EXE,
		output [31:0] br_address_out_EXE
	);

	wire [31:0] left_sh_val2;
	//hazard wires
	wire [31:0] Val1_EXE_Forward;
	wire [31:0] Val2_EXE_Forward;
	wire [1:0] sel_alu_in1;
	wire [1:0] sel_alu_in2;
	wire [1:0] sel_st_val;
	Condition_check condtion_check 
		(
			.val1(Val1_EXE_Forward), 
			.src2_val(Reg2_EXE), 
			.branch_type(EXE_CMD_EXE[1:0]), 
			.pc_src(PC_src_out_EXE)
		);


	Adder_32_signed adder_32_signed 
		(
			.val2(left_sh_val2), 
			.pc(PC_in), 
			.result(br_address_out_EXE)
		);


	Forward_Unit inst_Forward_Unit
		(
			.sw 		   (sw),
			.Src1_EXE      (Src1_EXE),
			.Src2_EXE      (Src2_EXE),
			.Dst_MEM       (Dst_MEM),
			.Dst_WB        (Dst_WB),
			.Dst_EXE       (Dst_EXE),
			.WB_EN_WB_out  (WB_EN_WB_out),
			.WB_EN_MEM_out (WB_EN_MEM_out),
			.is_immediate  (is_immediate_EXE),
			.Mem_read_EXE  (MEM_CMD_EXE[0] ),
			.sel_alu_in1   (sel_alu_in1),
			.sel_alu_in2   (sel_alu_in2),
			.sel_st_val 	(sel_st_val)
		);



	Mux32_4To1 mux32_4To1_hazard_val1
	(
		.mux32_4To1_in1(Val1_EXE),
		.mux32_4To1_in2(Result_WB_to_IR),
		.mux32_4To1_in3(Result_Alu_Mem ),
		.mux32_4To1_in4(32'b1),
		.mux32_2To1_sel(sel_alu_in1), // sel_alu_in1
		.mux32_4To1_out(Val1_EXE_Forward)
	); 

	Mux32_4To1 mux32_4To1_hazard_val2
	(
		.mux32_4To1_in1(Val2_EXE),
		.mux32_4To1_in2(Result_WB_to_IR),
		.mux32_4To1_in3(Result_Alu_Mem),
		.mux32_4To1_in4(32'b1),
		.mux32_2To1_sel(sel_alu_in2), // sel_alu_in2
		.mux32_4To1_out(Val2_EXE_Forward)
	); 

	Mux32_4To1 inst_Mux32_4To1
	(
		.mux32_4To1_in1 (Reg2_EXE),
		.mux32_4To1_in2 (Result_WB_to_IR),
		.mux32_4To1_in3 (Result_Alu_Mem),
		.mux32_4To1_in4 (32'b1),

		.mux32_2To1_sel (sel_st_val),
		.mux32_4To1_out (src2_val_out_EXE)
	);


	ALU ALU 
		(
			.in1(Val1_EXE_Forward), 
			.in2(Val2_EXE_Forward), 
			.cmd(EXE_CMD_EXE[5:2]), 
			.result(ALU_res_out_EXE)
		);

	Shift_Left shift_Left 
		(
			.in(Val2_EXE), 
			.out(left_sh_val2)
		);

	assign PC = PC_in;
	assign WB_EN_out_EXE = WB_EN_EXE;
	assign MEM_CMD_out_EXE = MEM_CMD_EXE;
	assign Dst_EXE_out_EXE = Dst_EXE;
	

endmodule // EXE_Stage