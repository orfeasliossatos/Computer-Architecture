vsim -t ps timed_button
add wave *

force clk 1 0, 0 5 -repeat 10
force clear 0 0, 1 80, 0 100, 1 310, 0 330
force button 0 0, 1 20, 0 30, 1 90, 0 150, 1 250, 0 260

run 550
