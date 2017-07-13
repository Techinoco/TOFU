`include "SMA.h"

module mc (
	input  clk,
	input  rst_n,
	input  i_cbank,
	input  i_run,
	input  i_exwe,
	input  i_exre,
	input  [`DATA_W*12-1:0      ] i_fpearray,
	input  [`DATA_W-1:0         ] i_exwd,
	input  [`ROMULTIC_W-1:0     ] i_exromul,
	input  [`GLB_ADR_W-1:0      ] i_exa,
	input  [`DBGSEL_W-1:0       ] i_dbgsel,

	output [`DATA_W*12-1:0      ] o_topearray,
	output [`ACTIVE_BIT_96_W-1:0] o_conf_alu,
	output [`CONF_SEL_96_W-1:0  ] o_conf_sel_a,
	output [`CONF_SEL_96_W-1:0  ] o_conf_sel_b,
	output [`CONF_SE_96_W-1:0   ] o_conf_se,
	output [`CONST_DATA_8_W-1:0 ] o_const_data_a,
	output [`CONST_DATA_8_W-1:0 ] o_const_data_b,
	output o_conf_sel_dr_01, 
	output o_conf_sel_dr_12, 
	output o_conf_sel_dr_23, 
	output o_conf_sel_dr_34, 
	output o_conf_sel_dr_45, 
	output o_conf_sel_dr_56,
	output o_conf_sel_dr_67,
	output [`DATA_W-1:0         ] o_exrd,
	output [`DBGDAT_W-1:0       ] o_dbgdat,
	output o_done
);

reg r_exwe;
reg r_exre;
reg [`DATA_W-1:0			] r_exwd;
reg [`ROMULTIC_W-1:0		] r_exromul;
reg [`EXA_W-1:0				] r_exa;

wire [`DATA_W*12-1:0		] w_fdmem;
wire [`DATA_W*12-1:0		] w_todmem;
wire [`CPU_W-1:0			] w_rd1;
wire [`CPU_W-1:0			] w_rdst;
wire [`CPU_W-1:0			] w_rd1_st;
//wire [`DMEMA_W+2:0			] w_rd1_st;
wire [`MAP_W-1:0			] w_dmemwe;
wire [`REG_W-1:0			] w_func;
wire [`REG_W-1:0			] w_func_st;
wire [`DLY-1:0				] w_delay;
wire [`CPU_W-1:0			] w_exrd_ifex;
wire [`DATA_W-1:0			] w_exrd_ldadd;
wire [`DATA_W-1:0			] w_exrd_stadd;
wire [`DATA_W-1:0			] w_exrd_bank;
wire [`CONF_OP_ACT_W-1:0	] w_exrd_act;
wire [`CONF_NETWORK_W-1:0	] w_exrd_net;
wire [`CONST_DATA_W-1:0		] w_exrd_const;
wire [`DBGDAT_W-1:0			] w_pc30;
//wire w_ld_add_op;
//wire w_st_add_op;
wire w_ld_st_add_op;
wire w_delay_op;
wire w_running;
wire w_working;
wire w_lock;
wire w_first_set;
//wire w_mode;

ifex ifex_1 (
	.clk			(clk),
	.rst_n			(rst_n), 
	.i_run			(i_run),
	.i_working		(w_working),
	.o_rd1			(w_rd1),
	.o_rd1_st		(w_rd1_st),
	//.o_ld_add_op	(w_ld_add_op),
	//.o_st_add_op	(w_st_add_op),
	.o_ld_st_add_op	(w_ld_st_add_op),
	.o_delay_op		(w_delay_op),
	.o_func			(w_func),
	.o_func_st		(w_func_st),
	.o_done			(o_done),
	.o_delay		(w_delay),
	.o_first_set	(w_first_set),
	.o_pc30			(w_pc30),
	.o_running		(w_running),
	//.lock			(w_lock),
	//.o_mode			(w_mode),
	.i_exwe			(r_exwe),
	.i_exre			(r_exre),
	.i_exwd			(r_exwd[15:0]),
	.o_exrd			(w_exrd_ifex),
	.i_exa			(r_exa)
);

ldadd ldadd_1 (
	.clk			(clk),
	.rst_n			(rst_n),
	//.i_ld_add_op	(w_ld_add_op),
	.i_ld_st_add_op	(w_ld_st_add_op),
	.i_func			(w_func),
	.i_dmemin		(w_fdmem),
	.o_fetch		(o_topearray),
	.i_exwe			(r_exwe),
	.i_exre			(r_exre),
	.i_exwd			(r_exwd[24:0]),
	.o_exrd			(w_exrd_ldadd),
	.i_exa			(r_exa)
);

stadd stadd_1 (
	.clk			(clk),
	.rst_n			(rst_n),
	//.i_st_add_op	(w_st_add_op),
	.i_ld_st_add_op	(w_ld_st_add_op),
	.i_first_set	(w_first_set),
	.o_working		(w_working),
	//.i_func			(w_func),
	.i_func_st		(w_func_st),
	.i_delay		(w_delay),
	//.i_rd1			(w_rd1),
	.i_rd1_st		(w_rd1_st),
	//.w_lock			(w_lock),
	//.i_mode			(w_mode),
	.i_fpearray		(i_fpearray),
	.o_todmem		(w_todmem),
	.o_dmemwe		(w_dmemwe),
	.o_rdst			(w_rdst),
	.i_exwe			(r_exwe),
	.i_exre			(r_exre),
	.i_exwd			(r_exwd[24:0]),
	.o_exrd			(w_exrd_stadd),
	.i_exa          (r_exa)   
);

dbank dbank_1 (
	.clk			(clk),
	.i_cbank		(i_cbank),
	.i_a			(w_rd1[`DMEMA_W+2:0]),
	.i_b			(w_rdst[`DMEMA_W+2:0]),
	.i_wd			(w_todmem),
	.i_we			(w_dmemwe),
	.i_exa          (r_exa), 
	.i_exwd			(r_exwd),
	.i_exwe			(r_exwe),
	.i_exre			(r_exre),
	.o_rd			(w_fdmem),
	.o_exrd			(w_exrd_bank)
);

CONF_CONST_CTRL CCC_1(
	.clk							(clk),
	.rst_n							(rst_n),
	.i_we_from_external				(r_exwe),
	.i_romultic_bits_from_external	(r_exromul),
	.i_glb_adr_from_external		(r_exa),
	//.i_data_from_external			(r_exwd[`CONST_DATA_B]),
	//.i_data_from_external			(r_exwd[`DATA_B]),
	.i_data_from_external			(r_exwd[`CONF_OP_NET_B]),
	.o_const_data_to_external		(w_exrd_const),
	.o_conf_op_act_to_external		(w_exrd_act),
	.o_conf_network_to_external		(w_exrd_net),
	.o_conf_alu						(o_conf_alu),
	.o_conf_sel_a					(o_conf_sel_a),
	.o_conf_sel_b					(o_conf_sel_b),
	.o_conf_se						(o_conf_se),
	.o_const_data_a					(o_const_data_a),
	.o_const_data_b					(o_const_data_b),
	.o_conf_sel_dr_01				(o_conf_sel_dr_01),
	.o_conf_sel_dr_12				(o_conf_sel_dr_12),
	.o_conf_sel_dr_23				(o_conf_sel_dr_23),
	.o_conf_sel_dr_34				(o_conf_sel_dr_34),
	.o_conf_sel_dr_45				(o_conf_sel_dr_45),
	.o_conf_sel_dr_56				(o_conf_sel_dr_56),
	.o_conf_sel_dr_67				(o_conf_sel_dr_67)
);

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		r_exwe <= 0;
		r_exre <= 0;
		r_exwd <= 0;
		r_exromul <= 0;
		r_exa <= 0;
	end
	else begin
		r_exwe <= i_exwe;
		r_exre <= i_exre;
		r_exwd <= i_exwd;
		r_exromul <= i_exromul;
		r_exa <= i_exa;
	end
end

assign o_dbgdat =
	i_dbgsel==3'b000 ? o_topearray[3:0]:
	i_dbgsel==3'b001 ? i_fpearray[3:0]:
	i_dbgsel==3'b010 ? w_todmem[3:0]:
	i_dbgsel==3'b011 ? w_fdmem[3:0]:
	i_dbgsel==3'b100 ? w_pc30:
	i_dbgsel==3'b101 ? {3'b0,w_running}: 0;
	//stdbg;

/*
always @(negedge rst_n)
	stdbg <= 0;
*/
//assign w_exa = r_exa[`GLB_ADR_W-1:1];

assign o_exrd =
	r_exa[`EXSELB] == `EX_ACT	? {15'b0,w_exrd_act}:
	r_exa[`EXSELB] == `EX_NET	? {9'b0 ,w_exrd_net}:
	r_exa[`EXSELB] == `EX_CONST ? {8'b0 ,w_exrd_const}:
	r_exa[`EXSEL ] == `EX_IMEM	? {9'b0 ,w_exrd_ifex}:
	r_exa[`EXSEL ] == `EX_LTBL	? {1'b0 ,w_exrd_ldadd}:
	r_exa[`EXSEL ] == `EX_STBL	? {1'b0 ,w_exrd_stadd}: w_exrd_bank;
endmodule
