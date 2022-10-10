    ;;    game state memory location
    .equ CURR_STATE, 0x1000              ; current game state
    .equ GSA_ID, 0x1004                     ; gsa currently in use for drawing
    .equ PAUSE, 0x1008                     ; is the game paused or running
    .equ SPEED, 0x100C                      ; game speed
    .equ CURR_STEP,  0x1010              ; game current step
    .equ SEED, 0x1014              ; game seed
    .equ GSA0, 0x1018              ; GSA0 starting address
    .equ GSA1, 0x1038              ; GSA1 starting address
    .equ SEVEN_SEGS, 0x1198             ; 7-segment display addresses
    .equ CUSTOM_VAR_START, 0x1200 ; Free range of addresses for custom variable definition
    .equ CUSTOM_VAR_END, 0x1300
    .equ LEDS, 0x2000                       ; LED address
    .equ RANDOM_NUM, 0x2010          ; Random number generator address
    .equ BUTTONS, 0x2030                 ; Buttons addresses

    ;; states
    .equ INIT, 0
    .equ RAND, 1
    .equ RUN, 2

    ;; constants
    .equ N_SEEDS, 4
    .equ N_GSA_LINES, 8
    .equ N_GSA_COLUMNS, 12
    .equ MAX_SPEED, 10
    .equ MIN_SPEED, 1
    .equ PAUSED, 0x00
    .equ RUNNING, 0x01

; BEGIN:clear_leds
clear_leds:
	addi t0, zero, LEDS ; LEDS Address
	stw zero, 0(t0) ; Address 2000
	stw zero, 4(t0) ; Address 2004
	stw zero, 8(t0) ; Address 2008
	ret
; END:clear_leds

; BEGIN:set_pixel
set_pixel:
	addi t4, zero, LEDS ; LEDS Address

	andi t0, a0, 3 ; x mod 4
	slli t0, t0, 3 ; (x mod 4) * 8
	add  t0, t0, a1 ; (x mod 4) * 8 + y (LED bit number)

	addi t2, zero, 1 ; a single bit to be shifted t0 times
	sll t2, t2, t0 ; LED bit to be activated

	addi t1, zero, 4 ; if x < 4 then set bit t0 of LEDS[0] to 1  
	blt a0, t1, less_than_four 
	less_than_four:
		ldw t5, 0(t4)
		or t5, t5, t2
		stw t5, 0(t4)
		jmpi done

	addi t1, zero, 8 ; if x < 8 then set bit t0 of LEDS[1] to 1
	blt a0, t1, less_than_eight ; (x < 8) ? 1 : 0
	less_than_eight:
		ldw t5, 4(t4)
		or t5, t5, t2
		stw t5, 4(t4)
		jmpi done

	addi t1, zero, 12 ; if x < 12 then set bit t0 of LEDS[2] to 1
	blt a0, t1, less_than_twelve ; (x < 8) ? 1 : 0
	less_than_twelve:
		ldw t5, 8(t4)
		or t5, t5, t2
		stw t5, 8(t4)
		jmpi done

	done:
ret
; END:set_pixel

; BEGIN:wait
wait:
	addi t0, zero, 1 ; 1
	slli t1, t1, 19 ; 2^19
	
	addi t2, zero, SPEED ; game_speed register
	ldw t2, 0(t2) ; game_speed
	sll t3, t0, t2	; decrement 2^(game_speed - 1) 
	srli t3, t3, 1 
	count_loop: ; count from 2^19 to 0 by increments of t3
		sub t1, t1, t3
		bge t1, zero, count_loop 
ret
; END:wait

; BEGIN:random_gsa
random_gsa:
	
; you can access masks(4) and and it to the right gsa.
ret
; END:random_gsa

main:
    ;; TODO
	


font_data:
    .word 0xFC ; 0
    .word 0x60 ; 1
    .word 0xDA ; 2
    .word 0xF2 ; 3
    .word 0x66 ; 4
    .word 0xB6 ; 5
    .word 0xBE ; 6
    .word 0xE0 ; 7
    .word 0xFE ; 8
    .word 0xF6 ; 9
    .word 0xEE ; A
    .word 0x3E ; B
    .word 0x9C ; C
    .word 0x7A ; D
    .word 0x9E ; E
    .word 0x8E ; F

seed0:
    .word 0xC00
    .word 0xC00
    .word 0x000
    .word 0x060
    .word 0x0A0
    .word 0x0C6
    .word 0x006
    .word 0x000

seed1:
    .word 0x000
    .word 0x000
    .word 0x05C
    .word 0x040
    .word 0x240
    .word 0x200
    .word 0x20E
    .word 0x000

seed2:
    .word 0x000
    .word 0x010
    .word 0x020
    .word 0x038
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000

seed3:
    .word 0x000
    .word 0x000
    .word 0x090
    .word 0x008
    .word 0x088
    .word 0x078
    .word 0x000
    .word 0x000


    ;; Predefined seeds
SEEDS:
    .word seed0
    .word seed1
    .word seed2
    .word seed3

mask0:
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000

mask1:
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0xE00
    .word 0xE00
    .word 0xE00

mask2:
    .word 0x800
    .word 0x800
    .word 0x800
    .word 0x800
    .word 0x800
    .word 0x800
    .word 0x800
    .word 0x800

mask3:
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0xFFF

mask4:
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0x000
    .word 0xFFF

MASKS:
    .word mask0
    .word mask1
    .word mask2
    .word mask3
    .word mask4
