vsim -t ps main_fsm

add wave clk
add wave reset

add wave accept
add wave accept_clear
add wave cancel
add wave cancel_clear
add wave yes
add wave yes_clear
add wave no
add wave no_clear
add wave clear_choices

add wave in_coin_type
add wave drink_type

add wave available
add wave base_price
add wave final_price

add wave drink_type_o

add wave pour_cmd_served
add wave pour_cmd_complete

add wave zero
add wave negative

add wave insert_coin
add wave calc_change
add wave give_change
add wave release_coins
add wave merge_coins
add wave coin_type
add wave show_change

add wave money_cmd_served
add wave money_cmd_complete

add wave msg
add wave s_curr_state

####

force clk 1 0, 0 5 -repeat 10
force reset 0 0

force accept 0 0, 1 20, 0 30
force cancel 0 0
force yes 0 0
force no 0 0

force in_coin_type 00000 0
force drink_type 00000 0, 10000 40 

force available 0 0, 1 40
force base_price 0000000010000000 0

force pour_cmd_complete 0 0
force money_cmd_complete 0 0

force zero 0 0
force negative 0 0

run 400

