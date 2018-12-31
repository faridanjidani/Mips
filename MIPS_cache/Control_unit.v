module Control_unit
	(
		input [5:0]Opcode,
		// ex -> [1:0] br control, [5:2] alu op
		output reg[5:0] EXE_Commands,
		
		output reg[1:0] MEM_Commands,
		output reg WB_Commands,
		output reg is_Immediate
	);
	always @(*) begin
		{EXE_Commands, MEM_Commands, WB_Commands, is_Immediate} = 10'b0;
		case (Opcode)
			// R Type
			6'b000001:
			begin : Addition
				EXE_Commands = {4'b0, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b000011: 
			begin : Subtraction
				EXE_Commands = {4'b0010, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b000101:
			begin : And
				EXE_Commands = {4'b0100, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b000110:
			begin : Or
				EXE_Commands = {4'b0101, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b000111:
			begin : Nor
				EXE_Commands = {4'b0110, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b001000:
			begin : Xor
				EXE_Commands = {4'b0111, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b001001:
			begin : SLA
				EXE_Commands = {4'b1000, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b001010:
			begin : SLL
				EXE_Commands = {4'b1000, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b001011:
			begin : SRA
				EXE_Commands = {4'b1001, 2'b0};
				WB_Commands = 1'b1;
			end
			6'b001100:
			begin : SRL
				EXE_Commands = {4'b1010, 2'b0};
				WB_Commands = 1'b1;
			end

			// I Type
			6'b100000:
			begin : AddI
				EXE_Commands = {4'b0000, 2'b0};
				is_Immediate = 1'b1;
				WB_Commands = 1'b1;
			end
			6'b100001:
			begin : SubI
				EXE_Commands = {4'b0010, 2'b0};
				is_Immediate = 1'b1;
				WB_Commands = 1'b1;
			end
			6'b100100:
			begin : Load
				EXE_Commands = {4'b0000, 2'b0};
				MEM_Commands = {2'b01};
				WB_Commands = 1'b1;
				is_Immediate = 1'b1;
			end
			6'b100101:
			begin : Store
				EXE_Commands = {4'b0000, 2'b0};
				MEM_Commands = {2'b10};
				is_Immediate = 1'b1;
			end
			6'b101000:
			begin : BEZ
				EXE_Commands = {4'b0000, 2'b01};
				is_Immediate = 1'b1;
			end
			6'b101001:
			begin : BNE
				EXE_Commands = {4'b0000, 2'b10};
				is_Immediate = 1'b1;
			end
			6'b101010:
			begin : Jump
				EXE_Commands = {4'b0000, 2'b11};
				is_Immediate = 1'b1;
			end
			default : /* default */;
		endcase
	end
endmodule