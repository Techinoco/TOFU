`include "SMA.h"
module stadd (
	input					clk,
	input					rst_n,
	//input					i_st_add_op,  // H with 1 clock
	input					i_ld_st_add_op,
	input					i_first_set,    // First set becomes 1 after the delay instruction
	output 					o_working,
	//output lock,
	//input  [`REG_W-1:0]		i_func,
	input  [`REG_W-1:0]		i_func_st,
	input  [`DLY-1:0]		i_delay,
	//input  [`CPU_W-1:0]		i_rd1,
	input  [`CPU_W-1:0]		i_rd1_st,
	//input					i_mode,
	input  [`DATA_W*12-1:0]	i_fpearray,
	output [`DATA_W*12-1:0]	o_todmem,
	output [`CPU_W-1:0]		o_rdst,
	output [`MAP_W-1:0]		o_dmemwe,
	input					i_exwe,
	input					i_exre,
	input  [`DATA_W-1:0]	i_exwd,
	output [`DATA_W-1:0]	o_exrd,
	input  [`EXA_W-1:0]		i_exa
);

reg 					r_working;
reg [`CPU_W-1:0]		r_rdst;
//reg [`DLY-1:0] 			r_first;
//reg 					r_dmode;              // r_first counter decrement
reg 					r_memwe;
reg [`REG_W-1:0]		r_tblad;
reg [`DATA_W*12-1:0]	r_gather;
reg [`REG_W+`CPU_W:0] 	pr0, pr1, pr2, pr3, pr4, pr5, pr6, pr7;
reg [`REG_W+`CPU_W:0]   pr8, pr9, pr10, pr11, pr12, pr13, pr14, pr15;
wire [`MAP_W-1:0] 		w_map;
wire					w_exre_sttbl;
wire					w_exwe_sttbl;
wire [`LDTBL_W-1:0]		w_sttblout;
wire 					w_flag_1;
//wire					w_flag_2;
wire [`REG_W-1:0]		w_func_1;
//wire [`REG_W-1:0]		w_func_2;
wire [`CPU_W-1:0]		w_rd1_1;
//wire [`CPU_W-1:0]		w_rd1_2;

ldtbl sttbl_1(
	.clk		(clk),
	.rst_n		(rst_n),
	.i_exwe		(w_exwe_sttbl),
	.i_exre		(w_exre_sttbl),
	.i_func		(r_tblad),
	.i_exa		(i_exa[5:0]),
	.i_exwd		(i_exwd),
	.o_ldtblout	(w_sttblout),
	.o_mapout	(w_map),
	.o_exrd		(o_exrd)
);

dmanu8 dmanu8_st(
	.i_indata	(r_gather),
	.o_outdata	(o_todmem),
	.i_seltbl	(w_sttblout)
);

assign w_exre_sttbl = i_exre & (i_exa[`EXSEL] == `EX_STBL);
assign w_exwe_sttbl = i_exwe & (i_exa[`EXSEL] == `EX_STBL);
//assign diff = r_gather != i_fpearray;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) pr0 <= 0;
	else begin
		//if(i_st_add_op) pr0 <= {1'b1,i_func,i_rd1};
		if (i_ld_st_add_op) pr0 <= {1'b1, i_func_st, i_rd1_st};
		else pr0 <= 0;
		case(i_delay)
		0: begin	pr1 <= 0;   pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		1: begin	pr1 <= pr0; pr2 <= 0  ; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		2: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= 0  ; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		3: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= 0   ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		4: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= 0   ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		5: begin 	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= 0   ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		6: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= 0   ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		7: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= 0  ; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		8: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= 0  ; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		9: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= 0  ; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		10: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= 0   ; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		11: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= 0   ; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		12: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= 0   ; pr14 <= pr13; pr15 <= pr14; end
		13: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= 0   ; pr15 <= pr14; end
		14: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= 0   ; end
		15: begin	pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		default: 
		begin 		pr1 <= pr0; pr2 <= pr1; pr3  <= pr2; pr4  <= pr3 ; pr5  <= pr4 ; pr6  <= pr5 ; pr7  <= pr6 ;
					pr8 <= pr7; pr9 <= pr8; pr10 <= pr9; pr11 <= pr10; pr12 <= pr11; pr13 <= pr12; pr14 <= pr13; pr15 <= pr14; end
		endcase
	end
end
/*
assign {w_flag_1, w_func_1, w_rd1_1} = 
	r_first == 0 ? pr0 :
	r_first == 1 ? pr1 :
	r_first == 2 ? pr2 :
	r_first == 3 ? pr3 :
	r_first == 4 ? pr4 :
	r_first == 5 ? pr5 :
	r_first == 6 ? pr6 :
	r_first == 7 ? pr7 :
	r_first == 8 ? pr8 :
	r_first == 9 ? pr9 :
	r_first == 10 ? pr10 :
	r_first == 11 ? pr11 :
	r_first == 12 ? pr12 :
	r_first == 13 ? pr13 :
	r_first == 14 ? pr14 : pr15;

assign {w_flag_2, w_func_2, w_rd1_2} =
	i_delay == 0 ? pr0 :
	i_delay == 1 ? pr1 :
	i_delay == 2 ? pr2 :
	i_delay == 3 ? pr3 :
	i_delay == 4 ? pr4 :
	i_delay == 5 ? pr5 :
	i_delay == 6 ? pr6 :
	i_delay == 7 ? pr7 :
	i_delay == 8 ? pr8 :
	i_delay == 9 ? pr9 :
	i_delay == 10 ? pr10 :
	i_delay == 11 ? pr11 :
	i_delay == 12 ? pr12 :
	i_delay == 13 ? pr13 :
	i_delay == 14 ? pr14 : pr15;
 */
assign {w_flag_1, w_func_1, w_rd1_1} =
	i_delay == 0 ? pr0 :
	i_delay == 1 ? pr1 :
	i_delay == 2 ? pr2 :
	i_delay == 3 ? pr3 :
	i_delay == 4 ? pr4 :
	i_delay == 5 ? pr5 :
	i_delay == 6 ? pr6 :
	i_delay == 7 ? pr7 :
	i_delay == 8 ? pr8 :
	i_delay == 9 ? pr9 :
	i_delay == 10 ? pr10 :
	i_delay == 11 ? pr11 :
	i_delay == 12 ? pr12 :
	i_delay == 13 ? pr13 :
	i_delay == 14 ? pr14 : pr15;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		r_working <= 0;
	else
		r_working <= pr0 [`REG_W+`CPU_W] | pr1 [`REG_W+`CPU_W] | pr2 [`REG_W+`CPU_W] | pr3 [`REG_W+`CPU_W] | 
					 pr4 [`REG_W+`CPU_W] | pr5 [`REG_W+`CPU_W] | pr6 [`REG_W+`CPU_W] | pr7 [`REG_W+`CPU_W] |
					 pr8 [`REG_W+`CPU_W] | pr9 [`REG_W+`CPU_W] | pr10[`REG_W+`CPU_W] | pr11[`REG_W+`CPU_W] |
					 pr12[`REG_W+`CPU_W] | pr13[`REG_W+`CPU_W] | pr14[`REG_W+`CPU_W] | pr15[`REG_W+`CPU_W];
	end
assign o_working = r_working;
/*
assign lock = r_first == 0 ? pr0[`REG_W+`CPU_W] :
			  r_first == 1 ? pr0[`REG_W+`CPU_W] | pr1[`REG_W+`CPU_W] :
			  r_first == 2 ? pr0[`REG_W+`CPU_W] | pr1[`REG_W+`CPU_W] | pr2[`REG_W+`CPU_W] :
			  r_first == 3 ? pr0[`REG_W+`CPU_W] | pr1[`REG_W+`CPU_W] | pr2[`REG_W+`CPU_W] | pr3[`REG_W+`CPU_W] : 
			  r_first == 4 ? pr0[`REG_W+`CPU_W] | pr1[`REG_W+`CPU_W] | pr2[`REG_W+`CPU_W] | pr3[`REG_W+`CPU_W] | pr4[`REG_W+`CPU_W] :
			  r_first == 5 ? pr0[`REG_W+`CPU_W] | pr1[`REG_W+`CPU_W] | pr2[`REG_W+`CPU_W] | pr3[`REG_W+`CPU_W] | pr4[`REG_W+`CPU_W] | pr5[`REG_W+`CPU_W] :
			  r_first == 6 ? pr0[`REG_W+`CPU_W] | pr1[`REG_W+`CPU_W] | pr2[`REG_W+`CPU_W] | pr3[`REG_W+`CPU_W] | pr4[`REG_W+`CPU_W] | pr5[`REG_W+`CPU_W] | pr6[`REG_W+`CPU_W] :r_working;
*/
always @(posedge clk or negedge rst_n) begin
	if(!rst_n) r_memwe <= 1'b0;
	//else if(w_flag_1 & !i_mode) r_memwe <= 1'b1;
	else if(w_flag_1) r_memwe <= 1'b1;
	//else if(w_flag_2) r_memwe <= diff | i_mode;
	//else if(w_flag_2) r_memwe <= diff;
	else r_memwe <= 1'b0;
end
assign o_dmemwe = {r_memwe&w_map[11], r_memwe&w_map[10], r_memwe&w_map[9], r_memwe&w_map[8],
				   r_memwe&w_map[7] , r_memwe&w_map[6] , r_memwe&w_map[5], r_memwe&w_map[4],
				   r_memwe&w_map[3] , r_memwe&w_map[2] , r_memwe&w_map[1], r_memwe&w_map[0]};

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) r_rdst <= 0;
	//else  if(w_flag_1 & !i_mode) r_rdst <= w_rd1_1; 
	//else  if(w_flag_2 & (diff|i_mode) ) r_rdst <= w_rd1_2; 
	else  if(w_flag_1) r_rdst <= w_rd1_1; 
	//else  if(w_flag_2 & diff) r_rdst <= w_rd1_2; 
end
assign o_rdst = r_rdst;

always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) r_gather <= 0;
	//else if(w_flag_1 & !i_mode) r_gather <= i_fpearray;
	//else if(w_flag_2 & (diff|i_mode) ) r_gather <= i_fpearray;
	else if(w_flag_1) r_gather <= i_fpearray;
	//else if(w_flag_2 & diff) r_gather <= i_fpearray;
end

always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) r_tblad <= 0;
	//else if(w_flag_1 & !i_mode) r_tblad <= w_func_1;
	//else if(w_flag_2 & (diff|i_mode) ) r_tblad <= w_func_2;
	else if(w_flag_1) r_tblad <= w_func_1;
	//else if(w_flag_2 & diff) r_tblad <= w_func_2;
end

//always @(posedge clk or negedge rst_n ) begin
//	if(!rst_n) r_first <= 0;
//	else if(i_first_set) r_first <= i_delay;
//	   else if( w_flag_2 & !diff & (r_first >= i_delay>>1) & (r_first > 2) & r_dmode) r_first <= r_first -1;
// else if(!mode & w_flag_2 & !diff & (r_first >= i_delay>>1) & r_dmode) r_first <= r_first -1;
// else if(!mode & w_flag_2 & diff & r_first < i_delay) r_first <= r_first+1;
//end
/*
always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) r_dmode <= 0;
	else if(i_first_set) r_dmode <= 1;
	//else if(!i_mode & w_flag_2 & diff) r_dmode <= 0;
	else if(w_flag_2 & diff) r_dmode <= 0;
end
*/
endmodule
