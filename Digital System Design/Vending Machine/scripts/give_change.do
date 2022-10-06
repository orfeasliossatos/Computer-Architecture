vsim -t ps storage_ctl
add wave clk
add wave reset 
add wave price
add wave insert_coin
add wave s_curr_insert_sum
add wave in_coin_type
add wave cptr
add wave temp_storage_en
add wave temp_storage_add_coin

#TEST TASK 1

force clk 1 0, 0 10 -repeat 20
force reset 1 0, 0 25
force insert_coin 0 0, 1 30
force in_coin_type 10000 0, 01000 30, 00100 60, 00010 80, 00001 100

run 1000
