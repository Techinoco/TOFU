`include "SMA.h"
//OK
module dmanu8 (
	       input [`DATA_W*12-1:0] i_indata,
	       output [`DATA_W*12-1:0] o_outdata,
	       input [`LDTBL_W-1:0] i_seltbl
	       );
   
   wire [`DATA_W-1:0] 		    i0,i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11;

   assign i0 = i_indata[`DATA_W-1:0];
   assign i1 = i_indata[`DATA_W*2-1:`DATA_W];
   assign i2 = i_indata[`DATA_W*3-1:`DATA_W*2];
   assign i3 = i_indata[`DATA_W*4-1:`DATA_W*3];
   assign i4 = i_indata[`DATA_W*5-1:`DATA_W*4];
   assign i5 = i_indata[`DATA_W*6-1:`DATA_W*5];
   assign i6 = i_indata[`DATA_W*7-1:`DATA_W*6];
   assign i7 = i_indata[`DATA_W*8-1:`DATA_W*7];
   assign i8 = i_indata[`DATA_W*9-1:`DATA_W*8];
   assign i9 = i_indata[`DATA_W*10-1:`DATA_W*9];
   assign i10 = i_indata[`DATA_W*11-1:`DATA_W*10];
   assign i11 = i_indata[`DATA_W*12-1:`DATA_W*11];
   
   assign o_outdata[`DATA_W-1:0] = i_seltbl[3:0] == 4'b0000 ? i0:
				   i_seltbl[3:0] == 4'b0001 ? i1:
				   i_seltbl[3:0] == 4'b0010 ? i2:
				   i_seltbl[3:0] == 4'b0011 ? i3:
				   i_seltbl[3:0] == 4'b0100 ? i4:
				   i_seltbl[3:0] == 4'b0101 ? i5:
				   i_seltbl[3:0] == 4'b0110 ? i6:
				   i_seltbl[3:0] == 4'b0111 ? i7:
				   i_seltbl[3:0] == 4'b1000 ? i8:
				   i_seltbl[3:0] == 4'b1001 ? i9:
				   i_seltbl[3:0] == 4'b1010 ? i10: i11;
   
   assign o_outdata[`DATA_W*2-1:`DATA_W] = i_seltbl[7:4] == 4'b0000 ? i0:
					   i_seltbl[7:4] == 4'b0001 ? i1:
					   i_seltbl[7:4] == 4'b0010 ? i2:
					   i_seltbl[7:4] == 4'b0011 ? i3:
					   i_seltbl[7:4] == 4'b0100 ? i4:
					   i_seltbl[7:4] == 4'b0101 ? i5:
					   i_seltbl[7:4] == 4'b0110 ? i6:
					   i_seltbl[7:4] == 4'b0111 ? i7:
					   i_seltbl[7:4] == 4'b1000 ? i8:
					   i_seltbl[7:4] == 4'b1001 ? i9:
					   i_seltbl[7:4] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*3-1:`DATA_W*2] = i_seltbl[11:8] == 4'b0000 ? i0:
					     i_seltbl[11:8] == 4'b0001 ? i1:
					     i_seltbl[11:8] == 4'b0010 ? i2:
					     i_seltbl[11:8] == 4'b0011 ? i3:
					     i_seltbl[11:8] == 4'b0100 ? i4:
					     i_seltbl[11:8] == 4'b0101 ? i5:
					     i_seltbl[11:8] == 4'b0110 ? i6:
					     i_seltbl[11:8] == 4'b0111 ? i7:
					     i_seltbl[11:8] == 4'b1000 ? i8:
					     i_seltbl[11:8] == 4'b1001 ? i9:
					     i_seltbl[11:8] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*4-1:`DATA_W*3] = i_seltbl[15:12] == 4'b0000 ? i0:
					     i_seltbl[15:12] == 4'b0001 ? i1:
					     i_seltbl[15:12] == 4'b0010 ? i2:
					     i_seltbl[15:12] == 4'b0011 ? i3:
					     i_seltbl[15:12] == 4'b0100 ? i4:
					     i_seltbl[15:12] == 4'b0101 ? i5:
					     i_seltbl[15:12] == 4'b0110 ? i6:
					     i_seltbl[15:12] == 4'b0111 ? i7:
					     i_seltbl[15:12] == 4'b1000 ? i8:
					     i_seltbl[15:12] == 4'b1001 ? i9:
					     i_seltbl[15:12] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*5-1:`DATA_W*4] = i_seltbl[19:16] == 4'b0000 ? i0:
					     i_seltbl[19:16] == 4'b0001 ? i1:
					     i_seltbl[19:16] == 4'b0010 ? i2:
					     i_seltbl[19:16] == 4'b0011 ? i3:
					     i_seltbl[19:16] == 4'b0100 ? i4:
					     i_seltbl[19:16] == 4'b0101 ? i5:
					     i_seltbl[19:16] == 4'b0110 ? i6:
					     i_seltbl[19:16] == 4'b0111 ? i7:
					     i_seltbl[19:16] == 4'b1000 ? i8:
					     i_seltbl[19:16] == 4'b1001 ? i9:
					     i_seltbl[19:16] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*6-1:`DATA_W*5] = i_seltbl[23:20] == 4'b0000 ? i0:
					     i_seltbl[23:20] == 4'b0001 ? i1:
					     i_seltbl[23:20] == 4'b0010 ? i2:
					     i_seltbl[23:20] == 4'b0011 ? i3:
					     i_seltbl[23:20] == 4'b0100 ? i4:
					     i_seltbl[23:20] == 4'b0101 ? i5:
					     i_seltbl[23:20] == 4'b0110 ? i6:
					     i_seltbl[23:20] == 4'b0111 ? i7:
					     i_seltbl[23:20] == 4'b1000 ? i8:
					     i_seltbl[23:20] == 4'b1001 ? i9:
					     i_seltbl[23:20] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*7-1:`DATA_W*6] = i_seltbl[27:24] == 4'b0000 ? i0:
					     i_seltbl[27:24] == 4'b0001 ? i1:
					     i_seltbl[27:24] == 4'b0010 ? i2:
					     i_seltbl[27:24] == 4'b0011 ? i3:
					     i_seltbl[27:24] == 4'b0100 ? i4:
					     i_seltbl[27:24] == 4'b0101 ? i5:
					     i_seltbl[27:24] == 4'b0110 ? i6:
					     i_seltbl[27:24] == 4'b0111 ? i7:
					     i_seltbl[27:24] == 4'b1000 ? i8:
					     i_seltbl[27:24] == 4'b1001 ? i9:
					     i_seltbl[27:24] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*8-1:`DATA_W*7] = i_seltbl[31:28] == 4'b0000 ? i0:
					     i_seltbl[31:28] == 4'b0001 ? i1:
					     i_seltbl[31:28] == 4'b0010 ? i2:
					     i_seltbl[31:28] == 4'b0011 ? i3:
					     i_seltbl[31:28] == 4'b0100 ? i4:
					     i_seltbl[31:28] == 4'b0101 ? i5:
					     i_seltbl[31:28] == 4'b0110 ? i6:
					     i_seltbl[31:28] == 4'b0111 ? i7:
					     i_seltbl[31:28] == 4'b1000 ? i8:
					     i_seltbl[31:28] == 4'b1001 ? i9:
					     i_seltbl[31:28] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*9-1:`DATA_W*8] = i_seltbl[35:32] == 4'b0000 ? i0:
					     i_seltbl[35:32] == 4'b0001 ? i1:
					     i_seltbl[35:32] == 4'b0010 ? i2:
					     i_seltbl[35:32] == 4'b0011 ? i3:
					     i_seltbl[35:32] == 4'b0100 ? i4:
					     i_seltbl[35:32] == 4'b0101 ? i5:
					     i_seltbl[35:32] == 4'b0110 ? i6:
					     i_seltbl[35:32] == 4'b0111 ? i7:
					     i_seltbl[35:32] == 4'b1000 ? i8:
					     i_seltbl[35:32] == 4'b1001 ? i9:
					     i_seltbl[35:32] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*10-1:`DATA_W*9] = i_seltbl[39:36] == 4'b0000 ? i0:
					      i_seltbl[39:36] == 4'b0001 ? i1:
					      i_seltbl[39:36] == 4'b0010 ? i2:
					      i_seltbl[39:36] == 4'b0011 ? i3:
					      i_seltbl[39:36] == 4'b0100 ? i4:
					      i_seltbl[39:36] == 4'b0101 ? i5:
					      i_seltbl[39:36] == 4'b0110 ? i6:
					      i_seltbl[39:36] == 4'b0111 ? i7:
					      i_seltbl[39:36] == 4'b1000 ? i8:
					      i_seltbl[39:36] == 4'b1001 ? i9:
					      i_seltbl[39:36] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*11-1:`DATA_W*10] = i_seltbl[43:40] == 4'b0000 ? i0:
					       i_seltbl[43:40] == 4'b0001 ? i1:
					       i_seltbl[43:40] == 4'b0010 ? i2:
					       i_seltbl[43:40] == 4'b0011 ? i3:
					       i_seltbl[43:40] == 4'b0100 ? i4:
					       i_seltbl[43:40] == 4'b0101 ? i5:
					       i_seltbl[43:40] == 4'b0110 ? i6:
					       i_seltbl[43:40] == 4'b0111 ? i7:
					       i_seltbl[43:40] == 4'b1000 ? i8:
					       i_seltbl[43:40] == 4'b1001 ? i9:
					       i_seltbl[43:40] == 4'b1010 ? i10: i11;

   assign o_outdata[`DATA_W*12-1:`DATA_W*11] = i_seltbl[47:44] == 4'b0000 ? i0:
					       i_seltbl[47:44] == 4'b0001 ? i1:
					       i_seltbl[47:44] == 4'b0010 ? i2:
					       i_seltbl[47:44] == 4'b0011 ? i3:
					       i_seltbl[47:44] == 4'b0100 ? i4:
					       i_seltbl[47:44] == 4'b0101 ? i5:
					       i_seltbl[47:44] == 4'b0110 ? i6:
					       i_seltbl[47:44] == 4'b0111 ? i7:
					       i_seltbl[47:44] == 4'b1000 ? i8:
					       i_seltbl[47:44] == 4'b1001 ? i9:
					       i_seltbl[47:44] == 4'b1010 ? i10: i11;
endmodule
