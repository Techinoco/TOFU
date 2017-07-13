`include "SMA.h"

module cma (
    input  clk, rst_n, cbank, run,
    input  exwe, exre,
    input  [`DATA_W-1:0    ] exwd,
    input  [`ROMULTIC_W-1:0] exromul,
    input  [`GLB_ADR_W-1:0 ] exa,
    input  [`DBGSEL_W-1:0  ] dbgsel,

    output [`DATA_W-1:0    ] exrd,
    output [`DBGDAT_W-1:0  ] dbgdat,
    output done
);

wire [`DATA_12_B] fpearray, topearray;
wire [`ACTIVE_BIT_96_W-1:0] CONF_ALU;
wire [`CONF_SEL_96_W-1:0] CONF_SEL_A;
wire [`CONF_SEL_96_W-1:0] CONF_SEL_B;
wire [`CONF_SE_96_W-1:0]  CONF_SE;
wire [`CONST_DATA_8_W-1:0] CONST_DATA_A;
wire [`CONST_DATA_8_W-1:0] CONST_DATA_B;
// reg [`DATA_12_B] d1, d2, d3;

mc mc1(
    .clk (clk), .rst_n(rst_n), .cbank(cbank), .run(run),
    .topearray     (topearray),
    .fpearray      (fpearray),// swoped d3
    .CONF_ALU      (CONF_ALU),
    .CONF_SEL_A    (CONF_SEL_A),
    .CONF_SEL_B    (CONF_SEL_B),
    .CONF_SE       (CONF_SE),
    .CONST_DATA_A  (CONST_DATA_A),
    .CONST_DATA_B  (CONST_DATA_B),
    .done          (done),
    .exwe          (exwe), 
    .exre          (exre),
    .exwd          (exwd),
    .exrd          (exrd),
    .exromul       (exromul),
    .exa           (exa),
    .dbgsel        (dbgsel),
    .dbgdat        (dbgdat)
);

// mc mc1(
//     .CLK (clk), .RST_N(rst_n), .CBANK(cbank), .RUN(run),
//     .TOPEARRAY     (topearray),
//     .FPEARRAY      (fpearray),// swoped d3
//     .CONF_ALU      (CONF_ALU),
//     .CONF_SEL_A    (CONF_SEL_A),
//     .CONF_SEL_B    (CONF_SEL_B),
//     .CONF_SE       (CONF_SE),
//     .CONST_DATA_A  (CONST_DATA_A),
//     .CONST_DATA_B  (CONST_DATA_B),
//     .DONE          (done),
//     .EXWE          (exwe), 
//     .EXRE          (exre),
//     .EXWD          (exwd),
//     .EXRD          (exrd),
//     .EXROMUL       (exromul),
//     .EXA           (exa),
//     .DBGSEL        (dbgsel),
//     .DBGDAT        (dbgdat)
// );
   
PE_ARRAY PE_ARRAY1 (
    .CLK           (clk),
    .RST_N         (rst_n),
    .CONF_ALU      (CONF_ALU),
    .CONF_SEL_A    (CONF_SEL_A),
    .CONF_SEL_B    (CONF_SEL_B),
    .CONF_SE       (CONF_SE),
    .IN_SOUTH      (topearray),
    .IN_CONST_A    (CONST_DATA_A),
    .IN_CONST_B    (CONST_DATA_B),
    .OUT_SOUTH     (fpearray)
);

// always @(posedge clk) begin
// 	d1 <= fpearray;
// 	d2 <= d1;
// 	d3 <= d2;
// end

endmodule

