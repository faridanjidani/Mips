module Seven_segment
	(
		input [3:0] Sev_Seg_in,
		output reg [6:0] Sev_Seg_out
	);

	always @(*)
	begin 
		case (Sev_Seg_in)
			0: Sev_Seg_out = 7'b1000000;
			1: Sev_Seg_out = 7'b1111001;
			2: Sev_Seg_out = 7'b0100100;
			3: Sev_Seg_out = 7'b0110000;
			4: Sev_Seg_out = 7'b0011001;
			5: Sev_Seg_out = 7'b0010010;
			6: Sev_Seg_out = 7'b0000010;
			7: Sev_Seg_out = 7'b1110000;
			8: Sev_Seg_out = 7'b0000000;
			9: Sev_Seg_out = 7'b0010000;
			default : Sev_Seg_out = 7'b1000000;
		endcase
	end

endmodule // Seven_segment