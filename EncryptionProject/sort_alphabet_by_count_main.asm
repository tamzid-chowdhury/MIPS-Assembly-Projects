.data
sorted_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka"
counts: .word 23 26 29 1 20 9 15 30 24 20 23 7 17 15 5 4 17 14 12 24 14 1 0 4 14 33

.text
.globl main
main:
	la $a0, sorted_alphabet
	la $a1, counts
	jal sort_alphabet_by_count
	
	# You must write your own code here to check the correctness of the function implementation.
	la $a0, sorted_alphabet
   	li $v0, 4
    	syscall
	li $v0, 10
	syscall
	
.include "hwk2.asm"
