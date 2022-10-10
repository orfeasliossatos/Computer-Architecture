.equ LEDS, 0x2000
.equ TIMER, 0x2020
.equ BUTTONS, 0x2030

_start:
	br main					; first instruction line must jump to main
interrupt_handler:			; Nios II sim assumes interrupt handler starts at 0x0004

	; Push everything used by IH on the stack
	addi sp, sp, -24
	stw ra, 20(sp)
	stw t4, 16(sp)
	stw t3, 12(sp)
	stw t2, 8(sp)
	stw t1, 4(sp)
	stw t0, 0(sp)			

	rdctl t0, ctl4			; t0 contains ipending bits at time of exception
	addi sp, sp, -4
	stw t0, 0(sp)			; save the ipending bits

	; ISR routing: depending on the ipending bits perform different service routines	

	; Timer ISR (ipending[0])
	srli t1, t0, 0
	andi t1, t1, 1 		
	beq t1, zero, dont_call_timer_ISR
	call timer_ISR			; if ipending[0] == 1 call timer_ISR
	dont_call_timer_ISR:

	ldw t0, 0(sp)			; restore ipending bits to t0
	addi sp, sp, 4		

	; Buttons ISR (ipending[2])
	srli t1, t0, 2
	andi t1, t1, 1
	beq t1, zero, dont_call_buttons_ISR; if ipending[1] == 1 call buttons_ISR 
	call buttons_ISR
	dont_call_buttons_ISR:

	; retrieve everything from the stack
	ldw ra, 20(sp)
	ldw t4, 16(sp)
	ldw t3, 12(sp)
	ldw t2, 8(sp)
	ldw t1, 4(sp)
	ldw t0, 0(sp)
	addi sp, sp, 24

	addi ea, ea, -4 		; correct the exception return address
	eret					; return from exception

timer_ISR:
	
	; Counter 2 incrementation
	ldw t0, LEDS+4(zero)
	addi t0, t0, 0x1	
	stw t0, LEDS+4(zero)	; increment the second counter

	; Clearing to timer's TO bit acknowledges the IRQ
	stw zero, TIMER+12(zero)	; clear TO to ack the IRQ 

	ret
	
buttons_ISR:
	ldw t0, BUTTONS(zero)	; status register
	ldw t1, BUTTONS+4(zero)	; edgecapter register
	
	; Button 0 
	andi t2, t0, 3			
	addi t3, zero, 3		
	beq t2, t3, do_nothing	; if both buttons pressed do nothing

	srli t2, t0, 0			
	andi t2, t2, 1			
	xori t2, t2, 1			; not(status[0])

	ldw t3, LEDS(zero)
	sub t3, t3, t2
	stw t3, LEDS(zero)		; decrement the first counter

	; Button 1
	srli t2, t0, 1
	andi t2, t2, 1
	xori t2, t2, 1			; not(status[1])

	ldw t3, LEDS(zero)
	add t3, t3, t2
	stw t3, LEDS(zero)		; increment the first counter
	
	; Buttons 2 and 3 do nothing.

	do_nothing:

	; Acknowledge the IRQs
	addi t4, zero, -1		; FFFF
	xori t4, t4, 0xF		; FFF0
	and t1, t1, t4			
	stw t1, BUTTONS+4(zero) ; Write 0 to edgecapture[0..3] = t1[0..3] to clear the IRQs
	ret

main:
	; perform setup	in order for the interrupt handler to work
	addi sp, zero, LEDS  	; initialize stack pointer

	; PIE = processor interrupt-enable bit. Enables IRQs
	rdctl t0, ctl0		
	ori t0, t0, 0x1			
	wrctl ctl0, t0			; write 1 to PIE bit to enable IRQs

	; ienable register controls which interrupt inputs are considered
	rdctl t0, ctl3			
	ori t0, t0, 0x5
	wrctl ctl3, t0			; write enable irq0, irq2 for timer and buttons

	; LEDs directly store their individual counters
	stw zero, LEDS(zero)
	stw zero, LEDS+4(zero)
	stw zero, LEDS+8(zero)	; starts counters from 0
	
	; We want the timer peripheral to run for 1000 cycles
	addi t0, zero, 999		
	stw t0, TIMER+4(zero)	; assign 999 to timer counter period

	; Start the timer and allow the timer to output interrupts
	ldw t0, TIMER+8(zero)	
	ori t0, t0, 0xB 
	stw t0, TIMER+8(zero)	; set the START and ITO bits of the timer control register

	ldw t0, LEDS+8(zero)
	main_loop:

		; Simple infinite counter loop
		addi t0, t0, 0x1	
		stw t0, LEDS+8(zero); increment the third counter

		br main_loop
