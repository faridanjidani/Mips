module Hazard_Detect (
	input [4:0] Src1_ID,
	input [4:0] Src2_ID,
  input Branch_Predict,
	input is_Immediate,
	input WB_EN_MEM,
	input WB_EN_EXE,
	input [4:0] Dest_EXE,
	input [4:0] Dest_MEM,
	output reg Freeze,
  output reg Flush
);
	always @(*) begin 
      	Freeze = 1'b0;
        Flush = 1'b0;
        if(Branch_Predict)
          Flush = 1'b1;
        if ((Src1_ID == Dest_EXE ) && Dest_EXE != 5'b0 && WB_EN_EXE)     
          Freeze = 1'b1;
        else if ((Src2_ID == Dest_EXE ) && Dest_EXE != 5'b0 && WB_EN_EXE && !is_Immediate)     
          Freeze = 1'b1;
        else if ((Src1_ID == Dest_MEM ) && Dest_MEM != 5'b0 && WB_EN_MEM) 
          Freeze = 1'b1; 
        else if ((Src2_ID == Dest_MEM ) && Dest_MEM != 5'b0 && WB_EN_MEM && !is_Immediate) 
          Freeze = 1'b1;  
  	end
endmodule // Hazard_Detect