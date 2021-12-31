# Add a book to a hash table with existing values; no collisions
.data
isbn: .asciiz "9781620610090"
title: .asciiz "Opal (Lux, #3)"
author: .asciiz "Jennifer L. Armentrout"
books:
.align 2
.word 9 4 68
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# Book struct start
.align 2
.ascii "9780446695660\0"
.ascii "Double Whammy\0\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Carl Hiaasen\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# Book struct start
.align 2
.ascii "9780553214830\0"
.ascii "The Declaration of Indep\0"
.ascii "Founding Fathers\0\0\0\0\0\0\0\0\0"
.word 14
# Book struct start
.align 2
.ascii "9788433914260\0"
.ascii "Hollywood\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Charles Bukowski\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780345527780\0"
.ascii "Wicked Business (Lizzy &\0"
.ascii "Janet Evanovich\0\0\0\0\0\0\0\0\0\0"
.word 0
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 



.text
.globl main
main:
la $a0, books
la $a1, isbn
la $a2, title
la $a3, author
jal add_book

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1 
syscall 
move $a0, $v1
syscall 
li $v0, 10
syscall

.include "hwk4.asm"

