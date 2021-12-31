.data
counts: .word -890186 -438641 -817157 612618 -145953 -440997 -774137 758469 889951 834642 -919986 -204919 124497 179267 -303331 -285295 786955 -891155 -665164 -716764 -292806 176422 -299979 471550 -485856 -656536
message: .ascii "When in the Course of human events, it becomes necessary for one people to dissolve the political bands which have connected them with another, and to assume among the powers of the earth, the separate and equal station to which the Laws of Nature and of Nature's God entitle them, a decent respect to the opinions of mankind requires that they should declare the causes which impel them to the separation.\0"

.text
.globl main
main:
	la $a0, counts
	la $a1, message
	jal count_lowercase_letters

	# You must write your own code here to check the correctness of the function implementation.

	move $a0, $v0
	li $v0, 1 
	syscall 
	
	la $t1, counts
	li $t2, 0
	li $t3, 25
	

	loop_syscall: 
	lw $a0, 0($t1)
	beq $t2, $t3, done 
	syscall 
	addi $t1, $t1, 4 
	addi $t2, $t2,1
	j loop_syscall
	
	done: 
	li $v0, 10
	syscall
	
.include "hwk2.asm"
