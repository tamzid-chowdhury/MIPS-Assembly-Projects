#tamzid chowdhury
#tamchowdhury
#111454408

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

init_list:
   sw $0, 0($a0)
   sw $0, 4($a0) 
   jr $ra

append_card:
   addi $sp, $sp, -8
   sw $s0, 0($sp) 
   sw $s1, 4($sp) 
   
   move $s0, $a0 #card list
   move $s1, $a1 #card num
   
   li $a0, 8 
   li $v0, 9 
   syscall
   
   sw $s1, 0($v0) #load card num into first 4 bytes of object
   sw $0, 4($v0) #load 0 for next in object
   move $t0, $v0 #t0 now contains address of our new cardnode
   
   increase_size: 
   lw $v0, 0($s0) 
   addi $v0, $v0, 1 
   sw $v0, 0($s0) 
   
   lw $t1, 4($s0) #t1 contains address of head
   move $t2, $s0 
   loop_thru_list: 
   beq $0, $t1, add_cardnode 
   move $t2, $t1
   lw $t1, 4($t1) 
   j loop_thru_list
   
   add_cardnode:
   sw $t0, 4($t2) 
   
   
   lw $s0, 0($sp) 
   lw $s1, 4($sp)
   addi $sp, $sp, 8 
   jr $ra

create_deck:
   addi $sp, $sp, -20
   sw $ra, 0($sp) 
   sw $s0, 4($sp) 
   sw $s1, 8($sp) 
   sw $s2, 12($sp) 
   sw $s3, 16($sp) 
   
   li $a0, 8 
   li $v0, 9 
   syscall
   
   move $a0, $v0
   jal init_list 
   
   move $s0, $v0 
   
   li $s1, 0 #counter
   li $s2, 8
   straight_loop: 
   beq $s1, $s2, done
   li $s3, 0x00645330
   card_loop: 
   li $t0, 0x0064533a
   beq $s3, $t0, done_card_loop
   move $a0, $s0
   move $a1, $s3
   jal append_card
   addi $s3, $s3, 1 
   j card_loop
   done_card_loop: 
   addi $s1, $s1, 1
   j straight_loop
   
   done:
   move $v0, $s0
   lw $ra, 0($sp) 
   lw $s0, 4($sp) 
   lw $s1, 8($sp) 
   lw $s2, 12($sp) 
   lw $s3, 16($sp) 
   addi $sp, $sp, 20
   jr $ra

deal_starting_cards:
   addi $sp, $sp, -28
   sw $ra, 0($sp) 
   sw $s0, 4($sp) 
   sw $s1, 8($sp) 
   sw $s2, 12($sp) 
   sw $s3, 16($sp)
   sw $s4, 20($sp) 
   sw $s5, 24($sp) 
 
   
   move $s0, $a1 #cardlist
   move $s1, $a0 #board
   
   
   li $s2, 0 #counter for number of cards to deal
   li $s3, 44 #number of cards to deal 
   move $s4, $s1
   addi $s5, $s4, 36 
   deal_card_loop: 
   beq $s2, $s3, flip_card 
   bne $s1, $s5, skip_reset
   addi $s1, $s1, -36 #reset back to column 0
   skip_reset: 
   lw $a0, 0($s1) 
   #get card num
   lw $t0, 4($s0) 
   lw $a1, 0($t0) 
   #appendcard
   jal append_card
   #add 1 to counter '
   addi $s2, $s2, 1
   #add 4 to $s1 to get next column 
   addi $s1, $s1, 4
   #set head of cardlist to next and size -1
   lw $t0, 0($s0) 
   addi $t0, $t0, -1 
   sw $t0, 0($s0)
   lw $t1, 4($s0) #get pointer at head
   lw $t2, 4($t1) #get pointer of next 
   sw $t2, 4($s0) #store next into head 
   j deal_card_loop 
   
   
   flip_card: #s4 contains board
   beq $s4, $s5, done_dealing
   lw $t0, 0($s4) #contains column x 
   loop_thru_cards10:
   lw $t0, 4($t0) #contains head of list
   bnez $t0, set_card
   li $t2, 'u'
   sb $t2, 2($t1)
   addi $s4, $s4, 4
   j flip_card
   set_card: 
   move $t1, $t0
   j loop_thru_cards10
    
   done_dealing: 
   lw $ra, 0($sp) 
   lw $s0, 4($sp) 
   lw $s1, 8($sp) 
   lw $s2, 12($sp) 
   lw $s3, 16($sp) 
   lw $s4, 20($sp) 
   lw $s5, 24($sp) 
   addi $sp, $sp, 28
   jr $ra

get_card:
    addi $sp, $sp, -8
    sw $s0, 0($sp) 
    sw $s1, 4($sp) 
    
    move $s0, $a0 #cardlist
    move $s1, $a1 #index
    
    lw $t0, 0($s0) 
    beqz $t0, invalid_index
    bge $s1, $t0, invalid_index 
    
    li $t2, 0 #counter 
    lw $t3, 4($s0) #start at head 
    loop_thru_card_list: 
    beq $t2, $s1, found_card
    lw $t3, 4($t3) 
    addi $t2, $t2, 1 
    j loop_thru_card_list
    
    found_card: 
    lw $v1, 0($t3)
    lbu $t0, 2($t3)
    li $t1, 'u'
    beq $t0, $t1, store_up 
    li $t1, 'd' 
    beq $t0, $t1, store_down
    return_after_store: 
    j done_get_card
    
    store_up:
    li $v0, 2
    j return_after_store
    
    store_down:
    li $v0, 1
    j return_after_store
    
    invalid_index: 
    li $v0, -1
    li $v1, -1
    j done_get_card
    
    
    done_get_card: 
    lw $s0, 0($sp) 
    lw $s1, 4($sp) 
    addi $sp, $sp, 8
    jr $ra

check_move:
    addi $sp, $sp, -36
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp)
    sw $s4, 20($sp) 
    sw $s5, 24($sp) 
    sw $s6, 28($sp)
    sw $s7, 32($sp)  
   
    move $s0, $a0 #board
    move $s1, $a1 #deck 
    
    move $t0, $a2
    
    li $a0, 4
    li $v0, 9 
    syscall 
    sw $t0, 0($v0) 
    
    lbu $s2, 0($v0) #move byte 0 donor col
    lbu $s3, 1($v0) #move byte 1 donor row
    lbu $s4, 2($v0) #move byte 2 rec col
    lbu $s5, 3($v0) #move byte 3 dealmove or no 
    
    check_deal_move: #check if it is a deal move and it there is an error or success
    #check error 1
    beqz $s5, check_normal_move_params
    bnez $s4, error_1
    bnez $s3, error_1
    bnez $s2, error_1
    #check error 2
    lw $t0, 0($s1)
    beqz, $t0, error_2
    
    move $t0, $s0
    addi $t1, $t0, 36
    check_board_columns: 
    beq $t0, $t1, success_1
    lw $t2, 0($t0)
    lw $t3, 0($t2)
    beqz $t3, error_2
    addi $t0, $t0, 4
    j check_board_columns
    
        
    check_normal_move_params:
    #check error 3
    li $t0, 0
    li $t1, 8
    blt $s2, $t0, error_3
    bgt $s2, $t1, error_3
    blt $s4, $t0, error_3
    bgt $s4, $t1, error_3
    #check error 4
    move $t0, $s0
    move $t1, $s2
    li $t2, 4
    mul $t1, $t1, $t2
    add $t0, $t0, $t1 #address of column we need
    lw $t0, 0($t0)
    lw $t0, 0($t0) 
    bge $s3, $t0, error_4
    blt $s3, $0, error_4
    #check error 5
    beq $s2, $s4, error_5
    
    check_normal_moves: 
    #check error 6
    move $t0, $s0
    move $t1, $s2
    li $t2, 4
    mul $t1, $t1, $t2
    add $t0, $t0, $t1 
    lw $a0, 0($t0) #address of column we need
    move $s6, $a0 #save address of column were in to check error 7
    move $a1, $s3
    jal get_card
    li $t9, 1
    beq $v0, $t9, error_6
    
    #check error 7
    move $s1, $v1 #selected card
    lw $s7, 0($s6) #size of donor column 
    addi $s3, $s3, 1 #add 1 to row 
    li $s5, 1
    check_descending: 
    beq $s3, $s7, check_recep #if current row = size that means we have checked all card in the column that we need to 
    move $a0, $s6
    move $a1, $s3
    jal get_card
    sub $t0, $s1, $v1
    bne $t0, $s5, error_7
    addi $s3, $s3, 1
    addi $s5, $s5, 1
    j check_descending
    
    
    check_recep: 
    #check error 8
    move $t0, $s0
    move $t1, $s4
    li $t2, 4
    mul $t1, $t1, $t2
    add $t0, $t0, $t1 
    lw $s2, 0($t0) #address of column we need
    lw $s3, 0($s2) #size of col
    beqz $s3, success_2
    move $a0, $s2
    addi $a1, $s3, -1
    jal get_card
    sub $t0, $v1, $s1
    li $t1, 1 
    beq $t0, $t1, success_3
    j error_8
    
    
    
    error_1:
    li $v0, -1 
    j done_check_move
    
    error_2:
    li $v0, -2 
    j done_check_move
    
    error_3:
    li $v0, -3 
    j done_check_move
    
    error_4:
    li $v0, -4 
    j done_check_move
    
    error_5:
    li $v0, -5 
    j done_check_move
    
    error_6:
    li $v0, -6 
    j done_check_move
    
    error_7:
    li $v0, -7 
    j done_check_move
    
    error_8:
    li $v0, -8 
    j done_check_move
    
    success_1:
    li $v0, 1 
    j done_check_move
    
    success_2:
    li $v0, 2
    j done_check_move
    
    success_3:
    li $v0, 3
    j done_check_move
   	
    done_check_move: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    lw $s5, 24($sp) 
    lw $s6, 28($sp) 
    lw $s7, 32($sp) 
    addi $sp, $sp, 36
    jr $ra

clear_full_straight:
    addi $sp, $sp, -24
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp)
    sw $s4, 20($sp) 

    move $s0, $a0 #board
    move $s1, $a1 #column num 
    
    #check if col num is valid 
    bltz $s1, clear_error_1
    li $t0, 8
    bgt $s1, $t0, clear_error_1
    
    #check if col size if > 10 
    move $t0, $s0
    move $t1, $s1
    li $t2, 4
    mul $t1, $t1, $t2
    add $t0, $t0, $t1 
    lw $s2, 0($t0) #address of column we need
    lw $s3, 0($s2) #size of col
    li $t0, 10
    blt $s3, $t0, clear_error_2
    
    #check if valid straight can be removed
    li $s4, 0x00755330 #if this is not the top card in a column than we cannot clear the column by default 
    addi $s3, $s3, -1 #index of the top card of the column
    validate_straight:
    li $t0, 0x0075533a 
    beq $s4, $t0, valid_straight_found
    move $a0, $s2 #column
    move $a1, $s3 #index of top card
    jal get_card
    bne $s4, $v1, clear_error_3
    addi $s3, $s3, -1 
    addi $s4, $s4, 1 
    j validate_straight
    
    valid_straight_found:
    lw $s3, 0($s2) #size of column
    addi $s3, $s3, -10
    sw $s3, 0($s2) 
    beqz $s3, clear_success_2
    j clear_success_1
    
    
    clear_error_1:
    li $v0, -1
    j done_clear
    
    clear_error_2:
    li $v0, -2
    j done_clear
    
    clear_error_3:
    li $v0, -3
    j done_clear
    
    clear_success_2: #work to do 
    sw $0, 4($s2) 
    li $v0, 2
    j done_clear
    
    clear_success_1: #work to do 
    li $t2, 1
    lw $t0, 4($s2) 
    find_top_card:
    beq $t2, $s3, update_top_card
    lw $t0, 4($t0)
    addi $t2, $t2, 1
    j find_top_card
    update_top_card: 
    sw $0, 4($t0)
    li $t1, 'u'
    sb $t1, 2($t0)
    li $v0, 1   
    j done_clear 
    
    done_clear:
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    addi $sp, $sp, 24
    jr $ra

deal_move: 
    addi $sp, $sp, -16
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 

    
    move $s0, $a0 #board
    move $s1, $a1 #deck
    
    addi $s2, $s0, 36
    #column0 
    deal_loop:
    beq $s0, $s2, fix_deck_size
    lw $a0, 0($s0)
    lw $t0, 4($s1) #address of head node
    li $t9, 'u'
    sb $t9, 2($t0) 
    lw $a1, 0($t0) 
    lw $t1, 4($t0)
    sw $t1, 4($s1) 
    jal append_card
    addi $s0, $s0, 4
    j deal_loop

    fix_deck_size: 
    lw $t0, 0($s1)
    addi $t0, $t0, -9
    sw $t0, 0($s1)
    
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    addi $sp, $sp, 16
    jr $ra

move_card:
    addi $sp, $sp, -36
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp)
    sw $s4, 20($sp) 
    sw $s5, 24($sp) 
    sw $s6, 28($sp)
    sw $s7, 32($sp)  
   
    move $s0, $a0 #board
    move $s1, $a1 #deck    
    move $s6, $a2 #move
    
    li $a0, 4
    li $v0, 9 
    syscall 
    sw $s6, 0($v0) 
    
    lbu $s2, 0($v0) #move byte 0 donor col
    lbu $s3, 1($v0) #move byte 1 donor row
    lbu $s4, 2($v0) #move byte 2 rec col
    lbu $s5, 3($v0) #move byte 3 dealmove or no 
    
    move $a0, $s0
    move $a1, $s1
    move $a2, $s6
    jal check_move     
    bltz $v0, invalid_move_exit #if check move returns a negative value an error occured 
    
    li $t0, 1
    beq $v0, $t0, perform_deal_move
    
    li $t0, 2
    beq $v0, $t0, perform_normal_move_empty
    
    li $t0, 3
    beq $v0, $t0, perform_normal_move_nonempty
    
    perform_deal_move:
    move $a0, $s0
    move $a1, $s1
    jal deal_move
    li $s6, 0 
    li $s7, 9
    clear_column_loop: 
    beq $s6, $s7, done_valid_move
    move $a0, $s0 
    move $a1, $s6 #col num
    jal clear_full_straight
    addi $s6, $s6, 1
    j clear_column_loop
    
    
    perform_normal_move_empty: #moving some of the cards in the donor column to an empty recipient column. In this case, the new top card in the donor column must be flipped over
    beqz $s3, perform_normal_move_empty_all
    move $t0, $s2 #donor col
    li $t1, 4
    mul $t0, $t0, $t1
    add $t0, $s0, $t0 
    lw $s6, 0($t0) #address of donor col
    
    lw $s5, 0($s6)
    sub $s5, $s5, $s3
    sw $s3, 0($s6) 
    
    li $t0, 0
    loop_thru_donor_col:
    beq $t0, $s3, found_top_donor_card 
    lw $s6, 4($s6)
    addi $t0, $t0, 1
    j loop_thru_donor_col
    
    found_top_donor_card: 
    lw $s7, 4($s6)
    sw $0, 4($s6) 
    li $t0, 'u'
    sb $t0, 2($s6) 
    
    move $t2, $s4 #recep
    li $t3, 4
    mul $t2, $t2, $t3
    add $t2, $s0, $t2
    lw $s6, 0($t2) #address of recep col
    
    sw $s5, 0($s6) 
    sw $s7, 4($s6) 
    
    move $a0, $s0
    move $a1, $s4
    jal clear_full_straight
    j done_valid_move
    
    
    perform_normal_move_empty_all: #moving all of the cards in the donor column to an empty recipient column
    move $t0, $s2 #donor col
    li $t1, 4
    mul $t0, $t0, $t1
    add $t0, $s0, $t0 
    lw $t1, 0($t0) #address of donor col
    
    move $t2, $s4 #recep
    li $t3, 4
    mul $t2, $t2, $t3
    add $t2, $s0, $t2
    lw $t3, 0($t2) #address of recep col
    
    sw $t3, 0($t0) 
    sw $t1 0($t2) 
    
    move $a0, $s0
    move $a1, $s4
    jal clear_full_straight
    j done_valid_move
    
    perform_normal_move_nonempty: #moving some of the cards in the donor column to a nonempty recipient column. In this case, the new top card in the donor column must be flipped over
    beqz $s3, perform_normal_move_nonempty_all
    move $t0, $s2 #donor col
    li $t1, 4
    mul $t0, $t0, $t1
    add $t0, $s0, $t0 
    lw $s6, 0($t0) #address of donor col
    
    lw $s5, 0($s6)
    sub $s5, $s5, $s3 #add to size of recep
    sw $s3, 0($s6) 
    
    li $t0, 0
    loop_thru_donor_col1:
    beq $t0, $s3, found_top_donor_card1
    lw $s6, 4($s6)
    addi $t0, $t0, 1
    j loop_thru_donor_col1
    
    found_top_donor_card1: 
    lw $s7, 4($s6)
    sw $0, 4($s6) 
    li $t0, 'u'
    sb $t0, 2($s6) 
    
    move $t2, $s4 #recep
    li $t3, 4
    mul $t2, $t2, $t3
    add $t2, $s0, $t2
    lw $s6, 0($t2) #address of recep col
    
    lw $t0, 0($s6)
    add $t0, $t0, $s5
    sw $t0, 0($s6) #adjust size
    
    li $t0, 1
    loop_thru_recep_col1:
    beq $t0, $0, found_top_recep_card1
    lw $s6, 4($s6)
    lw $t0, 4($s6)
    j loop_thru_recep_col1
    
    found_top_recep_card1:
    sw $s7, 4($s6)
    
    move $a0, $s0
    move $a1, $s4
    jal clear_full_straight
    j done_valid_move
    
    
    
    perform_normal_move_nonempty_all: #moving all of the cards in the donor column to a nonempty recipient column
    move $t0, $s2 #donor col
    li $t1, 4
    mul $t0, $t0, $t1
    add $t0, $s0, $t0 
    lw $s6, 0($t0) #address of donor col
    
    lw $s7, 4($s6)
    sw $0, 4($s6) 
    lw $s2, 0($s6)
    sw $0, 0($s6)
    
    move $t2, $s4 #recep
    li $t3, 4
    mul $t2, $t2, $t3
    add $t2, $s0, $t2
    lw $s6, 0($t2) #address of recep col
    
    lw $t0, 0($s6)
    add $t0, $t0, $s2
    sw $t0, 0($s6) #adjust size
        
    
    li $t0, 1
    loop_thru_recep_col:
    beq $t0, $0, found_top_recep_card 
    lw $s6, 4($s6)
    lw $t0, 4($s6)
    j loop_thru_recep_col
    
    found_top_recep_card:
    sw $s7, 4($s6)
    
    move $a0, $s0
    move $a1, $s4
    jal clear_full_straight
    j done_valid_move
    
    
    
    
    
    invalid_move_exit:
    li $v0, -1 
    j done_move_card
    
    done_valid_move:
    li $v0, 1 
    done_move_card: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    lw $s5, 24($sp) 
    lw $s6, 28($sp) 
    lw $s7, 32($sp) 
    addi $sp, $sp, 36
    jr $ra
    
load_game:
    addi $sp, $sp, -32
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp)
    sw $s4, 20($sp) 
    sw $s5, 24($sp) 
    sw $s6, 28($sp)
    
    move $s0, $a0 #filename
    move $s1, $a1 #board 
    move $s2, $a2 #deck
    move $s3, $a3 #moves
    
    li $v0, 13
    move $a0, $s0
    li $a1, 0
    li $a2, 0
    syscall 
    bltz $v0, no_file
    
    move $s0, $v0      # save the file descriptor 
    
    move $a0, $s2 #deck is moved into a0
    jal init_list
    
    #initialize the deck 
    addi $sp, $sp, -4

    init_deck: #get number of rows 
    li $t1, 0x00645330
    li   $v0, 14       # system call for read from file
    move $a0, $s0      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    lw $t0, 0($sp) #holds digit 1 
    li $t2, '\n'
    beq $t0, $t2, init_moves 
    addi $t0, $t0, -48
    add $t0, $t0, $t1
    move $a0, $s2
    move $a1, $t0
    jal append_card
    li   $v0, 14       # system call for read from file
    move $a0, $s0      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    j init_deck 
    
    
    init_moves:
    li $s6, 0
    loop_moves_array:
    li   $v0, 14       # system call for read from file
    move $a0, $s0      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    lw $t0, 0($sp) #holds digit 1 
    li $t1, '\n'
    beq $t0, $t1, initialize_board
    li $t1, ' ' 
    bne $t0, $t1, skip_this_part
    addi $s6, $s6, 1 
    j loop_moves_array
    skip_this_part:
    addi $t0, $t0, -48
    sb $t0, 0($s3) 
    addi $s3, $s3, 1 
    j loop_moves_array
    
    initialize_board:
    lw $a0, 0($s1) 
    jal init_list
    lw $a0, 4($s1) 
    jal init_list
    lw $a0, 8($s1) 
    jal init_list
    lw $a0, 12($s1) 
    jal init_list
    lw $a0, 16($s1) 
    jal init_list
    lw $a0, 20($s1) 
    jal init_list
    lw $a0, 24($s1) 
    jal init_list
    lw $a0, 28($s1) 
    jal init_list
    lw $a0, 32($s1)
    jal init_list
    
    init_board: 
    move $s4, $s1 #extra copy of board starting address
    li $s5, 0 #figure out end 
    loop_read_board: 
    li   $v0, 14       # system call for read from file
    move $a0, $s0      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    lw $t0, 0($sp) #holds digit 1 
    li $t1, ' '
    bne $t0, $t1, skip_space
    li   $v0, 14       # system call for read from file
    move $a0, $s0      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    addi $s4, $s4, 4
    j loop_read_board
    skip_space:
    li $t1, '\n'
    bne $t0, $t1, skip_board_reset
    addi $s5, $s5, 1 
    li $t9, 2
    beq $s5, $t9, done_valid_load_game
    move $s4, $s1
    j loop_read_board
    skip_board_reset:
    li $s5, 0 
    li   $v0, 14       # system call for read from file
    move $a0, $s0      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    lw $t7, 0($sp) 
    li $t8, 100 
    beq $t7, $t8, start_with_down
    li $t8, 117
    beq $t7, $t8, start_with_up
    continue_board_looping: 
    addi $t0, $t0, -48
    add $t0, $t0, $t1
    lw $a0, 0($s4)
    move $a1, $t0
    jal append_card
    addi $s4, $s4, 4
    j loop_read_board
    
    start_with_up: 
    li $t1, 0x00755330
    j continue_board_looping
    
    start_with_down: 
    li $t1, 0x00645330
    j continue_board_looping
    
    no_file: 
    li $v0, -1
    j done_load_game
    
    done_valid_load_game:
    addi $sp, $sp, 4 
    li $v0, 1
    addi $s6, $s6, 1 
    move $v1, $s6
    done_load_game:    
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    lw $s5, 24($sp) 
    lw $s6, 28($sp)  
    addi $sp, $sp, 32
    jr $ra

simulate_game:
    addi $sp, $sp, -32
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp)
    sw $s4, 20($sp) 
    sw $s5, 24($sp) 
    sw $s6, 28($sp)

    
    move $s0, $a0 #filename
    move $s1, $a1 #board
    move $s2, $a2 #deck 
    move $s3, $a3 #moves 
    
    jal load_game 
    bltz $v0, invalid_simulation 
    
    
    move $s4, $v1 #holds number of moves in moves array 
    
    li $s5, 0 #counter
    li $s6, 0 #number of valid moves performed 
    execute_moves: 
    beq $s5, $s4, done_simulating_moves
    move $a0, $s1
    move $a1, $s2
    lw $a2, 0($s3) 
    jal move_card
    bltz $v0, invalid_move_performed
    addi $s6, $s6, 1
    addi $s5, $s5, 1
    addi $s3, $s3, 4
    j execute_moves
    invalid_move_performed:
    addi $s5, $s5, 1
    addi $s3, $s3, 4
    j execute_moves
    
    invalid_simulation: 
    li $v0, -1
    li $v1, -1 
    j done_simulation
    
    done_simulating_moves: #figure out if we won or not
    #check deck 
    lw $t0, 0($s2) 
    bnez $t0, lost_game
    
    
    #column 0
    lw $t0, 0($s1) 
    lw $t0, 0($t0) 
    bnez $t0, lost_game
    
    #column 1
    lw $t0, 4($s1) 
    lw $t0, 0($t0) 
    bnez $t0, lost_game
    
    #column 2  
    lw $t0, 8($s1) 
    lw $t0, 0($t0)
    bnez $t0, lost_game
    
    #column 3 
    lw $t0, 12($s1)
    lw $t0, 0($t0)
    bnez $t0, lost_game 
    
    #column 4 
    lw $t0, 16($s1)
    lw $t0, 0($t0) 
    bnez $t0, lost_game 
    
    #column 5
    lw $t0, 20($s1)
    lw $t0, 0($t0)
    bnez $t0, lost_game 
    
    #column 6 
    lw $t0, 24($s1)
    lw $t0, 0($t0)
    bnez $t0, lost_game
    
    #column 7  
    lw $t0, 28($s1)
    lw $t0, 0($t0)
    bnez $t0, lost_game 
    
    #column 8
    lw $t0, 32($s1)
    lw $t0, 0($t0)
    bnez $t0, lost_game 
    
    j won_game
    
    won_game: 
    li $v1, 1
    j done_valid_simulation
    
    
    lost_game: 
    li $v1, -2 
    j done_valid_simulation
    
    done_valid_simulation: 
    move $v0, $s6 
    done_simulation: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    lw $s5, 24($sp) 
    lw $s6, 28($sp)  
    addi $sp, $sp, 32
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
