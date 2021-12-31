# Simulate game02.txt - results in a win
.data
filename: .asciiz "game02.txt"
### Deck ###
# Garbage values
deck: .word 77626828 25487147
### Board ###
# Garbage values
.data
.align 2
board:
.word card_list547011 card_list216912 card_list669785 card_list848653 card_list417583 card_list677543 card_list718104 card_list835157 card_list933336 
# column #1
.align 2
card_list216912:
.word 840431  # list's size
.word 506422 # address of list's head
# column #7
.align 2
card_list835157:
.word 564679  # list's size
.word 669362 # address of list's head
# column #3
.align 2
card_list848653:
.word 552679  # list's size
.word 592251 # address of list's head
# column #0
.align 2
card_list547011:
.word 319918  # list's size
.word 360147 # address of list's head
# column #2
.align 2
card_list669785:
.word 861167  # list's size
.word 638481 # address of list's head
# column #4
.align 2
card_list417583:
.word 330578  # list's size
.word 13158 # address of list's head
# column #5
.align 2
card_list677543:
.word 936317  # list's size
.word 806648 # address of list's head
# column #8
.align 2
card_list933336:
.word 699042  # list's size
.word 625481 # address of list's head
# column #6
.align 2
card_list718104:
.word 537660  # list's size
.word 455488 # address of list's head
# Garbage values
moves: .ascii "c8I7tSbnRcj2PHgTd1AZU4ENyvQlPQzBQRgfcnjQZPiYTQLtxGATqsA2lIH2Q7Jf27a4LMTjHWM8QMgD6PpOZ0JEbxsZWDxPVs1IWKLPYvmkcxdLgFZxWAQl5gQNeoKyiGRTgW7F7HWo4OYHFvu8MO2AY55WPrvRElpgUT1dSHTXjx7cijZPkRRzVZlXJ4pG8PlXFGQaEjrwRGOCoeBV24EzudOB3ASfuCDahcTwxuXpSJSR6JEUX0LSvQocliPCm0R1EBO1aw8P7ir97wItRewnYdhJiHaMFGAzTFeZmlwovSAVFhzewG8ygmqfShxlmf3eB0PP6C7UB8CTcAdg7t8Gzy12UvxwevMlhbCzGuc0nZsuSsjuMExoIW3cNE1jnvpSEJo2t6XkmDEYvEOCDZ6rBU6sfPz3Dg63N2uyKKNHioXdkSAYGCRNrMpXsl6Hp6SAZVfLyJexDSO7ikwSLii99ZtAjkDrNoN0msmLMdW3t77XmNCblkXvNQZkucgpcwnfl6DBlgJHdMQpPgA5jpRtkCWiLxVz9bNFtBBUMk6K"


col: .asciiz "COL " 
size: .asciiz "SIZE "
space: .asciiz " "
arrow: .asciiz "->" 
end: .asciiz "END \n" 

.text
.globl main
main:
la $a0, filename
la $a1, board
la $a2, deck
la $a3, moves
jal simulate_game

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
