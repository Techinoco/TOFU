`include "./SMA.h"
`timescale 1ns/1ps

`define INIT 		16'b0000000000000001
`define EMEM_INIT 	16'b0000000000000010
`define EMEM_SET0 	16'b0000000000000100
`define DMEM_INIT 	16'b0000000000001000
`define DMEM_SET 	16'b0000000000010000
`define IMEM_INIT 	16'b0000000000100000
`define IMEM_SET0 	16'b0000000001000000
`define RUN_SMA 	16'b0000000010000000
`define READ_SMA 	16'b0000000100000000
`define EMEM_INIT2 	16'b0000001000000000
`define EMEM_SET1 	16'b0000010000000000
`define EMEM_SET2 	16'b0000100000000000
`define EMEM_SET12 	16'b0001000000000000
`define IMEM_SET1 	16'b0010000000000000
`define IMEM_INIT2 	16'b0100000000000000
`define RUN_WAIT 	16'b1000000000000000

`define EMEM_INIT_BIT 	4'b0001
`define EMEM_SET0_BIT 	4'b0010
`define DMEM_INIT_BIT 	4'b0011
`define DMEM_SET_BIT 	4'b0100
`define IMEM_INIT_BIT 	4'b0101
`define IMEM_SET0_BIT 	4'b0110
`define RUN_SMA_BIT 	4'b0111
`define READ_SMA_BIT 	4'b1000
`define EMEM_SET1_BIT 	4'b1010
`define EMEM_SET2_BIT 	4'b1011
`define EMEM_SET12_BIT 	4'b1100
`define IMEM_SET1_BIT 	4'b1101
`define RUN_WAIT_BIT 	4'b1111

module FPGA_CMA (
  input    CLK,
  input RST_N,
  output RUN,
  output BANK_SEL,
  output RE_FROM_EXTERNAL, 
  output WE_FROM_EXTERNAL,
  output [`ROMULTIC_B] ROMULTIC_BITS_FROM_EXTERNAL,
  output [`GLB_ADR_B] GLB_ADR_FROM_EXTERNAL,
  output [`GLB_DATA_B] DATA_FROM_EXTERNAL,
  input [`GLB_DATA_B] DATA_TO_EXTERNAL,
  input  DONE);
  
  //////// CONNECTION TO SMA ///////////////////////////////////
  wire [36:0] DATA_IN;
  reg [36:0] DATA_R;
  wire [15:0] INST_IN;
  reg [23:0] INST_R;
  wire [46:0] EMEM_IN;
  reg [46:0] EMEM_R;
  wire [5:0] GADR_TOP;
  wire [5:0] GADR_BOTTOM;
  wire [6:0] PAD7;
  wire [11:0] CONST;
  wire [6:0] DADR;
  wire [7:0] IADR;
  wire [6:0] EADR;
  wire [6:0] RADR;
  wire [15:0] stat;
 parameter CMEM1= 35; // Sepialoop
// parameter CMEM1= 41; // DCT
// parameter CMEM1= 23; // Sepia
// parameter CMEM1= 27; // Alpha

  //assign #3 WE_FROM_EXTERNAL = stat[`EMEM_SET12_BIT] | (stat[`DMEM_SET_BIT] & DADR != 1) | stat[`IMEM_SET0_BIT] ;
  assign WE_FROM_EXTERNAL = stat[`EMEM_SET12_BIT] | (stat[`DMEM_SET_BIT] & DADR != 1) | stat[`IMEM_SET0_BIT] ;
  assign RE_FROM_EXTERNAL = stat[`READ_SMA_BIT] ;
  assign ROMULTIC_BITS_FROM_EXTERNAL = EMEM_R[19:0] ;//
  assign  DMEM_BP = `DISABLE;
  assign  LS_BP  = `DISABLE;
  assign RUN = stat[`RUN_SMA_BIT]|stat[`RUN_WAIT_BIT] ;
//  assign BANK_SEL = ~(stat[`RUN_SMA_BIT]|stat[`RUN_WAIT_BIT]) ;
  assign BANK_SEL = ~stat[`RUN_SMA_BIT];

assign {GADR_TOP,GADR_BOTTOM,PAD7,CONST} = EMEM_IN[46:16];
ex_mem EX_MEM0(.clk(CLK), .addr(EADR), .q(EMEM_IN));
d_mem D_MEM0(.clk(CLK), .addr(DADR), .q(DATA_IN));
i_mem I_MEM0(.clk(CLK), .addr(IADR), .q(INST_IN));

wire [7:0] IADR1 ;
assign IADR1 = IADR - 6'b000001;
wire ememset,imemset;
assign ememset = stat[`EMEM_SET0_BIT] | 
			stat[`EMEM_SET1_BIT] | stat[`EMEM_SET2_BIT]  
			| stat[`EMEM_SET12_BIT] ; 
assign imemset = stat[`IMEM_SET0_BIT] | stat[`IMEM_SET1_BIT];

assign DATA_FROM_EXTERNAL =
	ememset ?
		(EMEM_R[46:41] == 6'b100010 ? {2'b0, EMEM_R[40:18]}:
		 EMEM_R[46:41] == 6'b101000 ? {1'b0, EMEM_R[33:14]}:
		 EMEM_R[46:41] == 6'b101001 ? {1'b0, EMEM_R[33:14]}:
		 							  {4'b0, EMEM_R[40:20]}) : //
	stat[`DMEM_SET_BIT] ? DATA_R[24:0] :
						  {1'b0,INST_R};

assign GLB_ADR_FROM_EXTERNAL = ememset ? EMEM_R[46:35]: 
				stat[`DMEM_SET_BIT] ? DATA_R[36:25]:
				imemset ? {4'b0010,IADR1}:
				stat[`RUN_SMA_BIT] ? 12'h880: 
					{5'b00000,RADR};

  
//////// INSTANTIATION ///////////////////////////////////////
  
  always @(posedge CLK) begin
	EMEM_R <= EMEM_IN;
	DATA_R <= DATA_IN;
	INST_R <= {8'b0,INST_IN}; end

	fsm fsm0 (
	.CLK(CLK),
	.RST_N(RST_N),
	.GADR_TOP(GADR_TOP),
	.DATA_TOP(DATA_IN[36:31]),
	.DONE(DONE),
	.EADR(EADR),
	.DADR(DADR),
	.IADR(IADR),
	.RADR(RADR),
	.stat(stat) );

endmodule
