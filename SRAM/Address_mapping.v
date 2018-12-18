module Address_mapping 
	(
		input [31:0] Alu_result,
		output [31:0] Mem_Address
	);
	wire [31:0] exact_mem_address; 
	assign  exact_mem_address = Alu_result - 32'd1024 ;
	assign  Mem_Address = { exact_mem_address [31:2] , 2'b0 } ; // for reading a complete word

endmodule
