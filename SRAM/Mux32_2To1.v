module Mux32_2To1
	(
		input [31:0] mux32_2To1_in1,
		input [31:0] mux32_2To1_in2,
		input mux32_2To1_sel,
		output [31:0] mux32_2To1_out
	);

	assign mux32_2To1_out = mux32_2To1_sel ? mux32_2To1_in2 : mux32_2To1_in1;

endmodule // Mux32_2To1