/* test bench */
`timescale 1ns/1ps
`include "SMA.h"
module TEST_CMA;
   parameter STEP = 50;
   parameter STEP_FOR_ARRAY = 50;

   reg clk, rst_n, clk_for_array;
   reg [2:0] interval;
   wire cbank, run;
   wire [`DATA_W-1:0] exrd;
   wire [`DATA_W-1:0] exwd;
   wire [`EXA_W-1:0] exa;
   wire [`ROMULTIC_W-1:0] exromul;
   wire exwe, exre;
   wire done;
   reg [`DBGSEL_W-1:0] dbgsel;
   wire [`DBGDAT_W-1:0] dbgdat;
  
   wire clk2;
   assign #3 clk2 = clk;

   always #(STEP/2) begin
            clk <= ~clk;
   end
   always #(STEP_FOR_ARRAY/2) begin
            clk_for_array <= ~clk_for_array;
   end

	

	CMA_TOP CMA_TOP (
	.CLK(clk), .RST_N(rst_n), .CBANK(cbank), .RUN(run),
	.DONE(done), .DBGSEL(dbgsel), .DBGDAT(dbgdat), .EXWE(exwe), .EXRE(exre), .EXWD(exwd),
	.EXRD(exrd), .EXROMUL(exromul), .EXA(exa), .CLK_FOR_ARRAY(clk_for_array) );

	FPGA_CMA FPGA_CMA_1 (
  	.CLK(clk2),
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

   integer mcd;
   initial begin
      // $sdf_annotate("../chip/CMA_TOP_10.sdf", TEST_CMA.CMA_TOP, , "sdf_top", "MAXIMUM");
      // $sdf_annotate("../chip/mc_10.sdf", TEST_CMA.CMA_TOP.I0.mc1, , "sdf_mc", "MAXIMUM");
      // $sdf_annotate("../chip/PE_ARRAY_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1, , "sdf_pe", "MAXIMUM");
      //$sdf_annotate("../chip/mc_10.sdf", TEST_CMA.CMA.mc1, , "sdf_mc", "MAXIMUM");


      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_00, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_01, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_02, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_03, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_04, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_05, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_06, , "sdf_pe", "MAXIMUM");
      $sdf_annotate("../chip/ROW_10.sdf", TEST_CMA.CMA_TOP.I0.PE_ARRAY1.ROW_07, , "sdf_pe", "MAXIMUM");
      
      $shm_open("./ARRAY_SDF_ONLY");
      $shm_probe("AC");
      
      mcd <= $fopen("./signal.log");

      clk <= `DISABLE;
      clk_for_array <= `DISABLE;
      rst_n <= 1'b0;
      dbgsel <= 3'b110;
	  #(STEP*1/4);
	  #STEP;
      rst_n <= 1'b1;
      
	  #(STEP*100);
	  
	  while (~run) begin
	     // if(exa >= 31 && exa <=50) begin
	     // 	$display("%h",exrd);
	     // end
   	  #(STEP);
	  end
	
	  //#(STEP*6);

      $display("run start:", $realtime);
      // $dumpfile("AAA.vcd");
      // $dumpvars(0,TEST_CMA.CMA_TOP);
      $set_toggle_region("TEST_CMA.CMA_TOP");
      // $set_toggle_region("TEST_CMA.CMA");
      $toggle_start();
      // $dumpon;
      
      while (run) begin
          #(STEP);
      end

      $fmonitor(mcd, "%h, %h", exa, exrd);
	
      $display("run end:", $realtime);
      $toggle_stop();
      // $dumpoff;
      $toggle_report("AAA.saif", 1.0e-9, "TEST_CMA.CMA_TOP");
      //$toggle_report("AAA.saif", 1.0e-9, "TEST_CMA.CMA");

      #(STEP*100)

      $finish;
   end
endmodule
