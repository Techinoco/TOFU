`include "./SMA.h"


module CONST_CTRL (
	input                     clk,
	input                     rst_n,

	// CONNECTION TO EXTERNAL
	input                     i_we_from_external,
	input  [`GLB_ADR_B      ] i_glb_adr_from_external,
	input  [`CONST_DATA_B   ] i_const_data_from_external,
	output [`CONST_DATA_B   ] o_const_data_to_external,

	// CONNECTION TO PE ARRAY
	output [`CONST_DATA_8_B]  o_const_data_a,
	output [`CONST_DATA_8_B]  o_const_data_b
//   output [`CONST_DATA_8_B] CONST_DATA_TO_PE_ARRAY_SOUTH,
//   output [`CONST_DATA_4_B] CONST_DATA_TO_PE_ARRAY_EAST,
//   output [`CONST_DATA_4_B] CONST_DATA_TO_PE_ARRAY_WEST
);
  
  
//////// REGISTER AND WIRE DECLARATION ///////////////////////
integer i;

wire [`CONST_REG_ADR_B] w_const_reg_adr;
wire [`CONST_DATA_B   ] w_const_data_in;
reg  [`CONST_DATA_B   ] r_const_reg[`CONST_REG_ENTRY_RNG];


//////// CONSTANT DATA CONTROL ///////////////////////////////
assign w_const_reg_adr = i_glb_adr_from_external[`CONST_REG_ADR_B];
assign w_const_data_in = i_const_data_from_external[`CONST_DATA_B];

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i = 0; i < `CONST_REG_ENTRY; i = i + 1)
			r_const_reg[i] <= `CONST_DATA_W'd0;
	end
	else begin
		if (i_we_from_external & (i_glb_adr_from_external[`GLB_ADR_HEAD_RNG] == `GLB_ADR_HEAD_CONST))
			r_const_reg[w_const_reg_adr] <= w_const_data_in;
	end
end
  
  
//////// CONNECTION TO PE ARRAY //////////////////////////////
assign o_const_data_b = {r_const_reg[15], r_const_reg[14], r_const_reg[13], r_const_reg[12],
					   r_const_reg[11], r_const_reg[10], r_const_reg[09], r_const_reg[08]};
assign o_const_data_a = {r_const_reg[07], r_const_reg[06], r_const_reg[05], r_const_reg[04],
					   r_const_reg[03], r_const_reg[02], r_const_reg[01], r_const_reg[00]};  

//////// EXTERNAL SIGNAL /////////////////////////////////////
assign o_const_data_to_external = r_const_reg[w_const_reg_adr];
  
endmodule
