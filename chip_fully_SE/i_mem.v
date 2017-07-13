module i_mem(clk, addr, q);
 parameter DWIDTH=16,AWIDTH=8,WORDS=256;

 input clk;
 input [AWIDTH-1:0] addr;
 output [DWIDTH-1:0] q;
 reg [DWIDTH-1:0] q;
 reg [DWIDTH-1:0] mem [WORDS-1:0];

 always @(posedge clk)
    begin
     q <= mem[addr];
   end

 integer i;
 initial begin
    for(i=0;i<WORDS;i=i+1)
       mem[i]=0;
    $readmemb("dac.conf",mem);
 end

endmodule
