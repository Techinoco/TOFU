module ex_mem(clk, addr, q);
 parameter DWIDTH=47,AWIDTH=7,WORDS=128;

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
    $readmemb("confp.dat",mem);
 end

endmodule
