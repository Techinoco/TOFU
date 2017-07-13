`include "./SMA.h"


module FUNC (
  input  [`CONF_ALU_B] CONF_ALU,
  
  input  [`WORD_B    ] ADD_SUB_IN_A,
  input  [`WORD_B    ] ADD_SUB_IN_B,
  input  [`CARRY_B   ] ADD_SUB_IN_C_A,
  input  [`CARRY_B   ] ADD_SUB_IN_C_B,
  output [`WORD_B    ] ADD_SUB_OUT,
  output [`CARRY_B   ] ADD_SUB_OUT_C,
  
  input  [`WORD_B    ] MULT_IN_A,
  input  [`WORD_B    ] MULT_IN_B,
  input  [`CARRY_B   ] MULT_IN_C_A,
  input  [`CARRY_B   ] MULT_IN_C_B,
  output [`WORD_B    ] MULT_OUT,
  output [`CARRY_B   ] MULT_OUT_C,
  
  input  [`WORD_B    ] SL_IN_A,
  input  [`WORD_B    ] SL_IN_B,
  input  [`WORD_B    ] SR_SRA_IN_A,
  input  [`WORD_B    ] SR_SRA_IN_B,
  input  [`CARRY_B   ] SL_IN_C_A,
  input  [`CARRY_B   ] SR_SRA_IN_C_A,
  output [`WORD_B    ] SHIFT_OUT,
  output [`CARRY_B   ] SHIFT_OUT_C,
  
  input  [`WORD_B    ] BIT_IN_A,
  input  [`WORD_B    ] BIT_IN_B,
  input  [`CARRY_B   ] BIT_IN_C_A,
  input  [`CARRY_B   ] BIT_IN_C_B,
  input  [`WORD_B    ] GT_IN_A,
  input  [`WORD_B    ] GT_IN_B,
  input  [`CARRY_B   ] GT_IN_C_A,
  input  [`WORD_B    ] LT_IN_A,
  input  [`WORD_B    ] LT_IN_B,
  input  [`CARRY_B   ] LT_IN_C_A,
  output [`WORD_B    ] LOGIC_OUT,
  output [`CARRY_B   ] LOGIC_OUT_C
);
  
  ADD_SUB_FUNC ADD_SUB_FUNC_0 (
    .CONF_ALU       (CONF_ALU        ),
    .ADD_SUB_IN_A   (ADD_SUB_IN_A    ),
    .ADD_SUB_IN_B   (ADD_SUB_IN_B    ),
    .ADD_SUB_IN_C_A (ADD_SUB_IN_C_A  ),
    .ADD_SUB_IN_C_B (ADD_SUB_IN_C_B  ),
    .ADD_SUB_OUT    (ADD_SUB_OUT     ),
    .ADD_SUB_OUT_C  (ADD_SUB_OUT_C   )
  );
  
  MULT_FUNC MULT_FUNC_0 (
    .MULT_IN_A      (MULT_IN_A       ),
    .MULT_IN_B      (MULT_IN_B       ),
    .MULT_IN_C_A    (MULT_IN_C_A     ),
    .MULT_IN_C_B    (MULT_IN_C_B     ),
    .MULT_OUT       (MULT_OUT        ),
    .MULT_OUT_C     (MULT_OUT_C      )
  );
  
  SHIFT_FUNC SHIFT_FUNC_0 (
    .CONF_ALU       (CONF_ALU       ),
    .SL_IN_A        (SL_IN_A        ),
    .SL_IN_B        (SL_IN_B        ),
    .SR_SRA_IN_A    (SR_SRA_IN_A    ),
    .SR_SRA_IN_B    (SR_SRA_IN_B    ),
    .SL_IN_C_A      (SL_IN_C_A      ),
    .SR_SRA_IN_C_A  (SR_SRA_IN_C_A  ),
    .SHIFT_OUT      (SHIFT_OUT      ),
    .SHIFT_OUT_C    (SHIFT_OUT_C    )
  );
  
  LOGIC_FUNC LOGIC_FUNC_0 (
    .CONF_ALU       (CONF_ALU        ),
    .BIT_IN_A       (BIT_IN_A        ),
    .BIT_IN_B       (BIT_IN_B        ),
    .BIT_IN_C_A     (BIT_IN_C_A      ),
    .BIT_IN_C_B     (BIT_IN_C_B      ),
    .GT_IN_A        (GT_IN_A         ),
    .GT_IN_B        (GT_IN_B         ),
    .GT_IN_C_A      (GT_IN_C_A       ),
    .LT_IN_A        (LT_IN_A         ), 
    .LT_IN_B        (LT_IN_B         ),
    .LT_IN_C_A      (LT_IN_C_A       ),
    .LOGIC_OUT      (LOGIC_OUT       ),
    .LOGIC_OUT_C    (LOGIC_OUT_C     )
  );
endmodule


module ADD_SUB_FUNC (
  input  [`CONF_ALU_B] CONF_ALU,
  input  [`WORD_B    ] ADD_SUB_IN_A,
  input  [`WORD_B    ] ADD_SUB_IN_B,
  input  [`CARRY_B   ] ADD_SUB_IN_C_A,
  input  [`CARRY_B   ] ADD_SUB_IN_C_B,
  output [`WORD_B    ] ADD_SUB_OUT,
  output [`CARRY_B   ] ADD_SUB_OUT_C
);

  wire [`WORD_B ] ADD_OUT,   SUB_OUT;
  wire [`CARRY_B] ADD_OUT_C, SUB_OUT_C;
  
  ADD ADD_0 (
    .IN_A    (ADD_SUB_IN_A  ),
    .IN_B    (ADD_SUB_IN_B  ),
    .IN_C_A  (ADD_SUB_IN_C_A),
    .IN_C_B  (ADD_SUB_IN_C_B),
    .OUT     (ADD_OUT       ),
    .OUT_C   (ADD_OUT_C     )
  );
  
  SUB SUB_0 (
    .IN_A    (ADD_SUB_IN_A  ),
    .IN_B    (ADD_SUB_IN_B  ),
    .IN_C_A  (ADD_SUB_IN_C_A),
    .IN_C_B  (ADD_SUB_IN_C_B),
    .OUT     (SUB_OUT       ),
    .OUT_C   (SUB_OUT_C     )
  );
  
  assign {ADD_SUB_OUT_C, ADD_SUB_OUT} =
	 (CONF_ALU == `CONF_ALU_SUB) ? {SUB_OUT_C, SUB_OUT}
	                             : {ADD_OUT_C, ADD_OUT};
endmodule


module MULT_FUNC (
  input  [`WORD_B ] MULT_IN_A,
  input  [`WORD_B ] MULT_IN_B,
  input  [`CARRY_B] MULT_IN_C_A,
  input  [`CARRY_B] MULT_IN_C_B,
  output [`WORD_B ] MULT_OUT,
  output [`CARRY_B] MULT_OUT_C
);
  
  MULT MULT_0 (
    .IN_A   (MULT_IN_A  ),
    .IN_B   (MULT_IN_B  ),
    .IN_C_A (MULT_IN_C_A),
    .IN_C_B (MULT_IN_C_B),
    .OUT    (MULT_OUT   ),
    .OUT_C  (MULT_OUT_C )
  );
endmodule


module SHIFT_FUNC (
  input      [`CONF_ALU_B ] CONF_ALU,
  input      [`WORD_B     ] SL_IN_A,
  input      [`WORD_B     ] SL_IN_B,
  input      [`WORD_B     ] SR_SRA_IN_A,
  input      [`WORD_B     ] SR_SRA_IN_B,
  input      [`CARRY_B    ] SL_IN_C_A,
  input      [`CARRY_B    ] SR_SRA_IN_C_A,
  output reg [`WORD_B     ] SHIFT_OUT,
  output reg [`CARRY_B    ] SHIFT_OUT_C
);
  
  wire [`WORD_B ] SL_OUT,       SR_OUT,       SRA_OUT;
  wire [`CARRY_B] SL_OUT_C,     SR_OUT_C,     SRA_OUT_C;
  
  SL SL_0 (
    .IN_A      (SL_IN_A      ),
    .IN_B      (SL_IN_B      ),
    .IN_C_A    (SL_IN_C_A    ),
    .OUT       (SL_OUT       ),
    .OUT_C     (SL_OUT_C     )
  );
  
  SR SR_0 (
    .IN_A      (SR_SRA_IN_A  ),
    .IN_B      (SR_SRA_IN_B  ),
    .IN_C_A    (SR_SRA_IN_C_A),
    .OUT       (SR_OUT       ),
    .OUT_C     (SR_OUT_C     )
  );
  
  SRA SRA_0 (
    .IN_A      (SR_SRA_IN_A  ),
    .IN_B      (SR_SRA_IN_B  ),
    .IN_C_A    (SR_SRA_IN_C_A),
    .OUT       (SRA_OUT      ),
    .OUT_C     (SRA_OUT_C    )
  );
  
////  always @(*) begin
////    case(CONF_ALU)
////      `CONF_ALU_SL : {SHIFT_OUT_EXT, SHIFT_OUT_C, SHIFT_OUT} <= {SL_OUT_EXT,  SL_OUT_C,  SL_OUT };
////      `CONF_ALU_SR : {SHIFT_OUT_EXT, SHIFT_OUT_C, SHIFT_OUT} <= {SR_OUT_EXT,  SR_OUT_C,  SR_OUT };
////      default      : {SHIFT_OUT_EXT, SHIFT_OUT_C, SHIFT_OUT} <= {SRA_OUT_EXT, SRA_OUT_C, SRA_OUT};
////    endcase
////  end
  always @(*) begin
    case(CONF_ALU)
      `CONF_ALU_SL : {SHIFT_OUT_C, SHIFT_OUT} <= {SL_OUT_C,  SL_OUT };
      `CONF_ALU_SR : {SHIFT_OUT_C, SHIFT_OUT} <= {SR_OUT_C,  SR_OUT };
      default      : {SHIFT_OUT_C, SHIFT_OUT} <= {SRA_OUT_C, SRA_OUT};
    endcase
  end
endmodule


module LOGIC_FUNC (
  input      [`CONF_ALU_B ] CONF_ALU,
  input      [`WORD_B     ] BIT_IN_A,     BIT_IN_B,
  input      [`WORD_B     ] GT_IN_A,      GT_IN_B,
  input      [`WORD_B     ] LT_IN_A,      LT_IN_B,
  input      [`CARRY_B    ] BIT_IN_C_A,   BIT_IN_C_B,
  input      [`CARRY_B    ] GT_IN_C_A,
  input      [`CARRY_B    ] LT_IN_C_A,
  output reg [`WORD_B     ] LOGIC_OUT,
  output reg [`CARRY_B    ] LOGIC_OUT_C
);
  
  wire [`WORD_B ] SEL_OUT,   CAT_OUT,   NOT_OUT,   AND_OUT;
  wire [`WORD_B ] OR_OUT,    XOR_OUT,   EQL_OUT,   GT_OUT,    LT_OUT;
  wire [`CARRY_B] SEL_OUT_C, CAT_OUT_C, NOT_OUT_C, AND_OUT_C;
  wire [`CARRY_B] OR_OUT_C,  XOR_OUT_C, EQL_OUT_C, GT_OUT_C,  LT_OUT_C;
  
  SEL SEL_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_B   (BIT_IN_B  ),
    .IN_C_A (BIT_IN_C_A),
    .IN_C_B (BIT_IN_C_B),
    .OUT    (SEL_OUT   ),
    .OUT_C  (SEL_OUT_C )
  );
    
  CAT CAT_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_C_A (BIT_IN_C_A),
    .OUT    (CAT_OUT   ),
    .OUT_C  (CAT_OUT_C )
  );

  NOT NOT_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_C_A (BIT_IN_C_A),
    .OUT    (NOT_OUT   ),
    .OUT_C  (NOT_OUT_C )
  );
  
  AND AND_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_B   (BIT_IN_B  ),
    .IN_C_A (BIT_IN_C_A),
    .IN_C_B (BIT_IN_C_B),
    .OUT    (AND_OUT   ),
    .OUT_C  (AND_OUT_C )
  );
  
  OR  OR_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_B   (BIT_IN_B  ),
    .IN_C_A (BIT_IN_C_A),
    .IN_C_B (BIT_IN_C_B),
    .OUT    (OR_OUT    ),
    .OUT_C  (OR_OUT_C  )
  );
  
  XOR XOR_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_B   (BIT_IN_B  ),
    .OUT    (XOR_OUT   ),
    .OUT_C  (XOR_OUT_C )
  );
  
  EQL EQL_0 (
    .IN_A   (BIT_IN_A  ),
    .IN_B   (BIT_IN_B  ),
    .OUT    (EQL_OUT   ),
    .OUT_C  (EQL_OUT_C )
  );
  
  GT GT_0 (
    .IN_A   (GT_IN_A   ),
    .IN_B   (GT_IN_B   ),
    .IN_C_A (GT_IN_C_A ),
    .OUT    (GT_OUT    ),
    .OUT_C  (GT_OUT_C  )
  );
  
  LT LT_0 (
    .IN_A   (LT_IN_A   ),
    .IN_B   (LT_IN_B   ),
    .IN_C_A (LT_IN_C_A ),
    .OUT    (LT_OUT    ),
    .OUT_C  (LT_OUT_C  )
  );
  
  always @(*) begin
    case(CONF_ALU)
      `CONF_ALU_SEL : {LOGIC_OUT_C, LOGIC_OUT} <= {SEL_OUT_C, SEL_OUT};
      `CONF_ALU_CAT : {LOGIC_OUT_C, LOGIC_OUT} <= {CAT_OUT_C, CAT_OUT};
      `CONF_ALU_NOT : {LOGIC_OUT_C, LOGIC_OUT} <= {NOT_OUT_C, NOT_OUT};
      `CONF_ALU_AND : {LOGIC_OUT_C, LOGIC_OUT} <= {AND_OUT_C, AND_OUT};
      `CONF_ALU_OR  : {LOGIC_OUT_C, LOGIC_OUT} <= {OR_OUT_C,  OR_OUT };
      `CONF_ALU_XOR : {LOGIC_OUT_C, LOGIC_OUT} <= {XOR_OUT_C, XOR_OUT};
      `CONF_ALU_EQL : {LOGIC_OUT_C, LOGIC_OUT} <= {EQL_OUT_C, EQL_OUT};
      `CONF_ALU_GT  : {LOGIC_OUT_C, LOGIC_OUT} <= {GT_OUT_C,  GT_OUT };
      `CONF_ALU_LT  : {LOGIC_OUT_C, LOGIC_OUT} <= {LT_OUT_C,  LT_OUT };
      default       : {LOGIC_OUT_C, LOGIC_OUT} <= {SEL_OUT_C, SEL_OUT};
    endcase
  end
endmodule
