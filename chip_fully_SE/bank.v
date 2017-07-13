`include "SMA.h"
module bank (
	input clk,
	input [`DMEMA_W+2:0] i_a,
	input [`DMEMA_W+2:0] i_b,
	input [`DATA_W*12-1:0] i_wd,
	input  [`BANK_RG_RNG] i_we,
	input [`DMEMA_W+2:0] i_exa,
	input [`DATA_W-1:0] i_exwd,
	input i_exwe,
	input i_exre,
	output [`DATA_W*12-1:0] o_rd,
	output [`DATA_W-1:0] o_exrd
);

wire [`DMEMA_W-1:0] w_a0,w_a1,w_a2,w_a3,w_a4,w_a5,w_a6,w_a7,w_a8,w_a9,w_a10,w_a11;
wire [`DMEMA_W-1:0] w_aplus;
wire [`DMEMA_W-1:0] w_da0,w_da1,w_da2,w_da3,w_da4,w_da5,w_da6,w_da7,w_da8,w_da9,w_da10,w_da11;
wire [`DMEMA_W-1:0] w_b0,w_b1,w_b2,w_b3,w_b4,w_b5,w_b6,w_b7,w_b8,w_b9,w_b10,w_b11;
wire [`DMEMA_W-1:0] w_bplus;
wire [`DMEMA_W-1:0] w_db0,w_db1,w_db2,w_db3,w_db4,w_db5,w_db6,w_db7,w_db8,w_db9,w_db10,w_db11;
wire [`DATA_W-1:0] w_rd0,w_rd1,w_rd2,w_rd3,w_rd4,w_rd5,w_rd6,w_rd7,w_rd8,w_rd9,w_rd10,w_rd11;
wire [`DATA_W-1:0] w_wd0,w_wd1,w_wd2,w_wd3,w_wd4,w_wd5,w_wd6,w_wd7,w_wd8,w_wd9,w_wd10,w_wd11;
wire w_we0,w_we1,w_we2,w_we3,w_we4,w_we5,w_we6,w_we7,w_we8,w_we9,w_we10,w_we11;
wire w_ext = i_exwe | i_exre;
wire [5:0] w_aadr, w_badr, w_exadr;
wire [3:0] w_aadr_i, w_badr_i, w_exadr_i;
wire [`BANK_RG_RNG] we_sift;

div div_a (.adr(i_a), .mem_adr(w_aadr), .mem_adr_i(w_aadr_i));
div div_b (.adr(i_b), .mem_adr(w_badr), .mem_adr_i(w_badr_i));
div div_ex (.adr(i_exa), .mem_adr(w_exadr), .mem_adr_i(w_exadr_i));

dmem d0 (.i_a(w_da0), .i_b(w_db0), .o_rd(w_rd0), .i_wd(w_wd0), .i_we(w_we0), .clk(clk));
dmem d1 (.i_a(w_da1), .i_b(w_db1), .o_rd(w_rd1), .i_wd(w_wd1), .i_we(w_we1), .clk(clk));
dmem d2 (.i_a(w_da2), .i_b(w_db2), .o_rd(w_rd2), .i_wd(w_wd2), .i_we(w_we2), .clk(clk));
dmem d3 (.i_a(w_da3), .i_b(w_db3), .o_rd(w_rd3), .i_wd(w_wd3), .i_we(w_we3), .clk(clk));
dmem d4 (.i_a(w_da4), .i_b(w_db4), .o_rd(w_rd4), .i_wd(w_wd4), .i_we(w_we4), .clk(clk));
dmem d5 (.i_a(w_da5), .i_b(w_db5), .o_rd(w_rd5), .i_wd(w_wd5), .i_we(w_we5), .clk(clk));
dmem d6 (.i_a(w_da6), .i_b(w_db6), .o_rd(w_rd6), .i_wd(w_wd6), .i_we(w_we6), .clk(clk));
dmem d7 (.i_a(w_da7), .i_b(w_db7), .o_rd(w_rd7), .i_wd(w_wd7), .i_we(w_we7), .clk(clk));
dmem d8 (.i_a(w_da8), .i_b(w_db8), .o_rd(w_rd8), .i_wd(w_wd8), .i_we(w_we8), .clk(clk));
dmem d9 (.i_a(w_da9), .i_b(w_db9), .o_rd(w_rd9), .i_wd(w_wd9), .i_we(w_we9), .clk(clk));
dmem d10 (.i_a(w_da10), .i_b(w_db10), .o_rd(w_rd10), .i_wd(w_wd10), .i_we(w_we10), .clk(clk));
dmem d11 (.i_a(w_da11), .i_b(w_db11), .o_rd(w_rd11), .i_wd(w_wd11), .i_we(w_we11), .clk(clk));
// sift control	

assign o_rd = w_aadr_i == 4'b0000 ?	{w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0}:
			  w_aadr_i == 4'b0001 ?	{w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1}:
			  w_aadr_i == 4'b0010 ?	{w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2}:
			  w_aadr_i == 4'b0011 ?	{w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3}:
			  w_aadr_i == 4'b0100 ?	{w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4}:
			  w_aadr_i == 4'b0101 ?	{w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5}:
			  w_aadr_i == 4'b0110 ?	{w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7,w_rd6}:
			  w_aadr_i == 4'b0111 ?	{w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8,w_rd7}:
			  w_aadr_i == 4'b1000 ?	{w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9,w_rd8}:
			  w_aadr_i == 4'b1001 ?	{w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10,w_rd9}:
			  w_aadr_i == 4'b1010 ?	{w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11,w_rd10}:
									{w_rd10,w_rd9,w_rd8,w_rd7,w_rd6,w_rd5,w_rd4,w_rd3,w_rd2,w_rd1,w_rd0,w_rd11};

assign {w_wd11,w_wd10,w_wd9,w_wd8,w_wd7,w_wd6,w_wd5,w_wd4,w_wd3,w_wd2,w_wd1,w_wd0} =
			w_ext ? {i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd,i_exwd}:
			w_badr_i == 4'b0000 ? 
			{i_wd[299:275],i_wd[274:250],i_wd[249:225],i_wd[224:200],i_wd[199:175],i_wd[174:150],
			 i_wd[149:125],i_wd[124:100],i_wd[99:75],  i_wd[74:50],  i_wd[49:25],  i_wd[24:0]}:
			w_badr_i == 4'b0001 ?
			{i_wd[274:250],i_wd[249:225],i_wd[224:200],i_wd[199:175], i_wd[174:150],i_wd[149:125],
			 i_wd[124:100],i_wd[99:75],  i_wd[74:50],  i_wd[49:25],   i_wd[24:0],   i_wd[299:275]}:			  			  
			w_badr_i == 4'b0010 ?
			{i_wd[249:225],i_wd[224:200],i_wd[199:175],i_wd[174:150], i_wd[149:125],i_wd[124:100],
			 i_wd[99:75],  i_wd[74:50],  i_wd[49:25],  i_wd[24:0],    i_wd[299:275],i_wd[274:250]}:
			w_badr_i == 4'b0011 ?
			{i_wd[224:200],i_wd[199:175],i_wd[174:150], i_wd[149:125],i_wd[124:100],i_wd[99:75],  
			 i_wd[74:50],  i_wd[49:25],  i_wd[24:0],    i_wd[299:275],i_wd[274:250],i_wd[249:225]}:			  			  
			w_badr_i == 4'b0100 ?
			{i_wd[199:175],i_wd[174:150], i_wd[149:125],i_wd[124:100],i_wd[99:75],  i_wd[74:50],
			 i_wd[49:25],  i_wd[24:0],    i_wd[299:275],i_wd[274:250],i_wd[249:225],i_wd[224:200]}:
			w_badr_i == 4'b0101 ?
			{i_wd[174:150], i_wd[149:125],i_wd[124:100],i_wd[99:75],  i_wd[74:50],  i_wd[49:25],
			 i_wd[24:0],    i_wd[299:275],i_wd[274:250],i_wd[249:225],i_wd[224:200],i_wd[199:175]}:			  
			w_badr_i == 4'b0110 ?
			{i_wd[149:125],i_wd[124:100],i_wd[99:75],  i_wd[74:50],  i_wd[49:25],  i_wd[24:0],
			 i_wd[299:275],i_wd[274:250],i_wd[249:225],i_wd[224:200],i_wd[199:175],i_wd[174:150]}:
			w_badr_i == 4'b0111 ?
			{i_wd[124:100],i_wd[99:75],  i_wd[74:50],  i_wd[49:25],  i_wd[24:0],   i_wd[299:275],
			 i_wd[149:125],i_wd[274:250],i_wd[249:225],i_wd[224:200],i_wd[199:175],i_wd[174:150]}:
			w_badr_i == 4'b1000 ?
			{i_wd[99:75],  i_wd[74:50],  i_wd[49:25],  i_wd[24:0],   i_wd[299:275],i_wd[274:250],
			 i_wd[149:125],i_wd[124:100],i_wd[249:225],i_wd[224:200],i_wd[199:175],i_wd[174:150]}:
			w_badr_i == 4'b1001 ?
			{i_wd[74:50],  i_wd[49:25],  i_wd[24:0],   i_wd[299:275],i_wd[274:250],i_wd[249:225],
			 i_wd[224:200],i_wd[199:175],i_wd[174:150],i_wd[149:125],i_wd[124:100],i_wd[99:75]}:
			w_badr_i == 4'b1010 ?
			{i_wd[49:25],  i_wd[24:0],   i_wd[299:275],i_wd[274:250],i_wd[249:225],i_wd[224:200],
			 i_wd[199:175],i_wd[174:150],i_wd[149:125],i_wd[124:100],i_wd[99:75],  i_wd[74:50] }:
			{i_wd[24:0],   i_wd[299:275],i_wd[274:250],i_wd[249:225],i_wd[224:200],i_wd[199:175],
			 i_wd[174:150],i_wd[149:125],i_wd[124:100],i_wd[99:75],  i_wd[74:50],  i_wd[49:25]}; 

assign we_sift = (i_we << w_badr_i) + (i_we >> (12 - w_badr_i));

// sift control END
	
assign w_we0	= w_ext & w_exadr_i == 4'b0000 ? i_exwe : we_sift[0];
assign w_we1	= w_ext & w_exadr_i == 4'b0001 ? i_exwe : we_sift[1];
assign w_we2	= w_ext & w_exadr_i == 4'b0010 ? i_exwe : we_sift[2];
assign w_we3	= w_ext & w_exadr_i == 4'b0011 ? i_exwe : we_sift[3];
assign w_we4	= w_ext & w_exadr_i == 4'b0100 ? i_exwe : we_sift[4];
assign w_we5	= w_ext & w_exadr_i == 4'b0101 ? i_exwe : we_sift[5];
assign w_we6	= w_ext & w_exadr_i == 4'b0110 ? i_exwe : we_sift[6];
assign w_we7	= w_ext & w_exadr_i == 4'b0111 ? i_exwe : we_sift[7];
assign w_we8	= w_ext & w_exadr_i == 4'b1000 ? i_exwe : we_sift[8];
assign w_we9	= w_ext & w_exadr_i == 4'b1001 ? i_exwe : we_sift[9];
assign w_we10	= w_ext & w_exadr_i == 4'b1010 ? i_exwe : we_sift[10];
assign w_we11	= w_ext & w_exadr_i == 4'b1011 ? i_exwe : we_sift[11];
	
assign o_exrd = w_exadr_i == 4'b0000 ? w_rd0:
			  w_exadr_i == 4'b0001 ? w_rd1:
			  w_exadr_i == 4'b0010 ? w_rd2:
			  w_exadr_i == 4'b0011 ? w_rd3:
			  w_exadr_i == 4'b0100 ? w_rd4:
			  w_exadr_i == 4'b0101 ? w_rd5:
			  w_exadr_i == 4'b0110 ? w_rd6:
			  w_exadr_i == 4'b0111 ? w_rd7:
			  w_exadr_i == 4'b1000 ? w_rd8:
			  w_exadr_i == 4'b1001 ? w_rd9:
			  w_exadr_i == 4'b1010 ? w_rd10: w_rd11;

assign w_aplus = w_aadr + 1;
assign w_a0  = w_aadr_i < 4'b0001 ? w_aadr : w_aplus;
assign w_a1  = w_aadr_i < 4'b0010 ? w_aadr : w_aplus;
assign w_a2  = w_aadr_i < 4'b0011 ? w_aadr : w_aplus;
assign w_a3  = w_aadr_i < 4'b0100 ? w_aadr : w_aplus;
assign w_a4  = w_aadr_i < 4'b0101 ? w_aadr : w_aplus;
assign w_a5  = w_aadr_i < 4'b0110 ? w_aadr : w_aplus;
assign w_a6  = w_aadr_i < 4'b0111 ? w_aadr : w_aplus;
assign w_a7  = w_aadr_i < 4'b1000 ? w_aadr : w_aplus;
assign w_a8  = w_aadr_i < 4'b1001 ? w_aadr : w_aplus;
assign w_a9  = w_aadr_i < 4'b1010 ? w_aadr : w_aplus;
assign w_a10 = w_aadr_i < 4'b1011 ? w_aadr : w_aplus;
assign w_a11 = w_aadr;

assign w_bplus = w_badr + 1;
assign w_b0  = w_badr_i < 4'b0001 ? w_badr : w_bplus;
assign w_b1  = w_badr_i < 4'b0010 ? w_badr : w_bplus;
assign w_b2  = w_badr_i < 4'b0011 ? w_badr : w_bplus;
assign w_b3  = w_badr_i < 4'b0100 ? w_badr : w_bplus;
assign w_b4  = w_badr_i < 4'b0101 ? w_badr : w_bplus;
assign w_b5  = w_badr_i < 4'b0110 ? w_badr : w_bplus;
assign w_b6  = w_badr_i < 4'b0111 ? w_badr : w_bplus;
assign w_b7  = w_badr_i < 4'b1000 ? w_badr : w_bplus;
assign w_b8  = w_badr_i < 4'b1001 ? w_badr : w_bplus;
assign w_b9	 = w_badr_i < 4'b1010 ? w_badr : w_bplus;
assign w_b10 = w_badr_i < 4'b1011 ? w_badr : w_bplus;
assign w_b11 = w_badr;

assign w_da0 = w_ext ? w_exadr : w_a0 ;
assign w_da1 = w_ext ? w_exadr : w_a1 ;
assign w_da2 = w_ext ? w_exadr : w_a2 ;
assign w_da3 = w_ext ? w_exadr : w_a3 ;
assign w_da4 = w_ext ? w_exadr : w_a4 ;
assign w_da5 = w_ext ? w_exadr : w_a5 ;
assign w_da6 = w_ext ? w_exadr : w_a6 ;
assign w_da7 = w_ext ? w_exadr : w_a7 ;
assign w_da8 = w_ext ? w_exadr : w_a8 ;
assign w_da9 = w_ext ? w_exadr : w_a9 ;
assign w_da10 = w_ext ? w_exadr : w_a10 ;
assign w_da11 = w_ext ? w_exadr : w_a11 ;

assign w_db0 = w_ext ? w_exadr : w_b0 ;
assign w_db1 = w_ext ? w_exadr : w_b1 ;
assign w_db2 = w_ext ? w_exadr : w_b2 ;
assign w_db3 = w_ext ? w_exadr : w_b3 ;
assign w_db4 = w_ext ? w_exadr : w_b4 ;
assign w_db5 = w_ext ? w_exadr : w_b5 ;
assign w_db6 = w_ext ? w_exadr : w_b6 ;
assign w_db7 = w_ext ? w_exadr : w_b7 ;
assign w_db8 = w_ext ? w_exadr : w_b8 ;
assign w_db9 = w_ext ? w_exadr : w_b9 ;
assign w_db10 = w_ext ? w_exadr : w_b10 ;
assign w_db11 = w_ext ? w_exadr : w_b11 ;

endmodule
