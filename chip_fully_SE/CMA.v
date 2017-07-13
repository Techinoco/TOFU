
module CMA ( CLK, RST_N, CBANK, RUN, EXWE, EXRE, EXWD, EXROMUL, EXA, DBGSEL, 
             EXRD, DBGDAT, DONE);
   input [24:0] EXWD;
   input [19:0] EXROMUL;
   input [11:0] EXA;
   input [2:0] 	DBGSEL;
   output [24:0] EXRD;
   output [3:0]  DBGDAT;
   input 	 CLK, RST_N, CBANK, RUN, EXWE, EXRE;
   output 	 DONE;

   wire [299:0]  TOPEARRAY;
   wire [299:0]  FPEARRAY;
   wire [383:0]  CONF_ALU;
   wire [287:0]  CONF_SEL_A;
   wire [287:0]  CONF_SEL_B;
   wire [959:0]  CONF_SE;
   wire [135:0]  CONST_DATA_A;
   wire [135:0]  CONST_DATA_B;
   wire 	 CONF_SEL_DR_12, CONF_SEL_DR_34, CONF_DEL_DR_56;

   // mc mc1 ( .CLK(CLK), .RST_N(RST_N), .CBANK(CBANK), .RUN(RUN), .TOPEARRAY(
   //       TOPEARRAY), .FPEARRAY(FPEARRAY), .CONF_ALU(CONF_ALU), .CONF_SEL_A(
   //       CONF_SEL_A), .CONF_SEL_B(CONF_SEL_B), .CONF_SE(CONF_SE), 
   //       .CONST_DATA_A(CONST_DATA_A), .CONST_DATA_B(CONST_DATA_B), .DONE(DONE), 
   //       .EXWE(EXWE), .EXRE(EXRE), .EXWD(EXWD), .EXRD(EXRD), .EXROMUL(EXROMUL), 
   //       .EXA(EXA), .DBGSEL(DBGSEL), .DBGDAT(DBGDAT) );
   mc mc1(
	  .CLK (CLK), .RST_N(RST_N), .CBANK(CBANK), .RUN(RUN),
	  .TOPEARRAY     (TOPEARRAY),
	  .FPEARRAY      (FPEARRAY),// SWOPED D3
	  .CONF_ALU      (CONF_ALU),
	  .CONF_SEL_A    (CONF_SEL_A),
	  .CONF_SEL_B    (CONF_SEL_B),
	  .CONF_SE       (CONF_SE),
	  .CONST_DATA_A  (CONST_DATA_A),
	  .CONST_DATA_B  (CONST_DATA_B),
	  .CONF_SEL_DR_01(CONF_SEL_DR_01),
	  .CONF_SEL_DR_12(CONF_SEL_DR_12),
	  .CONF_SEL_DR_23(CONF_SEL_DR_23),
	  .CONF_SEL_DR_34(CONF_SEL_DR_34),
	  .CONF_SEL_DR_45(CONF_SEL_DR_45),
	  .CONF_SEL_DR_56(CONF_SEL_DR_56),
	  .CONF_SEL_DR_67(CONF_SEL_DR_67),
	  .DONE          (DONE),
	  .EXWE          (EXWE), 
	  .EXRE          (EXRE),
	  .EXWD          (EXWD),
	  .EXRD          (EXRD),
	  .EXROMUL       (EXROMUL),
	  .EXA           (EXA),
	  .DBGSEL        (DBGSEL),
	  .DBGDAT        (DBGDAT)
	  );
   PE_ARRAY PE_ARRAY1 (
		       .CLK           (CLK),
		       .RST_N         (RST_N),
		       .CONF_ALU      (CONF_ALU),
		       .CONF_SEL_A    (CONF_SEL_A),
		       .CONF_SEL_B    (CONF_SEL_B),
		       .CONF_SE       (CONF_SE),
		       .CONF_SEL_DR_01(CONF_SEL_DR_01),
		       .CONF_SEL_DR_12(CONF_SEL_DR_12),
		       .CONF_SEL_DR_23(CONF_SEL_DR_23),
		       .CONF_SEL_DR_34(CONF_SEL_DR_34),
		       .CONF_SEL_DR_45(CONF_SEL_DR_45),
		       .CONF_SEL_DR_56(CONF_SEL_DR_56),
		       .CONF_SEL_DR_67(CONF_SEL_DR_67),
		       .IN_SOUTH      (TOPEARRAY),
		       .IN_CONST_A    (CONST_DATA_A),
		       .IN_CONST_B    (CONST_DATA_B),
		       .OUT_SOUTH     (FPEARRAY)
		       );
   // PE_ARRAY PE_ARRAY1 ( .CLK(CLK), .RST_N(RST_N), .CONF_ALU(CONF_ALU), .CONF_SEL_A(CONF_SEL_A), .CONF_SEL_B(CONF_SEL_B), .CONF_SE(CONF_SE), .IN_SOUTH(TOPEARRAY), 
   //       .IN_CONST_A(CONST_DATA_A), .IN_CONST_B(CONST_DATA_B), .OUT_SOUTH(
   //       FPEARRAY) );
endmodule

