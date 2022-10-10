vsim -t ps storage_ctl
add wave clk
add wave reset
add wave price
add wave s_change
add wave zero
add wave negative
add wave cmd_served
add wave cmd_complete
add wave calc_change
add wave s_curr_coin
add wave s_curr_change_sum
add wave s_curr_change_count_2
add wave disp_on
add wave disp_sum
add wave change_count_2
add wave change_count_1
add wave change_count_05
add wave change_count_02 

# cmd_complete must be 1 at the end of each test

# TEST 1 (negative)
# expected output : disp_sum = Undefined, negative = 1, zero = 0, change_count = 0 (for each type of coin)
force price 0000000011000000 0
force temp_storage_sum 0000000001000000 0

#TEST 2 (zero)
# expected output : disp_sum = 0, negative = 0, zero = 1, change_count = 0 (for each type of coin)
#force price 0000000011000000 0
#force temp_storage_sum 0000000011000000 0

#TEST 3 (normal)
# expected output : disp_sum = 0000000111000000, negative = 0, zero = 0, change_count :(2f: 1, 1f: 1, 05f: 1, 02f: 0)
#force price 0000000011000000 0
#force temp_storage_sum 0000001010000000 0


#TEST 4 (normal 2)
# expected output : disp_sum = 0000000011011001, negative = 0, zero = 0, change_count :(2f: 0, 1f: 1, 05f: 1, 02f: 1)
force price 0000000011000000 0
force temp_storage_sum 0000000110011001 0

force reset 1 0, 0 25
force cmd_served 0 0, 1 30
force show_change 1 0
force calc_change 0 0, 1 30
force clk 1 0, 0 10 -repeat 20

run 1000
