module Sram_Controller (
	input clk,
	input rst,
	// From memory stage
	input wr_en,
	input rd_en,
	input [31:0] address,
	input [31:0] Write_Data,
	// to next stage
	output  [63:0 ] Read_Data,
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
	reg [63:0] temp;
	reg [15:0] temp_data;
	// wire write_en;
	reg write_en;
	reg [17:0] write_addr;
	
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			temp <= 64'b0;
			state <= 3'b000;
		end
		else begin
			write_en <= 1'b1;

			if (wr_en || rd_en)
				if ( state < 3'b101 )
					state <= state + 3'b001;
				else
					state <= 3'b000;



			case(state)

				3'b000: begin
					if (wr_en) begin
						write_en     <= 1'b0;
						temp_data    <= Write_Data[15:0];
						write_addr   <= {1'b0,address[17:2], 1'b0};
					end
					else if (rd_en)
						temp[15:0] <= SRAM_DQ;
				end

				3'b001:
				begin
					if (wr_en) begin
						write_en    <= 1'b0;
						temp_data    <= Write_Data[31:16];
						write_addr 	 <= {1'b0 ,address[17:2], 1'b1};
					end
					else if (rd_en)
						temp[31:16] <= SRAM_DQ;
				end
				3'b010:
				begin
					if (rd_en)
						temp[47:32] <= SRAM_DQ;

				end
				3'b011:
				begin
					if (rd_en)
						temp[63:48] <= SRAM_DQ;
				end
			endcase
		end
	end
	// keep ready 1 if there is no request 
	// assign write_en = wr_en ? 1'b0 : 1'b1 ;
	assign ready = ( (wr_en || rd_en) && state != 3'b100) ? 1'b0 : 1'b1;

	assign SRAM_ADDR = (rd_en && state == 3'b000) ? {1'b0,address[17:3], 2'b00} :
					   (rd_en && state == 3'b001) ? {1'b0,address[17:3], 2'b01} : 
						 (rd_en && state == 3'b010) ? {1'b0,address[17:3], 2'b10} : 
						 (rd_en && state == 3'b011) ? {1'b0 , address[17:3], 2'b11} : 
					   (wr_en) ? write_addr : {1'b0,address[17:2], 1'b0};

	// keep SRAM_DQ bus z if we are not writing
	assign SRAM_DQ   = (~write_en) ? temp_data : 16'bz;
	assign SRAM_WE_N = write_en;

	assign Read_Data = temp;
endmodule

