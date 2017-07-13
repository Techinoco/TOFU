`include "SMA.h"

module cma (
	input clk,
	input rst_n,
	input i_cbank,
	input i_run,
	input i_exwe,
	input i_exre,
	input  [`DATA_W-1:0    ] i_exwd,
	input  [`ROMULTIC_W-1:0] i_exromul,
	input  [`GLB_ADR_W-1:0 ] i_exa,
	input  [`DBGSEL_W-1:0  ] i_dbgsel,

	output [`DATA_W-1:0    ] o_exrd,
	output [`DBGDAT_W-1:0  ] o_dbgdat,
	output o_done
);

wire [`DATA_12_B] w_fpearray;
wire [`DATA_12_B] w_topearray;
wire [`ACTIVE_BIT_96_W-1:0] w_conf_alu;
wire [`CONF_SEL_96_W-1:0]   w_conf_sel_a;
wire [`CONF_SEL_96_W-1:0]   w_conf_sel_b;
wire [`CONF_SE_96_W-1:0]    w_conf_se;
wire [`CONST_DATA_8_W-1:0]  w_const_data_a;
wire [`CONST_DATA_8_W-1:0]  w_const_data_b;
wire w_conf_sel_dr_01, w_conf_sel_dr_12, w_conf_sel_dr_23, w_conf_sel_dr_34;
wire w_conf_sel_dr_45, w_conf_sel_dr_56, w_conf_sel_dr_67;
   // reg [`DATA_12_B] d1, d2, d3;

mc mc1(
	.clk				(clk), 
	.rst_n				(rst_n),
	.i_cbank			(i_cbank),
	.i_run				(i_run),
	.o_topearray		(w_topearray),
	.i_fpearray			(w_fpearray),// swoped d3
	.o_conf_alu			(w_conf_alu),
	.o_conf_sel_a		(w_conf_sel_a),
	.o_conf_sel_b		(w_conf_sel_b),
	.o_conf_se			(w_conf_se),
	.o_const_data_a		(w_const_data_a),
	.o_const_data_b		(w_const_data_b),
	.o_conf_sel_dr_01	(w_conf_sel_dr_01),
	.o_conf_sel_dr_12	(w_conf_sel_dr_12),
	.o_conf_sel_dr_23	(w_conf_sel_dr_23),
	.o_conf_sel_dr_34	(w_conf_sel_dr_34),
	.o_conf_sel_dr_45	(w_conf_sel_dr_45),
	.o_conf_sel_dr_56	(w_conf_sel_dr_56),
	.o_conf_sel_dr_67	(w_conf_sel_dr_67),
	.o_done				(o_done),
	.i_exwe				(i_exwe),
	.i_exre				(i_exre),
	.i_exwd				(i_exwd),
	.o_exrd				(o_exrd),
	.i_exromul			(i_exromul),
	.i_exa				(i_exa),
	.i_dbgsel			(i_dbgsel),
	.o_dbgdat			(o_dbgdat)
);

PE_ARRAY PE_ARRAY1 (
	.CLK			(clk),
	.CONF_ALU		(w_conf_alu),
	.CONF_SEL_A		(w_conf_sel_a),
	.CONF_SEL_B		(w_conf_sel_b),
	.CONF_SE		(w_conf_se),
	.CONF_SEL_DR_01	(w_conf_sel_dr_01),
	.CONF_SEL_DR_12	(w_conf_sel_dr_12),
	.CONF_SEL_DR_23	(w_conf_sel_dr_23),
	.CONF_SEL_DR_34	(w_conf_sel_dr_34),
	.CONF_SEL_DR_45	(w_conf_sel_dr_45),
	.CONF_SEL_DR_56	(w_conf_sel_dr_56),
	.CONF_SEL_DR_67	(w_conf_sel_dr_67),
	.IN_SOUTH		(w_topearray),
	.IN_CONST_A		(w_const_data_a),
	.IN_CONST_B		(w_const_data_b),
	.OUT_SOUTH		(w_fpearray)
);

// always @(posedge clk) begin
// 	d1 <= fpearray;
// 	d2 <= d1;
// 	d3 <= d2;
// end

endmodule

