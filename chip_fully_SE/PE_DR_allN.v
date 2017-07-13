`include "./SMA.h"


module PE_withReg_allN (
			input                  clk,
			input  [`CONF_ALU_B  ] CONF_ALU,
			input  [`CONF_SEL_B  ] CONF_SEL_A,
			input  [`CONF_SEL_B  ] CONF_SEL_B,
			input  [`CONF_SE_B   ] CONF_SE,

			input  [`DATA_B      ] IN_NORTH,
			input  [`DATA_B      ] IN_SOUTH,
			input  [`DATA_B      ] IN_EAST,
			input  [`DATA_B      ] IN_WEST,
			input  [`DATA_B      ] IN_DL_S,
			input  [`DATA_B      ] IN_DL_W,
			input  [`DATA_B      ] IN_DL_SS,
			input  [`DATA_B      ] IN_CONST_A,
			input  [`DATA_B      ] IN_CONST_B,

			output [`DATA_B      ] OUT_NORTH,
			output [`DATA_B      ] OUT_SOUTH,
			output [`DATA_B      ] OUT_EAST,
			output [`DATA_B      ] OUT_WEST,
			output [`DATA_B      ] OUT_DL_N,
			output [`DATA_B      ] OUT_DL_E,
			output [`DATA_B      ] OUT_DL_NN
			);
   wire [`DATA_B] 			       TO_NORTH, TO_DL_N, TO_DL_NN;
   wire [`DATA_B] 			       ALU_IN_A, ALU_IN_B, ALU_OUT;
   
   Door_Reg TO_NORTH_REG(.CLK(clk), .SEL(CONF_SEL_DR), .D(TO_NORTH));
   Door_Reg TO_DL_N_REG(.CLK(clk), .SEL(CONF_SEL_DR), .D(TO_DL_N));
   Door_Reg TO_DL_NN_REG(.CLK(clk), .SEL(CONF_SEL_DR), .D(TO_DL_NN));
   
   SE SE_0 (
	    .CONF_SE           (CONF_SE          ),

	    .ALU_OUT           (ALU_OUT          ),
	    .IN_NORTH          (IN_NORTH         ),
	    .IN_SOUTH          (IN_SOUTH         ),
	    .IN_EAST           (IN_EAST          ),
	    .IN_WEST           (IN_WEST          ),
	    .IN_DL_S           (IN_DL_S          ),
	    .IN_DL_W           (IN_DL_W          ),
	    .IN_DL_SS          (IN_DL_SS         ),
	    .IN_CONST_A        (IN_CONST_A       ),

	    .OUT_NORTH         (TO_NORTH        ),
	    .OUT_SOUTH         (OUT_SOUTH        ),
	    .OUT_EAST          (OUT_EAST         ),
	    .OUT_WEST          (OUT_WEST         )
	    );
   
   ALU_SEL ALU_SEL_0 (
		      .CONF_SEL_A        (CONF_SEL_A       ),
		      .CONF_SEL_B        (CONF_SEL_B       ),

		      .IN_SOUTH          (IN_SOUTH         ),
		      .IN_EAST           (IN_EAST          ),
		      .IN_WEST           (IN_WEST          ),
		      .IN_DL_S           (IN_DL_S          ),
		      .IN_DL_W           (IN_DL_W          ),
		      .IN_DL_SS          (IN_DL_SS         ),
		      .IN_CONST_A        (IN_CONST_A       ),
		      .IN_CONST_B        (IN_CONST_B       ),

		      .OUT_A             (ALU_IN_A         ),
		      .OUT_B             (ALU_IN_B         )
		      );
   
   ALU ALU_0 (
	      .CONF_ALU          (CONF_ALU         ),

	      .IN_A              (ALU_IN_A         ),
	      .IN_B              (ALU_IN_B         ),

	      .OUT               (ALU_OUT          )
	      );

   assign OUT_DL_E  = ALU_OUT;   
   assign OUT_NORTH = TO_NORTH_REG;
   assign OUT_DL_N  = TO_DL_N_REG;
   assign OUT_DL_NN = TO_DL_NN_REG;
   assign TO_DL_N = ALU_OUT;
   assign TO_DL_NN = ALU_OUT;
   
endmodule
