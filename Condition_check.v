module Condition_check(
		input [31:0] val1,
		input [31:0] src2_val,
		input [1:0] branch_type,
		output reg pc_src
	);
	
	always @(*) begin
		case(branch_type)
			2'b01: begin
				if(val1 == 32'b0)
					pc_src = 1'b1;
				else begin
					pc_src = 1'b0;
				end
			end

			2'b10: begin
				if(~ (val1 == src2_val) )
					pc_src = 1'b1;
				else begin
					pc_src = 1'b0;
				end
			end

			2'b11:begin
				pc_src = 1'b1;
			end
			default: pc_src = 1'b0;

		
		endcase
	end

endmodule