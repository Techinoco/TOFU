`include "./SMA.h"
 

module ALU_SEL (
  input      [`CONF_SEL_B] CONF_SEL_A,
  input      [`CONF_SEL_B] CONF_SEL_B,
  input      [`DATA_B    ] IN_SOUTH,
  input      [`DATA_B    ] IN_EAST,
  input      [`DATA_B    ] IN_WEST,
  input      [`DATA_B    ] IN_DL_S,
  input      [`DATA_B    ] IN_DL_SE,
  input      [`DATA_B    ] IN_DL_SW,
  input      [`DATA_B    ] IN_CONST_A,
  input      [`DATA_B    ] IN_CONST_B,
  output reg [`DATA_B    ] OUT_A,
  output reg [`DATA_B    ] OUT_B
);
  
  always @(*) begin
    case(CONF_SEL_A)
      `CONF_SEL_SOUTH         : OUT_A <= IN_SOUTH;
      `CONF_SEL_EAST          : OUT_A <= IN_EAST;
      `CONF_SEL_WEST          : OUT_A <= IN_WEST;
      `CONF_SEL_DL_S          : OUT_A <= IN_DL_S;
      `CONF_SEL_DL_SE         : OUT_A <= IN_DL_SE;
      `CONF_SEL_DL_SW         : OUT_A <= IN_DL_SW;
      `CONF_SEL_CONST_A       : OUT_A <= IN_CONST_A;
      `CONF_SEL_CONST_B       : OUT_A <= IN_CONST_B;
    endcase
  end
  
  always @(*) begin
    case(CONF_SEL_B)
      `CONF_SEL_SOUTH         : OUT_B <= IN_SOUTH;
      `CONF_SEL_EAST          : OUT_B <= IN_EAST;
      `CONF_SEL_WEST          : OUT_B <= IN_WEST;
      `CONF_SEL_DL_S          : OUT_B <= IN_DL_S;
      `CONF_SEL_DL_SE         : OUT_B <= IN_DL_SE;
      `CONF_SEL_DL_SW         : OUT_B <= IN_DL_SW;
      `CONF_SEL_CONST_A       : OUT_B <= IN_CONST_A;
      `CONF_SEL_CONST_B       : OUT_B <= IN_CONST_B;
    endcase
  end
endmodule
