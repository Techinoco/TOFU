# クロックの定義
set sdc_version 1.9
set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions DEFAULT -library $UMLIBRARY
set_max_fanout 10 [current_design]
create_clock -name CLK -period 2000 -waveform {0  1000}
# クロックの立ち上がりから入力が遷移するまでの遅延の定義
set_input_delay 1 -clock CLK [all_inputs]
# クロックのエッジに対して出力の余裕
set_output_delay 1 -clock CLK [all_outputs]
# 入力をドライブするセルの定義 INVXD
set_driving_cell -library $UMLIBRARY -lib_cell LE8UMINVCLXD [all_inputs]
set_false_path -through [list CONF*]

#set_false_path -through [list ROW_00/*WEST*]
#set_false_path -through [list ROW_00/*EAST*]
#set_false_path -through [list ROW_01/*WEST*]
#set_false_path -through [list ROW_01/*EAST*]
#set_false_path -through [list ROW_02/*WEST*]
#set_false_path -through [list ROW_02/*EAST*]
#set_false_path -through [list ROW_03/*WEST*]
#set_false_path -through [list ROW_03/*EAST*]
#set_false_path -through [list ROW_04/*WEST*]
#set_false_path -through [list ROW_04/*EAST*]
#set_false_path -through [list ROW_05/*WEST*]
#set_false_path -through [list ROW_05/*EAST*]
#set_false_path -through [list ROW_06/*WEST*]
#set_false_path -through [list ROW_06/*EAST*]
#set_false_path -through [list ROW_07/*WEST*]
#set_false_path -through [list ROW_07/*EAST*]
current_design "ROW"
set_false_path -through [list *WEST*]
set_false_path -through [list *EAST*]
current_design "PE_ARRAY"


set_load -pin_load 0 [all_outputs]
# 出力につく容量 INVDx4
#set_load [expr 4 * [load_of [get_lib_pins $UMLIBRARY/LE8UMINVCLXD/A]]] [all_outputs]
