module Adder_32_signed(
	input signed [31:0] val2,
	input signed [31:0] pc,
	output signed [31:0] result
	);
	assign  result = val2 + pc;
	
endmodule