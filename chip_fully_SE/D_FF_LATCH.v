module D_FF_LATCH (input D,
		   input RST_N,
		   input CLK,
		   input SEL,
		   output Q);
   wire 		  master_out, slave_out;
   wire [1:0] 		  sel_in;
   wire 		  CLK_MAS;

   DLATCH master(.c(CLK_MAS), .d(D), .r_n(RST_N), .q(master_out));
   DLATCH slave(.c(CLK), .d(master_out), .r_n(RST_N), .q(slave_out));

   assign CLK_MAS = ~CLK;
   assign sel_in = {slave_out, master_out};
   assign Q = sel_in[SEL];
endmodule // D_FF_LATCH

module DLATCH(c, d, r_n,q);
   input c, d, r_n;
   output q;
   // reg 	  qq;

   // initial qq <= 0;

   // always @(c or d) begin
   //    if (r_n==0)
   // 	qq <= 0;
   //    else if (c==1)
   // 	qq <= d;
   // end

   // assign q = qq;
   assign q = (~r_n) ? 0 :
	      (c) ? d :
	      q;
endmodule // DLATCH
