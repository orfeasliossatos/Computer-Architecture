.equ    RAM, 0x1000
.equ    LEDs, 0x2000
.equ    TIMER, 0x2020
.equ    BUTTON, 0x2030

.equ    LFSR, RAM

br main
br interrupt_handler

main:
    ; Variable initialization for spend_time
    addi t0, zero, 18
    stw t0, LFSR(zero)

; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; DO NOT CHANGE ANYTHING ABOVE THIS LINE
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    ; WRITE YOUR CONSTANT DEFINITIONS AND main HERE
	addi sp, zero, LEDs
	
	; PIE = processor interrupt-enable bit. Enables IRQs
	rdctl t0, ctl0		
	ori t0, t0, 0x1			
	wrctl ctl0, t0			; write 1 to PIE bit to enable IRQs

	; ienable register controls which interrupt inputs are considered
	rdctl t0, ctl3			
	ori t0, t0, 0x5
	wrctl ctl3, t0			; write enable irq0, irq2 for timer and buttons

	; We want the timer peripheral to run for 5'000'000 cycles
	addi t0, zero, 0x4C		; load upper immediate
	slli t0, t0, 16
	addi t0, t0, 0x4B3F		; load lower immediate	
	stw t0, TIMER+4(zero)	; assign 4'999'999 to timer counter period

	; Start the timer and allow the timer to output interrupts
	ldw t0, TIMER+8(zero)	
	ori t0, t0, 0xB 
	stw t0, TIMER+8(zero)	; set the START and ITO bits of the timer control register


	; 100ms counter now stored in at RAM address 0x1008
	stw zero, RAM+8(zero)
	
	; Infinite loop
	main_loop:

		br main_loop

interrupt_handler:	

	; Push everything used by IH on the stack
	addi sp, sp, -44
	stw a1, 36(sp)
	stw a0, 32(sp)
	stw ra, 28(sp)
	stw t6, 24(sp)
	stw t5, 20(sp)
	stw t4, 16(sp)
	stw t3, 12(sp)
	stw t2, 8(sp)
	stw t1, 4(sp)
	stw t0, 0(sp)

	; ipending
	rdctl t0, ctl4	

	; ISR routing: depending on the ipending bits perform different service routines	

	; Timer ISR (ipending[0])
	srli t1, t0, 0
	andi t1, t1, 1 		
	beq t1, zero, dont_call_timer_ISR

	; call timer_ISR
	addi sp, sp, -4
	stw t0, 0(sp)		
	call timer_ISR			
	ldw t0, 0(sp)
	addi sp, sp, 4

	dont_call_timer_ISR:


	; Buttons ISR (ipending[2])
	srli t1, t0, 2
	andi t1, t1, 1
	beq t1, zero, dont_call_buttons_ISR; if ipending[1] == 1 call buttons_ISR 

	; Call buttons_ISR
	call buttons_ISR

	dont_call_buttons_ISR:


	; retrieve everything from the stack
	ldw a1, 36(sp)
	ldw a0, 32(sp)
	ldw ra, 28(sp)
	ldw t6, 24(sp)
	ldw t5, 20(sp)
	ldw t4, 16(sp)
	ldw t3, 12(sp)
	ldw t2, 8(sp)
	ldw t1, 4(sp)
	ldw t0, 0(sp)
	addi sp, sp, 44

	addi ea, ea, -4
	eret		

timer_ISR:

	; Increment the counter
	ldw t0, RAM+8(zero)
	addi t0, t0, 1
	stw t0, RAM+8(zero)
	
	; Call display if i'm in buttons_ISR (RAM+4 contains 1)
	ldw t1, RAM+4(zero)
	bne t1, zero, dont_display

	addi sp, sp, -4
	stw ra, 0(sp)
	add a0, t0, zero
	call display
	ldw ra, 0(sp)
	addi sp, sp, 4

	dont_display:
	
	; ACK the IRQ by clearing timer status register
	stw zero, TIMER+12(zero)	

	ret

buttons_ISR: 
	ldw t0, BUTTON(zero)	; status register
	ldw t1, BUTTON+4(zero)	; edgecapter register

	; Get value of edgecapture[0] == falling_edge(button0)
	andi t2, t1, 1
	beq t2, zero, ignore_buttons_ISR

	; Call spend_time
	addi sp, sp, -16
	stw ra, 0(sp)
	stw t0, 4(sp)
	stw t1, 8(sp)
	stw ea, 12(sp)

	; Acknowledge the IRQ
	addi t0, zero, -1		; FFFF
	xori t0, t0, 0xF		; FFF0
	and t1, t1, t0			
	stw t1, BUTTON+4(zero) ; Write 0 to edgecapture[0..3] = t1[0..3] to clear the IRQs

	; This means "I am in buttons_ISR handler!"
	ldw t0, RAM+4(zero)
	ori t0, t0, 1
	stw t0, RAM+4(zero)

	; Disable IRQs for button presses. We don't want to call twice
	rdctl t0, ctl3			
	addi t0, zero, 0x1
	wrctl ctl3, t0			; write enable irq0 for timer 

	; We reactivate the PIE bit. Enables IRQs
	rdctl t0, ctl0		
	ori t0, t0, 0x1			
	wrctl ctl0, t0			; write 1 to PIE bit to enable IRQs

	call spend_time

	; We deactivate the PIE bit. This doesn't stop ipending, so they can be handled next time.
	rdctl t0, ctl0		
	addi t0, zero, 0			
	wrctl ctl0, t0			; write 0 to PIE bit to disable IRQs

	; Reenable IRQs for button presses. It's safe now.
	rdctl t0, ctl3			
	addi t0, zero, 0x5
	wrctl ctl3, t0			; write enable irq0, irq2 for timer and buttons

	; This means "I am not longer in buttons_ISR handler!"
	ldw t0, RAM+4(zero)
	xori t0, t0, 1
	stw t0, RAM+4(zero)

	ldw ea, 12(sp)
	ldw t1, 8(sp)
	ldw t0, 4(sp)
	ldw ra, 0(sp) 
	addi sp, sp, 12

	ignore_buttons_ISR:	

	ret
	


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

;	addi t1, zero, 2000
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
