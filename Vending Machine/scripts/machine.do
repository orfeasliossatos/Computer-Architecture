vsim -t ps work.machine
add wave *

force clk 1 0, 0 5 -repeat 10
force reset 0 0, 1 5, 0 15
force n_choice_buttons 11111 0, 01111 45, 11111 55, 11011 155, 11111 165, 11110 185, 11111 195, 01111 245, 11111 255, 11110 295, 11111 305
force n_cancel_button 1 0
force n_accept_button 1 0, 0 95, 1 125
run 500