module Mux32_4To1
	(
		input [31:0] mux32_4To1_in1,
		input [31:0] mux32_4To1_in2,
		input [31:0] mux32_4To1_in3,
		input [31:0] mux32_4To1_in4,
		input [1:0]mux32_2To1_sel,
		output reg [31:0] mux32_4To1_out
	); 

	always @(*) begin
		case(mux32_2To1_sel)
			2'b00: mux32_4To1_out = mux32_4To1_in1;
			2'b01: mux32_4To1_out = mux32_4To1_in2;
			2'b10: mux32_4To1_out = mux32_4To1_in3;
			2'b11: mux32_4To1_out = 32'b0;
		endcase
	end

endmodule // Mux32_4To1
