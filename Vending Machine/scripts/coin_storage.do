vsim -t ps coin_storage
add wave fault count sum

force en 0 0, 1 40
force add_coin 0 0, 1 40, 0 100, 1 160, 0 240
force rem_coin 0 0, 1 100, 0 160
force coin_type 10000 0, 00010 100, 10000 160

force reset 1 0, 0 25
force clk 1 0, 0 10 -repeat 20

run 1000
