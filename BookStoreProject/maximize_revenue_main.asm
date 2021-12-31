
.data
num_sales: .word 9
.align 2
sales_list:
# BookSale struct start
.align 2
.ascii "0845558347906\0"
.byte 0 0
.word 65818
.word 1620
.word 82
# BookSale struct start
.align 2
.ascii "5577045702462\0"
.byte 0 0
.word 91689
.word 1951
.word 154
# BookSale struct start
.align 2
.ascii "6354780489355\0"
.byte 0 0
.word 94530
.word 1579
.word 60
# BookSale struct start
.align 2
.ascii "1999320995468\0"
.byte 0 0
.word 93964
.word 1715
.word 225
# BookSale struct start
.align 2
.ascii "0145174318443\0"
.byte 0 0
.word 41570
.word 1195
.word 232
# BookSale struct start
.align 2
.ascii "5871544817889\0"
.byte 0 0
.word 57193
.word 1139
.word 387
# BookSale struct start
.align 2
.ascii "7106045480035\0"
.byte 0 0
.word 48631
.word 1282
.word 414
# BookSale struct start
.align 2
.ascii "1730871923235\0"
.byte 0 0
.word 39311
.word 1399
.word 78
# BookSale struct start
.align 2
.ascii "8122589552824\0"
.byte 0 0
.word 60637
.word 1888
.word 497


.text
.globl main
main:
la $a0, sales_list
lw $a1, num_sales
jal maximize_revenue

# Write code to check the correctness of your code!
move $a0, $v0 
li $v0, 1 
syscall 
li $v0, 10
syscall

.include "hwk4.asm"
