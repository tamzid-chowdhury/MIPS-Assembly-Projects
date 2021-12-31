.data
isbn: .asciiz "9780316905750"
books:
.align 2
.word 7 7 68
# Book struct start, 0
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# Book struct start, 1
.align 2
.ascii "9780316905750\0"
.ascii "Moreta: Dragonlady of Pe\0"
.ascii "Anne McCaffrey\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start, 2
.align 2
.ascii "9781516865870\0"
.ascii "Beacon 23: The Complete \0"
.ascii "Hugh Howey\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start, 3
.align 2
.ascii "9780440060670\0"
.ascii "The Other Side of Midnig\0"
.ascii "Sidney Sheldon\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start, 4
.align 2
.ascii "9781573451990\0"
.ascii "Rumors of War (Children \0"
.ascii "Dean Hughes\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start, 5, start here
.align 2
.ascii "9780140168130\0"
.ascii "Big Sur\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Jack Kerouac, Aram Saroy\0"
.word 0
# Book struct start, 6
.align 2
.ascii "9780316934750\0"
.ascii "Out of My Mind\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Sharon M. Draper\0\0\0\0\0\0\0\0\0"
.word 0
.text
.globl main
main:
la $a0, books
la $a1, isbn
jal get_book

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1 
syscall 
move $a0, $v1
syscall 
li $v0, 10
syscall

.include "hwk4.asm"

