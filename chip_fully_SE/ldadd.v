`include "SMA.h"
module ldadd (
	input clk,
	input rst_n,
	//input i_ld_add_op, 
	input i_ld_st_add_op, 
	input [`REG_W-1:0] i_func,
	input [`DATA_W*12-1:0] i_dmemin,
	output[`DATA_W*12-1:0] o_fetch,
	input i_exwe,
	input i_exre,
	input [`DATA_W-1:0] i_exwd,
	output [`DATA_W-1:0] o_exrd,
	input [`EXA_W-1:0] i_exa
);

reg [`DATA_W*12-1:0] r_fetch;

wire [`LDTBL_W-1:0] w_ldtblout;
wire [`MAP_W-1:0] w_mapout;
wire [`DATA_W*12-1:0] w_fetchin;
wire w_exre_ldtbl;
wire w_exwe_ldtbl;


assign w_exre_ldtbl = i_exre & (i_exa[`EXSEL] == `EX_LTBL);
assign w_exwe_ldtbl = i_exwe & (i_exa[`EXSEL] == `EX_LTBL);

ldtbl ldtbl_1 (
	.clk		(clk),
	.rst_n		(rst_n),
	.i_exwe		(w_exwe_ldtbl),
	.i_exre		(w_exre_ldtbl),
	.i_func		(i_func),
	.i_exa		(i_exa[5:0]),
	.i_exwd		(i_exwd),
	.o_exrd		(o_exrd),
	.o_ldtblout	(w_ldtblout),
	.o_mapout	(w_mapout)
);

dmanu8 dmanu8_ld (
	.i_indata	(i_dmemin),
	.o_outdata	(w_fetchin),
	.i_seltbl	(w_ldtblout)
);

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) r_fetch <= 0;
	else begin
		/*
		if(w_mapout[11] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*12-1:`DATA_W*11] <= w_fetchin[`DATA_W*12-1:`DATA_W*11];
		if(w_mapout[10] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*11-1:`DATA_W*10] <= w_fetchin[`DATA_W*11-1:`DATA_W*10];
		if(w_mapout[9] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*10-1:`DATA_W*9] <= w_fetchin[`DATA_W*10-1:`DATA_W*9];
		if(w_mapout[8] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*9-1:`DATA_W*8] <= w_fetchin[`DATA_W*9-1:`DATA_W*8];
		if(w_mapout[7] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*8-1:`DATA_W*7] <= w_fetchin[`DATA_W*8-1:`DATA_W*7];
		if(w_mapout[6] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*7-1:`DATA_W*6] <= w_fetchin[`DATA_W*7-1:`DATA_W*6];
		if(w_mapout[5] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*6-1:`DATA_W*5] <= w_fetchin[`DATA_W*6-1:`DATA_W*5];
		if(w_mapout[4] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*5-1:`DATA_W*4] <= w_fetchin[`DATA_W*5-1:`DATA_W*4];
		if(w_mapout[3] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*4-1:`DATA_W*3] <= w_fetchin[`DATA_W*4-1:`DATA_W*3];
		if(w_mapout[2] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*3-1:`DATA_W*2] <= w_fetchin[`DATA_W*3-1:`DATA_W*2];
		if(w_mapout[1] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W*2-1:`DATA_W] <=  w_fetchin[`DATA_W*2-1:`DATA_W];
		if(w_mapout[0] & i_ld_add_op | i_ld_st_add_op)
			r_fetch[`DATA_W-1:0] <=  w_fetchin[`DATA_W-1:0]; 
		*/

		if(w_mapout[11] & i_ld_st_add_op)
			r_fetch[`DATA_W*12-1:`DATA_W*11] <= w_fetchin[`DATA_W*12-1:`DATA_W*11];
		if(w_mapout[10] & i_ld_st_add_op)
			r_fetch[`DATA_W*11-1:`DATA_W*10] <= w_fetchin[`DATA_W*11-1:`DATA_W*10];
		if(w_mapout[9] & i_ld_st_add_op)
			r_fetch[`DATA_W*10-1:`DATA_W*9] <= w_fetchin[`DATA_W*10-1:`DATA_W*9];
		if(w_mapout[8] & i_ld_st_add_op)
			r_fetch[`DATA_W*9-1:`DATA_W*8] <= w_fetchin[`DATA_W*9-1:`DATA_W*8];
		if(w_mapout[7] & i_ld_st_add_op)
			r_fetch[`DATA_W*8-1:`DATA_W*7] <= w_fetchin[`DATA_W*8-1:`DATA_W*7];
		if(w_mapout[6] & i_ld_st_add_op)
			r_fetch[`DATA_W*7-1:`DATA_W*6] <= w_fetchin[`DATA_W*7-1:`DATA_W*6];
		if(w_mapout[5] & i_ld_st_add_op)
			r_fetch[`DATA_W*6-1:`DATA_W*5] <= w_fetchin[`DATA_W*6-1:`DATA_W*5];
		if(w_mapout[4] & i_ld_st_add_op)
			r_fetch[`DATA_W*5-1:`DATA_W*4] <= w_fetchin[`DATA_W*5-1:`DATA_W*4];
		if(w_mapout[3] & i_ld_st_add_op)
			r_fetch[`DATA_W*4-1:`DATA_W*3] <= w_fetchin[`DATA_W*4-1:`DATA_W*3];
		if(w_mapout[2] & i_ld_st_add_op)
			r_fetch[`DATA_W*3-1:`DATA_W*2] <= w_fetchin[`DATA_W*3-1:`DATA_W*2];
		if(w_mapout[1] & i_ld_st_add_op)
			r_fetch[`DATA_W*2-1:`DATA_W] <=  w_fetchin[`DATA_W*2-1:`DATA_W];
		if(w_mapout[0] & i_ld_st_add_op)
			r_fetch[`DATA_W-1:0] <=  w_fetchin[`DATA_W-1:0]; 
	end
end
assign o_fetch = r_fetch;

endmodule
