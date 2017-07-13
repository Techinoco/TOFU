module Switch_clk (input clk,
		   input en,
		   output clk_af);
   assign clk_af = en & clk;
endmodule // Switch_clok


