`include "SMA.h"
module acquire (
input clk, rst_n,
input first_ac, 
input [`REG_W-1:0] func_s,
input [`REG_W-1:0] delay_r,
input [`CPU_W-1:0] rd1_s,
input [`DATA_W*8-1:0] fpearray,
output reg [`REG_W-1:0] diff,
output [`DATA_W*8-1:0] todmem,
output [`MAP_W-1:0] dmemwe,
output reg [`CPU_W-1:0] rdst,
output [`DBGDAT_W-1:0] stdbg,
input exwe,exre,
input [`LDTBL_W-1:0] exwd,
output [`LDTBL_W-1:0] exrd,
input [`EXA_W-1:0] exa);

reg [`DATA_W*8-1:0] gather_r;
reg [`REG_W-1:0] count;
wire [`LDTBL_W-1:0] sttblout;
wire [`MAP_W-1:0] map;
reg [`REG_W-1:0] tblad;
reg spec_mode;
wire exre_sttbl, exwe_sttbl;
wire memwe; 
wire fail, sacc;
reg working;
assign memwe = first_ac | fail;

assign stdbg = {fail, 1'b0, spec_mode, memwe};
assign dmemwe = {memwe&map[7],memwe&map[6],memwe&map[5],memwe&map[4],
				memwe&map[3],memwe&map[2],memwe&map[1],memwe&map[0]};
assign fail = (fpearray != gather_r)& (count == delay_r & working);
assign sacc = (fpearray == gather_r)& (count == delay_r & working);

assign exre_sttbl = exre & (exa[`EXSEL] == `EX_STBL);
assign exwe_sttbl = exwe & (exa[`EXSEL] == `EX_STBL);

ldtbl sttbl_1(.clk(clk), .exwe(exwe_sttbl), .exre(exre_sttbl),
	.func(tblad), .exa(exa[4:0]), .exwd(exwd), .exrd(exrd),
	    .ldtblout(sttblout), .mapout(map) );

dmanu8 dmanu8_st(.indata(gather_r), .outdata(todmem), .seltbl(sttblout) );

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) working <= 0;
	else if (first_ac) working <= 1;
	else if (count == delay_r ) working <= 0;
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) count <= 0;
	else if (first_ac) count <= delay_r - diff;
	else if ((count != delay_r) & working ) count <= count + 1 ;
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) diff <= 1;
	else if (fail & diff > 1) diff <= diff - 1;
	else if (sacc & diff < delay_r>1 -1) diff <= diff+1;
end

always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) gather_r <= 0;
	else begin
		if(first_ac) gather_r <= fpearray; //1st Acquire
		else if(fail) gather_r <= fpearray; //2nd Acquire
	end
end

always @(posedge clk or negedge rst_n )  begin
	if(!rst_n) rdst <= 0;
	else if( first_ac) rdst <= rd1_s; 
end

always @(posedge clk or negedge rst_n ) begin
	if(!rst_n) tblad <= 0;
	else if(first_ac) tblad <= func_s; 
end

endmodule
