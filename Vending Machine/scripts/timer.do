vsim -t ps timer
add wave *

force clk 1 0, 0 5 -repeat 10
force clear 0 0, 1 5, 0 15
force timeout 00011 0
force en 1 0, 0 146, 1 166

run 550
