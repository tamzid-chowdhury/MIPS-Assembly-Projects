# Tamzid Chowdhury 
# tamchowdhury
# 111454408 

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
load_game:
    addi $sp, $sp, -8 #allocate 8 bytes into the stack pointer
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    
    move $s0, $a0 #move state into s0 register
    
    li $v0, 13
    move $a0, $a1
    li $a1, 0
    li $a2, 0
    syscall 
    bltz $v0, no_file
    
    move $s1, $v0      # save the file descriptor 
    
    
    addi $sp, $sp, -4
    li $t5, 0 #for counter reading rows and columns
    read_byte_line1: #get number of rows 
    li   $v0, 14       # system call for read from file
    move $a0, $s1      # file descriptor 
    move $a1, $sp   # address of buffer to which to read
    li   $a2, 1     # hardcoded buffer length
    syscall            # read from file
    lbu $t2, 0($sp) #holds digit 1 
    li $v0, 14
    syscall 
    lbu $t3, 0($sp) #holds digit 2 or escape character
    li $t4, '\r'
    beq $t3, $t4, casewithr
    li $t4, '\n'
    beq $t3, $t4, casewithn
    addi $t2, $t2, -48
    addi $t3, $t3, -48 
    li $t4, 10 
    mul $t2, $t2, $t4
    add $t3, $t3, $t2
    sb $t3, 0($s0) 
    li $v0, 14
    syscall 
    lbu $t2, 0($sp) 
    li $t4, '\n'
    beq $t2, $t4, read_byte_line2
    li $v0, 14
    syscall 
    j read_byte_line2
    casewithr:
    li $v0, 14 
    syscall 
    casewithn: 
    addi $t2, $t2, -48
    sb $t2, 0($s0) 
    
    read_byte_line2:
    bnez $t5, finished_both_lines
    addi $t5, $t5, 1 
    addi $s0, $s0, 1
    j read_byte_line1 
    finished_both_lines:
    addi $s0, $s0, -1 
    
    li $t0, 0 #will store in v0 at end of function holds if apple is found
    li $t1, 0 #will store in v1 and holds number of # characters found
    lbu $t2, 0($s0) #num of rows
    lbu $t3, 1($s0) #num of columns 
    li $t4, 0 #current row
    li $t5, 0 #current column 
    li $t6, 0 #length 
    addi $t9, $s0, 5 #starting byte of game grid stored in $t9 
    
    read_game_grid: 
    li $v0, 14
    syscall 
    lbu $t7, 0($sp) #holds current byte 
    j process_byte
    continue:
    addi $t5, $t5, 1 #add one to current column 
    bne $t5, $t3, read_game_grid #if current column is equal to column length we set current column to 0 and increment row by 1 
    li $v0, 14
    syscall 
    lbu $t7, 0($sp) 
    li $t8, '\n'
    beq $t7, $t8, continue1 
    li $v0, 14
    syscall 
    continue1: 
    li $t5, 0 
    addi $t4, $t4, 1  
    bne $t4, $t2, read_game_grid
    j get_length 
    
    
    process_byte: 
    sb $t7, 0($t9) 
    addi $t9, $t9, 1 
    li $t8, '#' 
    bne $t8, $t7, check_apple
    addi $t1, $t1, 1
    j continue
    check_apple:
    li $t8, 'a' 
    bne $t8, $t7, check_head
    li $t0, 1
    j continue
    check_head: 
    li $t8, '1' 
    bne $t8, $t7, check_body
    sb $t4, 2($s0) #store head row in struct
    sb $t5, 3($s0) #store head column in struct 
    check_body: 
    blt $t7, $t8, continue
    blt $t7, $t6, continue
    move $t6, $t7
    j continue
    
   
	
    no_file: 
    li $v0, -1 
    li $v1, -1
    
    get_length: #t6 holds the ascii letter which can be converted to a length 1-Z
    li $t8, 'A'
    bge $t6, $t8, convert_letter
    addi $t6, $t6, -48
    j done_load
    convert_letter: 
    addi $t6, $t6, -55
    done_load: 
    close_file: 
    move $a0, $s1
    li $v0, 16
    syscall 
    
    sb $t6, 4($s0) 
    
    move $v0, $t0
    move $v1, $t1
    
    addi $sp, $sp, 4 
    lw $s0, 0($sp)
    lw $s1, 4($sp) 
    addi $sp, $sp, 8 
    jr $ra

get_slot:
    addi $t0, $a0, 5 #starting address of grid 
    lbu $t1, 0($a0) #num of rows
    lbu $t2, 1($a0) #num of columns 
    
    bltz $a1, get_invalid1
    bltz $a2, get_invalid1
    bge $a1, $t1, get_invalid
    bge $a2, $t2, get_invalid 
    
    
    li $t3, 0 #count rows
    check_row_zero: 
    beq $t3, $a1, check_column_zero
    loop_thru_rows: 
    add $t0, $t0, $t2 
    addi $t3, $t3, 1
    bne $t3, $a1, loop_thru_rows
    check_column_zero: 
    li $t3, 0 #count columns 
    beq $t3, $a2, done_get_slot 
    loop_thru_columns:
    addi $t0, $t0, 1 
    addi $t3, $t3, 1
    bne $t3, $a2, loop_thru_columns
    j done_get_slot 
    
    
    get_invalid:
    li $v0, -1 
    j done_slot
    
    done_get_slot:
    lbu $t0, 0($t0)  
    move $v0, $t0 
    done_slot: 
    jr $ra

set_slot: #same exact code as get_slot except the end we store the char byte into the spot it is supposed to be at 

    addi $t0, $a0, 5 #starting address of grid 
    lbu $t1, 0($a0) #num of rows
    lbu $t2, 1($a0) #num of columns 
    
    bltz $a1, get_invalid1
    bltz $a2, get_invalid1
    bge $a1, $t1, get_invalid1
    bge $a2, $t2, get_invalid1
    
    
    li $t3, 0 #count rows
    check_row_zero1: 
    beq $t3, $a1, check_column_zero1
    loop_thru_rows1: 
    add $t0, $t0, $t2 
    addi $t3, $t3, 1
    bne $t3, $a1, loop_thru_rows1
    check_column_zero1: 
    li $t3, 0 #count columns 
    beq $t3, $a2, done_get_slot1 
    loop_thru_columns1:
    addi $t0, $t0, 1 
    addi $t3, $t3, 1
    bne $t3, $a2, loop_thru_columns1
    j done_get_slot1 
    
    
    get_invalid1:
    li $v0, -1 
    j done_slot1
    
    done_get_slot1:
    sb $a3, 0($t0)  
    move $v0, $a3 
    done_slot1: 
    jr $ra

place_next_apple:
    addi $sp, $sp, -16
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    
    move $s0, $a0 #state of game 
    move $s1, $a1 #apples array
    move $s2, $a1 #apple_length 
     
    get_pair: 
    lbu $s3, 0($s1) #row 
    lbu $s4, 1($s1) #column
    addi $s1, $s1, 2 
    bltz $s3, get_pair #if pair is (-1,-1) we can skip it 
    move $a0, $s0
    move $a1, $s3
    move $a2, $s4 
    jal get_slot 
    li $t0, '.' 
    beq $v0, $t0, set_pair 
    j get_pair 
    
    set_pair:
    move $a0, $s0 
    move $a1, $s3
    move $a2, $s4
    li $t0, 'a' 
    move $a3, $t0 
    jal set_slot 
    
    move $v0, $s3
    move $v1, $s4 
    li $t0, -1
    addi $s1, $s1, -2 
    sb $t0, 0($s1) 
    sb $t0, 1($s1) 
    
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    addi $sp, $sp, 16
    jr $ra

find_next_body_part:
    addi $sp, $sp, -24
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp) 
    sw $s4, 20($sp) 
    
    move $s0, $a3 #target 
    move $s1, $a1 #row of current
    move $s2, $a2 #colum of current
    
    lbu $t1, 0($a0) #num of rows
    lbu $t2, 1($a0) #num of columns 
    
    bltz $s1, cannot_find
    bltz $s2, cannot_find
    bge $s1, $t1, cannot_find
    bge $s2, $t2, cannot_find
    
    
    li $s3, 0
    li $s4, 0 
    
    try_left: 
    move $s3, $s1 #row doesn't change
    addi $s4, $s2, -1 #column-1 because we are going to left 
    move $a0, $a0
    move $a1, $s3
    move $a2, $s4
    jal get_slot 
    beq $v0, $s0, found
    
    try_right: 
    move $s3, $s1 #row doesn't change
    addi $s4, $s2, 1 #column+1 because we are going to right
    move $a0, $a0
    move $a1, $s3
    move $a2, $s4
    jal get_slot 
    beq $v0, $s0, found
    
    try_up:    
    addi $s3, $s1, 1 
    move $s4, $s2  
    move $a0, $a0
    move $a1, $s3
    move $a2, $s4
    jal get_slot 
    beq $v0, $s0, found
    
    try_down:    
    addi $s3, $s1, -1 
    move $s4, $s2  
    move $a0, $a0
    move $a1, $s3
    move $a2, $s4
    jal get_slot 
    beq $v0, $s0, found
    
    cannot_find: 
    li $v0, -1
    li $v1, -1 
    j part_5_done
    
    found: 
    move $v0, $s3
    move $v1, $s4
         
    part_5_done: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp)
    lw $s3, 16($sp) 
    lw $s4, 20($sp)  
    addi $sp, $sp, 24
    jr $ra

slide_body:
    lw $t0, 0($sp) #argument 5
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
    
    move $s0, $a0 #state 
    move $t1, $a1 #head_row_delta
    move $t2, $a2 #head_column_delta
    move $s3, $a3 #apples
    move $s4, $t0 #apples_length 
    
    lb $s5, 2($s0) #head row 
    lb $s6, 3($s0) #head column  
    
    get_next_position: 
    add $s1, $s5, $t1 #next head row
    add $s2, $s6, $t2 #next head column 
    move $a0, $s0 
    move $a1, $s1 
    move $a2, $s2 
    jal get_slot #we now have the next position to move to in v0 we must see if it is valid 
    
    li $t0, '.' 
    beq $t0, $v0, set_zero
    li $t0, 'a' 
    beq $t0, $v0, get_new_apple 
    li $s7, -1 
    j done_slide 
    
    set_zero: 
    li $s7, 0 #will be return value 
    slither: 
    sb $s1, 2($s0) 
    sb $s2, 3($s0) 
    set_new_head: 
    move $a0, $s0 #state 
    move $a1, $s1 #new head row
    move $a2, $s2 #new head column
    li $a3, '1'
    jal set_slot 
    # $s5 head row 
    # $s6 head column
    li $s3, '2' #we dont need apples anymore 
    loop_thru_body: 
    move $a0, $s0 #state 
    move $a1, $s5 #row
    move $a2, $s6 #column 
    move $a3, $s3 #target 
    jal find_next_body_part 
    bltz $v0, set_new_tail 
    move $a0, $s0
    move $a1, $s5
    move $a2, $s6 
    move $a3, $s3 
    addi $sp, $sp -8 
    sw $v0, 0($sp) 
    sw $v1, 4($sp) 
    jal set_slot 
    lw $v0, 0($sp) 
    lw $v1, 4($sp) 
    addi $sp, $sp, 8 
    move $s5, $v0
    move $s6, $v1
    li $t0, '9' 
    bne $s3, $t0, increment_one
    addi $s3, $s3, 8 
    j loop_thru_body 
    increment_one: 
    addi $s3, $s3, 1 
    j loop_thru_body 
    
    
    
    set_new_tail:
    move $a0, $s0 
    move $a1, $s5  
    move $a2, $s6  
    li $a3, '.'
    jal set_slot 
    
    j done_slide 
    
    get_new_apple: 
    li $s7, 1
    move $a0, $s0 
    move $a1, $s3
    move $a2, $s4
    jal place_next_apple
    j slither 
    
        
    
    done_slide:
    move $v0, $s7
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

add_tail_segment:
    lw $t0, 0($sp) #argument 5
    addi $sp, $sp, -32 
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp) 
    sw $s4, 20($sp)
    sw $s5, 24($sp) 
    sw $s6, 28($sp) 

    move $s0, $a0 #state
    move $s1, $a1 #direction 
    move $s2, $a2 #tail row 
    move $s3, $a3 #tail column
    lb $s6, 4($s0) #length 
    
    li $t0, 35
    bne $t0, $s6, check_direction #if length is equal to 35 we continue else we branch to check direction
    li $v0, -1
    j done_adding 
    
    check_direction: 
    li $t0, 'U' 
    beq $s1, $t0, convert_up 
    li $t0, 'D' 
    beq $s1, $t0, convert_down 
    li $t0, 'L' 
    beq $s1, $t0, convert_left 
    li $t0, 'R' 
    beq $s1, $t0, convert_right 
    li $v0, -1 
    j done_adding
    
    convert_up: #(-1,0)
    addi $s4, $s2, -1 
    move $s5, $s3 
    j check_new_tail
    
    convert_down: #(1,0) 
    addi $s4, $s2, 1
    move $s5, $s3
    j check_new_tail 
    
    convert_left: #(0,-1)
    move $s4, $s2
    addi $s5, $s3, -1 
    j check_new_tail
    
    convert_right: #(0,1) 
    move $s4, $s2
    addi $s5, $s3, 1
    j check_new_tail 
    
    check_new_tail: 
    move $a0, $s0 
    move $a1, $s4
    move $a2, $s5 
    jal get_slot
    li $t0, '.' 
    beq $t0, $v0, append_tail 
    li $v0, -1 
    j done_adding 
    
    
    append_tail: 
    addi $s6, $s6, 1
    sb $s6, 4($s0) #increase length by 1 
    #get char of tail 
    move $a0, $s0 
    move $a1, $s2
    move $a2, $s3 
    jal get_slot 
    li $t0, '9'  
    bne $t0, $v0, add_one_tochar
    addi $v0, $v0, 8
    j set_tail 
    add_one_tochar:
    addi $v0, $v0, 1 
    set_tail: 
    move $a0, $s0 
    move $a1, $s4 
    move $a2, $s5
    move $a3, $v0
    jal set_slot 
    move $v0, $s6
      
    done_adding: 
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

increase_snake_length:
    addi $sp, $sp, -24
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp) 
    sw $s4, 20($sp)  
   

    move $s0, $a0 #state
    move $s1, $a1 #direction 
    
    li $t0, 'U' 
    beq $s1, $t0, flip_down 
    li $t0, 'D' 
    beq $s1, $t0, flip_up
    li $t0, 'L' 
    beq $s1, $t0, flip_right
    li $t0, 'R' 
    beq $s1, $t0, flip_left 
    li $v0, -1 
    j done_increase
    
    flip_down: 
    li $s1, 'D' 
    j get_tail
    
    flip_up:
    li $s1, 'U'
    j get_tail
    
    flip_right: 
    li $s1, 'R' 
    j get_tail
    
    flip_left: 
    li $s1, 'L' 
    j get_tail 
     
           
    get_tail: 
    lbu $s2, 2($s0) #temp for head row 
    lbu $s3, 3($s0) #temp for head column 
    li $s4, '2' 
    loop_thru_snake: 
    move $a0, $s0 
    move $a1, $s2
    move $a2, $s3 
    move $a3, $s4
    jal find_next_body_part 
    bltz $v0, found_tail
    move $s2, $v0
    move $s3, $v1
    li $t0, '9' 
    bne $t0, $s4, increment_by_one_only
    addi $s4, $s4, 8
    j loop_thru_snake  
    increment_by_one_only: 
    addi $s4, $s4, 1 
    j loop_thru_snake 
      
    
    found_tail:
    li $t0, 'U'
    beq $s1, $t0, addtail_up 
    li $t0, 'D'
    beq $s1, $t0, addtail_down
    li $t0, 'L' 
    beq $s1, $t0, addtail_left
    li $t0, 'R'
    beq $s1, $t0, addtail_right 
    
    addtail_up:
    move $a0, $s0 
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3 
    jal add_tail_segment
    bltz $v0, try_left1
    j add_successful
    try_left1: 
    move $a0, $s0 
    li $t0, 'L'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_down1
    j add_successful
    try_down1:
    move $a0, $s0 
    li $t0, 'D'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_right1
    j add_successful
    try_right1: 
    move $a0, $s0 
    li $t0, 'R'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, add_failure
    j add_successful
    
    
    addtail_down:
    move $a0, $s0 
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3 
    jal add_tail_segment
    bltz $v0, try_right2
    j add_successful
    try_right2: 
    move $a0, $s0 
    li $t0, 'R'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_up2
    j add_successful
    try_up2:
    move $a0, $s0 
    li $t0, 'U'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_left2
    j add_successful
    try_left2: 
    move $a0, $s0 
    li $t0, 'L'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, add_failure
    j add_successful
        
    addtail_left:
    move $a0, $s0 
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3 
    jal add_tail_segment
    bltz $v0, try_down3
    j add_successful
    try_down3: 
    move $a0, $s0 
    li $t0, 'D'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_right3
    j add_successful
    try_right3:
    move $a0, $s0 
    li $t0, 'R'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_up3
    j add_successful
    try_up3: 
    move $a0, $s0 
    li $t0, 'U'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, add_failure
    j add_successful
    
    addtail_right:  
    move $a0, $s0 
    move $a1, $s1
    move $a2, $s2
    move $a3, $s3 
    jal add_tail_segment
    bltz $v0, try_up4
    j add_successful
    try_up4: 
    move $a0, $s0 
    li $t0, 'U'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_left4
    j add_successful
    try_left4:
    move $a0, $s0 
    li $t0, 'L'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, try_down4
    j add_successful
    try_down4: 
    move $a0, $s0 
    li $t0, 'D'
    move $a1, $t0
    move $a2, $s2
    move $a3, $s3
    jal add_tail_segment 
    bltz $v0, add_failure
    j add_successful
    
    add_failure: 
    li $v0, -1 
    j done_increase 
    
    add_successful: 
    lb $v0, 4($s0) 
    
    done_increase: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp)
    lw $s4, 20($sp)  
    addi $sp, $sp, 24
    jr $ra

move_snake:
    addi $sp, $sp, -28
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp) 
    sw $s4, 20($sp)  
    sw $s5, 24($sp)
    
    move $s0, $a0 #state 
    move $s5, $a1 #direction
    move $s1, $a2 #apples
    move $s2, $a3 #apples length
    
    get_direction:
    li $t0, 'U' 
    beq $s5, $t0, store_up 
    li $t0, 'D' 
    beq $s5, $t0, store_down 
    li $t0, 'L' 
    beq $s5, $t0, store_left
    li $t0, 'R' 
    beq $s5, $t0, store_right 
    j invalid_movedirection
    
    store_up: 
    li $s3, -1 #row delta
    li $s4, 0  #column delta 
    j slide_snake
    
    store_down: 
    li $s3, 1 
    li $s4, 0 
    j slide_snake
    
    store_left: 
    li $s3, 0 
    li $s4, -1 
    j slide_snake
    
    store_right:  
    li $s3, 0
    li $s4, 1 
    j slide_snake
    
    slide_snake: 
    move $a0, $s0 
    move $a1, $s3 
    move $a2, $s4 
    move $a3, $s1
    addi $sp, $sp, -4
    move $t0, $s2
    sw $t0, 0($sp)
    jal slide_body
    addi $sp, $sp, 4
    
    li $t0, -1
    beq $t0, $v0, case_1
    li $t0, 1
    beq $t0, $v0, case_2 
    li $t0, 0 
    beq $t0, $v0, case_3
    
    case_1: 
    li $v0, 0
    li $v1, -1 
    j done_move_snake
    
    case_2: 
    move $a0, $s0
    move $a1, $s5
    jal increase_snake_length
    bltz $v0, invalid_movedirection
    li $v0, 100
    li $v1, 1 
    j done_move_snake
    
    case_3:
    li $v0, 0 
    li $v1, 1 
    j done_move_snake
    
    
    invalid_movedirection: 
    li $v0, 0 
    li $v1, -1
    j done_move_snake 
    
    
    done_move_snake: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp)
    lw $s4, 20($sp) 
    lw $s5, 24($sp) 
    addi $sp, $sp, 28
    jr $ra

simulate_game:
    lw $t0, 0($sp) 
    lw $t1, 4($sp) 
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
    
    move $s0, $a0 #state
    move $s1, $a2 #directions 
    move $s2, $a3 #num_moves 
    move $s3, $t0 #apples
    move $s4, $t1 #apples length 
    
    load_game_simulation: 
    jal load_game
    bltz $v0, invalid_simulation 
    bgtz $v0, initialize_score
    move $a0, $s0 
    move $a1, $s3
    move $a2, $s4
    jal place_next_apple 
    
    
    initialize_score:
    li $s5, 0 #score
    lb $s6, 4($s0) #length 
    li $t2, 0 #counter  
    
    check_if_loop: 
    beqz, $s2, done_with_loop 
    li $t0, 35
    lb $s6, 4($s0) #load length 
    beq $s6, $t0, done_with_loop
    li $t0, '\0' 
    lbu $s7, 0($s1) 
    beq $s7, $t0, done_with_loop 
    
    
    loop_thru_directions: 
    move $a0, $s0 
    move $a1, $s7
    move $a2, $s3 
    move $a3, $s4
    addi $sp, $sp, -4
    sw $t2, 0($sp)  
    jal move_snake 
    lw $t2, 0($sp) 
    addi $sp, $sp, 4 
    bltz $v1, done_with_loop 
    addi $t2, $t2, 1 
    beqz $v0, skip_add 
    li $t1, 0 
    li $t0, 100
    mul $t1, $t0, $s6
    add $s5, $s5, $t1
    skip_add: 
    addi $s2, $s2, -1 
    addi $s1, $s1, 1 
    j check_if_loop 
    
    
    
    done_with_loop: 
    move $v0, $t2
    move $v1, $s5
    j done_simulation 
    
    
    
    invalid_simulation: 
    li $v0, -1
    li $v1, -1
    
    done_simulation: 
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

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
