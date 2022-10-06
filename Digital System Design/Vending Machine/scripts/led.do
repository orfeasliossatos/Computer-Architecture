vsim -t ps led_driver
add wave *

force msg 110 0
force progress_led 1 0 

run 550
