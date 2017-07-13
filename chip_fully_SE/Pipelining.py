# -*- coding: utf-8 -*-

import sys

argvs = sys.argv

if len(argvs) == 1 or len(argvs) >= 3:
    print "error"
    sys.exit(1)
else:
    reg_num = argvs[1]
    PE_num_max = 8
    reg_pos_interval = PE_num_max / (int(reg_num) + 1)
    out_name = "COL_reg" + reg_num + ".v"
    origin_f = open("COL.v","r")
    out_f = open(out_name,"w")
    input_clk_rst_n = """  input clk,
  input rst_n,
"""

    CONF_ALUs = []
    MSB = 0
    for LSB in range(0,31,4)[::-1]:
        MSB = int(LSB) + 3
        CONF_ALUs.append(".CONF_ALU (CONF_ALU[" + str(MSB) + ":" + str(LSB) + "]),")

    CONF_SEL_As = []
    CONF_SEL_Bs = []
    for LSB in range(0,23,3)[::-1]:
        MSB = int(LSB) + 2
        CONF_SEL_As.append(".CONF_SEL_A (CONF_SEL_A[" + str(MSB) + ":" + str(LSB) + "]),")
        CONF_SEL_Bs.append(".CONF_SEL_B (CONF_SEL_B[" + str(MSB) + ":" + str(LSB) + "]),")

    CONF_SEs = []
    for LSB in range(0,79,10)[::-1]:
        MSB = int(LSB) + 9
        CONF_SEs.append(".CONF_SE (CONF_SE[" + str(MSB) + ":" + str(LSB) + "]),")

    IN_NORTHs = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 7:
            IN_NORTHs.append(".IN_NORTH (PE_OUT_07),")
        else:
            MSB = "0" + str(PE_num + 1)
            LSB = "0" + str(PE_num)
            IN_NORTHs.append(".IN_NORTH (PE_" + str(MSB) + "_" + str(LSB) + "_A),")

    IN_SOUTHs = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 0:
            IN_SOUTHs.append(".IN_SOUTH (IN_SOUTH),")
        else:
            MSB = "0" + str(PE_num - 1)
            LSB = "0" + str(PE_num)
            IN_SOUTHs.append(".IN_SOUTH (PE_" + str(MSB) + "_" + str(LSB) + "_A),")
        
    IN_EASTs = []
    IN_WESTs = []
    IN_DL_Ws = []
    IN_CONST_As = []
    IN_CONST_Bs = []
    OUT_EASTs = []
    OUT_WESTs = []
    OUT_DL_Es = []
    for LSB in range(0,199,25)[::-1]:
        MSB = int(LSB) + 24
        IN_EASTs.append(".IN_EAST (IN_EAST[" + str(MSB) + ":" + str(LSB) + "]),")
        IN_WESTs.append(".IN_WEST (IN_WEST[" + str(MSB) + ":" + str(LSB) + "]),")
        IN_DL_Ws.append(".IN_DL_W (IN_DL_W[" + str(MSB) + ":" + str(LSB) + "]),")
        IN_CONST_As.append(".IN_CONST_A (IN_CONST_A[" + str(MSB) + ":" + str(LSB) + "]),")
        IN_CONST_Bs.append(".IN_CONST_B (IN_CONST_B[" + str(MSB) + ":" + str(LSB) + "]),")
        OUT_EASTs.append(".OUT_EAST (OUT_EAST[" + str(MSB) + ":" + str(LSB) + "]),")
        OUT_WESTs.append(".OUT_WEST (OUT_WEST[" + str(MSB) + ":" + str(LSB) + "]),")
        OUT_DL_Es.append(".OUT_DL_E (OUT_DL_E[" + str(MSB) + ":" + str(LSB) + "]),")
        
    IN_DL_Ss = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 0:
            IN_DL_Ss.append(".IN_DL_S (IN_PE_00_DL_N),")
        else:
            MSB = "0" + str(PE_num - 1)
            LSB = "0" + str(PE_num)
            IN_DL_Ss.append(".IN_DL_S (PE_" + MSB + "_" + LSB + "_DL),")

    IN_DL_SSs = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 0:
            IN_DL_SSs.append(".IN_DL_SS (IN_PE_00_DL_NN),")
        elif PE_num == 1:
            IN_DL_SSs.append(".IN_DL_SS (IN_PE_01_DL_NN),")
        else:
            MSB = "0" + str(PE_num - 2)
            LSB = "0" + str(PE_num)
            IN_DL_SSs.append(".IN_DL_SS (PE_" + MSB + "_" + LSB + "_DL),")
    
    OUT_NORTHs = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 7:
            OUT_NORTHs.append(".OUT_NORTH (PE_07_OUT),")
        else:
            MSB = "0" + str(PE_num)
            LSB = "0" + str(PE_num + 1)
            OUT_NORTHs.append(".OUT_NORTH (PE_" + MSB + "_" + LSB + "_A),")

    OUT_SOUTHs = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 0:
            OUT_SOUTHs.append(".OUT_SOUTH (OUT_SOUTH),")
        else:
            MSB = "0" + str(PE_num)
            LSB = "0" + str(PE_num - 1)
            OUT_SOUTHs.append(".OUT_SOUTH (PE_" + MSB + "_" + LSB + "_A),")

    OUT_DL_Ns = []
    OUT_DL_NNs = []
    for PE_num in range(PE_num_max)[::-1]:
        if PE_num == 7:
            OUT_DL_Ns.append(".OUT_DL_N (PE_07_XX_DL),")
            OUT_DL_NNs.append(".OUT_DL_NN (PE_07_XX_DL_NN)")
        else:
            MSB = "0" + str(PE_num)
            LSB = "0" + str(PE_num + 1)
            OUT_DL_Ns.append(".OUT_DL_N (PE_" + MSB + "_" + LSB + "_DL),")
            if PE_num == 6:
                LSB = "XX"
            else:
                LSB = "0" + str(PE_num + 2)
            OUT_DL_NNs.append(".OUT_DL_NN (PE_" + MSB + "_" + LSB + "_DL)")

    for row in origin_f:
        if 'module COL' in row:
            out_f.write("module COL_reg" + str(reg_num) + " (\n")
            out_f.write(input_clk_rst_n)
        else:
            out_f.write(row)
        if 'assign PE_OUT_07' in row:
            out_f.write("\n")
            break
    origin_f.close()

    PEs = []
    flag = 0
    for PE_num in range(PE_num_max)[::-1]:
        if flag == 2:
            appended = "PE_withReg_allN PE" + str(PE_num)
        elif flag == 1:
            appended = "PE_withReg_onlyNN PE" + str(PE_num)
        else:
            appended = "PE PE" + str(PE_num)
        if not PE_num % reg_pos_interval:
            flag = 3
        flag -= 1
        PEs.append(appended)
    for PE in range(PE_num_max):
        out_f.write(PEs[PE])
        out_f.write(" ( \n")
        if 'Reg' in PEs[PE]:
            out_f.write(".clk (clk),\n.rst_n (rst_n),\n")
        out_f.write(CONF_ALUs[PE])
        out_f.write("\n")
        out_f.write(CONF_SEL_As[PE])
        out_f.write("\n")
        out_f.write(CONF_SEL_Bs[PE])
        out_f.write("\n")
        out_f.write(CONF_SEs[PE])
        out_f.write("\n\n")

        out_f.write(IN_NORTHs[PE])
        out_f.write("\n")
        out_f.write(IN_SOUTHs[PE])
        out_f.write("\n")
        out_f.write(IN_EASTs[PE])
        out_f.write("\n")
        out_f.write(IN_WESTs[PE])
        out_f.write("\n")
        out_f.write(IN_DL_Ss[PE])
        out_f.write("\n")
        out_f.write(IN_DL_Ws[PE])
        out_f.write("\n")
        out_f.write(IN_DL_SSs[PE])
        out_f.write("\n")
        out_f.write(IN_CONST_As[PE])
        out_f.write("\n")
        out_f.write(IN_CONST_Bs[PE])
        out_f.write("\n\n")

        out_f.write(OUT_NORTHs[PE])
        out_f.write("\n")
        out_f.write(OUT_SOUTHs[PE])
        out_f.write("\n")
        out_f.write(OUT_EASTs[PE])
        out_f.write("\n")
        out_f.write(OUT_WESTs[PE])
        out_f.write("\n")
        out_f.write(OUT_DL_Ns[PE])
        out_f.write("\n")
        out_f.write(OUT_DL_Es[PE])
        out_f.write("\n")
        out_f.write(OUT_DL_NNs[PE])
        out_f.write("\n")
        out_f.write(");\n\n")

    out_f.write("endmodule")
    out_f.close()
        
