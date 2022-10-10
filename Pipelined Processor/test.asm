main:
addi t1, zero, zero
nop
nop
nop
nop
nop
loop:
ldw t0, 0x2030(zero)
nop
nop
nop
andi t0, t0, 1
nop 
nop
nop
beq t0, zero, loop
nop
nop
addi t1, t1, 1
nop
nop
stw t1, 0x2000(zero)
br loop
nop
nop