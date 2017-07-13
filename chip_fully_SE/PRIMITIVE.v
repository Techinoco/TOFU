`include "./SMA.h"


module ADD (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  input  [`CARRY_B] IN_C_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign {OUT_C, OUT}   = {IN_C_A,IN_A} + {IN_C_B,IN_B};
endmodule

module SUB (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  input  [`CARRY_B] IN_C_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  
  wire [`DATA_B      ] SRC_B;
  wire [`CARRY_B     ] CARRY_BIT;
  
  assign SRC_B        = ~{IN_C_B,IN_B};
  assign {OUT_C, OUT} = {IN_C_A,IN_A} + SRC_B + {`WORD_MSB'd0,`CARRY_W'd1};
endmodule


module MULT (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  input  [`CARRY_B] IN_C_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = IN_A * IN_B;
  assign OUT_C = IN_C_A ^ IN_C_B;
endmodule
/* -----\/----- EXCLUDED -----\/-----
module SL (
////  input             CASCADE,
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
////  input  [`WORD_B ] IN_EXT,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
////  output [`WORD_B ] OUT_EXT,
  output [`CARRY_B] OUT_C
);
////  wire           IS_HIGHER_BITS;
  wire [`WORD_B] HIGHER, LOWER;
////  assign IS_HIGHER_BITS  = (CASCADE) ? IN_C_A : `FALSE;
  assign {HIGHER, LOWER} = {`WORD_W'd0, IN_A} << IN_B[`WORD_2_BIT_B];
  assign OUT       = LOWER;  //// IS_HIGHER_BITS ? LOWER | IN_EXT : LOWER;
  assign OUT_EXT   = HIGHER;
  assign OUT_C     = | HIGHER;
endmodule
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
module SR (
  input             CASCADE,
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
////  input  [`WORD_B ] IN_EXT,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
////  output [`WORD_B ] OUT_EXT,
  output [`CARRY_B] OUT_C
);
////  wire           IS_LOWER_BITS;
  wire [`WORD_B] HIGHER, LOWER;
////  assign IS_LOWER_BITS   = (CASCADE) ? IN_C_A : `FALSE;
  assign {HIGHER, LOWER} = {IN_A, `WORD_W'd0} >> IN_B[`WORD_2_BIT_B];
  assign OUT       = HIGHER;    ////IS_LOWER_BITS ? IN_EXT | HIGHER : HIGHER;
////  assign OUT_EXT   = LOWER;
  assign OUT_C     = | LOWER;
endmodule
 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
module SRA (
////  input             CASCADE,
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
////  input  [`WORD_B ] IN_EXT,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
////  output [`WORD_B ] OUT_EXT,
  output [`CARRY_B] OUT_C
);
////  wire           IS_LOWER_BITS;
  reg  [`WORD_B] HIGHER, LOWER;
////  assign IS_LOWER_BITS = (CASCADE) ? IN_C_A : `FALSE;
  always @(*) begin
////    if(IS_LOWER_BITS) begin
////      {HIGHER, LOWER} <= {IN_A, `WORD_W'd0} >> IN_B[`WORD_2_BIT_B];
////    end else begin
      {HIGHER, LOWER} <= $signed({IN_A, `WORD_W'd0}) >>> IN_B[`WORD_2_BIT_B];
////    end
  end
  
  assign OUT       = HIGHER;
////  assign OUT_EXT   = LOWER;
  assign OUT_C     = | LOWER;
endmodule
 -----/\----- EXCLUDED -----/\----- */

module SL (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
//  assign {OUT_C, OUT} = {IN_C_A,IN_A} << IN_B[`WORD_2_BIT_B];
  assign {OUT_C, OUT} = {IN_C_A,IN_A} << IN_B;
endmodule

module SR (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
//  assign {OUT_C, OUT} = {IN_C_A,IN_A} >> IN_B[`WORD_2_BIT_B];
  assign {OUT_C, OUT} = {IN_C_A,IN_A} >> IN_B;
endmodule

module SRA (
  input [`WORD_B ] IN_A,
  input [`WORD_B ] IN_B,
  input [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
    //assign {OUT_C, OUT} = $signed({IN_C_A,IN_A}) >>> IN_B[`WORD_2_BIT_B];
    assign {OUT_C, OUT} = $signed({IN_C_A,IN_A}) >>> IN_B;
endmodule

module SEL (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  input  [`CARRY_B] IN_C_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = (~IN_C_A) ? IN_A   : IN_B;
  assign OUT_C = (~IN_C_A) ? IN_C_A : IN_C_B;
endmodule


module CAT (
  input  [`WORD_B ] IN_A,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = IN_A;
  assign OUT_C = IN_C_A;
endmodule


module NOT (
  input  [`WORD_B ] IN_A,
  input  [`CARRY_B] IN_C_A,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = ~IN_A;
  assign OUT_C = ~IN_C_A;
endmodule


module AND (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  input  [`CARRY_B] IN_C_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = IN_A   & IN_B;
  assign OUT_C = IN_C_A & IN_C_B;
endmodule


module OR (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  input  [`CARRY_B] IN_C_A,
  input  [`CARRY_B] IN_C_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = IN_A   | IN_B;
  assign OUT_C = IN_C_A | IN_C_B;
endmodule


module XOR (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = IN_A ^ IN_B;
  assign OUT_C = |OUT;
endmodule


module EQL (
  input  [`WORD_B ] IN_A,
  input  [`WORD_B ] IN_B,
  output [`WORD_B ] OUT,
  output [`CARRY_B] OUT_C
);
  assign OUT   = (IN_A == IN_B) ? IN_A : `WORD_W'd0;
  assign OUT_C = (IN_A == IN_B);
endmodule


module GT (
  input      [`WORD_B ] IN_A,
  input      [`WORD_B ] IN_B,
  input      [`CARRY_B] IN_C_A,
  output reg [`WORD_B ] OUT,
  output reg [`CARRY_B] OUT_C
);  
  always @(*) begin
    if(IN_C_A) begin
      if(IN_A >= IN_B) begin
        OUT   <= IN_A;
        OUT_C <= `TRUE;
      end else begin
        OUT   <= IN_B;
        OUT_C <= `FALSE;
      end
    end else begin
      if(IN_A > IN_B) begin
        OUT   <= IN_A;
        OUT_C <= `TRUE;
      end else begin
        OUT   <= IN_B;
        OUT_C <= `FALSE;
      end
    end
  end
endmodule


module LT (
  input      [`WORD_B ] IN_A,
  input      [`WORD_B ] IN_B,
  input      [`CARRY_B] IN_C_A,
  output reg [`WORD_B ] OUT,
  output reg [`CARRY_B] OUT_C
);
  always @(*) begin
    if(IN_C_A) begin
      if(IN_A <= IN_B) begin
        OUT   <= IN_A;
        OUT_C <= `TRUE;
      end else begin
        OUT   <= IN_B;
        OUT_C <= `FALSE;
      end
    end else begin
      if(IN_A < IN_B) begin
        OUT   <= IN_A;
        OUT_C <= `TRUE;
      end else begin
        OUT   <= IN_B;
        OUT_C <= `FALSE;
      end
    end
  end
endmodule
