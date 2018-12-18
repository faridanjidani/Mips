module ca1_mips(
	input clk,
	input rst,
	input sw,
	// output	[6:0]	HEX0,					//	Seven Segment Digit 0
	// output	[6:0]	HEX1,					//	Seven Segment Digit 1
	// output	[6:0]	HEX2,					//	Seven Segment Digit 2
	// output	[6:0]	HEX3,					//	Seven Segment Digit 3
	// output	[6:0]	HEX4					//	Seven Segment Digit 4
	inout [15:0 ] SRAM_DQ,
	output [17:0] SRAM_ADDR,
	output SRAM_UB_N,
	output SRAM_LB_N,
	output SRAM_WE_N,
	output SRAM_CE_N,
	output SRAM_OE_N
	); 
	
	// IF stage wires 
	wire [31:0] PC_out_IF;
	wire [31:0] Instruction_IF;
	wire [31:0] PC_Adder_out_IF;
	// ID stage wires
	wire [31:0] Instruction_ID;
	wire [31:0] PC_ID;
	wire [31:0] PC_out_ID;
	wire [8:0] Commands_ID;
	wire [31:0] Val1_ID;
	wire [31:0] Val2_ID;
	wire [31:0] Reg2_ID;
	wire [4:0] Dest_ID;
	wire [4:0] Src1_ID_out;
	wire [4:0] Src2_ID_out;
	wire [4:0] DST_WB_out;	
 	wire WB_EN_WB_out;
 	wire [31:0] Result_WB_to_IR;
	wire Freeze;
	wire Flush;
	wire is_Immediate_ID;
	// EXE
	wire [31:0] PC_EXE;
	wire [31:0] PC_out_EXE;
	wire WB_EN_EXE;
	wire [5:0] EXE_CMD_EXE;
	wire [1:0] MEM_CMD_EXE;
	wire [31:0] Val1_EXE;
	wire [31:0] Val2_EXE;
	wire [31:0] Reg2_EXE;
	wire [4:0] Dst_EXE;
	wire [4:0] Src1_EXE;
	wire [4:0] Src2_EXE;
	wire WB_EN_out_EXE;
	wire [1:0] MEM_CMD_out_EXE;
	wire [31:0] ALU_res_out_EXE;
	wire [31:0] src2_val_out_EXE;
	wire [4:0] Dst_EXE_out_EXE;
	wire PC_src_out_EXE;
	wire [31:0] br_address_out_EXE;
	wire is_Immediate_EXE;
	// MEM
	wire [31:0] PC_MEM;
	wire [31:0] PC_out_MEM;
	wire WB_EN_MEM;
	wire [1:0] MEM_CMD_MEM;
	wire [31:0] ALU_res_MEM;
	wire [31:0] src2_val_MEM;
	wire [4:0] Dst_MEM;

	wire WB_EN_MEM_out  ;    
	wire Mem_R_EN_muxsrc_out; 
	wire [31:0] Data_Mem_out;        
	wire [31:0] Alu_result_MEM_out; 
	wire [4:0] DST_MEM_out; 
	wire Freeze_SRAM;

	// WB
	wire WB_EN_WB;
    wire MEM_R_EN_WB;
    wire  [4:0] DST_WB;
  	wire [31:0] Mem_data_WB;
	wire [31:0] ALU_result_WB;

	wire [31:0] PC_WB;
	wire [31:0] PC_out_WB;
	
	IF_Stage inst_IF_Stage
		(
			.clk         (clk),
			.rst         (rst),
			.Freeze		 (Freeze || ~Freeze_SRAM),
			.pc_src      (PC_src_out_EXE),
			.br_address  (br_address_out_EXE),
			.PC          (PC_out_IF),
			.Instruction (Instruction_IF)
		);


	IF_Stage_reg if_stage_reg
		(
			.clk 		 		(clk),
			.rst 		 		(rst),
			.Freeze		 		(Freeze || ~Freeze_SRAM),
			.Flush				(Flush),
			.PC_in 		 		(PC_out_IF),
			.Instruction_in 	(Instruction_IF),
			.PC 				(PC_ID),
			.Instruction 		(Instruction_ID)
		);	
		
	ID_Stage id_stage
		(
			.clk         	(clk),
			.rst         	(rst),
			.sw 			(sw),
			.WB_EN       	(WB_EN_WB_out),
			.Dst_WB      	(DST_WB_out),
			.Result_WB   	(Result_WB_to_IR),
			.instruction 	(Instruction_ID),
			.PC_in       	(PC_ID),
			.WB_EN_EXE   	(WB_EN_out_EXE),
			.Dest_EXE    	(Dst_EXE_out_EXE),
			.Branch_Predict	(PC_src_out_EXE),
			.MEM_R_EN 		(MEM_CMD_out_EXE[0]),
			.WB_EN_MEM   	(WB_EN_MEM_out),
			.Dest_MEM    	(DST_MEM_out),	
			.Src1_ID_out 	(Src1_ID_out),
			.Src2_ID_out 	(Src2_ID_out),
			.Dest_ID     	(Dest_ID),
			.Val1_ID     	(Val1_ID),
			.Val2_ID     	(Val2_ID),
			.Reg2_ID     	(Reg2_ID),
			.Commands	 	(Commands_ID),
			.PC          	(PC_out_ID),
			.Freeze      	(Freeze),
			.Flush         	(Flush),
			.is_Immediate (is_Immediate_ID)
		);

	
	ID_Stage_reg id_stage_reg
		(
			.clk         (clk),
			.rst         (rst),
			.Flush		 (Flush),
			.WB_EN_ID    (Commands_ID[0]),
			.MEM_CMD_ID  (Commands_ID[2:1]),
			.EXE_CMD_ID  (Commands_ID[8:3]),
			.PC_in       (PC_out_ID),
			.Val1_ID     (Val1_ID),
			.Val2_ID     (Val2_ID),
			.Reg2_ID     (Reg2_ID),
			.Dst_ID      (Dest_ID),
			.Src1_ID_out (Src1_ID_out),
			.Src2_ID_out (Src2_ID_out),
			.Freeze 	 (~Freeze_SRAM),
			.is_Immediate(is_Immediate_ID),

			.WB_EN_EXE   (WB_EN_EXE),
			.MEM_CMD_EXE (MEM_CMD_EXE),
			.EXE_CMD_EXE (EXE_CMD_EXE),
			.PC          (PC_EXE),
			.Val1_EXE    (Val1_EXE),
			.Val2_EXE    (Val2_EXE),
			.Reg2_EXE    (Reg2_EXE),
			.Dst_EXE     (Dst_EXE),
			.Src1_EXE 	 (Src1_EXE),
			.Src2_EXE 	 (Src2_EXE),
			.is_Immediate_EXE(is_Immediate_EXE)
		);

	EXE_Stage exe_stage
		(
			.clk                (clk),
			.rst                (rst),
			.sw 				(sw),
			.PC_in              (PC_EXE),
			.WB_EN_EXE          (WB_EN_EXE),
			.MEM_CMD_EXE        (MEM_CMD_EXE),
			.EXE_CMD_EXE        (EXE_CMD_EXE),
			.Val1_EXE           (Val1_EXE),
			.Val2_EXE           (Val2_EXE),
			.Reg2_EXE           (Reg2_EXE),
			.Dst_EXE            (Dst_EXE),
			// hazard
			.Src1_EXE(Src1_EXE),
			.Src2_EXE(Src2_EXE),
			.Dst_MEM (Dst_MEM),
			.Dst_WB (DST_WB),
			.Result_Alu_Mem(ALU_res_MEM),
			.Result_WB_to_IR(Result_WB_to_IR),
			.WB_EN_WB_out(WB_EN_WB_out),
			.WB_EN_MEM_out(WB_EN_MEM_out),
			.is_immediate_EXE(is_Immediate_EXE),
			.PC                 (PC_out_EXE),
			.WB_EN_out_EXE      (WB_EN_out_EXE),
			.MEM_CMD_out_EXE    (MEM_CMD_out_EXE),
			.ALU_res_out_EXE    (ALU_res_out_EXE),
			.src2_val_out_EXE   (src2_val_out_EXE),
			.Dst_EXE_out_EXE    (Dst_EXE_out_EXE),
			.PC_src_out_EXE     (PC_src_out_EXE),
			.br_address_out_EXE (br_address_out_EXE)
		);

	EXE_Stage_reg exe_stage_reg
		(
			.clk          (clk),
			.rst          (rst),
			.Freeze       (~Freeze_SRAM),
			.PC_in        (PC_out_EXE),
			.WB_EN_EXE    (WB_EN_out_EXE),
			.MEM_CMD_EXE  (MEM_CMD_out_EXE),
			.ALU_res_EXE  (ALU_res_out_EXE),
			.src2_val_EXE (src2_val_out_EXE),
			.Dst_EXE      (Dst_EXE_out_EXE),
			.WB_EN_MEM    (WB_EN_MEM),
			.MEM_CMD_MEM  (MEM_CMD_MEM),
			.ALU_res_MEM  (ALU_res_MEM),
			.src2_val_MEM (src2_val_MEM),
			.Dst_MEM      (Dst_MEM),
			.PC           (PC_MEM)
		);

		
	MEM_Stage inst_MEM_Stage
		(
			.clk                 (clk),
			.rst                 (rst),
			.WB_EN_MEM           (WB_EN_MEM),
			.MEM_CMD_MEM         (MEM_CMD_MEM),
			.Alu_result_MEM      (ALU_res_MEM),
			.Src2_Val_MEM        (src2_val_MEM),
			.DST_MEM             (Dst_MEM),

			.WB_EN_MEM_out       (WB_EN_MEM_out),
			.Mem_R_EN_muxsrc_out (Mem_R_EN_muxsrc_out),
			.Data_Mem_out        (Data_Mem_out),
			.Alu_result_MEM_out  (Alu_result_MEM_out),
			.DST_MEM_out         (DST_MEM_out),
			.Freeze_SRAM		 (Freeze_SRAM),

			.SRAM_DQ			 (SRAM_DQ),
			.SRAM_ADDR 	 		 (SRAM_ADDR),
			.SRAM_UB_N			 (SRAM_UB_N),
			.SRAM_LB_N			 (SRAM_LB_N),
			.SRAM_WE_N       	 (SRAM_WE_N),
		    .SRAM_CE_N           (SRAM_CE_N),
			.SRAM_OE_N			 (SRAM_OE_N)
		);

	
	MEM_Stage_reg inst_MEM_Stage_reg
		(
			.clk            (clk),
			.rst            (rst),
			.Freeze         (~Freeze_SRAM),
			.WB_EN_MEM      (WB_EN_MEM_out),
			.MEM_R_EN_MEM   (Mem_R_EN_muxsrc_out),
			.DST_MEM        (DST_MEM_out),
			.Mem_data_out   (Data_Mem_out),
			.ALU_result_MEM (Alu_result_MEM_out),

			.WB_EN_WB       (WB_EN_WB),
			.MEM_R_EN_WB    (MEM_R_EN_WB),
			.DST_WB         (DST_WB),
			.Mem_data_WB    (Mem_data_WB),
			.ALU_result_WB  (ALU_result_WB)
		);

		
	WB_Stage inst_WB_Stage
		(
			.clk                 (clk),
			.rst                 (rst),
			.WB_EN_WB            (WB_EN_WB),
			.MEM_R_EN_WB_MUX_Sel (MEM_R_EN_WB),
			.DST_WB              (DST_WB),
			.Mem_data_WB         (ALU_result_WB),
			.ALU_result_WB       (Mem_data_WB),

			.DST_WB_out          (DST_WB_out),
			.WB_EN_WB_out        (WB_EN_WB_out),
			.Result_WB_to_IR     (Result_WB_to_IR)
		);

		
		
	// 7 segments 
	
	// pc
	// Seven_segment s_pc_IF	
	// 	(
	// 		.Sev_Seg_in(PC_ID[3:0]),
	// 		.Sev_Seg_out(HEX0)
	// 	);
		
	// Seven_segment s_pc_ID	
	// 	(
	// 		.Sev_Seg_in(PC_EXE[3:0]),
	// 		.Sev_Seg_out(HEX1)
	// 	);
		
	// Seven_segment s_pc_EXE	
	// 	(
	// 		.Sev_Seg_in(PC_MEM[3:0]),
	// 		.Sev_Seg_out(HEX2)
	// 	);
		
	// Seven_segment s_pc_MEM	
	// 	(
	// 		.Sev_Seg_in(PC_WB[3:0]),
	// 		.Sev_Seg_out(HEX3)
	// 	);

	// // seven segment instrunction 	
	// Seven_segment s_inst	
	// 	(
	// 		.Sev_Seg_in(Instruction_ID[24:21]),
	// 		.Sev_Seg_out(HEX4)
	// 	);	
	
	
		
endmodule // ca1_mips

module ca1_mips_TB;
	reg clk;
	reg rst;
	
	ca1_mips inst_ca1_mips
		(
			.clk  (clk),
			.rst  (rst)
		);

	initial begin
        clk = 0	;
        repeat(4000) #20 clk = ~clk;
    end

    initial begin
    	rst = 1;
    	#20;
    	rst = 2;
    	#400000;
        $stop;

    end

endmodule