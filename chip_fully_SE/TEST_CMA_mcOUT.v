/* test bench */
`timescale 1ns/1ps
`include "SMA.h"
module TEST_CMA;
parameter STEP = 20;
   reg clk, rst_n;
   wire cbank, run;
   wire [`DATA_W-1:0] exrd;
   wire [`DATA_W-1:0] exwd;
   wire [`EXA_W-1:0] exa;
   wire [`ROMULTIC_W-1:0] exromul;
   wire exwe, exre;
   wire done;
   reg [`DBGSEL_W-1:0] dbgsel;
   wire [`DBGDAT_W-1:0] dbgdat;
  
   always #(STEP/2) begin
            clk <= ~clk;
   end

	cma cma_1(
	.clk(clk), .rst_n(rst_n), .cbank(cbank), .run(run),
	.done(done), .dbgsel(dbgsel), .dbgdat(dbgdat), .exwe(exwe), .exre(exre), .exwd(exwd),
	.exrd(exrd), .exromul(exromul), .exa(exa) );
	// CMA_TOP CMA_TOP (
	// .CLK(clk), .RST_N(rst_n), .CBANK(cbank), .RUN(run),
	// .DONE(done), .DBGSEL(dbgsel), .DBGDAT(dbgdat), .EXWE(exwe), .EXRE(exre), .EXWD(exwd),
	// .EXRD(exrd), .EXROMUL(exromul), .EXA(exa) );

	FPGA_CMA FPGA_CMA_1 (
  	.CLK(clk),
    .RST_N(rst_n),
	 .RUN(run),
	 .BANK_SEL(cbank),
	 .RE_FROM_EXTERNAL(exre),
	 .WE_FROM_EXTERNAL(exwe),
	 .ROMULTIC_BITS_FROM_EXTERNAL(exromul),
	 .GLB_ADR_FROM_EXTERNAL(exa),
	.DATA_FROM_EXTERNAL(exwd),
	.DATA_TO_EXTERNAL(exrd),
	.DONE(done) );

   initial begin
      $shm_open("./FPGA_CMA_mcOUT");
      $shm_probe("AC");
      clk <= `DISABLE;
      rst_n <= 1'b0;
	  dbgsel <= 3'b110;
	  #(STEP*1/4);
	  #STEP;
      rst_n <= 1'b1;
      
	  #STEP;
	  
	  while (~run) begin
   	  #(STEP);
      end
	
      $display("run start:", $realtime);
      $set_toggle_region("TEST_CMA.cma_1");
      $toggle_start();
      
      while (run) begin
          #(STEP);
      end
	
      $toggle_stop();
      $toggle_report("AAA.saif", 1.0e-9, "TEST_CMA.cma_1");
      $display("run end:", $realtime);

      #(STEP*100)

      $finish;
   end

endmodule
