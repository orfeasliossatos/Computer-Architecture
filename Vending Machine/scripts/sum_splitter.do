vsim -t ps sum_splitter
add wave whole
add wave frac

#TEST 1:
#expected output: whole = 000000101, frac = 0011011
#force sum 0000001010100011 0

#TEST 2:
#expected output: whole = 000000000, frac = 1001011
force sum 0000000001100001 0

run 1000
