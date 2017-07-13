`include "./SMA.h"

module CONF_CTRL (
	input					clk,
	input					rst_n,

	// CONNECTION TO EXTERNAL
	input					i_we_from_external,
	input  [`ROMULTIC_B   ] i_romultic_bits_from_external,
	input  [`GLB_ADR_B    ] i_glb_adr_from_external,
	//input  [`CONF_NETWORK_B]i_conf_data_from_external,
	input  [`CONF_OP_NET_B]	i_conf_data_from_external,
	output [`CONF_OP_ACT_B] o_conf_op_act_to_external,
	output [`CONF_NETWORK_B]o_conf_network_to_external,

	// CONNECTION TO PE_ARRAY
	// output [`ACTIVE_BIT_64_B] ACTIVE_BIT,
	output [`CONF_ALU_96_B]	o_conf_alu,
	output [`CONF_SEL_96_B]	o_conf_sel_a,
	output [`CONF_SEL_96_B]	o_conf_sel_b,
	output [`CONF_SE_96_B ]	o_conf_se,
	output					o_conf_sel_dr_01,
	output					o_conf_sel_dr_12,
	output					o_conf_sel_dr_23,
	output					o_conf_sel_dr_34,
	output					o_conf_sel_dr_45,
	output					o_conf_sel_dr_56,
	output					o_conf_sel_dr_67
);
   
   //////// REGISTER FILE AND WIRE DECLARATION //////////////////
integer i, row, col;
   
wire [`PE_ROW_NUM_RNG]	w_romultic_bits_row;
wire [`PE_COL_NUM_RNG]	w_romultic_bits_col;
wire [`CONF_OP_ACT_B ]	w_in_conf_op_act;
wire [`CONF_NETWORK_B]	w_in_conf_network;
wire [`PE_ADR_B      ]	w_pe_adr;
wire					w_conf_op_act_we;
wire					w_conf_network_we;
wire					w_conf_preg_we;
wire					w_conf_peadr_we;
// wire [2:0] 		  IN_CONF_PREG;
reg  [`CONF_OP_ACT_B ]	r_conf_op_act  [`PE_NUM_RNG];
reg  [`CONF_NETWORK_B]	r_conf_network [`PE_NUM_RNG];
reg o_conf_sel_dr_01_REG, o_conf_sel_dr_12_REG, o_conf_sel_dr_23_REG, 
    o_conf_sel_dr_34_REG, o_conf_sel_dr_45_REG, o_conf_sel_dr_56_REG, o_conf_sel_dr_67_REG;
   
   
//////// SIGNAL FROM EXTERNAL ////////////////////////////////
assign {w_romultic_bits_row, w_romultic_bits_col} = i_romultic_bits_from_external;
assign w_in_conf_op_act      = i_conf_data_from_external[`CONF_OP_ACT_B ];
assign w_in_conf_network     = i_conf_data_from_external[`CONF_NETWORK_B];
// assign IN_CONF_PREG        = i_conf_data_from_external[];
assign w_pe_adr              = i_glb_adr_from_external[`PE_ADR_B];
assign w_conf_op_act_we  = i_we_from_external & (i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONF_OP_ACT );
assign w_conf_network_we = i_we_from_external & (i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONF_NETWORK);
assign w_conf_preg_we = i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONF_PREG;
assign w_conf_peadr_we = i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONF_PEADR ? 1'b1:
						 i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONF_PEADR2? 1'b1: 1'b0;
//assign w_conf_peadr_we = i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONF_PEADR;
   
//////// CONFIGURATION DATA STORING //////////////////////////
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin // initialize ( all configuration data is 0 )
		for (i = 0; i < `PE_NUM; i = i + 1) begin
			r_conf_op_act [i] <= `CONF_OP_ACT_W'd0;
			r_conf_network[i] <= `CONF_NETWORK_W'd0;
		end
	end
	else begin // write configuration data
		for (row = 0; row < `PE_ROW_NUM; row = row + 1) begin
			for (col = 0; col < `PE_COL_NUM; col = col + 1) begin
				if (w_romultic_bits_row[row] & w_romultic_bits_col[col] & w_conf_op_act_we)
					r_conf_op_act [row * `PE_COL_NUM + col] <= w_in_conf_op_act;
				if (w_romultic_bits_row[row] & w_romultic_bits_col[col] & w_conf_network_we)
					r_conf_network[row * `PE_COL_NUM + col] <= w_in_conf_network;
			end
		end
		if (w_conf_preg_we)
			{o_conf_sel_dr_67_REG, o_conf_sel_dr_56_REG, o_conf_sel_dr_45_REG,
			 o_conf_sel_dr_34_REG, o_conf_sel_dr_23_REG, o_conf_sel_dr_12_REG,
			 o_conf_sel_dr_01_REG} <= i_conf_data_from_external[6:0];
		/*write configration data with PE address*/
		if(w_conf_peadr_we) begin
			r_conf_op_act[w_pe_adr] <= i_conf_data_from_external[9:0];
			r_conf_network[w_pe_adr] <= i_conf_data_from_external[19:10];
		end
	end
end
   
   
//////// CONFIGURATION DATA TO PE ARRAY //////////////////////
assign o_conf_sel_dr_01 = o_conf_sel_dr_01_REG;
assign o_conf_sel_dr_12 = o_conf_sel_dr_12_REG;
assign o_conf_sel_dr_23 = o_conf_sel_dr_23_REG;
assign o_conf_sel_dr_34 = o_conf_sel_dr_34_REG;
assign o_conf_sel_dr_45 = o_conf_sel_dr_45_REG;
assign o_conf_sel_dr_56 = o_conf_sel_dr_56_REG;   
assign o_conf_sel_dr_67 = o_conf_sel_dr_67_REG;   

assign o_conf_alu =
   {r_conf_op_act[95][`CONF_ALU_RNG], r_conf_op_act[94][`CONF_ALU_RNG], r_conf_op_act[93][`CONF_ALU_RNG], 
	r_conf_op_act[92][`CONF_ALU_RNG], r_conf_op_act[91][`CONF_ALU_RNG], r_conf_op_act[90][`CONF_ALU_RNG], 
	r_conf_op_act[89][`CONF_ALU_RNG], r_conf_op_act[88][`CONF_ALU_RNG], r_conf_op_act[87][`CONF_ALU_RNG], 
	r_conf_op_act[86][`CONF_ALU_RNG], r_conf_op_act[85][`CONF_ALU_RNG], r_conf_op_act[84][`CONF_ALU_RNG], 
	r_conf_op_act[83][`CONF_ALU_RNG], r_conf_op_act[82][`CONF_ALU_RNG], r_conf_op_act[81][`CONF_ALU_RNG], 
	r_conf_op_act[80][`CONF_ALU_RNG], r_conf_op_act[79][`CONF_ALU_RNG], r_conf_op_act[78][`CONF_ALU_RNG], 
	r_conf_op_act[77][`CONF_ALU_RNG], r_conf_op_act[76][`CONF_ALU_RNG], r_conf_op_act[75][`CONF_ALU_RNG], 
	r_conf_op_act[74][`CONF_ALU_RNG], r_conf_op_act[73][`CONF_ALU_RNG], r_conf_op_act[72][`CONF_ALU_RNG], 
	r_conf_op_act[71][`CONF_ALU_RNG], r_conf_op_act[70][`CONF_ALU_RNG], r_conf_op_act[69][`CONF_ALU_RNG], 
	r_conf_op_act[68][`CONF_ALU_RNG], r_conf_op_act[67][`CONF_ALU_RNG], r_conf_op_act[66][`CONF_ALU_RNG], 
	r_conf_op_act[65][`CONF_ALU_RNG], r_conf_op_act[64][`CONF_ALU_RNG], r_conf_op_act[63][`CONF_ALU_RNG], 
	r_conf_op_act[62][`CONF_ALU_RNG], r_conf_op_act[61][`CONF_ALU_RNG], r_conf_op_act[60][`CONF_ALU_RNG], 
	r_conf_op_act[59][`CONF_ALU_RNG], r_conf_op_act[58][`CONF_ALU_RNG], r_conf_op_act[57][`CONF_ALU_RNG], 
	r_conf_op_act[56][`CONF_ALU_RNG], r_conf_op_act[55][`CONF_ALU_RNG], r_conf_op_act[54][`CONF_ALU_RNG], 
	r_conf_op_act[53][`CONF_ALU_RNG], r_conf_op_act[52][`CONF_ALU_RNG], r_conf_op_act[51][`CONF_ALU_RNG], 
	r_conf_op_act[50][`CONF_ALU_RNG], r_conf_op_act[49][`CONF_ALU_RNG], r_conf_op_act[48][`CONF_ALU_RNG], 
	r_conf_op_act[47][`CONF_ALU_RNG], r_conf_op_act[46][`CONF_ALU_RNG], r_conf_op_act[45][`CONF_ALU_RNG], 
	r_conf_op_act[44][`CONF_ALU_RNG], r_conf_op_act[43][`CONF_ALU_RNG], r_conf_op_act[42][`CONF_ALU_RNG], 
	r_conf_op_act[41][`CONF_ALU_RNG], r_conf_op_act[40][`CONF_ALU_RNG], r_conf_op_act[39][`CONF_ALU_RNG], 
	r_conf_op_act[38][`CONF_ALU_RNG], r_conf_op_act[37][`CONF_ALU_RNG], r_conf_op_act[36][`CONF_ALU_RNG], 
	r_conf_op_act[35][`CONF_ALU_RNG], r_conf_op_act[34][`CONF_ALU_RNG], r_conf_op_act[33][`CONF_ALU_RNG], 
	r_conf_op_act[32][`CONF_ALU_RNG], r_conf_op_act[31][`CONF_ALU_RNG], r_conf_op_act[30][`CONF_ALU_RNG], 
	r_conf_op_act[29][`CONF_ALU_RNG], r_conf_op_act[28][`CONF_ALU_RNG], r_conf_op_act[27][`CONF_ALU_RNG], 
	r_conf_op_act[26][`CONF_ALU_RNG], r_conf_op_act[25][`CONF_ALU_RNG], r_conf_op_act[24][`CONF_ALU_RNG], 
	r_conf_op_act[23][`CONF_ALU_RNG], r_conf_op_act[22][`CONF_ALU_RNG], r_conf_op_act[21][`CONF_ALU_RNG], 
	r_conf_op_act[20][`CONF_ALU_RNG], r_conf_op_act[19][`CONF_ALU_RNG], r_conf_op_act[18][`CONF_ALU_RNG], 
	r_conf_op_act[17][`CONF_ALU_RNG], r_conf_op_act[16][`CONF_ALU_RNG], r_conf_op_act[15][`CONF_ALU_RNG], 
	r_conf_op_act[14][`CONF_ALU_RNG], r_conf_op_act[13][`CONF_ALU_RNG], r_conf_op_act[12][`CONF_ALU_RNG], 
	r_conf_op_act[11][`CONF_ALU_RNG], r_conf_op_act[10][`CONF_ALU_RNG], r_conf_op_act[9][`CONF_ALU_RNG], 
	r_conf_op_act[8][`CONF_ALU_RNG], r_conf_op_act[7][`CONF_ALU_RNG], r_conf_op_act[6][`CONF_ALU_RNG], 
	r_conf_op_act[5][`CONF_ALU_RNG], r_conf_op_act[4][`CONF_ALU_RNG], r_conf_op_act[3][`CONF_ALU_RNG], 
	r_conf_op_act[2][`CONF_ALU_RNG], r_conf_op_act[1][`CONF_ALU_RNG], r_conf_op_act[0][`CONF_ALU_RNG]};

assign o_conf_sel_a =
   {r_conf_op_act[95][`CONF_SEL_A_RNG], r_conf_op_act[94][`CONF_SEL_A_RNG], r_conf_op_act[93][`CONF_SEL_A_RNG], 
	r_conf_op_act[92][`CONF_SEL_A_RNG], r_conf_op_act[91][`CONF_SEL_A_RNG], r_conf_op_act[90][`CONF_SEL_A_RNG], 
	r_conf_op_act[89][`CONF_SEL_A_RNG], r_conf_op_act[88][`CONF_SEL_A_RNG], r_conf_op_act[87][`CONF_SEL_A_RNG], 
	r_conf_op_act[86][`CONF_SEL_A_RNG], r_conf_op_act[85][`CONF_SEL_A_RNG], r_conf_op_act[84][`CONF_SEL_A_RNG], 
	r_conf_op_act[83][`CONF_SEL_A_RNG], r_conf_op_act[82][`CONF_SEL_A_RNG], r_conf_op_act[81][`CONF_SEL_A_RNG], 
	r_conf_op_act[80][`CONF_SEL_A_RNG], r_conf_op_act[79][`CONF_SEL_A_RNG], r_conf_op_act[78][`CONF_SEL_A_RNG], 
	r_conf_op_act[77][`CONF_SEL_A_RNG], r_conf_op_act[76][`CONF_SEL_A_RNG], r_conf_op_act[75][`CONF_SEL_A_RNG], 
	r_conf_op_act[74][`CONF_SEL_A_RNG], r_conf_op_act[73][`CONF_SEL_A_RNG], r_conf_op_act[72][`CONF_SEL_A_RNG], 
	r_conf_op_act[71][`CONF_SEL_A_RNG], r_conf_op_act[70][`CONF_SEL_A_RNG], r_conf_op_act[69][`CONF_SEL_A_RNG], 
	r_conf_op_act[68][`CONF_SEL_A_RNG], r_conf_op_act[67][`CONF_SEL_A_RNG], r_conf_op_act[66][`CONF_SEL_A_RNG], 
	r_conf_op_act[65][`CONF_SEL_A_RNG], r_conf_op_act[64][`CONF_SEL_A_RNG], r_conf_op_act[63][`CONF_SEL_A_RNG], 
	r_conf_op_act[62][`CONF_SEL_A_RNG], r_conf_op_act[61][`CONF_SEL_A_RNG], r_conf_op_act[60][`CONF_SEL_A_RNG], 
	r_conf_op_act[59][`CONF_SEL_A_RNG], r_conf_op_act[58][`CONF_SEL_A_RNG], r_conf_op_act[57][`CONF_SEL_A_RNG], 
	r_conf_op_act[56][`CONF_SEL_A_RNG], r_conf_op_act[55][`CONF_SEL_A_RNG], r_conf_op_act[54][`CONF_SEL_A_RNG], 
	r_conf_op_act[53][`CONF_SEL_A_RNG], r_conf_op_act[52][`CONF_SEL_A_RNG], r_conf_op_act[51][`CONF_SEL_A_RNG], 
	r_conf_op_act[50][`CONF_SEL_A_RNG], r_conf_op_act[49][`CONF_SEL_A_RNG], r_conf_op_act[48][`CONF_SEL_A_RNG], 
	r_conf_op_act[47][`CONF_SEL_A_RNG], r_conf_op_act[46][`CONF_SEL_A_RNG], r_conf_op_act[45][`CONF_SEL_A_RNG], 
	r_conf_op_act[44][`CONF_SEL_A_RNG], r_conf_op_act[43][`CONF_SEL_A_RNG], r_conf_op_act[42][`CONF_SEL_A_RNG], 
	r_conf_op_act[41][`CONF_SEL_A_RNG], r_conf_op_act[40][`CONF_SEL_A_RNG], r_conf_op_act[39][`CONF_SEL_A_RNG], 
	r_conf_op_act[38][`CONF_SEL_A_RNG], r_conf_op_act[37][`CONF_SEL_A_RNG], r_conf_op_act[36][`CONF_SEL_A_RNG], 
	r_conf_op_act[35][`CONF_SEL_A_RNG], r_conf_op_act[34][`CONF_SEL_A_RNG], r_conf_op_act[33][`CONF_SEL_A_RNG], 
	r_conf_op_act[32][`CONF_SEL_A_RNG], r_conf_op_act[31][`CONF_SEL_A_RNG], r_conf_op_act[30][`CONF_SEL_A_RNG], 
	r_conf_op_act[29][`CONF_SEL_A_RNG], r_conf_op_act[28][`CONF_SEL_A_RNG], r_conf_op_act[27][`CONF_SEL_A_RNG], 
	r_conf_op_act[26][`CONF_SEL_A_RNG], r_conf_op_act[25][`CONF_SEL_A_RNG], r_conf_op_act[24][`CONF_SEL_A_RNG], 
	r_conf_op_act[23][`CONF_SEL_A_RNG], r_conf_op_act[22][`CONF_SEL_A_RNG], r_conf_op_act[21][`CONF_SEL_A_RNG], 
	r_conf_op_act[20][`CONF_SEL_A_RNG], r_conf_op_act[19][`CONF_SEL_A_RNG], r_conf_op_act[18][`CONF_SEL_A_RNG], 
	r_conf_op_act[17][`CONF_SEL_A_RNG], r_conf_op_act[16][`CONF_SEL_A_RNG], r_conf_op_act[15][`CONF_SEL_A_RNG], 
	r_conf_op_act[14][`CONF_SEL_A_RNG], r_conf_op_act[13][`CONF_SEL_A_RNG], r_conf_op_act[12][`CONF_SEL_A_RNG], 
	r_conf_op_act[11][`CONF_SEL_A_RNG], r_conf_op_act[10][`CONF_SEL_A_RNG], r_conf_op_act[9][`CONF_SEL_A_RNG], 
	r_conf_op_act[8][`CONF_SEL_A_RNG], r_conf_op_act[7][`CONF_SEL_A_RNG], r_conf_op_act[6][`CONF_SEL_A_RNG], 
	r_conf_op_act[5][`CONF_SEL_A_RNG], r_conf_op_act[4][`CONF_SEL_A_RNG], r_conf_op_act[3][`CONF_SEL_A_RNG], 
	r_conf_op_act[2][`CONF_SEL_A_RNG], r_conf_op_act[1][`CONF_SEL_A_RNG], r_conf_op_act[0][`CONF_SEL_A_RNG]};

assign o_conf_sel_b =
   {r_conf_op_act[95][`CONF_SEL_B_RNG], r_conf_op_act[94][`CONF_SEL_B_RNG], r_conf_op_act[93][`CONF_SEL_B_RNG], 
	r_conf_op_act[92][`CONF_SEL_B_RNG], r_conf_op_act[91][`CONF_SEL_B_RNG], r_conf_op_act[90][`CONF_SEL_B_RNG], 
	r_conf_op_act[89][`CONF_SEL_B_RNG], r_conf_op_act[88][`CONF_SEL_B_RNG], r_conf_op_act[87][`CONF_SEL_B_RNG], 
	r_conf_op_act[86][`CONF_SEL_B_RNG], r_conf_op_act[85][`CONF_SEL_B_RNG], r_conf_op_act[84][`CONF_SEL_B_RNG], 
	r_conf_op_act[83][`CONF_SEL_B_RNG], r_conf_op_act[82][`CONF_SEL_B_RNG], r_conf_op_act[81][`CONF_SEL_B_RNG], 
	r_conf_op_act[80][`CONF_SEL_B_RNG], r_conf_op_act[79][`CONF_SEL_B_RNG], r_conf_op_act[78][`CONF_SEL_B_RNG], 
	r_conf_op_act[77][`CONF_SEL_B_RNG], r_conf_op_act[76][`CONF_SEL_B_RNG], r_conf_op_act[75][`CONF_SEL_B_RNG], 
	r_conf_op_act[74][`CONF_SEL_B_RNG], r_conf_op_act[73][`CONF_SEL_B_RNG], r_conf_op_act[72][`CONF_SEL_B_RNG], 
	r_conf_op_act[71][`CONF_SEL_B_RNG], r_conf_op_act[70][`CONF_SEL_B_RNG], r_conf_op_act[69][`CONF_SEL_B_RNG], 
	r_conf_op_act[68][`CONF_SEL_B_RNG], r_conf_op_act[67][`CONF_SEL_B_RNG], r_conf_op_act[66][`CONF_SEL_B_RNG], 
	r_conf_op_act[65][`CONF_SEL_B_RNG], r_conf_op_act[64][`CONF_SEL_B_RNG], r_conf_op_act[63][`CONF_SEL_B_RNG], 
	r_conf_op_act[62][`CONF_SEL_B_RNG], r_conf_op_act[61][`CONF_SEL_B_RNG], r_conf_op_act[60][`CONF_SEL_B_RNG], 
	r_conf_op_act[59][`CONF_SEL_B_RNG], r_conf_op_act[58][`CONF_SEL_B_RNG], r_conf_op_act[57][`CONF_SEL_B_RNG], 
	r_conf_op_act[56][`CONF_SEL_B_RNG], r_conf_op_act[55][`CONF_SEL_B_RNG], r_conf_op_act[54][`CONF_SEL_B_RNG], 
	r_conf_op_act[53][`CONF_SEL_B_RNG], r_conf_op_act[52][`CONF_SEL_B_RNG], r_conf_op_act[51][`CONF_SEL_B_RNG], 
	r_conf_op_act[50][`CONF_SEL_B_RNG], r_conf_op_act[49][`CONF_SEL_B_RNG], r_conf_op_act[48][`CONF_SEL_B_RNG], 
	r_conf_op_act[47][`CONF_SEL_B_RNG], r_conf_op_act[46][`CONF_SEL_B_RNG], r_conf_op_act[45][`CONF_SEL_B_RNG], 
	r_conf_op_act[44][`CONF_SEL_B_RNG], r_conf_op_act[43][`CONF_SEL_B_RNG], r_conf_op_act[42][`CONF_SEL_B_RNG], 
	r_conf_op_act[41][`CONF_SEL_B_RNG], r_conf_op_act[40][`CONF_SEL_B_RNG], r_conf_op_act[39][`CONF_SEL_B_RNG], 
	r_conf_op_act[38][`CONF_SEL_B_RNG], r_conf_op_act[37][`CONF_SEL_B_RNG], r_conf_op_act[36][`CONF_SEL_B_RNG], 
	r_conf_op_act[35][`CONF_SEL_B_RNG], r_conf_op_act[34][`CONF_SEL_B_RNG], r_conf_op_act[33][`CONF_SEL_B_RNG], 
	r_conf_op_act[32][`CONF_SEL_B_RNG], r_conf_op_act[31][`CONF_SEL_B_RNG], r_conf_op_act[30][`CONF_SEL_B_RNG], 
	r_conf_op_act[29][`CONF_SEL_B_RNG], r_conf_op_act[28][`CONF_SEL_B_RNG], r_conf_op_act[27][`CONF_SEL_B_RNG], 
	r_conf_op_act[26][`CONF_SEL_B_RNG], r_conf_op_act[25][`CONF_SEL_B_RNG], r_conf_op_act[24][`CONF_SEL_B_RNG], 
	r_conf_op_act[23][`CONF_SEL_B_RNG], r_conf_op_act[22][`CONF_SEL_B_RNG], r_conf_op_act[21][`CONF_SEL_B_RNG], 
	r_conf_op_act[20][`CONF_SEL_B_RNG], r_conf_op_act[19][`CONF_SEL_B_RNG], r_conf_op_act[18][`CONF_SEL_B_RNG], 
	r_conf_op_act[17][`CONF_SEL_B_RNG], r_conf_op_act[16][`CONF_SEL_B_RNG], r_conf_op_act[15][`CONF_SEL_B_RNG], 
	r_conf_op_act[14][`CONF_SEL_B_RNG], r_conf_op_act[13][`CONF_SEL_B_RNG], r_conf_op_act[12][`CONF_SEL_B_RNG], 
	r_conf_op_act[11][`CONF_SEL_B_RNG], r_conf_op_act[10][`CONF_SEL_B_RNG], r_conf_op_act[9][`CONF_SEL_B_RNG], 
	r_conf_op_act[8][`CONF_SEL_B_RNG], r_conf_op_act[7][`CONF_SEL_B_RNG], r_conf_op_act[6][`CONF_SEL_B_RNG], 
	r_conf_op_act[5][`CONF_SEL_B_RNG], r_conf_op_act[4][`CONF_SEL_B_RNG], r_conf_op_act[3][`CONF_SEL_B_RNG], 
	r_conf_op_act[2][`CONF_SEL_B_RNG], r_conf_op_act[1][`CONF_SEL_B_RNG], r_conf_op_act[0][`CONF_SEL_B_RNG]};

assign o_conf_se =
   {r_conf_network[95][`CONF_SE_RNG], r_conf_network[94][`CONF_SE_RNG], r_conf_network[93][`CONF_SE_RNG], 
	r_conf_network[92][`CONF_SE_RNG], r_conf_network[91][`CONF_SE_RNG], r_conf_network[90][`CONF_SE_RNG], 
	r_conf_network[89][`CONF_SE_RNG], r_conf_network[88][`CONF_SE_RNG], r_conf_network[87][`CONF_SE_RNG], 
	r_conf_network[86][`CONF_SE_RNG], r_conf_network[85][`CONF_SE_RNG], r_conf_network[84][`CONF_SE_RNG], 
	r_conf_network[83][`CONF_SE_RNG], r_conf_network[82][`CONF_SE_RNG], r_conf_network[81][`CONF_SE_RNG], 
	r_conf_network[80][`CONF_SE_RNG], r_conf_network[79][`CONF_SE_RNG], r_conf_network[78][`CONF_SE_RNG], 
	r_conf_network[77][`CONF_SE_RNG], r_conf_network[76][`CONF_SE_RNG], r_conf_network[75][`CONF_SE_RNG], 
	r_conf_network[74][`CONF_SE_RNG], r_conf_network[73][`CONF_SE_RNG], r_conf_network[72][`CONF_SE_RNG], 
	r_conf_network[71][`CONF_SE_RNG], r_conf_network[70][`CONF_SE_RNG], r_conf_network[69][`CONF_SE_RNG], 
	r_conf_network[68][`CONF_SE_RNG], r_conf_network[67][`CONF_SE_RNG], r_conf_network[66][`CONF_SE_RNG], 
	r_conf_network[65][`CONF_SE_RNG], r_conf_network[64][`CONF_SE_RNG], r_conf_network[63][`CONF_SE_RNG], 
	r_conf_network[62][`CONF_SE_RNG], r_conf_network[61][`CONF_SE_RNG], r_conf_network[60][`CONF_SE_RNG], 
	r_conf_network[59][`CONF_SE_RNG], r_conf_network[58][`CONF_SE_RNG], r_conf_network[57][`CONF_SE_RNG], 
	r_conf_network[56][`CONF_SE_RNG], r_conf_network[55][`CONF_SE_RNG], r_conf_network[54][`CONF_SE_RNG], 
	r_conf_network[53][`CONF_SE_RNG], r_conf_network[52][`CONF_SE_RNG], r_conf_network[51][`CONF_SE_RNG], 
	r_conf_network[50][`CONF_SE_RNG], r_conf_network[49][`CONF_SE_RNG], r_conf_network[48][`CONF_SE_RNG], 
	r_conf_network[47][`CONF_SE_RNG], r_conf_network[46][`CONF_SE_RNG], r_conf_network[45][`CONF_SE_RNG], 
	r_conf_network[44][`CONF_SE_RNG], r_conf_network[43][`CONF_SE_RNG], r_conf_network[42][`CONF_SE_RNG], 
	r_conf_network[41][`CONF_SE_RNG], r_conf_network[40][`CONF_SE_RNG], r_conf_network[39][`CONF_SE_RNG], 
	r_conf_network[38][`CONF_SE_RNG], r_conf_network[37][`CONF_SE_RNG], r_conf_network[36][`CONF_SE_RNG], 
	r_conf_network[35][`CONF_SE_RNG], r_conf_network[34][`CONF_SE_RNG], r_conf_network[33][`CONF_SE_RNG], 
	r_conf_network[32][`CONF_SE_RNG], r_conf_network[31][`CONF_SE_RNG], r_conf_network[30][`CONF_SE_RNG], 
	r_conf_network[29][`CONF_SE_RNG], r_conf_network[28][`CONF_SE_RNG], r_conf_network[27][`CONF_SE_RNG], 
	r_conf_network[26][`CONF_SE_RNG], r_conf_network[25][`CONF_SE_RNG], r_conf_network[24][`CONF_SE_RNG], 
	r_conf_network[23][`CONF_SE_RNG], r_conf_network[22][`CONF_SE_RNG], r_conf_network[21][`CONF_SE_RNG], 
	r_conf_network[20][`CONF_SE_RNG], r_conf_network[19][`CONF_SE_RNG], r_conf_network[18][`CONF_SE_RNG], 
	r_conf_network[17][`CONF_SE_RNG], r_conf_network[16][`CONF_SE_RNG], r_conf_network[15][`CONF_SE_RNG], 
	r_conf_network[14][`CONF_SE_RNG], r_conf_network[13][`CONF_SE_RNG], r_conf_network[12][`CONF_SE_RNG], 
	r_conf_network[11][`CONF_SE_RNG], r_conf_network[10][`CONF_SE_RNG], r_conf_network[9][`CONF_SE_RNG], 
	r_conf_network[8][`CONF_SE_RNG], r_conf_network[7][`CONF_SE_RNG], r_conf_network[6][`CONF_SE_RNG], 
	r_conf_network[5][`CONF_SE_RNG], r_conf_network[4][`CONF_SE_RNG], r_conf_network[3][`CONF_SE_RNG], 
	r_conf_network[2][`CONF_SE_RNG], r_conf_network[1][`CONF_SE_RNG], r_conf_network[0][`CONF_SE_RNG]};
   
//////// EXTERNAL SIGNAL /////////////////////////////////////
assign o_conf_op_act_to_external  = r_conf_op_act [w_pe_adr];
assign o_conf_network_to_external = r_conf_network[w_pe_adr];
endmodule
