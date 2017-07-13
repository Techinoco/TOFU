`include "./SMA.h"

module CONF_CONST_CTRL (
	input						clk,
	input						rst_n,

	// CONNECTION TO EXTERNAL
	input						i_we_from_external,
	input  [`ROMULTIC_B     ]	i_romultic_bits_from_external,
	input  [`GLB_ADR_B      ]	i_glb_adr_from_external,
	//input  [`CONST_DATA_B   ]	i_data_from_external,
	input  [`CONF_OP_NET_B	]	i_data_from_external,
	// ^^ Select the Widest Value between ALU&SEL, SE, CONST ^^
	output [`CONST_DATA_B   ]	o_const_data_to_external,
	output [`CONF_OP_ACT_B  ]	o_conf_op_act_to_external,
	output [`CONF_NETWORK_B ]	o_conf_network_to_external,

	// CONNECTION TO PE_ARRAY
	output [`CONF_ALU_96_B  ]	o_conf_alu,
	output [`CONF_SEL_96_B  ]	o_conf_sel_a,
	output [`CONF_SEL_96_B  ]	o_conf_sel_b,
	output [`CONF_SE_96_B   ]	o_conf_se,
	output [`CONST_DATA_8_B ]	o_const_data_a,
	output [`CONST_DATA_8_B ]	o_const_data_b,
	output						o_conf_sel_dr_01,
	output						o_conf_sel_dr_12,
	output						o_conf_sel_dr_23,
	output						o_conf_sel_dr_34,
	output						o_conf_sel_dr_45,
	output						o_conf_sel_dr_56,
	output						o_conf_sel_dr_67
);
   

CONF_CTRL CONF_CTRL_0 (
	.clk                          (clk                         ),
	.rst_n                        (rst_n                       ),
	.i_we_from_external             (i_we_from_external            ),
	.i_romultic_bits_from_external  (i_romultic_bits_from_external ),
	.i_glb_adr_from_external        (i_glb_adr_from_external       ),
	//.i_conf_data_from_external      (i_data_from_external[`CONF_NETWORK_B]),
	.i_conf_data_from_external      (i_data_from_external		   ),
	.o_conf_op_act_to_external      (o_conf_op_act_to_external     ),
	.o_conf_network_to_external     (o_conf_network_to_external    ),
	.o_conf_alu                     (o_conf_alu                    ),
	.o_conf_sel_a                   (o_conf_sel_a                  ),
	.o_conf_sel_b                   (o_conf_sel_b                  ),
	.o_conf_se                      (o_conf_se                     ),
	.o_conf_sel_dr_01               (o_conf_sel_dr_01              ),
	.o_conf_sel_dr_12               (o_conf_sel_dr_12              ),
	.o_conf_sel_dr_23               (o_conf_sel_dr_23              ),
	.o_conf_sel_dr_34               (o_conf_sel_dr_34              ),
	.o_conf_sel_dr_45               (o_conf_sel_dr_45              ),
	.o_conf_sel_dr_56               (o_conf_sel_dr_56              ),
	.o_conf_sel_dr_67               (o_conf_sel_dr_67              )
);
   
CONST_CTRL CONST_CTRL_0 (
	.clk                          (clk                         ),
	.rst_n                        (rst_n                       ),
	.i_we_from_external             (i_we_from_external            ),
	.i_glb_adr_from_external        (i_glb_adr_from_external       ),
	.i_const_data_from_external     (i_data_from_external[`CONST_DATA_B]),
	.o_const_data_to_external       (o_const_data_to_external      ),
	.o_const_data_a                 (o_const_data_a                ),
	.o_const_data_b                 (o_const_data_b                )
	//    .CONST_DATA_TO_PE_ARRAY_SOUTH (CONST_DATA_TO_PE_ARRAY_SOUTH),
	//    .CONST_DATA_TO_PE_ARRAY_EAST  (CONST_DATA_TO_PE_ARRAY_EAST ),
	//    .CONST_DATA_TO_PE_ARRAY_WEST  (CONST_DATA_TO_PE_ARRAY_WEST )
);
endmodule
