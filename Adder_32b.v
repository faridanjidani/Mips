module Adder_32b(
	input [31:0] PC_in,
	output [31:0] Adder_PC_out
	);
	assign Adder_PC_out = PC_in + 32'd4 ;	
endmodule