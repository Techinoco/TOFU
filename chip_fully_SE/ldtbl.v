`include "SMA.h"
module ldtbl (
	input clk,
	input rst_n,
	input i_exwe,
	input i_exre,
	input [`REG_W-1:0] i_func,
	input [5:0] i_exa,
	input [`DATA_W-1:0] i_exwd,
	output [`LDTBL_W-1:0] o_ldtblout,
	output [`MAP_W-1:0] o_mapout,
	output [`DATA_W-1:0] o_exrd
);

reg  [`LDTBL_W-1:0]	r_ldtbl[0:15];
reg  [`MAP_W-1:0]	r_map[0:15];

wire [3:0]			w_ldtblad;
integer i;

assign w_ldtblad = i_exre | i_exwe ? i_exa[5:2] : i_func;

always @(posedge clk) begin
	if (!rst_n)
		for (i=0; i<=15; i=i+1) begin
			r_ldtbl[i] <= `LDTBL_W'b0;
			r_map[i] <= `LDTBL_W'b0;
		end
	else if(i_exwe & i_exa[1] == 1 & i_exa[0] == 0) r_ldtbl[w_ldtblad][47:24] <= i_exwd[23:0];
	else if(i_exwe & i_exa[1] == 0 & i_exa[0] == 1) r_ldtbl[w_ldtblad][23:0] <= i_exwd[23:0];
	else if(i_exwe & i_exa[0] == 1 & i_exa[1] == 1) r_map[w_ldtblad] <= i_exwd[11:0];
end
assign o_ldtblout = r_ldtbl[w_ldtblad];
assign o_mapout = r_map[w_ldtblad];

assign o_exrd = i_exa[0] == 0 ? o_ldtblout: {12'b0,o_mapout};

endmodule
