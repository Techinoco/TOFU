`include "SMA.h"
module ifex (
	input clk,
	input rst_n,
	input i_run,
	input i_working,
	//input lock,
	output [`CPU_W-1:0] o_rd1,
	output [`CPU_W-1:0] o_rd1_st,
	//output o_ld_add_op,
	//output o_st_add_op,
	output o_ld_st_add_op,
	output o_delay_op,
	output [`REG_W-1:0] o_func,
	output [`REG_W-1:0] o_func_st,
	output o_done,
	output [`DLY-1:0] o_delay,
	output o_first_set,
	output [`DBGDAT_W-1:0] o_pc30,
	output o_running,
	//output o_mode,
	input i_exwe,
	input i_exre,
	input [`CPU_W-1:0] i_exwd,
	output [`CPU_W-1:0] o_exrd,
	input [`EXA_W-1:0] i_exa
);

reg r_run;
//reg 				run_r2;
reg  [`CPU_W-1:0]	r_rd1;       
reg  [`CPU_W-1:0]	r_rd1_st;       
reg					r_ld_add_op;              
reg					r_st_add_op;
reg					r_ld_st_add_op;
reg  [`REG_W-1:0]	r_func; 
reg  [`REG_W-1:0]	r_func_st; 
reg 				r_done;
reg  [`DLY-1:0]		r_delay;       
reg					r_first_set;
reg					r_running;                
//reg 				r_mode;                   
reg  [`INSTA_W-1:0]	r_pc;

wire [`CPU_W-1:0]	w_instr;
wire [`CPU_W-1:0]	w_inst;
wire [`REG_W-1:0]	w_opcode;
wire [`REG_W-1:0]	w_d;
wire [`REG_W-1:0]	w_s;
wire [`REG_W-1:0]	w_func;
wire [`REG_W-1:0]	w_func_st;
wire [`REG_W*2-1:0]	w_imm;
wire [`CPU_W-1:0]	w_rd1;
wire [`CPU_W-1:0]	w_rd2;
wire [`CPU_W-1:0]	w_wd3;
wire [`CPU_W-1:0]	w_rd1m1;
wire [`CPU_W-1:0]	w_sa_st_out;
wire [`CPU_W-1:0]	w_dnum_st_out;
wire [`CPU_W-1:0]	w_sa_ld_out;
wire [`CPU_W-1:0]	w_dnum_ld_out;
wire [`CPU_W-1:0]	w_sa_st_in;
wire [`CPU_W-1:0]	w_dnum_st_in;
wire [`CPU_W-1:0]	w_sa_ld_in;
wire [`CPU_W-1:0]	w_dnum_ld_in;
wire				w_rwe;
wire 				w_exwe_imem = (i_exa[`EXSEL] == `EX_IMEM) & i_exwe;
wire 				w_exre_imem = (i_exa[`EXSEL] == `EX_IMEM) & i_exre;
wire 				w_runstart;
//wire 				w_stall;
//wire				w_stall_st;
//wire				w_stall_ld;

wire add_op, sub_op, mv_op, nop_op, done_op;
wire ldi_op, addi_op, bez_op, bezd_op, bnz_op, bnzd_op;
wire ld_add_op, st_add_op ;
wire ld_st_add_op, set_ld_op, set_st_op;

assign w_instr = r_running ? w_inst : {`OP_REG,8'b0,`F_DONE} ;
assign o_exrd = w_instr;
//assign w_stall_st = 0;// !r_mode & lock & st_add_op ; 
//assign w_stall_ld = 0;// !r_mode & (lock | r_st_add_op) & ld_add_op;
//assign w_stall = w_stall_st | w_stall_ld;

assign w_opcode = w_instr[`REG_W*4-1:`REG_W*3];
assign w_d = w_instr[`REG_W*3-1:`REG_W*2];
assign w_s = w_instr[`REG_W*2-1:`REG_W];
assign w_func = w_opcode == `OP_LD_ST_ADD ? w_instr[`REG_W*2-1:`REG_W] :w_instr[`REG_W-1:0];
assign w_func_st = w_instr[`REG_W-1:0];
   // assign w_sa_ld_in = w_instr[`REG_W*2-1:`REG_W];
   // assign w_sa_st_in = w_instr[`REG_W*2-1:`REG_W];
assign w_imm = w_instr[`REG_W*2-1:0];
assign w_rd1m1 = w_rd1-1;

assign add_op = w_opcode == `OP_REG & w_func == `F_ADD;
assign sub_op = w_opcode == `OP_REG & w_func == `F_SUB;
assign mv_op = w_opcode == `OP_REG & w_func == `F_MV;
assign nop_op = w_opcode == `OP_REG & w_func == `F_NOP;
assign ldi_op = w_opcode == `OP_LDI ;
assign addi_op = w_opcode == `OP_ADDI ;
assign bez_op = w_opcode == `OP_BEZ ;
assign bezd_op = w_opcode == `OP_BEZD ;
assign bnz_op = w_opcode == `OP_BNZ ;
assign bnzd_op = w_opcode == `OP_BNZD ;
//assign ld_add_op = w_opcode == `OP_LD_ADD;
//assign st_add_op = w_opcode == `OP_ST_ADD;
assign ld_st_add_op = w_opcode ==`OP_LD_ST_ADD;
assign set_ld_op = w_opcode ==`OP_SET_LD;
assign set_st_op = w_opcode ==`OP_SET_ST;
assign done_op = w_opcode == `OP_REG & w_func == `F_DONE ;
assign w_delay_op = w_opcode == `OP_REG & w_func == `F_DELAY ;
assign o_delay_op = w_delay_op;

assign w_wd3 =
		//add_op | ld_add_op | st_add_op	? w_rd1 + w_rd2 :
		add_op				? w_rd1 + w_rd2 :
		sub_op				? w_rd1 - w_rd2 :
		mv_op				? w_rd2 :
		ldi_op				? {{8{w_imm[7]}}, w_imm} :
		addi_op				? w_rd1 + {{8{w_imm[7]}}, w_imm}:
		bezd_op | bnzd_op	? w_rd1m1 : w_rd1;

assign w_rwe = add_op | sub_op | mv_op | ldi_op | addi_op | 
			   bezd_op | bnzd_op;
			   //| ld_add_op | st_add_op;

assign w_sa_ld_in = set_ld_op ? {8'b0,w_instr[`REG_W*3-1:`REG_W]} : w_sa_ld_out + w_dnum_ld_out;
assign w_sa_st_in = set_st_op ? {8'b0,w_instr[`REG_W*3-1:`REG_W]} : w_sa_st_out + w_dnum_st_out;
assign w_dnum_ld_in = {12'b0,w_instr[`REG_W-1:0]};
assign w_dnum_st_in = {12'b0,w_instr[`REG_W-1:0]};
assign we_sa_ld = set_ld_op | ld_st_add_op;
assign we_sa_st = set_st_op | ld_st_add_op;
assign we_dnum_ld = set_ld_op;
assign we_dnum_st = set_st_op;

imem imem_1 (
	.clk			(clk),
	.rst_n			(rst_n),
	.i_a			(r_pc),
	.i_exa			(i_exa[`INSTA_W-1:0]), 
	.i_exwd			(i_exwd),
	.i_exwe			(w_exwe_imem),
	.i_exre			(w_exre_imem),
	.o_rd			(w_inst)
);

rfile rfile_1 (
	.clk			(clk),
	.rst_n			(rst_n),
	.i_a1			(w_d),
	.i_a2			(w_s),
	.i_a3			(w_d),
	.o_rd1			(w_rd1),
	.o_rd2			(w_rd2),
	.o_sa_ld_out	(w_sa_ld_out),
	.o_dnum_ld_out	(w_dnum_ld_out),
	.o_sa_st_out	(w_sa_st_out),
	.o_dnum_st_out	(w_dnum_st_out),
	.i_wd3			(w_wd3),
	.i_we3			(w_rwe),
	.i_we_sa_ld		(we_sa_ld),
	.i_we_dnum_ld	(we_dnum_ld),
	.i_we_sa_st		(we_sa_st),
	.i_we_dnum_st	(we_dnum_st),
	.i_sa_ld_in		(w_sa_ld_in),
	.i_dnum_ld_in	(w_dnum_ld_in),
	.i_sa_st_in		(w_sa_st_in),
	.i_dnum_st_in	(w_dnum_st_in)
);

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		//r_mode <= 0;
		r_delay <= 4'b1111;
	end
	else if(w_delay_op)
		r_delay <= w_d;
end
//assign o_mode = r_mode;
assign o_delay = r_delay;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) r_first_set <= 0;
	else r_first_set <= w_delay_op;
end
assign o_first_set = r_first_set;
/*
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) run_r <= 0;
	else run_r <= i_run;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) run_r2 <= 0;
	else run_r2 <= run_r;
end
   assign w_runstart  = ~run_r & run;
*/
always@(posedge clk or negedge rst_n) begin
	if(!rst_n) r_run <= 0;
	else r_run <= i_run;
end
assign w_runstart = ~r_run & i_run;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) r_done <= 0;
	else if (w_runstart) r_done <= 0;
	else if (done_op & !i_working) r_done <= 1;
end
assign o_done = r_done;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) r_running <= 0;
	else if (w_runstart) r_running <= 1;
	else if (done_op) r_running <= 0;
end
assign o_running = r_running;

always@(posedge clk or negedge rst_n) begin 
	if(!rst_n) r_pc <= 0;
	else if (w_runstart) r_pc <= 0;
	else if(r_running) begin
		if ((bez_op & |w_rd1==0) | (bezd_op & |w_rd1m1==0) |
			(bnz_op & |w_rd1==1) | (bnzd_op & |w_rd1m1==1))
			r_pc <= r_pc+1+w_imm;
		/*
		else if(!w_stall & !done_op)
			r_pc <= r_pc+1;
		*/
		else if(!done_op)
			r_pc <= r_pc+1;
	end
end
assign o_pc30 = r_pc[3:0];

/*
   always@(posedge clk or negedge rst_n) 
     begin
	if(!rst_n) 
	  r_ld_add_op <= 1'b0;
	else if(w_runstart) 
	  r_ld_add_op <= 1'b0;
	else if(!w_stall_ld )
	  r_ld_add_op <= ld_add_op;
     end
assign o_ld_add_op = r_ld_add_op;


   always@(posedge clk or negedge rst_n) 
     begin
	if(!rst_n) 
	  r_st_add_op <= 1'b0;
	else if(w_runstart) 
	  r_st_add_op <= 1'b0;
	else if(!w_stall_st)
	  r_st_add_op <= st_add_op;
     end
assign o_st_add_op = r_st_add_op;
*/

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) 
		r_ld_st_add_op <= 1'b0;
	else if(w_runstart) 
		r_ld_st_add_op <= 1'b0;
	else
		r_ld_st_add_op <= ld_st_add_op;
end
assign o_ld_st_add_op = r_ld_st_add_op;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		r_rd1 <= 0;
		r_func <= 0; 
	end
	/*
	else if(st_add_op & !w_stall_st | ld_add_op & !w_stall_ld) begin
		r_rd1 <= w_rd1;
		r_func <= w_func;
	end
	*/
	else if(ld_st_add_op) begin
		r_rd1 <= w_sa_ld_out;
		r_func <= w_func;
	end
end
assign o_rd1 = r_rd1;
assign o_func = r_func;

always@(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		r_rd1_st <= 0;
		r_func_st <= 0; 
	end
	else if(ld_st_add_op) begin
		r_rd1_st <= w_sa_st_out;
		r_func_st <= w_func_st;
	end
end
assign o_rd1_st = r_rd1_st;
assign o_func_st = r_func_st;

endmodule
