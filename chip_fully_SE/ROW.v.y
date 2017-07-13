`include "./SMA.h"

module ROW (
	    input [`CONF_ALU_12_B] CONF_ALU,
	    input [`CONF_SEL_12_B] CONF_SEL_A,
	    input [`CONF_SEL_12_B] CONF_SEL_B,
	    input [`CONF_SE_12_B ] CONF_SE,

	    input [`DATA_12_B    ] IN_NORTH,
	    input [`DATA_12_B    ] IN_SOUTH,
	    input [`DATA_12_B    ] IN_DL_S,
	    input [`DATA_11_B    ] IN_DL_SW,
	    input [`DATA_11_B    ] IN_DL_SE,
	    input [`DATA_B       ] IN_CONST_A,
	    input [`DATA_B       ] IN_CONST_B,

	    output [`DATA_12_B   ] OUT_SOUTH,
	    output [`DATA_12_B   ] OUT_NORTH,
	    output [`DATA_12_B   ] OUT_DL_Y,
	    output [`DATA_12_B   ] OUT_DL_N
	    );

   wire [`DATA_B] PE_OUT_00, PE_00_01_A, PE_01_02_A, PE_02_03_A, PE_03_04_A, PE_04_05_A, PE_05_06_A,
		  PE_06_07_A, PE_07_08_A, PE_08_09_A, PE_09_10_A, PE_10_11_A, PE_11_OUT;
   wire [`DATA_B] PE_OUT_11, PE_11_10_A, PE_10_09_A, PE_09_08_A, PE_08_07_A, PE_07_06_A, PE_06_05_A,
		  PE_05_04_A, PE_04_03_A, PE_03_02_A, PE_02_01_A, PE_01_00_A, PE_00_OUT;

   // Direct Links INPUT from SOUTH WEST and SOUTH EAST
   wire [`DATA_B] IN_00_DL_SW_XX, IN_01_DL_SW, IN_02_DL_SW, IN_03_DL_SW, IN_04_DL_SW, IN_05_DL_SW, IN_06_DL_SW,
		  IN_07_DL_SW, IN_08_DL_SW, IN_09_DL_SW, IN_10_DL_SW, IN_11_DL_SW;
   assign {IN_11_DL_SW, IN_10_DL_SW, IN_09_DL_SW, IN_08_DL_SW, IN_07_DL_SW, IN_06_DL_SW,
	   IN_05_DL_SW, IN_04_DL_SW, IN_03_DL_SW, IN_02_DL_SW, IN_01_DL_SW} = IN_DL_SW;
   assign IN_00_DL_SW_XX = `DATA_B'b0;
   wire [`DATA_B] IN_00_DL_SE, IN_01_DL_SE, IN_02_DL_SE, IN_03_DL_SE, IN_04_DL_SE, IN_05_DL_SE, IN_06_DL_SE,
		  IN_07_DL_SE, IN_08_DL_SE, IN_09_DL_SE, IN_10_DL_SE, IN_11_DL_SE_XX;
   assign {IN_10_DL_SE, IN_09_DL_SE, IN_08_DL_SE, IN_07_DL_SE, IN_06_DL_SE, IN_05_DL_SE, IN_04_DL_SE,
	   IN_03_DL_SE, IN_02_DL_SE, IN_01_DL_SE, IN_00_DL_SE} = IN_DL_SE;
   assign IN_11_DL_SE_XX = `DATA_B'b0;

   // // Direct Links OUTPUT to NORTH WEST and NORTH EAST like charactor Y
   // wire [`DATA_B] OUT_00_DL_Y, OUT_01_DL_Y, OUT_02_DL_Y, OUT_03_DL_Y, 
   // 		  OUT_04_DL_Y, OUT_05_DL_Y, OUT_06_DL_Y, OUT_07_DL_Y, 
   // 		  OUT_08_DL_Y, OUT_09_DL_Y, OUT_10_DL_Y, OUT_11_DL_Y;
   // assign OUT_DL_Y = {OUT_11_DL_Y, OUT_10_DL_Y, OUT_09_DL_Y, OUT_08_DL_Y, 
   // 		      OUT_07_DL_Y, OUT_06_DL_Y, OUT_05_DL_Y, OUT_04_DL_Y, 
   // 		      OUT_03_DL_Y, OUT_02_DL_Y, OUT_01_DL_Y, OUT_00_DL_Y};
   
   // Invalidation
   assign PE_OUT_11 = `DATA_W'd0;
   assign PE_OUT_00 = `DATA_W'd0;
   assign PE_11_OUT = `DATA_W'd0;
   assign PE_00_OUT = `DATA_W'd0;
   assign PE_XX_00_DL = `DATA_W'd0;
   assign PE_11_XX_DL = `DATA_W'd0;   

   PE PE[`PE_COL_NUM_RNG] (
			   .CONF_ALU          (CONF_ALU                                          ),
			   .CONF_SEL_A        (CONF_SEL_A                                        ),
			   .CONF_SEL_B        (CONF_SEL_B                                        ),
			   .CONF_SE           (CONF_SE                                           ),

			   .IN_EAST           ({PE_OUT_11, PE_11_10_A, PE_10_09_A, PE_09_08_A, 
						PE_09_07_A,  PE_07_06_A, PE_06_05_A, PE_05_04_A, 
						PE_04_03_A, PE_03_02_A, PE_02_01_A, PE_01_00_A}  ),
			   .IN_WEST           ({PE_10_11_A, PE_09_10_A, PE_08_09_A, PE_07_08_A, 
						PE_06_07_A, PE_05_06_A, PE_04_05_A, PE_03_04_A, 
						PE_02_03_A, PE_01_02_A, PE_00_01_A, PE_OUT_00}  ),
			   .IN_SOUTH          (IN_SOUTH                                           ),
			   .IN_DL_SW           ({IN_11_DL_SW, IN_10_DL_SW, IN_09_DL_SW, IN_08_DL_SW,
						IN_07_DL_SW, IN_06_DL_SW, IN_05_DL_SW, IN_04_DL_SW,
						IN_03_DL_SW, IN_02_DL_SW, IN_01_DL_SW, IN_00_DL_SW_XX}),
			   .IN_DL_SE           ({IN_11_DL_SE_XX, IN_10_DL_SE, IN_09_DL_SE, IN_08_DL_SE,
						IN_07_DL_SE, IN_06_DL_SE, IN_05_DL_SE, IN_04_DL_SE,
						IN_03_DL_SE, IN_02_DL_SE, IN_01_DL_SE, IN_00_DL_SE}),
			   .IN_DL_S           (IN_DL_S                                           ),
			   .IN_CONST_A        ({IN_CONST_A, IN_CONST_A, IN_CONST_A, IN_CONST_A,
						IN_CONST_A, IN_CONST_A, IN_CONST_A, IN_CONST_A,
						IN_CONST_A, IN_CONST_A, IN_CONST_A, IN_CONST_A}),
			   .IN_CONST_B        ({IN_CONST_B, IN_CONST_B, IN_CONST_B, IN_CONST_B,
						IN_CONST_B, IN_CONST_B, IN_CONST_B, IN_CONST_B,
						IN_CONST_B, IN_CONST_B, IN_CONST_B, IN_CONST_B}),

			   .OUT_EAST          ({PE_11_OUT, PE_10_11_A, PE_09_10_A, PE_08_09_A, 
						PE_07_08_A, PE_06_07_A, PE_05_06_A, PE_04_05_A, 
						PE_03_04_A,  PE_02_03_A, PE_01_02_A, PE_00_01_A} ),
			   .OUT_WEST          ({PE_11_10_A, PE_10_09_A, PE_09_08_A, PE_08_07_A, 
						PE_07_06_A,  PE_06_05_A, PE_05_04_A, PE_04_03_A, 
						PE_03_02_A,  PE_02_01_A, PE_01_00_A, PE_00_OUT}),
			   .OUT_NORTH          (OUT_NORTH                                        ),
			   .OUT_SOUTH          (OUT_SOUTH                                        ),
			   .OUT_DL_NE          ({OUT_11_DL_NE_XX, OUT_10_DL_NE, OUT_09_DL_NE,OUT_08_DL_NE,
						OUT_07_DL_NE, OUT_06_DL_NE, OUT_05_DL_NE, OUT_04_DL_NE,
						OUT_03_DL_NE, OUT_02_DL_NE, OUT_01_DL_NE, OUT_00_DL_NE}),
			   .OUT_DL_NW         ({OUT_11_DL_NW, OUT_10_DL_NW, OUT_09_DL_NW,OUT_08_DL_NW,
						OUT_07_DL_NW, OUT_06_DL_NW, OUT_05_DL_NW, OUT_04_DL_NW,
						OUT_03_DL_NW, OUT_02_DL_NW, OUT_01_DL_NW, OUT_00_DL_NW_XX}),
			   .OUT_DL_Y          (OUT_DL_Y                                          ),
			   .OUT_DL_N          (OUT_DL_N                                          )
   );
	     
endmodule
