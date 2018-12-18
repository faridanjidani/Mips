module Mux9_2To1
	(
		input [8:0] mux9_2To1_in1,
		input [8:0] mux9_2To1_in2,
		input mux9_2To1_sel,
		output [8:0] mux9_2To1_out
	);

	assign mux9_2To1_out = mux9_2To1_sel ? mux9_2To1_in2 : mux9_2To1_in1;

endmodule // Mux9_2To1