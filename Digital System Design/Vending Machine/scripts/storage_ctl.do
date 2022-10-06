vsim -t ps storage_ctl

add wave *

force price 0000000011000000 0
force temp_storage_sum 0000000110011001 0
force temp_storage_count 00000 0, 00001 350, 00000 361, 00001 390, 00000 400

force cmd_served 0 0, 1 40, 0 170, 1 210, 0 330, 1 360, 0 480
force calc_change 0 0, 1 40, 0 170
force give_change 0 0, 1 220, 0 330
force merge_coins 0 0, 1 360, 0 480
force show_change 1 0
force clk 1 0, 0 10 -repeat 20
force reset 0 0, 1 10, 0 21

run 1000
