module Mux5_2To1
	(
		input [4:0] mux5_2To1_in1,
		input [4:0] mux5_2To1_in2,
		input mux5_2To1_sel,
		output [4:0] mux5_2To1_out
	);

	assign mux5_2To1_out = mux5_2To1_sel ? mux5_2To1_in2 : mux5_2To1_in1;

endmodule // Mux5_2To1