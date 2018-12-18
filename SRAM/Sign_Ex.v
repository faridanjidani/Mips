module Sign_Ex
	(
		input [15:0] sign_In,
		output [31:0] sign_Out
	);

	assign sign_Out = (sign_In[15] == 1'b0) ? {16'b0, sign_In} : {16'b1111111111111111, sign_In};

endmodule // Sign_Ex