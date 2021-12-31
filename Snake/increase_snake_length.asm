.data
direction: .byte 'D'
.align 2
state:
.byte 8  # num_rows
.byte 14  # num_cols
.byte 4  # head_row
.byte 5  # head_col
.byte 13  # length
# Game grid:
.asciiz "....................##......................#........#....#..1234..#a.........56..D.......##.7..C..........89AB"

.text
.globl main
main:
la $a0, state
lbu $a1, direction
jal increase_snake_length
# You must write your own code here to check the correctness of the function implementation.
move $a0, $v0 
li $v0, 1
syscall 
li $v0, 4
la $a0, state
syscall 
li $v0, 10
syscall

.include "hwk3.asm"
