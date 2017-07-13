`include "./SMA.h"


module PE (
  input  [`CONF_ALU_B  ] CONF_ALU,
  input  [`CONF_SEL_B  ] CONF_SEL_A,
  input  [`CONF_SEL_B  ] CONF_SEL_B,
  input  [`CONF_SE_B   ] CONF_SE,
  input  [`CONF_SEL_B  ] CONF_SEL_A_NW,
  input  [`CONF_SEL_B  ] CONF_SEL_B_NW,
  input  [`CONF_SE_B   ] CONF_SE_NW,
  input  [`CONF_SEL_B  ] CONF_SEL_A_N,
  input  [`CONF_SEL_B  ] CONF_SEL_B_N,
  input  [`CONF_SE_B   ] CONF_SE_N,
  input  [`CONF_SEL_B  ] CONF_SEL_A_NE,
  input  [`CONF_SEL_B  ] CONF_SEL_B_NE,
  input  [`CONF_SE_B   ] CONF_SE_NE,
  
  input  [`DATA_B      ] IN_NORTH,
  input  [`DATA_B      ] IN_SOUTH,
  input  [`DATA_B      ] IN_EAST,
  input  [`DATA_B      ] IN_WEST,
  input  [`DATA_B      ] IN_DL_S,
  input  [`DATA_B      ] IN_DL_SE,
  input  [`DATA_B      ] IN_DL_SW,
  input  [`DATA_B      ] IN_CONST_A,
  input  [`DATA_B      ] IN_CONST_B,
  
  output [`DATA_B      ] OUT_NORTH,
  output [`DATA_B      ] OUT_SOUTH,
  output [`DATA_B      ] OUT_EAST,
  output [`DATA_B      ] OUT_WEST,
  output [`DATA_B      ] OUT_DL_N,
  output [`DATA_B      ] OUT_DL_NE,
  output [`DATA_B      ] OUT_DL_NW
);
  
  wire [`DATA_B] ALU_IN_A, ALU_IN_B, ALU_OUT;
  
  SE SE_0 (
    .CONF_SE           (CONF_SE          ),

    .ALU_OUT           (ALU_OUT          ),
    .IN_NORTH          (IN_NORTH         ),
    .IN_SOUTH          (IN_SOUTH         ),
    .IN_EAST           (IN_EAST          ),
    .IN_WEST           (IN_WEST          ),
    .IN_DL_S           (IN_DL_S          ),
    .IN_DL_SE          (IN_DL_SE         ),
    .IN_DL_SW          (IN_DL_SW         ),
    .IN_CONST_A        (IN_CONST_A       ),

    .OUT_NORTH         (OUT_NORTH        ),
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
    .IN_DL_SE          (IN_DL_SE         ),
    .IN_DL_SW          (IN_DL_SW         ),
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

   assign OUT_DL_N =	(CONF_SEL_A_N == `CONF_SEL_DL_S         ||
						 CONF_SEL_B_N == `CONF_SEL_DL_S         ||
						 CONF_SE_N[9:7] == `CONF_NORTH_SW_DL_S  ||
						 CONF_SE_N[4:2] == `CONF_EAST_SW_DL_S   ||
						 CONF_SE_N[1:0] == `CONF_WEST_SW_DL_S     ) ? ALU_OUT: 25'b0;
   
   assign OUT_DL_NW  =  (CONF_SEL_A_NW == `CONF_SEL_DL_SE        ||
						 CONF_SEL_B_NW == `CONF_SEL_DL_SE        ||
						 CONF_SE_NW[9:7] == `CONF_NORTH_SW_DL_SE ||
						 CONF_SE_NW[1:0] == `CONF_WEST_SW_DL_SE    ) ? ALU_OUT: 25'b0;
   
   assign OUT_DL_NE  =  (CONF_SEL_A_NE == `CONF_SEL_DL_SW        ||
						 CONF_SEL_B_NE == `CONF_SEL_DL_SW        ||
						 CONF_SE_NE[9:7] == `CONF_NORTH_SW_DL_SW ||
						 CONF_SE_NE[4:2] == `CONF_EAST_SW_DL_SW    ) ? ALU_OUT: 25'b0;

endmodule
