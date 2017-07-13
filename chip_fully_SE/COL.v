`include "./SMA.h"

module COL (
  input  [`CONF_ALU_8_B  ] CONF_ALU,
  input  [`CONF_SEL_8_B  ] CONF_SEL_A,
  input  [`CONF_SEL_8_B  ] CONF_SEL_B,
  input  [`CONF_SE_8_B   ] CONF_SE,

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
  
  wire [`DATA_B        ] PE_00_01_A, PE_01_02_A, PE_02_03_A, PE_03_04_A;
  wire [`DATA_B        ] PE_04_05_A, PE_05_06_A, PE_06_07_A, PE_07_OUT;

  wire [`DATA_B        ] PE_07_06_A, PE_06_05_A, PE_05_04_A, PE_04_03_A;
  wire [`DATA_B        ] PE_03_02_A, PE_02_01_A, PE_01_00_A, PE_OUT_07;
  
  
// Direct Lincs
  wire [`DATA_B        ] PE_00_01_DL, PE_01_02_DL, PE_02_03_DL, PE_03_04_DL;
  wire [`DATA_B        ] PE_04_05_DL, PE_05_06_DL, PE_06_07_DL, PE_07_XX_DL;

  wire [`DATA_B        ] PE_00_02_DL, PE_01_03_DL, PE_02_04_DL, PE_03_05_DL;
  wire [`DATA_B        ] PE_04_06_DL, PE_05_07_DL, PE_06_XX_DL, PE_07_XX_DL_NN;

  wire [`DATA_B        ] IN_PE_00_DL_N;
  wire [`DATA_B        ] IN_PE_00_DL_NN, IN_PE_01_DL_NN;
  
  assign IN_PE_00_DL_N	 = `DATA_W'd0;
  assign IN_PE_00_DL_NN  = `DATA_W'd0;
  assign IN_PE_01_DL_NN  = `DATA_W'd0;
  assign PE_OUT_07       = `DATA_W'd0;
   
  PE PE[`PE_ROW_NUM_RNG] (
    .CONF_ALU          (CONF_ALU                                          ),
    .CONF_SEL_A        (CONF_SEL_A                                        ),
    .CONF_SEL_B        (CONF_SEL_B                                        ),
    .CONF_SE           (CONF_SE                                           ),

    .IN_NORTH          ({PE_OUT_07,  PE_07_06_A, PE_06_05_A, PE_05_04_A,
                         PE_04_03_A, PE_03_02_A, PE_02_01_A, PE_01_00_A}  ),
    .IN_SOUTH          ({PE_06_07_A, PE_05_06_A, PE_04_05_A, PE_03_04_A,
                         PE_02_03_A, PE_01_02_A, PE_00_01_A, IN_SOUTH}  ),
    .IN_EAST           (IN_EAST                                           ),
    .IN_WEST           (IN_WEST                                           ),
    .IN_DL_S           ({PE_06_07_DL, PE_05_06_DL, PE_04_05_DL, PE_03_04_DL, 
			 PE_02_03_DL, PE_01_02_DL, PE_00_01_DL, IN_PE_00_DL_N}),
    .IN_DL_W           (IN_DL_W                                           ),
    .IN_DL_SS          ({PE_05_07_DL, PE_04_06_DL, PE_03_05_DL, PE_02_04_DL, 
		         PE_01_03_DL, PE_00_02_DL, IN_PE_01_DL_NN, IN_PE_00_DL_NN}),
    .IN_CONST_A        (IN_CONST_A                                        ),
    .IN_CONST_B        (IN_CONST_B                                        ),

    .OUT_NORTH         ({PE_07_OUT,   PE_06_07_A, PE_05_06_A, PE_04_05_A,
                         PE_03_04_A,  PE_02_03_A, PE_01_02_A, PE_00_01_A} ),
    .OUT_SOUTH         ({PE_07_06_A,  PE_06_05_A, PE_05_04_A, PE_04_03_A,
                         PE_03_02_A,  PE_02_01_A, PE_01_00_A, OUT_SOUTH}),
    .OUT_EAST          (OUT_EAST                                        ),
    .OUT_WEST          (OUT_WEST                                        ),
    .OUT_DL_N          ({PE_07_XX_DL, PE_06_07_DL, PE_05_06_DL, PE_04_05_DL,
						 PE_03_04_DL, PE_02_03_DL, PE_01_02_DL, PE_00_01_DL}),
    .OUT_DL_E          (OUT_DL_E                                          ),
    .OUT_DL_NN         ({PE_07_XX_DL_NN, PE_06_XX_DL, PE_05_07_DL, PE_04_06_DL,
						 PE_03_05_DL, PE_02_04_DL, PE_01_03_DL, PE_00_02_DL})
);
   
endmodule
