.data
.align 2
n: .word 7
.align 2
src: .ascii "ABCDEFGHIJ"
.align 2
dest: .ascii "XXXXXXX"

.text
.globl main
main:
la $a0,  dest
la $a1,  src
lw $a2,  n
jal memcpy

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1
syscall
la $a0, dest
li $v0, 4
syscall
li $v0, 10
syscall

.include "hwk4.asm"
