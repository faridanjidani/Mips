module Forward_Unit
  (
    input sw,
    input [4:0] Src1_EXE,
    input [4:0] Src2_EXE,
    input [4:0] Dst_MEM ,
    input [4:0] Dst_WB ,
    input [4:0] Dst_EXE,
    input WB_EN_WB_out,
    input WB_EN_MEM_out,
    input is_immediate,
    input Mem_read_EXE,
    output reg [1:0]sel_alu_in1,
    output reg [1:0]sel_alu_in2,
    output reg [1:0]sel_st_val
    );

  always@(*)begin 
      sel_alu_in1 = 2'b0;
      sel_alu_in2 = 2'b0;
      sel_st_val = 2'b0;
      if(sw) begin
          if ((Src1_EXE == Dst_WB  )&& Dst_WB != 5'b0 && WB_EN_WB_out  )     
               sel_alu_in1 = 2'b01;
          if ((Src2_EXE == Dst_WB )&& Dst_WB != 5'b0 && WB_EN_WB_out   ) 
               sel_alu_in2 = 2'b01;  
          


          /// update data
          if ((Src1_EXE == Dst_MEM  )&& Dst_MEM != 5'b0 && WB_EN_MEM_out )
            sel_alu_in1 = 2'b10;
          if ( (Src2_EXE == Dst_MEM )&& Dst_MEM != 5'b0 && WB_EN_MEM_out )  
            sel_alu_in2 = 2'b10; 

          if ( WB_EN_MEM_out && Dst_MEM != 5'b0 && (Dst_MEM == Dst_EXE) )
            sel_st_val <= 2'b10;

          else if ( WB_EN_WB_out && Dst_WB != 5'b0 && (Dst_WB == Dst_EXE) )
            sel_st_val <= 2'b01;  
      end
      


  end
  
endmodule