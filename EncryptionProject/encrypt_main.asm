.data
ciphertext: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZEn0MO"
plaintext: .ascii "If debugging is the process of removing software bugs, then programming must be the process of putting them in. -Edsger Dijkstra\0"

keyphrase: .ascii "What is the sum of 12 and 37? The answer, CLEARLY, is 49!\0"
corpus: .ascii "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way - in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.\0"
new_line_char: .asciiz "\n"
.text
.globl main
main:
 	la $a0, ciphertext
	la $a1, plaintext
	la $a2, keyphrase
	la $a3, corpus
	jal encrypt
		
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
	la $a0, ciphertext
    	li $v0, 4
    	syscall
	li $v0, 10
	syscall
	
.include "hwk2.asm"
