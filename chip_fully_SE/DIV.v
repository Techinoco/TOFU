`include "SMA.h"
module div (
 input [`DMEMA_W+2:0] adr,
 output [5:0] mem_adr,
 output [3:0] mem_adr_i
);
	
wire [8:0] adr_1, adr_2, adr_3, adr_4, adr_5;

wire [3:0] div_num;
assign div_num = 4'b1100;

assign mem_adr[5] = adr < {div_num,5'b0} ? 1'b0 : 1'b1;
assign adr_5 = mem_adr[5] == 1'b0 ? adr : adr - {div_num, 5'b0};
assign mem_adr[4] = adr_5 < {1'b0,div_num,4'b0} ? 1'b0 : 1'b1;
assign adr_4 = mem_adr[4] == 1'b0 ? adr_5 : adr_5 - {1'b0,div_num,4'b0};
assign mem_adr[3] = adr_4 < {2'b0,div_num,3'b0} ? 1'b0 : 1'b1;
assign adr_3 = mem_adr[3] == 1'b0 ? adr_4 : adr_4 - {2'b0,div_num,3'b0};
assign mem_adr[2] = adr_3 < {3'b0,div_num,2'b0} ? 1'b0 : 1'b1;
assign adr_2 = mem_adr[2] == 1'b0 ? adr_3 : adr_3 - {3'b0,div_num,2'b0};
assign mem_adr[1] = adr_2 < {4'b0,div_num,1'b0} ? 1'b0 : 1'b1;
assign adr_1 = mem_adr[1] == 1'b0 ? adr_2 : adr_2 - {4'b0,div_num,1'b0};
assign mem_adr[0] = adr_1 < {5'b0,div_num} ? 1'b0 : 1'b1;
assign mem_adr_i = mem_adr[0] == 1'b0 ? adr_1 : adr_1 - {5'b0,div_num};

endmodule
