.data
str: .ascii "MIPS\0"

.text
.globl main
main:
	la $a0, str
	jal strlen
	
	# You must write your own code here to check the correctness of the function implementation.
	move $a0, $v0
	li $v0, 1 
	syscall 
	li $v0, 10
	syscall
	
.include "hwk2.asm"
