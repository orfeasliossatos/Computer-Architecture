vsim -t ps machine
add wave -unsigned *

#first we do the reset (take into account that the clear is held for 1sec + 1clock cycle)
force clk 0 0, 1 1 -repeat 2
force reset 1 0, 0 2
force n_choice_buttons 11111
force n_accept_button 1
force n_cancel_button 1
run 50

#then we add the coins (1.70 francs normally)
force n_choice_buttons 11011 0, 11111 2, 11101 30, 11111 32, 11110 60, 11111 62
run 80

#then we end the insertion process of the coins
force n_accept_button 0 0, 1 2
run 15

#then we select the desired drink
force n_choice_buttons 01111 0, 11111 2
run 35

#then we say that we want to reuse our cup
#and we go to the change calculation process (should give back 0.50 francs)
force n_choice_buttons 01111 0, 11111 2
run 100

#then we say that we agree on the change
force n_choice_buttons 01111 0, 11111 2
run 50

#then we say that we don't want to donate the money
#and we go to the give_change process
#and then we go to the pouring process too
force n_choice_buttons 11110 0, 11111 2
run 200
