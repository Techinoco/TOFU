`include "./SMA.h"

module COL_var (
		 input  clk_01, clk_12, clk_23, clk_34, clk_45, clk_56, clk_67,
		 input  [`CONF_ALU_8_B  ] CONF_ALU,
		 input  [`CONF_SEL_8_B  ] CONF_SEL_A,
		 input  [`CONF_SEL_8_B  ] CONF_SEL_B,
		 input  [`CONF_SE_8_B   ] CONF_SE,
		 input  CONF_SEL_DR_01, CONF_SEL_DR_12, CONF_SEL_DR_23, 
		CONF_SEL_DR_34, CONF_SEL_DR_45, CONF_SEL_DR_56, CONF_SEL_DR_67,

		 //  input  [`DATA_B        ] IN_NORTH,
		 input  [`DATA_B        ] IN_SOUTH,
		 input  [`DATA_8_B      ] IN_EAST,
		 input  [`DATA_8_B      ] IN_WEST,
		 input  [`DATA_8_B      ] IN_DL_W,
		 input  [`DATA_8_B      ] IN_CONST_A,
		 input  [`DATA_8_B      ] IN_CONST_B,

		 //  output [`DATA_B        ] OUT_NORTH,
		 output [`DATA_B        ] OUT_SOUTH,
		 output [`DATA_8_B      ] OUT_EAST,
		 output [`DATA_8_B      ] OUT_WEST,
		 output [`DATA_8_B      ] OUT_DL_E
		 );
   
   wire [`DATA_B        ] 		  PE_00_01_A, PE_01_02_A, PE_02_03_A, PE_03_04_A;
   wire [`DATA_B        ] 		  PE_04_05_A, PE_05_06_A, PE_06_07_A, PE_07_OUT;

   wire [`DATA_B        ] 		  PE_07_06_A, PE_06_05_A, PE_05_04_A, PE_04_03_A;
   wire [`DATA_B        ] 		  PE_03_02_A, PE_02_01_A, PE_01_00_A, PE_OUT_07;
   
   
   // Direct Lincs
   wire [`DATA_B        ] 		  PE_00_01_DL, PE_01_02_DL, PE_02_03_DL, PE_03_04_DL;
   wire [`DATA_B        ] 		  PE_04_05_DL, PE_05_06_DL, PE_06_07_DL, PE_07_XX_DL;

   wire [`DATA_B        ] 		  PE_00_02_DL, PE_01_03_DL, PE_02_04_DL, PE_03_05_DL;
   wire [`DATA_B        ] 		  PE_04_06_DL, PE_05_07_DL, PE_06_XX_DL, PE_07_XX_DL_NN;

   wire [`DATA_B        ] 		  IN_PE_00_DL_N;
   wire [`DATA_B        ] 		  IN_PE_00_DL_NN, IN_PE_01_DL_NN;

   wire [`DATA_B        ] 		  f0t1_A, f0t1_DL,             f0t2_DL1;
   wire [`DATA_B        ] 		  f1t2_A, f1t2_DL, f1t3_DL1, f0t2_DL2;
   wire [`DATA_B        ] 		  f2t3_A, f2t3_DL, f1t3_DL2, f2t4_DL1;
   wire [`DATA_B        ] 		  f3t4_A, f3t4_DL, f3t5_DL1, f2t4_DL2;
   wire [`DATA_B        ] 		  f4t5_A, f4t5_DL, f3t5_DL2, f4t6_DL1;
   wire [`DATA_B        ] 		  f5t6_A, f5t6_DL, f5t7_DL1, f4t6_DL2;
   wire [`DATA_B        ] 		  f6t7_A, f6t7_DL, f5t7_DL2;
   
   
   assign IN_PE_00_DL_N	 = `DATA_W'd0;
   assign IN_PE_00_DL_NN  = `DATA_W'd0;
   assign IN_PE_01_DL_NN  = `DATA_W'd0;
   assign PE_OUT_07       = `DATA_W'd0;

   PE PE7 ( 
	    .CONF_ALU (CONF_ALU[31:28]),
	    .CONF_SEL_A (CONF_SEL_A[23:21]),
	    .CONF_SEL_B (CONF_SEL_B[23:21]),
	    .CONF_SE (CONF_SE[79:70]),

	    .IN_NORTH (PE_OUT_07),
	    .IN_SOUTH (f6t7_A),
	    .IN_EAST (IN_EAST[199:175]),
	    .IN_WEST (IN_WEST[199:175]),
	    .IN_DL_S (f6t7_DL),
	    .IN_DL_W (IN_DL_W[199:175]),
	    .IN_DL_SS (f5t7_DL2),
	    .IN_CONST_A (IN_CONST_A[199:175]),
	    .IN_CONST_B (IN_CONST_B[199:175]),

	    .OUT_NORTH (PE_07_OUT),
	    .OUT_SOUTH (PE_07_06_A),
	    .OUT_EAST (OUT_EAST[199:175]),
	    .OUT_WEST (OUT_WEST[199:175]),
	    .OUT_DL_N (PE_07_XX_DL),
	    .OUT_DL_E (OUT_DL_E[199:175]),
	    .OUT_DL_NN (PE_07_XX_DL_NN)
	    );

   Door_Reg from6to7_A(.CLK(clk_67), .EN(CONF_SEL_DR_67), .D(PE_06_07_A), .Q(f6t7_A));
   Door_Reg from6to7_DL(.CLK(clk_67), .EN(CONF_SEL_DR_67), .D(PE_06_07_DL), .Q(f6t7_DL));
   Door_Reg from5to7_DL2(.CLK(clk_67), .EN(CONF_SEL_DR_67), .D(f5t7_DL1), .Q(f5t7_DL2));

   PE PE6 ( 
	    .CONF_ALU (CONF_ALU[27:24]),
	    .CONF_SEL_A (CONF_SEL_A[20:18]),
	    .CONF_SEL_B (CONF_SEL_B[20:18]),
	    .CONF_SE (CONF_SE[69:60]),

	    .IN_NORTH (PE_07_06_A),
	    .IN_SOUTH (f5t6_A),
	    .IN_EAST (IN_EAST[174:150]),
	    .IN_WEST (IN_WEST[174:150]),
	    .IN_DL_S (f5t6_DL),
	    .IN_DL_W (IN_DL_W[174:150]),
	    .IN_DL_SS (f4t6_DL2),
	    .IN_CONST_A (IN_CONST_A[174:150]),
	    .IN_CONST_B (IN_CONST_B[174:150]),

	    .OUT_NORTH (PE_06_07_A),
	    .OUT_SOUTH (PE_06_05_A),
	    .OUT_EAST (OUT_EAST[174:150]),
	    .OUT_WEST (OUT_WEST[174:150]),
	    .OUT_DL_N (PE_06_07_DL),
	    .OUT_DL_E (OUT_DL_E[174:150]),
	    .OUT_DL_NN (PE_06_XX_DL)
	    );

   Door_Reg from5to6_A(.CLK(clk_56), .EN(CONF_SEL_DR_56), .D(PE_05_06_A), .Q(f5t6_A));
   Door_Reg from5to6_DL(.CLK(clk_56), .EN(CONF_SEL_DR_56), .D(PE_05_06_DL), .Q(f5t6_DL));
   Door_Reg from4to6_DL2(.CLK(clk_56), .EN(CONF_SEL_DR_56), .D(f4t6_DL1), .Q(f4t6_DL2));
   Door_Reg from5to7_DL1(.CLK(clk_56), .EN(CONF_SEL_DR_56), .D(PE_05_07_DL), .Q(f5t7_DL1));

   PE PE5 ( 
	    .CONF_ALU (CONF_ALU[23:20]),
	    .CONF_SEL_A (CONF_SEL_A[17:15]),
	    .CONF_SEL_B (CONF_SEL_B[17:15]),
	    .CONF_SE (CONF_SE[59:50]),

	    .IN_NORTH (PE_06_05_A),
	    .IN_SOUTH (f4t5_A),
	    .IN_EAST (IN_EAST[149:125]),
	    .IN_WEST (IN_WEST[149:125]),
	    .IN_DL_S (f4t5_DL),
	    .IN_DL_W (IN_DL_W[149:125]),
	    .IN_DL_SS (f3t5_DL2),
	    .IN_CONST_A (IN_CONST_A[149:125]),
	    .IN_CONST_B (IN_CONST_B[149:125]),

	    .OUT_NORTH (PE_05_06_A),
	    .OUT_SOUTH (PE_05_04_A),
	    .OUT_EAST (OUT_EAST[149:125]),
	    .OUT_WEST (OUT_WEST[149:125]),
	    .OUT_DL_N (PE_05_06_DL),
	    .OUT_DL_E (OUT_DL_E[149:125]),
	    .OUT_DL_NN (PE_05_07_DL)
	    );

   Door_Reg from4to5_A(.CLK(clk_45), .EN(CONF_SEL_DR_45), .D(PE_04_05_A), .Q(f4t5_A));
   Door_Reg from4to5_DL(.CLK(clk_45), .EN(CONF_SEL_DR_45), .D(PE_04_05_DL), .Q(f4t5_DL));
   Door_Reg from3to5_DL2(.CLK(clk_45), .EN(CONF_SEL_DR_45), .D(f3t5_DL1), .Q(f3t5_DL2));
   Door_Reg from4to6_DL1(.CLK(clk_45), .EN(CONF_SEL_DR_45), .D(PE_04_06_DL), .Q(f4t6_DL1));

   PE PE4 ( 
	    .CONF_ALU (CONF_ALU[19:16]),
	    .CONF_SEL_A (CONF_SEL_A[14:12]),
	    .CONF_SEL_B (CONF_SEL_B[14:12]),
	    .CONF_SE (CONF_SE[49:40]),

	    .IN_NORTH (PE_05_04_A),
	    .IN_SOUTH (f3t4_A),
	    .IN_EAST (IN_EAST[124:100]),
	    .IN_WEST (IN_WEST[124:100]),
	    .IN_DL_S (f3t4_DL),
	    .IN_DL_W (IN_DL_W[124:100]),
	    .IN_DL_SS (f2t4_DL2),
	    .IN_CONST_A (IN_CONST_A[124:100]),
	    .IN_CONST_B (IN_CONST_B[124:100]),

	    .OUT_NORTH (PE_04_05_A),
	    .OUT_SOUTH (PE_04_03_A),
	    .OUT_EAST (OUT_EAST[124:100]),
	    .OUT_WEST (OUT_WEST[124:100]),
	    .OUT_DL_N (PE_04_05_DL),
	    .OUT_DL_E (OUT_DL_E[124:100]),
	    .OUT_DL_NN (PE_04_06_DL)
	    );

   Door_Reg from3to4_A(.CLK(clk_34), .EN(CONF_SEL_DR_34), .D(PE_03_04_A), .Q(f3t4_A));
   Door_Reg from3to4_DL(.CLK(clk_34), .EN(CONF_SEL_DR_34), .D(PE_03_04_DL), .Q(f3t4_DL));
   Door_Reg from2to4_DL2(.CLK(clk_34), .EN(CONF_SEL_DR_34), .D(f2t4_DL1), .Q(f2t4_DL2));
   Door_Reg from3to5_DL1(.CLK(clk_34), .EN(CONF_SEL_DR_34), .D(PE_03_05_DL), .Q(f3t5_DL1));

   PE PE3 ( 
	    .CONF_ALU (CONF_ALU[15:12]),
	    .CONF_SEL_A (CONF_SEL_A[11:9]),
	    .CONF_SEL_B (CONF_SEL_B[11:9]),
	    .CONF_SE (CONF_SE[39:30]),

	    .IN_NORTH (PE_04_03_A),
	    .IN_SOUTH (f2t3_A),
	    .IN_EAST (IN_EAST[99:75]),
	    .IN_WEST (IN_WEST[99:75]),
	    .IN_DL_S (f2t3_DL),
	    .IN_DL_W (IN_DL_W[99:75]),
	    .IN_DL_SS (f1t3_DL2),
	    .IN_CONST_A (IN_CONST_A[99:75]),
	    .IN_CONST_B (IN_CONST_B[99:75]),

	    .OUT_NORTH (PE_03_04_A),
	    .OUT_SOUTH (PE_03_02_A),
	    .OUT_EAST (OUT_EAST[99:75]),
	    .OUT_WEST (OUT_WEST[99:75]),
	    .OUT_DL_N (PE_03_04_DL),
	    .OUT_DL_E (OUT_DL_E[99:75]),
	    .OUT_DL_NN (PE_03_05_DL)
	    );

   Door_Reg from2to3_A(.CLK(clk_23), .EN(CONF_SEL_DR_23), .D(PE_02_03_A), .Q(f2t3_A));
   Door_Reg from2to3_DL(.CLK(clk_23), .EN(CONF_SEL_DR_23), .D(PE_02_03_DL), .Q(f2t3_DL));
   Door_Reg from1to3_DL2(.CLK(clk_23), .EN(CONF_SEL_DR_23), .D(f1t3_DL1), .Q(f1t3_DL2));
   Door_Reg from2to4_DL1(.CLK(clk_23), .EN(CONF_SEL_DR_23), .D(PE_02_04_DL), .Q(f2t4_DL1));

   PE PE2 ( 
	    .CONF_ALU (CONF_ALU[11:8]),
	    .CONF_SEL_A (CONF_SEL_A[8:6]),
	    .CONF_SEL_B (CONF_SEL_B[8:6]),
	    .CONF_SE (CONF_SE[29:20]),

	    .IN_NORTH (PE_03_02_A),
	    .IN_SOUTH (f1t2_A),
	    .IN_EAST (IN_EAST[74:50]),
	    .IN_WEST (IN_WEST[74:50]),
	    .IN_DL_S (f1t2_DL),
	    .IN_DL_W (IN_DL_W[74:50]),
	    .IN_DL_SS (f0t2_DL2),
	    .IN_CONST_A (IN_CONST_A[74:50]),
	    .IN_CONST_B (IN_CONST_B[74:50]),

	    .OUT_NORTH (PE_02_03_A),
	    .OUT_SOUTH (PE_02_01_A),
	    .OUT_EAST (OUT_EAST[74:50]),
	    .OUT_WEST (OUT_WEST[74:50]),
	    .OUT_DL_N (PE_02_03_DL),
	    .OUT_DL_E (OUT_DL_E[74:50]),
	    .OUT_DL_NN (PE_02_04_DL)
	    );

   Door_Reg from1to2_A(.CLK(clk_12), .EN(CONF_SEL_DR_12), .D(PE_01_02_A), .Q(f1t2_A));
   Door_Reg from1to2_DL(.CLK(clk_12), .EN(CONF_SEL_DR_12), .D(PE_01_02_DL), .Q(f1t2_DL));
   Door_Reg from0to2_DL2(.CLK(clk_12), .EN(CONF_SEL_DR_12), .D(f0t2_DL1), .Q(f0t2_DL2));
   Door_Reg from1to3_DL1(.CLK(clk_12), .EN(CONF_SEL_DR_12), .D(PE_01_03_DL), .Q(f1t3_DL1));

   PE PE1 ( 
	    .CONF_ALU (CONF_ALU[7:4]),
	    .CONF_SEL_A (CONF_SEL_A[5:3]),
	    .CONF_SEL_B (CONF_SEL_B[5:3]),
	    .CONF_SE (CONF_SE[19:10]),

	    .IN_NORTH (PE_02_01_A),
	    .IN_SOUTH (f0t1_A),
	    .IN_EAST (IN_EAST[49:25]),
	    .IN_WEST (IN_WEST[49:25]),
	    .IN_DL_S (f0t1_DL),
	    .IN_DL_W (IN_DL_W[49:25]),
	    .IN_DL_SS (IN_PE_01_DL_NN),
	    .IN_CONST_A (IN_CONST_A[49:25]),
	    .IN_CONST_B (IN_CONST_B[49:25]),

	    .OUT_NORTH (PE_01_02_A),
	    .OUT_SOUTH (PE_01_00_A),
	    .OUT_EAST (OUT_EAST[49:25]),
	    .OUT_WEST (OUT_WEST[49:25]),
	    .OUT_DL_N (PE_01_02_DL),
	    .OUT_DL_E (OUT_DL_E[49:25]),
	    .OUT_DL_NN (PE_01_03_DL)
	    );

   Door_Reg from0to1_A(.CLK(clk_01), .EN(CONF_SEL_DR_01), .D(PE_00_01_A), .Q(f0t1_A));
   Door_Reg from0to1_DL(.CLK(clk_01), .EN(CONF_SEL_DR_01), .D(PE_00_01_DL), .Q(f0t1_DL));
   Door_Reg from0to2_DL1(.CLK(clk_01), .EN(CONF_SEL_DR_01), .D(PE_00_02_DL), .Q(f0t2_DL1));

   PE PE0 ( 
	    .CONF_ALU (CONF_ALU[3:0]),
	    .CONF_SEL_A (CONF_SEL_A[2:0]),
	    .CONF_SEL_B (CONF_SEL_B[2:0]),
	    .CONF_SE (CONF_SE[9:0]),

	    .IN_NORTH (PE_01_00_A),
	    .IN_SOUTH (IN_SOUTH),
	    .IN_EAST (IN_EAST[24:0]),
	    .IN_WEST (IN_WEST[24:0]),
	    .IN_DL_S (IN_PE_00_DL_N),
	    .IN_DL_W (IN_DL_W[24:0]),
	    .IN_DL_SS (IN_PE_00_DL_NN),
	    .IN_CONST_A (IN_CONST_A[24:0]),
	    .IN_CONST_B (IN_CONST_B[24:0]),

	    .OUT_NORTH (PE_00_01_A),
	    .OUT_SOUTH (OUT_SOUTH),
	    .OUT_EAST (OUT_EAST[24:0]),
	    .OUT_WEST (OUT_WEST[24:0]),
	    .OUT_DL_N (PE_00_01_DL),
	    .OUT_DL_E (OUT_DL_E[24:0]),
	    .OUT_DL_NN (PE_00_02_DL)
	    );

endmodule
