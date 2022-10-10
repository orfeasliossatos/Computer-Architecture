vsim -t ps disp_driver
add wave *;

#TEST 1: 5.50
#output : whole_disp = 10110111, frac_disp_u = 10110110, frac_disp_u = 11111100
#force num 0000001011000000 0
#force en 1 0

#TEST 2: 
#output : whole_disp = 11011011, frac_disp_u = 10111110, frac_disp_u = 11011010
#force num 0000000101010000 0
#force en 1 0

#TEST 3: 2.52
#output : whole_disp = 11011011, frac_disp_u = 10111110, frac_disp_u = 11011010
force num 0000000101010000 0
force en 1 0

run 1000
