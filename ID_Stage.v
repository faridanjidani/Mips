module ID_Stage
	(
		input clk,
		input rst,
		input sw,
		//From WB
		input WB_EN,
		input [4:0] Dst_WB,
		input [31:0] Result_WB,
		//from IF
		input [31:0] instruction,
		input [31:0] PC_in,
		// from EXE
		input WB_EN_EXE,
		input [4:0] Dest_EXE,
		input Branch_Predict,
		input MEM_R_EN,
		// from MEM 
		input WB_EN_MEM,
		input [4:0] Dest_MEM,
		// to registers
		output [4:0] Dest_ID,
		output [4:0] Src1_ID_out,
		output [4:0] Src2_ID_out,

		output [31:0] Val1_ID,
		output [31:0] Val2_ID,
		output [31:0] Reg2_ID,

		output [8:0] Commands,
		output [31:0] PC,
		output Freeze,
		output Flush,
		output is_Immediate
	);
	
	assign PC = PC_in;
	//instance of registers_file

	wire [31:0] sign_Out_ID;
	wire WB_EN_ID;
	// Mem_signals
	wire [1:0]MEM_CMD_ID;
	// branch and exe_cmd
	wire [5:0]EXE_CMD_ID;

	assign Src1_ID_out = instruction[25:21] ;
	assign Src2_ID_out = is_Immediate ? 5'b0 : instruction[20:16] ; // for three consecutive ld
	Registers_file rf
		(
			.clk(clk),
			.rst(rst),
			.src1(instruction[25:21]),  // first address src1
			.src2(instruction[20:16]),  // second address src2
			.dest(Dst_WB),  // distination
			.Write_val(Result_WB),
			.Write_En(WB_EN),
			.reg1(Val1_ID),
			.reg2(Reg2_ID)
		);


	Mux32_2To1 inst_Mux32_2To1
		(
			.mux32_2To1_in1 (Reg2_ID),
			.mux32_2To1_in2 (sign_Out_ID),
			.mux32_2To1_sel (is_Immediate),
			.mux32_2To1_out (Val2_ID)
		);

	Control_unit inst_Control_unit
		(
			.Opcode       (instruction[31:26]),
			.EXE_Commands (EXE_CMD_ID),
			.MEM_Commands (MEM_CMD_ID),
			.WB_Commands  (WB_EN_ID),
			.is_Immediate (is_Immediate)
		);

	Hazard_Detect inst_Hazard_Detect
		(
			.sw				(sw),
			.Src1_ID      	(instruction[25:21]),
			.Src2_ID      	(instruction[20:16]),
			.Branch_Predict	(Branch_Predict),
			.is_Immediate 	(is_Immediate),
			.WB_EN_MEM    	(WB_EN_MEM),
			.WB_EN_EXE    	(WB_EN_EXE),
			.MEM_R_EN		(MEM_R_EN),
			.Dest_EXE     	(Dest_EXE),
			.Dest_MEM     	(Dest_MEM),
			.Freeze       	(Freeze),
			.Flush         	(Flush)
		);


	Mux9_2To1 inst_Mux9_2To1
		(
			.mux9_2To1_in1 ({EXE_CMD_ID, MEM_CMD_ID, WB_EN_ID}),
			.mux9_2To1_in2 (9'b0),
			.mux9_2To1_sel (Freeze),
			.mux9_2To1_out (Commands)
		);

	Sign_Ex inst_Sign_Ex 
		(	
			.sign_In(instruction[15:0]),
			.sign_Out(sign_Out_ID)
		);

	Mux5_2To1 inst_Mux5_2To1
		(
			.mux5_2To1_in1 (instruction[15:11]),
			.mux5_2To1_in2 (instruction[20:16]), // for immediate mode
			.mux5_2To1_sel (is_Immediate),
			.mux5_2To1_out (Dest_ID)
		);




endmodule // ID_Stage