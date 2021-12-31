.data
str: .ascii "UNIVERSITY\0"

.text
.globl main
main:
	la $a0, str
	jal to_lowercase

	# You must write your own code here to check the correctness of the function implementation.
	la $a0, str
   	li $v0, 4
    	syscall
	li $v0, 10
	syscall
	
.include "hwk2.asm"	
