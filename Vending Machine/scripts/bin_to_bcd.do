vsim -t ps bin_to_bcd
add wave *

#TEST 1:
# expected output: l_bcd = 0110, u_bcd = 0010
force bin 00011010 0

#TEST 2:
# expected output: l_bcd = 0101, u_bcd = 0101
#force bin 00110111 0

run 1000
