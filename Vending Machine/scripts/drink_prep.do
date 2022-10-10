vsim -t ps drink_preparation
add wave *

force reset 1 0, 0 30
force drink_type 10000 0, 01000 1200
force cmd_served 0 0, 1 40, 0 1100, 1 1200


force clk 1 0, 0 10 -repeat 20

run 4000


