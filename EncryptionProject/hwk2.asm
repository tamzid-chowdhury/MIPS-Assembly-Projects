# Tamzid Chowdhury
# tamchowdhury
# 111454408

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text
strlen:
    li $t0, 0 #use as counter 
    move $t1, $a0 #move base address of string into temporary register
    lbu $t2, 0($t1) #store first character of word into temporary register
    li $t3, '\0' 
    loop_thru_string: 
    beq $t2, $t3, end_string_loop #if we have the null character we must exit the loop
    addi $t0, $t0, 1 #add one to counter
    addi $t1, $t1, 1 #add one to move onto the next character of string 
    lbu $t2, 0($t1)
    j loop_thru_string
    
    
    end_string_loop: 
    move $v0, $t0 #mofe counter into return register 
    jr $ra

index_of:
  begin_index_of: 
    addi $sp, $sp, -4 #allocate bytes for return register
    sw $ra, 0($sp) #store return address in stack pointer
    
    
  body_index_of:
    move $t1, $a0 #move string into $t1 register
    li $t2, 0 #counter
    bnez $a2, set_index #if start index is not at zero we branch to loop where we increment until we rearch start index 
    
    find_index:  
    lbu $t3, 0($t1) #load character into register t3
    li $t4, '\0'
    beq $t3, $t4, invalid_index #if we reach null terminator we invalidate the index
    beq $t3, $a1, load_index #if character matches we load it
    addi $t1, $t1, 1 #increment to next character of string
    addi $t2, $t2, 1 #increment counter 
    j find_index
    
    set_index: #set counter and address of string to starting index 
    addi $sp, $sp, -12 
    sw $t1, 0($sp) 
    sw $t2, 4($sp)
    sw $a2, 8($sp)
    jal strlen #call function to determine string length
    lw $t1, 0($sp) 
    lw $t2, 4($sp) 
    lw $a2, 8($sp) 
    addi $sp, $sp, 12 
    move $t0, $v0 #move length of string into $t0
    bltz $a2, invalid_index #if starting index is less than 0 we return -1
    bge  $a2, $t0, invalid_index #if starting index is greater than or equal to the length of the string we return -1 
    add $t1, $t1, $a2 #increment starting address 
    add $t2, $t2, $a2 #increment counter
    beq $t2, $a2, find_index
  
    
    invalid_index: 
    li $v0, -1 
    j end_index_of 
    
    load_index: 
    move $v0, $t2
     
  end_index_of: 
    lw $ra, 0($sp) #load return address back from the stack pointer 
    addi $sp, $sp, 4   
    jr $ra

to_lowercase:
    move $t0, $a0 #move address of string into t1 register
    li $t1, 0 #use as counter 
    li $t2, 65 #ascii code for A
    li $t3, 90 #ascii code for Z 
    li $t4, '\0' #null terminator
    
    find_lowercase: 
    lbu $t5, 0($t0) #load character of string into $t5 
    beq $t5, $t4, end_lowercase_search
    blt $t5, $t2, skip_index #if character is less than ascii code for A we skip it
    bgt $t5, $t3, skip_index #if character is greater than ascii code for Z we skip it 
    addi $t5, $t5, 32 
    sb $t5, 0($t0) 
    addi $t1, $t1, 1 
    skip_index: 
    addi $t0, $t0, 1 
    j find_lowercase
    
    
    end_lowercase_search: 
    move $v0, $t1
    jr $ra

generate_ciphertext_alphabet:
    addi $sp, $sp, -28 #allocate 8 bytes into the stack pointer
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)
    sw $s4, 16($sp)
    sw $s5, 20($sp) 
    sw $ra, 24($sp) 

    
    move $s0, $a0 #move the starting address of the ciphertext alphabet to $s0
    move $s1, $a1 #move the starting address of keyphrase to $s1
    move $a0, $a1 #move the keyphrase into $s6 so we can use it for the index of function 
    li $s4, 0 #return value will contain number of unique characters drawn from keyphrase by the end 
    li $s3, 0 #counter for index of keyphrase 

    
    
  gca_step2: #draw unique letters and digits from keyphrase and store them into cyphertext
    li $t1, '\0' #null character 
    lbu $s2, 0($s1) #load character in keyphrase into $s2 
    beq $s2, $t1, gca_step3
    confirm_alphanumeric: 
    li $t1, 48 #ascii character for 0 
    blt $s2, $t1, increment_and_continue
    li $t1, 122 #ascii character for 9 
    bgt $s2, $t1, increment_and_continue 
    li $t1, 57 
    bgt $s2, $t1, check_ascii1 #if greater than ascii for 9 check if it is still alphanumeric
    continue_ascii_check: 
    li $t1, 90 #ascii character for Z
    bgt $s2, $t1, check_ascii2 #if greater than ascii for Z check if it is still alphanumeric
    end_of_ascii_check:
    
    check_if_unique: #now that the character is confirmed alphanumeric we must check to see if the value is unique 
    move $a1, $s2 #we need to move the character into argument 1 so we can use index of 
    li $a2, 0 #move 0 into starting index
    jal index_of
    beq $s3, $v0, add_to_cypher 
    j increment_and_continue 
     
    add_to_cypher: 
    sb $s2, 0($s0) #store the character in keyphrase into the next available spot in the cyphertext 
    addi $s4, $s4, 1 #increment the number of of characters drawn from keyphrase by 1
    addi, $s0, $s0, 1 #increment to the next byte address in cypher text 
    j increment_and_continue
    
    check_ascii1: 
    li $t1, 65 #ascii code for A
    bge $s2, $t1, continue_ascii_check
    j increment_and_continue 
    
    check_ascii2: 
    li $t1, 97
    bge $s2, $t1, end_of_ascii_check
    j increment_and_continue
    
    increment_and_continue: 
    addi $s1, $s1, 1 #increment address by 1
    addi $s3, $s3, 1 #increment counter of keyphrase 
    j gca_step2 
    
       
  gca_step3: #add missing lowercase letters to cyphertext ($s0 contains the address of the next byte we need to alter in cyphertext) 
    li $t0, 'a' 
    li $t1, 'z' 
    
    append_lowercase_loop: 
    move $a1, $t0 
    move $a2, $0 
    addi $sp, $sp, -8 #allocate space on stack to save temp registers before calling fxn
    sw $t0, 0($sp) 
    sw $t1, 4($sp)
    jal index_of 
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8 
    bltz $v0, append_lowercase #if index_of returns -1 we know that the ascii letter is not in the keyphrase so we append to cyphertext
    j increment_and_return1
    
    append_lowercase: 
    sb $t0, 0($s0) 
    addi $s0, $s0, 1 
    increment_and_return1:
    addi $t0, $t0, 1 
    bgt $t0, $t1, gca_step4
    j append_lowercase_loop 
    
  gca_step4:  
    li $t0, 'A' 
    li $t1, 'Z' 
    
    append_uppercase_loop: 
    move $a1, $t0 
    move $a2, $0 
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal index_of 
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8 
    bltz $v0, append_uppercase #if index_of returns -1 we know that the ascii letter is not in the keyphrase so we append to cyphertext
    j increment_and_return2
    
    append_uppercase: 
    sb $t0, 0($s0) 
    addi $s0, $s0, 1 
    increment_and_return2:
    addi $t0, $t0, 1 
    bgt $t0, $t1, gca_step5
    j append_uppercase_loop 
    
    gca_step5: 
    li $t0, '0' 
    li $t1, '9' 
    
    append_digits_loop: 
    move $a1, $t0 
    move $a2, $0 
    addi $sp, $sp, -8
    sw $t0, 0($sp)
    sw $t1, 4($sp)
    jal index_of 
    lw $t0, 0($sp)
    lw $t1, 4($sp)
    addi $sp, $sp, 8 
    bltz $v0, append_digits #if index_of returns -1 we know that the ascii letter is not in the keyphrase so we append to cyphertext
    j increment_and_return3
    
    append_digits: 
    sb $t0, 0($s0) 
    addi $s0, $s0, 1 
    increment_and_return3:
    addi $t0, $t0, 1 
    bgt $t0, $t1, gca_step6
    j append_digits_loop
    
    gca_step6: #add null character to end of cyphertext
    li $t0, '\0'
    sb $t0, 0($s0)    
  
    move $v0, $s4   #move number of unique characters to return register 
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp) 
    lw $s4, 16($sp)
    lw $s5, 20($sp)
    lw $ra, 24($sp)  
    addi $sp, $sp, 28
    jr $ra

count_lowercase_letters:
    move $t0, $a0 #move address of counts array into $s0 
    move $t1, $a1 #move message into $s1
    li $t2, 'a' 
    li $t3, 'z' 
    li $t7, '\0'
    li $t4, 0 #TOTAL NUMBER OF LOWERCASE LETTERS 
    
    find_count: 
    bgt $t2, $t3, end_count 
    li $t5, 0 #counter for number of occurances 
    move $t1, $a1
    
    find_count_loop: 
    lbu $t6, 0($t1) 
    beq $t6, $t7, store_count_and_increment
    addi $t1, $t1, 1 
    bgt $t2, $t3, end_count 
    bne $t6, $t2, find_count_loop 
    addi $t5, $t5, 1
    addi $t4, $t4, 1 
    j find_count_loop 
    
    
    store_count_and_increment: 
    sw $t5, 0($t0) 
    addi $t0, $t0, 4 #increment into next index of count
    addi $t2, $t2, 1 #increment to next lowercase letter 
    j find_count 
     
    end_count: 
    move $v0, $t4 

    jr $ra

sort_alphabet_by_count:
    li $t7, 0 #letterloop counter
    li $t6, 26
    
    
    find_current_max:
    move $t1, $a1 #store counts into $t1  
    li $t2, -1 #current max 
    li $t3, 0 #current max address
    li $t5, 0 #maxloop counter 
    
    find_current_max_loop: 
    beq $t5, $t6, store_letter
    lw $t4, 0($t1) #load next word into loop 
    bgt $t4, $t2, update_max
    increment_sort:
    addi, $t1, $t1, 4 
    addi, $t5, $t5, 1
    j find_current_max_loop 
    
    update_max: 
    move $t2, $t4
    move $t3, $t1 
    j increment_sort 
    
    store_letter: 
    li $t2, -1
    sw $t2, 0($t3) 
    sub $t3, $t3, $a1
    li $t2, 4
    div $t3, $t2
    mflo $t3 
    addi $t3, $t3, 97
    sb $t3, 0($a0)
    addi $a0, $a0, 1
    addi $t7, $t7, 1
    beq $t7, $t6, done_sorting
    j find_current_max
    
    
    
    
    done_sorting: 
    li $t8, '\0'
    sb $t8, 0($a0) 
     
    jr $ra

generate_plaintext_alphabet:
    addi $sp, $sp, -20
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp) 
    sw $s3, 12($sp) 
    sw $ra, 16($sp) 
    
    move $s0, $a0 #move plaintext alphabet into $s0
    move $s1, $a1 #move sorted alphabet into $s1
    li $s2, 'a' 
    

    iterate_sorted_alphabet: 
    li $t1, 'z'
    bgt $s2, $t1, end_sorting
    move $a0, $s1 
    move $a1, $s2
    move $a2, $0 
    jal index_of 
    move $t0, $v0 #load index of character into temporary register 
    li $t1, 0 
    beq $t0, $t1, append_nine
    li $t1, 1 
    beq $t0, $t1, append_eight 
    li $t1, 2 
    beq $t0, $t1, append_seven 
    li $t1, 3 
    beq $t0, $t1, append_six 
    li $t1, 4 
    beq $t0, $t1, append_five 
    li $t1, 5 
    beq $t0, $t1, append_four 
    li $t1, 6 
    beq $t0, $t1, append_three 
    li $t1, 7 
    beq $t0, $t1, append_two
    append_one:
    sb $s2, 0($s0) #store character once 
    addi $s0, $s0, 1 
    next_char: 
    addi $s2, $s2, 1 
    j iterate_sorted_alphabet 
    
   
    append_two: 
    li $t0, 0 
    li $t1, 2
    	loop_two: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_two
    
    
    append_three: 
    li $t0, 0 
    li $t1, 3
    	loop_three: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_three  
    
    append_four: 
    li $t0, 0 
    li $t1, 4
    	loop_four: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_four
    
    
    append_five: 
    li $t0, 0 
    li $t1, 5
    	loop_five: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_five
    
    append_six: 
    li $t0, 0 
    li $t1, 6
    	loop_six: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_six
    
    append_seven: 
    li $t0, 0 
    li $t1, 7
    	loop_seven: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_seven
    
    append_eight: 
    li $t0, 0 
    li $t1, 8
    	loop_eight: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_eight
    
    append_nine: 
    li $t0, 0 
    li $t1, 9
    	loop_nine: 
    	beq $t0, $t1, next_char
    	sb $s2, 0($s0) 
    	addi $s0, $s0, 1
    	addi $t0, $t0, 1
    	j loop_nine
         
       
    end_sorting:  
    li $t0, '\0'
    sb $t0, 0($s0) 
       
    lw $s0, 0($sp) 
    lw $s1, 4($sp) 
    lw $s2, 8($sp)
    lw $s3, 12($sp) 
    lw $ra, 16($sp) 
    addi $sp, $sp, 20      
    jr $ra
    

encrypt_letter:
    addi, $sp, $sp, -24 
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp) 
    sw $s3, 12($sp) 
    sw $s4, 16 ($sp)
    sw $ra, 20($sp) 
    
    move $s0, $a0 #save plaintext letter into $s0
    move $s1, $a1, #save letter index into $s1
    move $s2, $a2 #save plaintext alphabet into $s2
    move $s3, $a3 #save cipher text alphabet into $s3
    
    li $t0, 'a' 
    blt $s0, $t0, load_invalid 
    li $t0, 'z' 
    bgt $s0, $t0, load_invalid 
    
    find_i: #figure out the value of i which is the first index that our letter appears in
    move $a0, $s2 #move plaintext alphabet into a0 for index of function
    move $a1, $s0
    move $a2, $0 #starting index should be 0 
    jal index_of 
    move $s4, $v0 #holds i which is index of first appearance of the character
    
    find_kplus1: 
    move $a0, $s2
    move $a1, $s0 
    addi $a1, $a1, 1 
    move $a2, $0 
    jal index_of 
    move $t0, $v0 #holds i + k+1 into $t0 register
    sub $t0, $t0, $s4 
    
    computer_cypher_index: #in this code we will do some arithmetic to determine i + letter_index mod (k+1)
    div $s1, $t0 
    mfhi $s1 #last two instructions effecticely computed letter_index mod k+1 and stores it in $s1
    add $s4, $s4, $s1 #this computes i + (letter_index mod k+1) and stores it in $s4 
    
    
    li $t0, 0 #counter 
    find_letter: 
    lbu $t1, 0($s3) #get first character of cyphertext
    beq $t0, $s4, load_letter
    addi $t0, $t0, 1
    addi $s3, $s3, 1 
    j find_letter
    
    load_invalid: 
    li $v0, -1 
    j end_encryptletter 
     
    load_letter:
    move $v0, $t1
    
    end_encryptletter:  
    lw $s0, 0($sp) 
    lw $s1, 4($sp)
    lw $s2, 8($sp) 
    lw $s3, 12($sp) 
    lw $s4, 16($sp) 
    lw $ra, 20($sp)       
    addi, $sp, $sp, 24        
    jr $ra

encrypt:
    addi, $sp, $sp, -36 
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp) 
    sw $s3, 12($sp) 
    sw $s4, 16 ($sp)
    sw $s5, 20($sp) 
    sw $s6, 24($sp)
    sw $s7, 28($sp)
    sw $ra, 32($sp)
    
    move $s0, $a0 #save ciphertext into $s0
    move $s1, $a1 #save plaintext into $s1
    move $s2, $a2 #save keyphrase into $s2
    move $s3, $a3 #save corpus into $s3 
    
    encrypt_step1: 
    move $a0, $s1
    jal to_lowercase #make the plaintext lowercase
    move $a0, $s3
    jal to_lowercase #make the corpus lowercase 
    
    encrypt_step2: 
    addi $sp, $sp, -104 #allocate space for counts
    move $a0, $sp 
    move $a1, $s3
    
    encrypt_step3: 
    jal count_lowercase_letters
    move $a1, $sp #address where sp is right now is the starting address of counts we will need this in a1 for the next function
    
    
    encrypt_step4: 
    addi $sp, $sp, -28 #allocate space for lowercase letters 
    move $a0, $sp 
    
    encrypt_step5:
    jal sort_alphabet_by_count
    move $a1, $sp #address where sorted alphabet is we will need this for the next function
    
    encrypt_step6: 
    addi $sp, $sp, -64
    move $a0, $sp 
    
    encrypt_step7:
    jal generate_plaintext_alphabet
    move $s4, $sp #we will store the starting address of the plaintext alphabet in $s4 
    
    encrypt_step8: 
    addi $sp, $sp, -64 
    move $a0, $sp 
    move $a1, $s2 
    
    encrypt_step9: 
    jal generate_ciphertext_alphabet 
    move $s5, $sp #we will store the starting address of the cyphertext alphabet in $s5 
    
    encrypt_step10: 
    li $t1, 0 #number of lowercase letters that were encrypted
    li $t2, 0 #number of characters that were not encrypted 
    li $t3, 0 #letter index we are currently on 
    
    encrypt_letter_loop: 
    lbu $s6, 0($s1) #load character of plaintext alphabet 
    li $t4, '\0'
    beq $s6, $t4, encrypt_step11
    li $t4, 'a' 
    blt $s6, $t4, copy_non_lowercase
    li $t4, 'z'
    bgt $s6, $t4, copy_non_lowercase
    move $a0, $s6
    move $a1, $t3
    move $a2, $s4
    move $a3, $s5
    addi $sp, $sp, -12
    sw $t1, 0($sp) 
    sw $t2, 4($sp)
    sw $t3, 8($sp) 
    jal encrypt_letter
    lw $t1, 0($sp) 
    lw $t2, 4($sp)
    lw $t3, 8($sp) 
    addi $sp, $sp, 12
    addi $t1, $t1, 1 
    sb $v0, 0($s0) 
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    addi $t3, $t3, 1
    j encrypt_letter_loop
    
    
    copy_non_lowercase: 
    addi $t2, $t2, 1
    sb $s6, 0($s0) 
    addi $s0, $s0, 1
    addi $s1, $s1, 1 
    addi $t3, $t3, 1 
    j encrypt_letter_loop 
    
    encrypt_step11: 
    li $t4, '\0' 
    sb $t4, 0($s0) 
    
    
    move $v0, $t1
    move $v1, $t2
    
    addi $sp, $sp, 260 
    
    
    lw $s0, 0($sp) 
    lw $s1, 4($sp)
    lw $s2, 8($sp) 
    lw $s3, 12($sp) 
    lw $s4, 16($sp) 
    lw $s5, 20($sp)
    lw $s6, 24($sp) 
    lw $s7, 28($sp)  
    lw $ra, 32($sp)       
    addi, $sp, $sp, 36  
    jr $ra

decrypt:
    addi, $sp, $sp, -36 
    sw $s0, 0($sp) 
    sw $s1, 4($sp)
    sw $s2, 8($sp) 
    sw $s3, 12($sp) 
    sw $s4, 16 ($sp)
    sw $s5, 20($sp) 
    sw $s6, 24($sp)
    sw $s7, 28($sp)
    sw $ra, 32($sp)
    
    move $s0, $a0 #save plaintext into $s0
    move $s1, $a1 #save ciphertext into $s1
    move $s2, $a2 #save keyphrase into $s2
    move $s3, $a3 #save corpus into $s3 
    
    decrypt_step1: 
    move $a0, $s3 
    jal to_lowercase
    
    decrypt_step2: 
    addi $sp, $sp, -104 
    
    decrypt_step3: 
    move $a0, $sp 
    move $a1, $s3 
    jal count_lowercase_letters
    move $a1, $sp #a1 will now hold the starting address of counts 
    
    decrypt_step4: 
    addi $sp, $sp, -28
    
    decrypt_step5: 
    move $a0, $sp 
    jal sort_alphabet_by_count
    move $a1, $sp #a1 will hold the start of lowercase letters 
    
    decrypt_step6: 
    addi $sp, $sp, -64
    
    
    decrypt_step7:
    move $a0, $sp 
    jal generate_plaintext_alphabet 
    move $s4, $sp #we store the starting address of the plaintext alphabet in here
    
    decrypt_step8: 
    addi $sp, $sp, -64
    
    decrypt_step9:
    move $a0, $sp 
    move $a1, $s2
    jal generate_ciphertext_alphabet 
    move $s5, $sp #store the starting address of cyphertext alphabet in here 
    
    li $t1, 0 #will hold number of lowercase letters writtern into plaintext
    li $t2, 0 #will hold number of non-letters written into plaintext
    
    decrypt_step10: 
    lbu $s6, 0($s1) 
    li $t0, '\0' 
    beq $t0, $s6, decrypt_step11
    j check_if_alphanumeric
    index_of_letter: 
    move $a0, $s5
    move $a1, $s6
    move $a2, $0 
    addi $sp, $sp, -8 
    sw $t1, 0($sp) 
    sw $t2, 4($sp) 
    jal index_of
    lw $t1, 0($sp)
    lw $t2, 4($sp) 
    addi, $sp, $sp, 8 
    find_char_in_plaintext_alphabet: 
    li $t3, 0
    move $t4, $s4
    start_loop: 
    beq $t3, $v0, finish_loop 
    addi $t4, $t4, 1 
    addi $t3, $t3, 1 
    j start_loop
    finish_loop: 
    lbu $t5, 0($t4) 
    sb $t5, 0($s0) 
    addi $s0, $s0, 1 
    addi $s1, $s1, 1 
    addi $t1, $t1, 1 
    j decrypt_step10
       
    non_alphanumeric: 
    addi $t2, $t2, 1
    sb $s6, 0($s0) 
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    j decrypt_step10
    
    check_if_alphanumeric: 
    li $t0, '0' 
    blt $s6, $t0, non_alphanumeric
    li $t0, 'z' 
    bgt $s6, $t0, non_alphanumeric 
    li $t0, '9'
    bgt $s6, $t0 check_if_less0
    continue_check0: 
    li $t0, 'Z'
    bgt $s6, $t0, check_if_less1
    continue_check1: 
    j index_of_letter
    
    check_if_less0: 
    li $t0, 'A' 
    blt $s6, $t0, non_alphanumeric
    j continue_check0
    
    check_if_less1: 
    li $t0, 'a' 
    blt $s6, $t0, non_alphanumeric
    j continue_check1
    
    
    
    decrypt_step11: 
    li $t0, '\0' 
    sb $t0, 0($s0)
    
    
    
    move $v0, $t1
    move $v1, $t2
    
    addi $sp, $sp, 260 
    

    lw $s0, 0($sp) 
    lw $s1, 4($sp)
    lw $s2, 8($sp) 
    lw $s3, 12($sp) 
    lw $s4, 16($sp) 
    lw $s5, 20($sp)
    lw $s6, 24($sp) 
    lw $s7, 28($sp)  
    lw $ra, 32($sp)       
    addi, $sp, $sp, 36  
    jr $ra

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
