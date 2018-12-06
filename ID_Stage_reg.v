module ID_Stage_reg
	(
		input clk,
		input rst,
		input Flush,
		// From ID
		input WB_EN_ID,
		input [1:0]MEM_CMD_ID,
		input [5:0]EXE_CMD_ID,
		input [31:0] PC_in,
		input [31:0] Val1_ID,
		input [31:0] Val2_ID,
		input [31:0] Reg2_ID,
		input [4:0] Dst_ID,

		input [4:0] Src1_ID_out,
		input [4:0] Src2_ID_out,

		input Freeze,
		input is_Immediate,
		// To EXE
		output reg WB_EN_EXE,
		output reg [1:0]MEM_CMD_EXE,
		output reg [5:0]EXE_CMD_EXE,
		output reg [31:0] PC,
		output reg [31:0] Val1_EXE,
		output reg [31:0] Val2_EXE,
		output reg [31:0] Reg2_EXE,
		output reg [4:0] Dst_EXE,

		output reg [4:0] Src1_EXE,
		output reg [4:0] Src2_EXE,
		output reg is_Immediate_EXE
	);


	always@(posedge clk or posedge rst) 
	begin 
		if(rst)
		begin
			WB_EN_EXE <= 1'b0;
			MEM_CMD_EXE <= 2'b0;
			EXE_CMD_EXE <= 6'b0;
			PC <= 32'b0;
			Val1_EXE <= 32'b0;
			Val2_EXE <= 32'b0;
			Reg2_EXE <= 32'b0;
			Dst_EXE <= 5'b0;
			Src1_EXE <= 5'b0;
			Src2_EXE <= 5'b0;
			is_Immediate_EXE<=1'b0;
		end	
		else if(Flush) begin 
			WB_EN_EXE <= 1'b0;
			MEM_CMD_EXE <= 2'b0;
			EXE_CMD_EXE <= 6'b0;
			PC <= 32'b0;
			Val1_EXE <= 32'b0;
			Val2_EXE <= 32'b0;
			Reg2_EXE <= 32'b0;
			Dst_EXE <= 5'b0;
			Src1_EXE <= 5'b0;
			Src2_EXE <= 5'b0;
			is_Immediate_EXE<=1'b0;
		end
		else  //if(!Freeze)
		begin
			WB_EN_EXE <= WB_EN_ID;
			MEM_CMD_EXE <= MEM_CMD_ID;
			EXE_CMD_EXE <= EXE_CMD_ID;
			PC <= PC_in;
			Val1_EXE <= Val1_ID;
			Val2_EXE <= Val2_ID;
			Reg2_EXE <= Reg2_ID;
			Dst_EXE <= Dst_ID;
			Src1_EXE <= Src1_ID_out;
			Src2_EXE <= Src2_ID_out;
			is_Immediate_EXE<=is_Immediate;
		end
	end
endmodule // ID_Stage_reg