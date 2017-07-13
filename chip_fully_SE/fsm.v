`timescale 1ns/1ps

`define INIT 		16'b00000000_00000001
`define EMEM_INIT 	16'b00000000_00000010
`define EMEM_SET0 	16'b00000000_00000100
`define DMEM_INIT 	16'b00000000_00001000
`define DMEM_SET 	16'b00000000_00010000
`define IMEM_INIT 	16'b00000000_00100000
`define IMEM_SET0 	16'b00000000_01000000
`define RUN_SMA 	16'b00000000_10000000
`define READ_SMA 	16'b00000001_00000000
`define EMEM_INIT2 	16'b00000010_00000000
`define EMEM_SET1 	16'b00000100_00000000
`define EMEM_SET2 	16'b00001000_00000000
`define EMEM_SET12 	16'b00010000_00000000
`define IMEM_SET1 	16'b00100000_00000000
`define IMEM_INIT2 	16'b01000000_00000000
`define RUN_WAIT 	16'b10000000_00000000

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

module fsm (
	input CLK,
	input RST_N,
	input [5:0] GADR_TOP,
	input [5:0] DATA_TOP,
	input DONE,
	output reg [6:0] EADR,
	output reg [7:0] IADR,
	output reg [6:0] RADR,
	output reg [6:0] DADR,
	output reg [15:0] stat
);

parameter CMEM1 = 36;
  
//////// CONNECTION TO SMA ///////////////////////////////////

always @(posedge CLK or negedge RST_N) begin
	if(!RST_N) begin
		stat <= `INIT;
		EADR <= 0;
		IADR <= 0;
		RADR <= 0;
		DADR <= 0;
	end
	else begin
		case (stat)
		`INIT: begin
			EADR <= 7'b0;
			stat <= `EMEM_INIT; end
		`EMEM_INIT: begin
			stat <= `EMEM_INIT2; end
		`EMEM_INIT2: begin
			stat <= `EMEM_SET0; end
		`EMEM_SET0: 
			stat <= `EMEM_SET1;
		`EMEM_SET1: begin
			stat <= `EMEM_SET12; end
		`EMEM_SET12: begin
			EADR <= EADR+1;
			stat <= `EMEM_SET2; end
		`EMEM_SET2: begin
			if(GADR_TOP==6'b111111) begin
				DADR <= 7'b0;
				stat <= `DMEM_INIT; end 
			else stat <= `EMEM_SET0; end
		`DMEM_INIT: begin
			DADR <= DADR+1; 
			stat <= `DMEM_SET; end
		`DMEM_SET: begin
			DADR <= DADR + 1; 
			if(DATA_TOP==6'b111111) begin
				IADR <= 8'b0;
				stat <= `IMEM_INIT; end end
		`IMEM_INIT: 
			stat <= `IMEM_INIT2; 
		`IMEM_INIT2: begin
			IADR <= IADR + 1; 
			stat <= `IMEM_SET0; end
		`IMEM_SET0: stat <= `IMEM_SET1;
		`IMEM_SET1: begin
			IADR <= IADR + 1; 
			if(IADR==CMEM1) begin
				stat <= `RUN_WAIT; end 
			else stat <= `IMEM_SET0; end
		`RUN_WAIT: stat <= `RUN_SMA;
		`RUN_SMA:
			if (DONE )  begin
				RADR <= 0;
				stat <= `READ_SMA; end 
		`READ_SMA:
			RADR <= RADR + 1;
		endcase
	end
end

endmodule
