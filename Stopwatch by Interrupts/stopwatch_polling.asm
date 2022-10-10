.equ    RAM, 0x1000
.equ    LEDs, 0x2000
.equ    TIMER, 0x2020
.equ    BUTTON, 0x2030

.equ    LFSR, RAM

; Variable initialization for spend_time
addi t0, zero, 18
stw t0, LFSR(zero)

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; DO NOT CHANGE ANYTHING ABOVE THIS LINE
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

; WRITE YOUR CODE AND CONSTANT DEFINITIONS HERE
main:
	addi sp, sp, LEDs		; init stack pointer

	; 100ms counter
	addi t2, zero, 0		

	; cycle counter
	addi t0, zero, 0		; cycle counter

	; cycle max (5 million)
	addi t1, zero, 0x4C		; load upper immediate
	slli t1, t1, 16
	addi t1, t1, 0x4B40		; load lower immediate
		
	main_loop:
	
		
		cycle_loop:
			addi t0, t0, 18					; 3 

			; if button(0) is pressed call spend_time
			ldw t3, (BUTTON+4)(zero) 		; 4
			andi t3, t3, 1					; 3 
			beq t3, zero, dont_spend_time 	; 4 
			
			; reset edge_capture
			stw zero, (BUTTON+4)(zero) 		; 4

			addi sp, sp, -16	; 3
			stw ra, 12(sp)		; 4
			stw t0, 8(sp)		; 4
			stw t1, 4(sp)		; 4
			stw t2, 0(sp)		; 4

			call spend_time		; 4

			ldw t2, 0(sp)		; 4
			ldw t1, 4(sp)		; 4
			ldw t0, 8(sp)		; 4
			ldw ra, 12(sp)		; 4
			addi sp, sp, 16		; 3

			addi t0, t0, 46		; calling spend_time


			ldw t4, LFSR(zero)	; special number stored here...
			slli t4, t4, 15
			addi t5, zero, 1
			slli t5, t5, 22
			add t4, t4, t5	

			; there are 7 * t4 cycles spent in spend_time
			add t0, t0, t4		 
			add t0, t0, t4		 
			add t0, t0, t4		 
			add t0, t0, t4		 
			add t0, t0, t4		 
			add t0, t0, t4		 
			add t0, t0, t4		

			dont_spend_time:

			blt  t0, t1, cycle_loop ; 4 cycles

		; 100ms have gone by (5 million cycles)
		; "cash in" our cycles
		cash_in_cycles:
			addi t2, t2, 1	
			sub t0, t0, t1
			bge t0, t1, cash_in_cycles		

		addi sp, sp, -16
		stw ra, 12(sp)
		stw t0, 8(sp)
		stw t1, 4(sp)
		stw t2, 0(sp)

		addi a0, t2, 0
		call display

		ldw t2, 0(sp)
		ldw t1, 4(sp)
		ldw t0, 8(sp)
		ldw ra, 12(sp)
		addi sp, sp, 16

		br main_loop
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; DO NOT CHANGE ANYTHING BELOW THIS LINE
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; ----------------- Common functions --------------------
; a0 = tenths of second
display:
    addi   sp, sp, -20
    stw    ra, 0(sp)
    stw    s0, 4(sp)
    stw    s1, 8(sp)
    stw    s2, 12(sp)
    stw    s3, 16(sp)
    add    s0, a0, zero
    add    a0, zero, s0
    addi   a1, zero, 600
    call   divide
    add    s0, zero, v0
    add    a0, zero, v1
    addi   a1, zero, 100
    call   divide
    add    s1, zero, v0
    add    a0, zero, v1
    addi   a1, zero, 10
    call   divide
    add    s2, zero, v0
    add    s3, zero, v1

    slli   s3, s3, 2
    slli   s2, s2, 2
    slli   s1, s1, 2
    ldw    s3, font_data(s3)
    ldw    s2, font_data(s2)
    ldw    s1, font_data(s1)

    xori   t4, zero, 0x8000
    slli   t4, t4, 16
    add    t5, zero, zero
    addi   t6, zero, 4
    minute_loop_s3:
    beq    zero, s0, minute_end
    beq    t6, t5, minute_s2
    or     s3, s3, t4
    srli   t4, t4, 8
    addi   s0, s0, -1
    addi   t5, t5, 1
    br minute_loop_s3

    minute_s2:
    xori   t4, zero, 0x8000
    slli   t4, t4, 16
    add    t5, zero, zero
    minute_loop_s2:
    beq    zero, s0, minute_end
    beq    t6, t5, minute_s1
    or     s2, s2, t4
    srli   t4, t4, 8
    addi   s0, s0, -1
    addi   t5, t5, 1
    br minute_loop_s2

    minute_s1:
    xori   t4, zero, 0x8000
    slli   t4, t4, 16
    add    t5, zero, zero
    minute_loop_s1:
    beq    zero, s0, minute_end
    beq    t6, t5, minute_end
    or     s1, s1, t4
    srli   t4, t4, 8
    addi   s0, s0, -1
    addi   t5, t5, 1
    br minute_loop_s1

    minute_end:
    stw    s1, LEDs(zero)
    stw    s2, LEDs+4(zero)
    stw    s3, LEDs+8(zero)

    ldw    ra, 0(sp)
    ldw    s0, 4(sp)
    ldw    s1, 8(sp)
    ldw    s2, 12(sp)
    ldw    s3, 16(sp)
    addi   sp, sp, 20

    ret

flip_leds:
    addi t0, zero, -1
    ldw t1, LEDs(zero)
    xor t1, t1, t0
    stw t1, LEDs(zero)
    ldw t1, LEDs+4(zero)
    xor t1, t1, t0
    stw t1, LEDs+4(zero)
    ldw t1, LEDs+8(zero)
    xor t1, t1, t0
    stw t1, LEDs+8(zero)
    ret

spend_time:
    addi sp, sp, -4
    stw  ra, 0(sp)
    call flip_leds
    ldw t1, LFSR(zero)
    add t0, zero, t1
    srli t1, t1, 2
    xor t0, t0, t1
    srli t1, t1, 1
    xor t0, t0, t1
    srli t1, t1, 1
    xor t0, t0, t1
    andi t0, t0, 1
    slli t0, t0, 7
    srli t1, t1, 1
    or t1, t0, t1
    stw t1, LFSR(zero)
    slli t1, t1, 15
    addi t0, zero, 1
    slli t0, t0, 22
    add t1, t0, t1

spend_time_loop:
    addi   t1, t1, -1
    bne    t1, zero, spend_time_loop
    
    call flip_leds
    ldw ra, 0(sp)
    addi sp, sp, 4

    ret

; v0 = a0 / a1
; v1 = a0 % a1
divide:
    add    v0, zero, zero
divide_body:
    add    v1, a0, zero
    blt    a0, a1, end
    sub    a0, a0, a1
    addi   v0, v0, 1
    br     divide_body
end:
    ret



font_data:
    .word 0x7E427E00 ; 0
    .word 0x407E4400 ; 1
    .word 0x4E4A7A00 ; 2
    .word 0x7E4A4200 ; 3
    .word 0x7E080E00 ; 4
    .word 0x7A4A4E00 ; 5
    .word 0x7A4A7E00 ; 6
    .word 0x7E020600 ; 7
    .word 0x7E4A7E00 ; 8
    .word 0x7E4A4E00 ; 9
    .word 0x7E127E00 ; A
    .word 0x344A7E00 ; B
    .word 0x42423C00 ; C
    .word 0x3C427E00 ; D
    .word 0x424A7E00 ; E
    .word 0x020A7E00 ; F
