`include "SMA.h"
//OK
module dmem (
	input clk,
	input [`DMEMA_W-1:0] i_a,
	input [`DMEMA_W-1:0] i_b,
	output [`DATA_W-1:0] o_rd, 
	input [`DATA_W-1:0] i_wd,
	input i_we
);

reg[`DATA_W-1:0] mem[0:`DEPTH-1];

integer i;

initial begin
	for (i=0; i<`DEPTH; i=i+1)
		mem[i] = `DATA_W'b0;
end

always @(posedge clk)  
	if(i_we) mem[i_b] <= i_wd;

assign o_rd = mem[i_a];
/*
initial
      begin
	         $readmemh("dmem.dat", mem);
	 end
*/

endmodule
