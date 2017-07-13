`include "SMA.h"
module imem (
	input clk, 
	input rst_n,
	input [`INSTA_W-1:0] i_a,
	input [`INSTA_W-1:0] i_exa,
	input [`CPU_W-1:0] i_exwd,
	input i_exwe,
	input i_exre,
	output [`CPU_W-1:0] o_rd
);

integer i;
reg[`CPU_W-1:0] r_mem[0:`DEPTH-1];

wire [`INSTA_W-1:0] w_imemad = i_exre | i_exwe ? i_exa: i_a;

assign o_rd = r_mem[w_imemad];

always @ (posedge clk)  
	if (!rst_n)
		for (i=0; i<`DEPTH; i=i+1)
			r_mem[i] <= `CPU_W'b0;
	else if(i_exwe) r_mem[w_imemad] <= i_exwd;
/*
initial
      begin
	    $readmemb("imem.dat", mem);
	  end
*/

endmodule
