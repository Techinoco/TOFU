`include "./SMA.h"

module SE(
  input      [`CONF_SE_B] CONF_SE,

  input      [`DATA_B   ] ALU_OUT,
  input      [`DATA_B   ] IN_NORTH,
  input      [`DATA_B   ] IN_SOUTH,
  input      [`DATA_B   ] IN_EAST,
  input      [`DATA_B   ] IN_WEST,
  input      [`DATA_B   ] IN_DL_S,  // from south PE
  input      [`DATA_B   ] IN_DL_SE, // from south east PE
  input      [`DATA_B   ] IN_DL_SW,  // from south west PE
  input      [`DATA_B   ] IN_CONST_A, // if input data of SE include constB,
                                      // const data for North_Output need 1 more bit width.
  output reg [`DATA_B   ] OUT_NORTH,
  output reg [`DATA_B   ] OUT_SOUTH,
  output reg [`DATA_B   ] OUT_EAST,
  output reg [`DATA_B   ] OUT_WEST
);

  wire [`CONF_SW_B] CONF_SW_NORTH, CONF_SW_EAST;
  wire [`CONF_SW_B] CONF_SW_SOUTH, CONF_SW_WEST;
  assign {CONF_SW_NORTH, CONF_SW_SOUTH, CONF_SW_EAST, CONF_SW_WEST} = CONF_SE;


  always @(*) begin
    case(CONF_SW_NORTH)
      `CONF_SW_ALU           : OUT_NORTH <= ALU_OUT;
      `CONF_SW_SOUTH         : OUT_NORTH <= IN_SOUTH;
      `CONF_SW_EAST          : OUT_NORTH <= IN_EAST;
      `CONF_SW_WEST          : OUT_NORTH <= IN_WEST;
      `CONF_SW_DL_S          : OUT_NORTH <= IN_DL_S;
      `CONF_SW_DL_SE         : OUT_NORTH <= IN_DL_SE;
      `CONF_SW_DL_SW         : OUT_NORTH <= IN_DL_SW;
      `CONF_SW_CONST_A         : OUT_NORTH <= IN_CONST_A;
      `CONF_SW_CONST_B         : OUT_NORTH <= IN_CONST_B;
      default                      : OUT_NORTH <= 0;
	endcase
  end

  always @(*) begin
    case(CONF_SW_SOUTH)
    `CONF_SW_ALU           : OUT_SOUTH <= ALU_OUT;
      `CONF_SW_NORTH         : OUT_SOUTH <= IN_NORTH;
      `CONF_SW_EAST          : OUT_SOUTH <= IN_EAST;
      `CONF_SW_WEST          : OUT_SOUTH <= IN_WEST;
      `CONF_SW_DL_S          : OUT_SOUTH <= IN_DL_S;
      `CONF_SW_DL_SE         : OUT_SOUTH <= IN_DL_SE;
      `CONF_SW_DL_SW         : OUT_SOUTH <= IN_DL_SW;
      `CONF_SW_CONST_A         : OUT_SOUTH <= IN_CONST_A;
      `CONF_SW_CONST_B         : OUT_SOUTH <= IN_CONST_B;
      default                      : OUT_SOUTH <= 0;
	endcase
  end

  always @(*) begin
    case(CONF_SW_EAST)
    `CONF_SW_ALU           : OUT_EAST <= ALU_OUT;
      `CONF_SW_SOUTH         : OUT_EAST <= IN_SOUTH;
      `CONF_SW_WEST          : OUT_EAST <= IN_WEST;
      `CONF_SW_DL_S          : OUT_EAST <= IN_DL_S;
      `CONF_SW_DL_SE         : OUT_EAST <= IN_DL_SE;
      `CONF_SW_DL_SW         : OUT_EAST <= IN_DL_SW;
      `CONF_SW_CONST_A         : OUT_EAST <= IN_CONST_A;
      `CONF_SW_CONST_B         : OUT_EAST <= IN_CONST_B;
      default                      : OUT_EAST <= 0;
    endcase
  end

  always @(*) begin
    case(CONF_SW_WEST)
    `CONF_SW_ALU           : OUT_WEST <= ALU_OUT;
      `CONF_SW_SOUTH         : OUT_WEST <= IN_SOUTH;
      `CONF_SW_EAST          : OUT_WEST <= IN_EAST;
      `CONF_SW_DL_S          : OUT_WEST <= IN_DL_S;
      `CONF_SW_DL_SE         : OUT_WEST <= IN_DL_SE;
      `CONF_SW_DL_SW         : OUT_WEST <= IN_DL_SW;
      `CONF_SW_CONST_A         : OUT_WEST <= IN_CONST_A;
      `CONF_SW_CONST_B         : OUT_WEST <= IN_CONST_B;
      default                      : OUT_WEST <= 0;
    endcase
  end
endmodule


