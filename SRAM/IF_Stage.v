module IF_Stage
	(

		input clk,
		input rst,
		input Freeze,
		input pc_src,
		input [31:0] br_address,
		output [31:0] PC,
		output [31:0] Instruction
	);
	//wires
	wire [31:0] PC_out;
	wire [31:0] ROM_out;
	wire [31:0] Mux_pc_out;
	// instance
		Mux32_2To1 mux_pc
		(
			.mux32_2To1_in1 (PC),
			.mux32_2To1_in2 (br_address),
			.mux32_2To1_sel (pc_src),
			.mux32_2To1_out (Mux_pc_out)
		);

	PC pc(.clk(clk) , .rst(rst) , .Freeze(Freeze), .PC_in(Mux_pc_out) , .PC(PC_out) );
	ROM rom(.Address_in(PC_out) , .Instruction(Instruction));
	Adder_32b pc_Adder(.PC_in(PC_out), .Adder_PC_out(PC));
endmodule // IF_Stage