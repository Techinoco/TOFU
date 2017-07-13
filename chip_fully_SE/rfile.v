`include "SMA.h"
module rfile (
	input clk,
	input rst_n,
	input [`REG_W-1:0] i_a1,
	input [`REG_W-1:0] i_a2,
	input [`REG_W-1:0] i_a3,
	output [`CPU_W-1:0] o_rd1,
	output [`CPU_W-1:0] o_rd2,
	output [`CPU_W-1:0] o_sa_ld_out,
	output [`CPU_W-1:0] o_dnum_ld_out,
	output [`CPU_W-1:0] o_sa_st_out,
	output [`CPU_W-1:0] o_dnum_st_out,
	input [`CPU_W-1:0] i_wd3,
	input i_we3,
	input i_we_sa_ld,
	input i_we_sa_st,
	input i_we_dnum_ld,
	input i_we_dnum_st,
	input [`CPU_W-1:0] i_sa_ld_in,
	input [`CPU_W-1:0] i_dnum_ld_in,
	input [`CPU_W-1:0] i_sa_st_in,
	input [`CPU_W-1:0] i_dnum_st_in
);

integer i;
reg [`CPU_W-1:0] r_rf[0:`REG-1];
reg [`CPU_W-1:0] r_sa_ld;
reg [`CPU_W-1:0] r_dnum_ld;
reg [`CPU_W-1:0] r_sa_st;
reg [`CPU_W-1:0] r_dnum_st;

assign o_rd1 = r_rf[i_a1];
assign o_rd2 = r_rf[i_a2];
   
always @(posedge clk) begin
	if (!rst_n)
		for (i=0; i<`REG; i=i+1)
			r_rf[i] <= `CPU_W'b0;
	else if(i_we3)
		r_rf[i_a3] <= i_wd3;
end
assign o_sa_ld_out = r_sa_ld;

always @(posedge clk)
	if(i_we_sa_ld) r_sa_ld <= i_sa_ld_in;

always @(posedge clk)
	if(i_we_dnum_ld) r_dnum_ld <= i_dnum_ld_in;
assign o_dnum_ld_out = r_dnum_ld;

always @(posedge clk)
	if(i_we_sa_st) r_sa_st <= i_sa_st_in;
assign o_sa_st_out = r_sa_st;

always @(posedge clk)
	if(i_we_dnum_st) r_dnum_st <= i_dnum_st_in;
assign o_dnum_st_out = r_dnum_st;

endmodule
