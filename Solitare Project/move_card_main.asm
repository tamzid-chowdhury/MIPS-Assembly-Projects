# Moving some of the cards in the donor column to a nonempty recipient column
.data
##### Deck #####
.align 2
deck:
.word 36  # list's size
.word node107668 # address of list's head
node7375:
.word 6574898
.word node310865
node554250:
.word 6574897
.word node603606
node852682:
.word 6574905
.word node144423
node868946:
.word 6574905
.word node642600
node895759:
.word 6574901
.word node852682
node127979:
.word 6574900
.word node232072
node968862:
.word 6574904
.word node746497
node847855:
.word 6574901
.word node868946
node229155:
.word 6574897
.word node554250
node341619:
.word 6574902
.word node847855
node310865:
.word 6574903
.word node956561
node119393:
.word 6574896
.word node845
node341498:
.word 6574905
.word node935179
node350485:
.word 6574904
.word node112120
node942543:
.word 6574900
.word node191266
node935179:
.word 6574901
.word node341619
node746497:
.word 6574899
.word node390989
node144423:
.word 6574896
.word node350485
node131830:
.word 6574899
.word node390498
node112120:
.word 6574897
.word node137610
node191266:
.word 6574897
.word node954692
node107668:
.word 6574896
.word node386825
node390498:
.word 6574905
.word node640788
node640788:
.word 6574901
.word 0
node348732:
.word 6574900
.word node47863
node603606:
.word 6574905
.word node895759
node642600:
.word 6574896
.word node7375
node47863:
.word 6574904
.word node352271
node232072:
.word 6574902
.word node341498
node954692:
.word 6574898
.word node229155
node352271:
.word 6574901
.word node968862
node956561:
.word 6574903
.word node119393
node845:
.word 6574899
.word node131830
node386825:
.word 6574903
.word node942543
node137610:
.word 6574902
.word node348732
node390989:
.word 6574900
.word node127979
##### Board #####
.data
.align 2
board:
.word card_list173107 card_list376468 card_list151596 card_list184021 card_list935254 card_list375962 card_list216027 card_list929376 card_list90630 
# column #5
.align 2
card_list375962:
.word 6  # list's size
.word node385589 # address of list's head
node727078:
.word 7689013
.word node827039
node827039:
.word 7689012
.word node655020
node655020:
.word 7689011
.word node160092
node800533:
.word 7689014
.word node727078
node385589:
.word 7689015
.word node800533
node160092:
.word 7689010
.word 0
# column #7
.align 2
card_list929376:
.word 6  # list's size
.word node599148 # address of list's head
node599148:
.word 6574902
.word node285816
node144245:
.word 7689011
.word node844580
node844580:
.word 7689010
.word node770646
node770646:
.word 7689009
.word node951401
node951401:
.word 7689008
.word 0
node285816:
.word 7689012
.word node144245
# column #4
.align 2
card_list935254:
.word 0  # list's size
.word 0  # address of list's head (null)
# column #1
.align 2
card_list376468:
.word 2  # list's size
.word node958227 # address of list's head
node958227:
.word 6574905
.word node878109
node878109:
.word 7689016
.word 0
# column #8
.align 2
card_list90630:
.word 3  # list's size
.word node168329 # address of list's head
node614944:
.word 7689016
.word node273666
node168329:
.word 6574896
.word node614944
node273666:
.word 7689015
.word 0
# column #3
.align 2
card_list184021:
.word 1  # list's size
.word node671275 # address of list's head
node671275:
.word 7689010
.word 0
# column #0
.align 2
card_list173107:
.word 5  # list's size
.word node643287 # address of list's head
node827274:
.word 6574902
.word node330448
node330448:
.word 7689011
.word node473759
node473759:
.word 7689010
.word node565407
node565407:
.word 7689009
.word 0
node643287:
.word 6574905
.word node827274
# column #6
.align 2
card_list216027:
.word 2  # list's size
.word node268740 # address of list's head
node268740:
.word 7689016
.word node514603
node514603:
.word 7689015
.word 0
# column #2
.align 2
card_list151596:
.word 9  # list's size
.word node475439 # address of list's head
node475439:
.word 7689016
.word node384111
node979461:
.word 7689009
.word node703299
node384111:
.word 7689015
.word node56060
node104705:
.word 7689010
.word node979461
node176883:
.word 7689012
.word node357100
node32414:
.word 7689013
.word node176883
node703299:
.word 7689008
.word 0
node357100:
.word 7689011
.word node104705
node56060:
.word 7689014
.word node32414
##### Move #####
move: .word 65794




col: .asciiz "COL " 
size: .asciiz "SIZE "
space: .asciiz " "
arrow: .asciiz "->" 
end: .asciiz "END \n" 


.text
.globl main
main:
la $a0, board
la $a1, deck
lw $a2, move
jal move_card

# Write code to check the correctness of your code!
li $t0, 0 #counter
li $t1, 9
la $s0, board
loop_board:  
beq $t0, $t1, end_loop
la $a0, col
li $v0, 4
syscall
move $a0, $t0
li $v0, 1
syscall 
la $a0, space
li $v0, 4
syscall 
la $a0, size 
syscall
lw $t2, 0($s0) #holds pointer for list
lw $a0, 0($t2)
li $v0, 1
syscall  
la $a0, space
li $v0, 4
syscall
lw $t3, 4($t2)
loop_thru_cards: 
beqz $t3, end_loop_cards
print_card: 
li $v0, 11
lbu $a0, 0($t3)
syscall
lbu $a0, 1($t3)
syscall
lbu $a0, 2($t3)
syscall 
li $v0, 4
la $a0, space
syscall
la $a0, arrow
syscall
la $a0, space
syscall

lw $t3, 4($t3) 
j loop_thru_cards
end_loop_cards: 
la $a0, end
li $v0, 4
syscall
addi $t0, $t0, 1
addi $s0, $s0, 4
j loop_board

end_loop: 
li $v0, 10
syscall

.include "hwk5.asm"
