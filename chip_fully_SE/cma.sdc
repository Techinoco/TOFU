# クロックの定義
create_clock  {CLK} -name CLK -period 1200 -waveform {0  600}
# クロックの立ち上がりから入力が遷移するまでの遅延の定義
set_input_delay 1 -clock CLK [all_inputs]
# クロックのエッジに対して出力の余裕
set_output_delay 1 -clock CLK [all_outputs]
# 入力をドライブするセルの定義 INVXD
set_driving_cell -library $UMLIBRARY -lib_cell LE8UMINVCLXD -pin YB [all_inputs]
# 出力につく容量 INVDx4
set_load [expr 4 * [load_of [get_lib_pins $UMLIBRARY/LE8UMINVCLXD/A]]] [all_outputs]
