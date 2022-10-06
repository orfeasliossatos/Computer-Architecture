vsim -t ps debouncer
add wave *

force clk 1 0, 0 10 -repeat 20
force button 0 0, 1 20, 0 22, 1 24, 0 28, 1 30, 0 40
force clear 0 0

run 550
