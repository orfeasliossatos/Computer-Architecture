vsim -t ps money_storage

add wave clk
add wave reset
add wave insert_coin
add wave calc_change
add wave give_change
add wave release_coins
add wave merge_coins
add wave in_coin_type
add wave price
add wave show_change
add wave zero
add wave negative
add wave cmd_served
add wave cmd_complete
add wave disp_on
add wave disp_sum
add wave change_count_2
add wave change_count_1
add wave change_count_05
add wave change_count_02

force clk 1 0, 0 10 -repeat 20
force reset 0 0, 0 30

force insert_coin 0 0, 1 50, 0 100
force calc_change 0 0, 1 150, 0 250
force give_change 0 0, 1 300, 0 400
force release_coins 0 0
force merge_coins 0 0, 1 450, 0 650

#1fr
force in_coin_type 00100 0
#1.5 fr
force price 0000000011000000 0 

force show_change 1 0

force cmd_served 0 0, 1 150, 0 250, 1 300, 0 400, 1 450, 0 650 

run 1000
