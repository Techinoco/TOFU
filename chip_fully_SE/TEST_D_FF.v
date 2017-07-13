`timescale 1ns/1ps
module ff_tb;
   parameter STEP = 50;
   parameter STEP_FAST = 70;
   reg clk, rst_n, data;
   reg sel;
   wire q, clk_af;

   always #(STEP/2) begin
      clk <= ~clk;
   end
   always #(STEP_FAST/2) begin
      data <= ~data;
   end
   
   D_FF_LATCH d_ff(.D(data), .RST_N(rst_n), .CLK(clk_af), .SEL(sel), .Q(q));
   Switch_clk sw(.clk_bf0(sel), .clk_bf1(clk), .sel(sel), .clk_af(clk_af));

   initial begin
      $shm_open("./D_FF");
      $shm_probe("AC");

      clk <= 0;
      data <= 0;
      rst_n <= 0;
      sel <= 1;

      #(STEP*10);
      
      rst_n <= 1;

      #(STEP*100);

      sel <= 0;

      #(STEP*100);

      $finish;
   end // initial begin

endmodule // ff_tb
