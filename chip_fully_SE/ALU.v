`include "./SMA.h"


module ALU (
  input      [`CONF_ALU_B  ] CONF_ALU,
  input      [`DATA_B      ] IN_A,
  input      [`DATA_B      ] IN_B,
  
  output reg [`DATA_B      ] OUT
);


  //////// OPERAND ISOLATION ///////////////////////////////////
  wire [`WORD_B ] ADD_SUB_IN_A,   ADD_SUB_IN_B;
  wire [`WORD_B ] MULT_IN_A,      MULT_IN_B;
  wire [`WORD_B ] SL_IN_A,        SL_IN_B,        SL_IN_EXT;
  wire [`WORD_B ] SR_SRA_IN_A,    SR_SRA_IN_B,    SR_SRA_IN_EXT;
  wire [`WORD_B ] BIT_IN_A,       BIT_IN_B;
  wire [`WORD_B ] GT_IN_A,        GT_IN_B;
  wire [`WORD_B ] LT_IN_A,        LT_IN_B;
  
  wire [`CARRY_B] ADD_SUB_IN_C_A, ADD_SUB_IN_C_B;
  wire [`CARRY_B] MULT_IN_C_A,    MULT_IN_C_B;
  wire [`CARRY_B] SL_IN_C_A,      SL_IN_C_B;   
  wire [`CARRY_B] SR_SRA_IN_C_A,  SR_SRA_IN_C_B;
  wire [`CARRY_B] BIT_IN_C_A,     BIT_IN_C_B;
  wire [`CARRY_B] GT_IN_C_A,      GT_IN_C_B;
  wire [`CARRY_B] LT_IN_C_A,      LT_IN_C_B;
  
  assign {ADD_SUB_IN_C_A,  ADD_SUB_IN_A,  ADD_SUB_IN_C_B, ADD_SUB_IN_B}
	 = ((CONF_ALU == `CONF_ALU_ADD ) |
	    (CONF_ALU == `CONF_ALU_SUB ))? {IN_A, IN_B}
	                                 : {`DATA_2_W'd0};

  assign {MULT_IN_C_A,     MULT_IN_A,     MULT_IN_C_B,    MULT_IN_B   }
	 =  (CONF_ALU == `CONF_ALU_MULT)  ? {IN_A, IN_B}
	                                  : {`DATA_2_W'd0};

  assign {SL_IN_C_A,       SL_IN_A,       SL_IN_C_B,      SL_IN_B     }
	 =  (CONF_ALU == `CONF_ALU_SL  )  ? {IN_A, IN_B}
	                                  : {`DATA_2_W'd0};

  assign {SR_SRA_IN_C_A,   SR_SRA_IN_A,   SR_SRA_IN_C_B,  SR_SRA_IN_B }
	 = ((CONF_ALU == `CONF_ALU_SR  )  |
            (CONF_ALU == `CONF_ALU_SRA )) ? {IN_A, IN_B} : {`DATA_2_W'd0};


  assign {BIT_IN_C_A,BIT_IN_A,BIT_IN_C_B,BIT_IN_B }
	 =  (CONF_ALU == `CONF_ALU_SEL )  |
            (CONF_ALU == `CONF_ALU_NOT )  |
            (CONF_ALU == `CONF_ALU_CAT )  |
            (CONF_ALU == `CONF_ALU_AND )  |
            (CONF_ALU == `CONF_ALU_OR  )  |
            (CONF_ALU == `CONF_ALU_XOR )  |
            (CONF_ALU == `CONF_ALU_EQL )  ? {IN_A, IN_B}
	                                  : {`DATA_2_W'd0};

  assign {GT_IN_C_A,GT_IN_A,GT_IN_C_B,GT_IN_B     }
	 =  (CONF_ALU == `CONF_ALU_GT  )  ? {IN_A, IN_B}
	                                  : {`DATA_2_W'd0};

  assign {LT_IN_C_A,LT_IN_A,LT_IN_C_B,LT_IN_B     }
	 =  (CONF_ALU == `CONF_ALU_LT  )  ? {IN_A, IN_B}
	                                  : {`DATA_2_W'd0};
  
  
  //////// INSTANTIATION ///////////////////////////////////////
  wire [`WORD_B ] ADD_SUB_OUT,   MULT_OUT,   SHIFT_OUT,   LOGIC_OUT;
  wire [`CARRY_B] ADD_SUB_OUT_C, MULT_OUT_C, SHIFT_OUT_C, LOGIC_OUT_C;
  
  
  FUNC FUNC_0 (
    .CONF_ALU       (CONF_ALU      ),
    .ADD_SUB_IN_A   (ADD_SUB_IN_A  ),
    .ADD_SUB_IN_B   (ADD_SUB_IN_B  ),
    .ADD_SUB_IN_C_A (ADD_SUB_IN_C_A),
    .ADD_SUB_IN_C_B (ADD_SUB_IN_C_B),
    .ADD_SUB_OUT    (ADD_SUB_OUT   ),
    .ADD_SUB_OUT_C  (ADD_SUB_OUT_C ),

    .MULT_IN_A      (MULT_IN_A     ),
    .MULT_IN_B      (MULT_IN_B     ),
    .MULT_IN_C_A    (MULT_IN_C_A   ),
    .MULT_IN_C_B    (MULT_IN_C_B   ),
    .MULT_OUT       (MULT_OUT      ),
    .MULT_OUT_C     (MULT_OUT_C    ),

    .SL_IN_A        (SL_IN_A       ),
    .SL_IN_B        (SL_IN_B       ),
    .SR_SRA_IN_A    (SR_SRA_IN_A   ),
    .SR_SRA_IN_B    (SR_SRA_IN_B   ),
    .SL_IN_C_A      (SL_IN_C_A     ),
    .SR_SRA_IN_C_A  (SR_SRA_IN_C_A ),
    .SHIFT_OUT      (SHIFT_OUT     ),
    .SHIFT_OUT_C    (SHIFT_OUT_C   ),

    .BIT_IN_A       (BIT_IN_A      ),
    .BIT_IN_B       (BIT_IN_B      ),
    .BIT_IN_C_A     (BIT_IN_C_A    ),
    .BIT_IN_C_B     (BIT_IN_C_B    ),

    .GT_IN_A        (GT_IN_A       ),
    .GT_IN_B        (GT_IN_B       ),
    .GT_IN_C_A      (GT_IN_C_A     ),
    .LT_IN_A        (LT_IN_A       ),
    .LT_IN_B        (LT_IN_B       ),
    .LT_IN_C_A      (LT_IN_C_A     ),
    .LOGIC_OUT      (LOGIC_OUT     ),
    .LOGIC_OUT_C    (LOGIC_OUT_C   )
  );
  
  
  //////// OUTPUT SELECTION ////////////////////////////////////
  always @(*) begin
    case(CONF_ALU)
      `CONF_ALU_NOP                             : OUT <= {`CARRY_W'd0,   `WORD_W'd0 };
      `CONF_ALU_ADD, `CONF_ALU_SUB              : OUT <= {ADD_SUB_OUT_C, ADD_SUB_OUT};
      `CONF_ALU_MULT                            : OUT <= {MULT_OUT_C,    MULT_OUT   };
      `CONF_ALU_SL, `CONF_ALU_SR, `CONF_ALU_SRA : OUT <= {SHIFT_OUT_C,   SHIFT_OUT  };
      default                                   : OUT <= {LOGIC_OUT_C,   LOGIC_OUT  };
    endcase
  end  
endmodule
