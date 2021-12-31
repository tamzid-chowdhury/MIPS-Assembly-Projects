.data
plaintext: .ascii "2WPlU0f6FQqkvvJz4eUDyKXvbmLf1Oxa5wozIGU06dOsF9WOUoIEljICyWDcaiDmbqZw"
ciphertext: .ascii "L7 e1iXTTAkT 9K MCu zFxsnGH x7 F2jxZEkT Gy7P0hDo iXTI, VCfk zFqTDhjj4kT jXKP in Mwm zFqsdKG q7 zXNOEkT VCnj Rk. -2eGTuD eAbcKSDt\0"
keyphrase: .ascii "What is the sum of 12 and 37? The answer, CLEARLY, is 49!\0"
corpus: .ascii "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way - in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.\0"
new_line_char: .asciiz "\n"
.text
.globl main
main:
 	la $a0, plaintext
	la $a1, ciphertext
	la $a2, keyphrase
	la $a3, corpus
	jal decrypt
	
	# You must write your own code here to check the correctness of the function implementation.

	move $a0, $v0 
	li $v0, 1
	syscall 
	la $a0, new_line_char
    	li $v0, 4
    	syscall 
	move $a0, $v1
	li $v0, 1
	syscall
	la $a0, new_line_char
    	li $v0, 4
    	syscall 
	la $a0, plaintext
    	li $v0, 4
    	syscall
	li $v0, 10
	syscall
.include "hwk2.asm"
