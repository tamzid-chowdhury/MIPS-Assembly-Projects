# Get the last card in the list
.data
index: .word 7
.align 2
card_list:
.word 8  # list's size
.word node85405 # address of list's head
node930524:
.word 6574898
.word node968934
node265857:
.word 7689011
.word node930524
node45000:
.word 6572086
.word node38905
node870030:
.word 6572083
.word 0
node579585:
.word 7685168
.word node45000
node85405:
.word 6574898
.word node579585
node38905:
.word 7684917
.word node265857
node968934:
.word 7684912
.word node870030


space: .asciiz " "

.text
.globl main
main:
la $a0, card_list
lw $a1, index
jal get_card

# Write code to check the correctness of your code!
move $a0, $v0 
li $v0, 1
syscall
la $a0, space
li $v0, 4
syscall
move $a0, $v1
li $v0, 1 
syscall
li $v0, 10
syscall

.include "hwk5.asm"
