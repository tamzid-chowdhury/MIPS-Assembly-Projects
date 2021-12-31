# Column contains a partially face-down straight
.data
.align 2
col_num: .word 4
##### Board #####
.data
.align 2
board:
.word card_list97368 card_list530896 card_list929558 card_list417512 card_list524862 card_list529669 card_list934351 card_list203595 card_list242146 
# column #3
.align 2
card_list417512:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #0
.align 2
card_list97368:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #7
.align 2
card_list203595:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #8
.align 2
card_list242146:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #2
.align 2
card_list929558:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #6
.align 2
card_list934351:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #5
.align 2
card_list529669:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #4
.align 2
card_list524862:
.word 10  # list's size
.word node89234 # address of list's head
node357716:
.word 7689013
.word node581472
node563801:
.word 7689011
.word node139951
node139951:
.word 7689010
.word node974520
node332429:
.word 6574903
.word node87809
node87809:
.word 7689014
.word node357716
node581472:
.word 7689012
.word node563801
node629253:
.word 6574904
.word node332429
node933768:
.word 7689008
.word 0
node89234:
.word 6574905
.word node629253
node974520:
.word 7689009
.word node933768
# column #1
.align 2
card_list530896:
.word 0  # list's size
.word 0  # address of list's head (null)



.text
.globl main
main:
la $a0, board
lw $a1, col_num
jal clear_full_straight

# Write code to check the correctness of your code!
move $a0, $v0
li $v0, 1 
syscall
li $v0, 10
syscall

.include "hwk5.asm"
