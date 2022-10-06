vsim -t ps work.main_fsm
add wave *
force clk 1 0, 0 5 -repeat 10
force reset 0 0, 1 5, 0 15

force accept 0 0, 1 75, 0 85
force cancel 0 0
force yes 0 0, 1 205, 0 215
force no 0 0

force in_coin_type 01000 0, 00000 30
force drink_type 00000 0, 01000 149

force available 1 0
force base_price 0000000110000000 0

force money_cmd_complete 0 0, 1 250, 0 265

force zero 0 0
force negative 0 0

force pour_cmd_complete 0 0

run 700