`include "SMA.h"
module dbank (
	input clk,
	input i_cbank,
	input [`DMEMA_W+2:0] i_a,
	input [`DMEMA_W+2:0] i_b,
	input [`DATA_W*12-1:0] i_wd,
	input [`BANK_RG_RNG] i_we,
	input [`EXA_W-1:0] i_exa, 
	input [`DATA_W-1:0] i_exwd, 
	input i_exwe,
	input i_exre,
	output [`DATA_W*12-1:0] o_rd,
	output [`DATA_W-1:0] o_exrd
);

wire [`DATA_W*12-1:0] w_rd0;
wire [`DATA_W*12-1:0] w_rd1;
wire [`DATA_W-1:0] w_exrd0;
wire [`DATA_W-1:0] w_exrd1;
wire w_exwe0;
wire w_exwe1;
wire [`BANK_RG_RNG] w_we0;
wire [`BANK_RG_RNG] w_we1;

/* bank=0 bank0 -> CMA, bank=1 bank1 -> CMA */
bank bank0 (
	.clk	(clk),
	.i_a	(i_a),
	.i_b	(i_b),
	.i_wd	(i_wd),
	.i_we	(w_we0),
	.i_exa	(i_exa[`DMEMA_W+2:0]),
	.i_exwd	(i_exwd),
	.i_exwe	(w_exwe0),
	.i_exre	(i_cbank&i_exre),
	.o_rd	(w_rd0),
	.o_exrd	(w_exrd0) 
);

bank bank1 (
	.clk	(clk),
	.i_a	(i_a),
	.i_b	(i_b),
	.i_wd	(i_wd),
	.i_we	(w_we1),
	.i_exa	(i_exa[`DMEMA_W+2:0]),
	.i_exwd	(i_exwd),
	.i_exwe	(w_exwe1),
	.i_exre	(~i_cbank&i_exre),
	.o_rd	(w_rd1),
	.o_exrd	(w_exrd1) 
);

assign o_rd = i_cbank ? w_rd1 : w_rd0;

assign w_we0 = {~i_cbank&i_we[11], ~i_cbank&i_we[10], ~i_cbank&i_we[9], ~i_cbank&i_we[8],
				~i_cbank&i_we[7] , ~i_cbank&i_we[6] , ~i_cbank&i_we[5], ~i_cbank&i_we[4],
				~i_cbank&i_we[3] , ~i_cbank&i_we[2] , ~i_cbank&i_we[1], ~i_cbank&i_we[0]};

assign w_we1 = {i_cbank&i_we[11], i_cbank&i_we[10], i_cbank&i_we[9], i_cbank&i_we[8],
				i_cbank&i_we[7] , i_cbank&i_we[6] , i_cbank&i_we[5], i_cbank&i_we[4],
				i_cbank&i_we[3] , i_cbank&i_we[2] , i_cbank&i_we[1], i_cbank&i_we[0]};
	
assign o_exrd = i_exa[`EXSEL] == `EX_BANK0 ? w_exrd0 : w_exrd1;
assign w_exwe0 = (i_exa[`EXSEL] == `EX_BANK0) & i_exwe;
assign w_exwe1 = (i_exa[`EXSEL] == `EX_BANK1) & i_exwe;

endmodule
