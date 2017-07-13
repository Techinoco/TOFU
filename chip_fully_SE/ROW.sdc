# クロックの定義
create_clock  {CLK} -name CLK -period 10 -waveform { 0  5 }
# クロックの立ち上がりから入力が遷移するまでの遅延の定義
#set_input_delay 5 -clock CLK {IN LD RST}
# クロックのエッジに対して出力の余裕
#set_output_delay 1 -clock CLK [all_outputs]
# 入力をドライブするセルの定義 INVXD
set_driving_cell -library $ULLIBRARY -lib_cell LE8ULINVXD -pin YB [all_inputs]
current_design "ROW"
set_false_path -through [list CONF*]
set_false_path -through [list *WEST*]
set_false_path -through [list *EAST*]

set_load -pin_load 0 [all_outputs]
# 出力につく容量 INVDx4
#set_load [expr 4 * [load_of [get_lib_pins $ULLIBRARY/LE8ULINVCLXD/A]]] [all_outputs]
