.data
start_date: .asciiz "2019-01-08"
end_date: .asciiz "8410-09-08"

.text
.globl main
main:
la $a0, start_date
la $a1, end_date
jal datestring_to_num_days

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1 
syscall
li $v0, 10
syscall

.include "hwk4.asm"

