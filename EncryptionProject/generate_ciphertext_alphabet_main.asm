.data
ciphertext_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"
keyphrase: .ascii "suPeRcalIfrAgiListICexPiaLIdoCIOus\0"
new_line_char: .asciiz "\n"

.text
.globl main
main:
	la $a0, ciphertext_alphabet
	la $a1, keyphrase
	jal generate_ciphertext_alphabet
	
	# You must write your own code here to check the correctness of the function implementation.
	move $a0, $v0
	li $v0, 1
	syscall 
	la $a0, new_line_char
    	li $v0, 4
    	syscall 
	la $a0, ciphertext_alphabet 
   	li $v0, 4
    	syscall
	li $v0, 10
	syscall
	
.include "hwk2.asm"
