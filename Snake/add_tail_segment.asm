.data
direction: .byte 'R'
tail_row: .byte 4
tail_col: .byte 8
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 1  # head_row
.byte 5  # head_col
.byte 7  # length
# Game grid:
.asciiz ".............a.#.1..#......#.2..#......#.3..#........4567..."

.text
.globl main
main:
la $a0, state
lbu $a1, direction
lb $a2, tail_row
lb $a3, tail_col
jal add_tail_segment


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
