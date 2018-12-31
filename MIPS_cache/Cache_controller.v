module Cache_controller (
		input clk,
		input rst,
		// memory stage
		input [31:0] address,
		input [31:0] wdata,
		input 	MEM_R_EN,
		input 	MEM_W_EN,
		output [31:0] Rdata,
		output ready,

		// Sram controller
		input [63:0] Sram_rdata,
		input Sram_Ready,
		output  [31:0] Sram_Address,
		output [31:0] Sram_Wdata,
		output Sram_write,
		output Sram_read


	);
	reg [63:0] cache_Data_L [0:63];
	reg valid_L [0:63];
	reg [8:0] tag_L[0:63];

	reg [63:0] cache_Data_R [0:63];
	reg valid_R [0:63];
	reg [8:0] tag_R[0:63];

	reg LRU[0:63];

	wire [17:0]address_cache;
	wire [5:0] index_cache;
	wire [8:0] tag_cache;
	wire hit;
	wire compL;
	wire compR;
	wire [63:0] temp;
	assign  address_cache = address [17:0] ; 
	assign index_cache = address_cache[8:3];
	assign tag_cache = address_cache [17:9];
	reg [31:0]raw_address;
	integer ind;
	always @(posedge clk ) begin

		// Sram_write = 1'b0;
		// Sram_read  = 1'b0;
		
		if (rst) begin
			// reset

			for (ind = 0; ind < 64; ind = ind + 1)
			begin
				valid_L[ind] <= 1'b0;
				valid_R[ind] <= 1'b0;
				tag_L[ind] <= 9'b0;
				tag_R[ind] <= 9'b0;
				LRU[ind] <= 1'b0; 
				// cache_Data_L[ind] <= 64'b0;
				// cache_Data_R[ind] <= 64'b0;
			end
			
		end
		else begin

			if (	MEM_W_EN ) begin // write to sram
				// if( Sram_Ready )
				// 	Sram_write = 1'b1;
				// else
				// 	Sram_write = 1'b0;
				
				

				{valid_L[index_cache], LRU[index_cache]} = compL ? 2'b01 :{ valid_L[index_cache], LRU[index_cache]};
				{valid_R[index_cache], LRU[index_cache]} = compR ? 2'b0 : {valid_R[index_cache], LRU[index_cache]};

				
			end

			if(MEM_R_EN && ~hit) // read from chache
			begin
				
				// Sram_read <= 1'b1;
				if ( Sram_Ready ) begin
					if(~LRU[index_cache]) begin
						tag_L[index_cache] = tag_cache;
						cache_Data_L[index_cache] = Sram_rdata;
						valid_L[index_cache] = 1'b1;
						LRU[index_cache] = 1'b1;
					end

					else 
					begin
						tag_R[index_cache] = tag_cache;
						cache_Data_R[index_cache] = Sram_rdata;
						valid_R[index_cache] = 1'b1;
						LRU[index_cache] = 1'b0;
					end
				end

			end

		end

		// if (ready)
		// begin
		// 	Sram_read  <= 1'b0;
		// 	Sram_write <= 1'b0;
		// end
	end
	assign Sram_Address = (MEM_R_EN && ~hit) || MEM_W_EN ? address : 32'b0;
	assign Sram_Wdata = MEM_W_EN? wdata : 32'b0 ;
	assign Sram_read =  (MEM_R_EN && ~hit) ? 1'b1 : 1'b0 ;
	assign Sram_write = MEM_W_EN ? 1'b1 : 1'b0 ;
	assign ready = hit || Sram_Ready;
	assign compL = (tag_L[index_cache] == tag_cache ? valid_L[index_cache] == 1'b1 ? 1'b1 : 1'b0 : 1'b0  ) ;
	assign compR = (tag_R[index_cache] == tag_cache ? valid_R[index_cache] == 1'b1 ? 1'b1 : 1'b0 : 1'b0  ) ;
	assign  hit =  MEM_R_EN ? compL || compR  : MEM_W_EN ? 1'b0 : 1'b1 ;
	assign temp = compL ? cache_Data_L[ index_cache ] : compR ? cache_Data_R[ index_cache ] : Sram_rdata;
	assign  Rdata = address_cache [2] ? temp[63:32 ] : temp[31:0 ];
 
	
endmodule 