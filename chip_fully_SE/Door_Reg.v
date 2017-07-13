`include "./SMA.h"
module Door_Reg (input [`DATA_B] D,
		 input CLK,
		 input EN,
		 output [`DATA_B] Q);
   reg [`DATA_B] 		  DREG;
   
   always @ (posedge CLK) begin
      DREG <= D;
   end
   assign Q = (EN) ? DREG : D;
   
endmodule // Door_Reg
