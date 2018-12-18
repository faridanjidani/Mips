module Sram_Controller (
	input clk,
	input rst,
	// From memory stage
	input wr_en,
	input rd_en,
	input [31:0] address,
	input [31:0] Write_Data,
	// to next stage
	output  [31:0 ] Read_Data,
	// for freeze other stage
	output ready,

	inout [15:0 ] SRAM_DQ,
	output [17:0] SRAM_ADDR,
	output SRAM_UB_N,
	output SRAM_LB_N,
	output SRAM_WE_N,
	output SRAM_CE_N,
	output SRAM_OE_N
);
	assign SRAM_CE_N = 1'b0;
	assign SRAM_LB_N = 1'b0;
	assign SRAM_UB_N = 1'b0;
	assign SRAM_OE_N =1'b0;

	reg [2:0] state;
	reg [31:0] temp;
	reg [15:0] temp_data;
	reg write_en;
	reg [17:0] write_addr;

	always@(posedge clk, posedge rst) begin
		if (rst) begin
			temp <= 32'b0;
			state <= 3'b000;
		end
		else begin
			write_en <= 1'b1;

			if (wr_en || rd_en)
				if ( state < 3'b100 )
					state <= state + 3'b001;
				else
					state <= 3'b000;

			case(state)

				3'b000: begin
					if (wr_en) begin
						write_en     <= 1'b0;
						temp_data    <= Write_Data[15:0];
						write_addr   <= {address[17:1], 1'b0};
					end
					else if (rd_en)
						temp[15:0] <= SRAM_DQ;
				end

				3'b001:
				begin
					if (wr_en) begin
						write_en    <= 1'b0;
						temp_data    <= Write_Data[31:16];
						write_addr 	 <= {address[17:1], 1'b1};
					end
					else if (rd_en)
						temp[31:16] <= SRAM_DQ;
				end
			endcase
		end
	end
	// keep ready 1 if there is no request 
	assign ready     = ( (wr_en || rd_en) && state != 3'b100) ? 1'b0 : 1'b1;
	
	assign SRAM_ADDR = (rd_en && state == 3'b000) ? {address[17:1], 1'b0} :
					   (rd_en && state == 3'b001) ? {address[17:1], 1'b1} : 
					   (wr_en) ? write_addr : {address[17:1], 1'b0};

	// keep SRAM_DQ bus z if we are not writing
	assign SRAM_DQ   = (~write_en) ? temp_data : 16'bz;
	assign SRAM_WE_N = write_en;

	assign Read_Data = temp;
endmodule

