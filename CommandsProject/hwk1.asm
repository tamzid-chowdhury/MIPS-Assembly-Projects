# Tamzid Chowdhury
# tamchowdhury
# 111454408

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
addr_arg5: .word 0
addr_arg6: .word 0
addr_arg7: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
big_bobtail_str: .asciiz "BIG_BOBTAIL\n"
full_house_str: .asciiz "FULL_HOUSE\n"
five_and_dime_str: .asciiz "FIVE_AND_DIME\n"
skeet_str: .asciiz "SKEET\n"
blaze_str: .asciiz "BLAZE\n"
high_card_str: .asciiz "HIGH_CARD\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here, if any.
new_line_char: .asciiz "\n"
radix_point: .asciiz "." 

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
    li $t0, 5
    beq $a0, $t0, five_args
    li $t0, 6
    beq $a0, $t0, six_args
seven_args:
    lw $t0, 24($a1)
    sw $t0, addr_arg6
six_args:
    lw $t0, 20($a1)
    sw $t0, addr_arg5
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here

zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    
validate_first_argument: 

    lw $s0, addr_arg0 #load the address of the first argument $s0 
    
    # Check to see if the first argument contains more than 1 character 
    lbu $t0, 1($s0) #load the second character of the first argument into $t0 
    li $t1, '\0' #temporarily load the null character into $t1
    bne $t0, $t1, invalid_operation 
    
    #Check to see if the first argument contains 1,2,S,F,R,or P 
    lbu $t0, 0($s0) #load the first character of the first arguement into $t0 
    li $t1, '1'  
    beq $t0, $t1, validate_one_two_S_operation #branch to 1,2,S operation validator if the registers are equal 
    li $t1, '2'  
    beq $t0, $t1, validate_one_two_S_operation #branch to 1,2,S operation validator if the registers are equal 
    li $t1, 'S'
    beq $t0, $t1, validate_one_two_S_operation #branch to 1,2,S operation validator if the registers are equal 
    li $t1, 'F' 
    beq $t0, $t1, validate_f_operation #branch to F operation validator if the registers are equal 
    li $t1, 'R'
    beq $t0, $t1, validate_r_operation #branch to R operation validator if the registers are equal 
    li $t1, 'P'
    beq $t0, $t1, validate_p_operation #branch to P operation validator if the registers are equal 
    
    #if the code has not branched out at this point, it means that the first argument was invalid and the code will continue into the invalid operation 
    
invalid_operation: 
    la $a0, invalid_operation_error
    li $v0, 4
    syscall 
    j exit 
    
invalid_args: 
    la $a0, invalid_args_error
    li $v0, 4
    syscall
    j exit 

#validate that the number of arguments in each operation are correct 
        
validate_one_two_S_operation: 
    lw $t0, num_args
    li $t1, 3
    beq $t0, $t1, one_two_S_operation #if the number of arguments is three, jump to operation implementation 
    j invalid_args #otherwise you have the wrong number of arguments  
    
validate_f_operation: 
    lw $t0, num_args
    li $t1, 2
    beq $t0, $t1, f_operation #if the number of arguments is two, jump to operation implementation 
    j invalid_args #otherwise you have the wrong number of arguments  
    
validate_r_operation: 
    lw $t0, num_args
    li $t1, 7
    beq $t0, $t1, r_operation #if the number of arguments is seven, jump to operation implementation 
    j invalid_args #otherwise you have the wrong number of arguments  
    
validate_p_operation: 
    lw $t0, num_args
    li $t1, 2
    beq $t0, $t1, p_operation #if the number of arguments is two, jump to operation implementation 
    j invalid_args #otherwise you have the wrong number of arguments  
    
    
#END OF PART 1 OF ASSIGNMENT ------------------------------------------------------------------------------------------------


#START OF PART 2 OF ASSIGNMENT (12S Operations) 
one_two_S_operation: 
    lw $t0, addr_arg0
    lbu $s0, 0($t0) #load the first argument which is 1,2, or S which is the representation of the hexidecimal number 
    
validate_hex_code: 
    lw $t0, addr_arg1 #load second argument into temporary register
    li $t1, '\0'
    li $t2, '0' #LOWER BOUND OF OUR ASCII LETTERS VALID FOR HEX 
    li $t3, 'F' #UPPER BOUND OF OUR ASCII LETTER VALID FOR HEX 
    #there are intermediate values ": - @" which would make the hex code invalid we have to take care of 
    li $t4, ':' #intermediate lower
    li $t5, '@' #intermediate upper
    
    
  while: #while loop to iterate through the 4 hexidecimal digits 
    lbu $s1, 0($t0) #load the next character of argument 2 into the register
    beq $s1, $t1, done #check if our next digit is equal to the null terminator 
    
    #code to check if our digit is within the bounds of hex digits
    bgt $s1, $t3, invalid_args #if our digit > 'F' go to invaid args
    blt $s1, $t2, invalid_args #if our digit < '0' go to invalid args
    blt $s1, $t4, continue #continue looping if hex is a number
    bgt $s1, $t5, continue #continue looping if hex is a digit between A and F 
    j invalid_args 
    
    continue: addi $t0, $t0, 1 #increment our counter "i++" 
    j while 
    
    done:  

convert_hex_code: 
    lw $t0, addr_arg1 #load second argument into temporary register
    li $s1, 0 #eventually will be binary representation of hexidecimal number
    li $t2, '\0'
    li $t8, '9' #ascii code temporary   
    li $t9, 12 #variable shift that will decrease over time
    
    
    start_hex_loop: 
    lbu $t1, 0($t0) #load first character into expression
    beq $t1, $t2, end_hex_loop 
    bgt $t1, $t8, subtract_digit
    
    substract_num: 
    addi $t1, $t1, -48 #if the ascii code is between 0-9 subtract 48 to get correct binary
    j continue_conversion
    
    subtract_digit: 
    addi $t1, $t1, -55 #if the ascii code is between a-e subtract 55 to get correct binary
    
    continue_conversion: 
    sllv $t1, $t1, $t9 #shift to its correct place in the binary representation 
    or $s1, $t1, $s1 
    addi $t9, $t9, -4 
    addi $t0, $t0, 1
    j start_hex_loop
    end_hex_loop: 
    
convert_and_validate_third_argument: 

    #convert string representation of third argument to decimal 
    lw $t0, addr_arg2 #load third argument into temporary regster
    li $s2, 0 #this will eventually be the decimal representation 
    li $t2, 48 #how much we will have to subtract 
    li $t3, 10 #will use for multiplication 
    
    lbu $t1, 0($t0) #load first digit into $t1
    sub $t1, $t1, $t2 #this will give us the correct digit in decimal ($t1 - 48) 
    mul $t1, $t1, $t3 #since the digit is in the 10's place we multiply by 10 
    add $s2, $s2, $t1 #we add our result into the saved register
    lbu $t1, 1($t0) 
    sub $t1, $t1, $t2
    add $s2, $s2, $t1 
    #ascii code has been converted to actual number representation 

    #validate that the number is between 16 and 32 
    li $t2, 16 #lower bound 
    li $t3, 32 #upper bound
    blt $s2, $t2, invalid_args
    bgt $s2, $t3, invalid_args
    
check_MSB: #check if the most significant bit is 1 or 0 --> if it is 0 we can output the number, if it is 1 we must convert based on representation
    li $t0, 1 #will use to check if msb is 1 
    srl  $t1, $s1, 15 
    andi $t2, $t1, 0x0001
    beq $t2, $t0, check_representation
        
output_binary_number: #output the number in $s2 within the number of bits in $s3
    addi $s2, $s2, -1 
    loop: 
    srlv $t4, $s1, $s2 #shift the hex number so the MSB will be at the LSB
    andi  $a0, $t4, 0x0001 
    li $v0, 1 
    syscall 
    addi $s2, $s2, -1
    bltz $s2, print_newline_char 
    j loop 
    
    print_newline_char: #print a new line character 
    la $a0, new_line_char
    li $v0, 4
    syscall 
    j exit
    
check_representation: 
    li $t0, '1'
    li $t1, '2'
    li $t2, 'S' 
    beq $s0, $t0, convert_ones
    beq $s0, $t1, convert_twos
    beq $s0, $t2, convert_signed 
    
    
convert_ones: #same as converting 2s but we would just need to add 1 after or'ing 
    li $t0, 0xFFFF0000
    or $s1, $s1, $t0  
    addi, $s1, $s1, 1 
    j output_binary_number

convert_twos: #we would just need to change all the 0's after the MSB to 1's to signify a two's complement number 
    li $t0, 0xFFFF0000 
    or $s1, $s1, $t0 #combines the leading 1s with the hexidecimal number  
    j output_binary_number

convert_signed:  
    nor $s1, $s1, $0 #invert bits
    addi $s1, $s1, 1 #add one to get twos complement
    ori, $s1, $s1, 0x8000 #make the 16th bit a 1 
    j output_binary_number
    
    
#END OF PART 2 OF ASSIGNMENT  ----------------------------------------------------------------------------------------------------------
    
    
#START OF PART 3 OF ASSIGNMENT ---------------------------------------------------------------------------------------------------------
f_operation: 
    lw $s0, addr_arg1 #load second argument saved register
    
get_left_side_in_decimal: 
    li $s1, 0 #this will eventually become the whole number part of base 10 representation 
    lbu $t0, 0($s0)
    addi $t0, $t0, -48
    li $t1, 100 #we will multiple the hundreds place by 100 
    mul $t0, $t0, $t1 
    add $s1, $s1, $t0
    lbu $t0, 1($s0)
    li $t1, 10 
    addi $t0, $t0, -48
    mul $t0, $t0, $t1 
    add $s1, $s1, $t0
    lbu $t0, 2($s0)
    addi $t0, $t0, -48
    add $s1, $s1, $t0  #upon completion of the instructions following the last label, our $s1 will hold the value of the whole number before the decimal 

        
print_out_left_side_in_binary: 
    check_if_zero: #first check if the whole number value is just 0 
    beqz $s1, print_bits
    
    li $t0, 9 #the decimal number 999 will have no more than 10 bits 
    li $t3, 1 #for bit masking and checking if LSB is 1 
    check_num_of_bits: #how many bits to start printing from 
    srlv $t1, $s1, $t0
    and $t2, $t1, $t3
    beq $t2, $t3, print_bits 
    addi $t0, $t0, -1 
    j check_num_of_bits
    
    print_bits: 
    srlv $t4, $s1, $t0 #shift the hex number so the MSB will be at the LSB
    andi $a0, $t4, 0x0001 
    li $v0, 1 
    syscall 
    addi $t0, $t0, -1
    bltz $t0, print_radix_point
    j print_bits
    
    print_radix_point: #print a new line character 
    la $a0, radix_point
    li $v0, 4
    syscall 
    
get_right_side_in_decimal: 
    li $s1, 0 #this will eventually become the decimal part of base 10 representation 
    lbu $t0, 4($s0)
    addi $t0, $t0, -48
    li $t1, 10000 #we will multiple the hundreds place by 10000 
    mul $t0, $t0, $t1 
    add $s1, $s1, $t0
    lbu $t0, 5($s0)
    li $t1, 1000 
    addi $t0, $t0, -48
    mul $t0, $t0, $t1 
    add $s1, $s1, $t0
    lbu $t0, 6($s0)
    li $t1, 100
    addi $t0, $t0, -48
    mul $t0, $t0, $t1 
    add $s1, $s1, $t0
    lbu $t0, 7($s0) 
    li $t1, 10 
    addi $t0, $t0, -48
    mul $t0, $t0, $t1
    add $s1, $s1, $t0 
    lbu $t0, 8($s0)
    addi $t0, $t0, -48
    add $s1, $s1, $t0 #at this point $s1 should have the right side of the decimal 
    
print_out_right_side_in_binary: #print out the right side in binary form 
    li $t0, 0 #we will continue to check if t0 > s1
    li $t1, 50000
    li $t2, -50000
    li $t5, 0 #will hold 2^-1s place
    li $t6, 0 #will hold 2^-2s place
    li $t7, 0 #will hold 2^-3s place
    li $t8, 0 #will hold 2^-4s place
    li $t9, 0 #will hold 2^-5s place
 
    try_t5: 
    add $t0, $t0, $t1
    bge $s1, $t0, invert_t5
    add $t0, $t0, $t2
    j try_t6
        
    invert_t5: 
    li $t5, 1 
    
    try_t6: 
    addi $t0, $t0, 25000
    bge $s1, $t0, invert_t6
    addi $t0, $t0, -25000
    j try_t7
    
    invert_t6: 
    li $t6, 1
    
    try_t7: 
    addi $t0, $t0, 12500
    bge $s1, $t0, invert_t7
    addi $t0, $t0, -12500
    j try_t8
    
    invert_t7: 
    li $t7, 1
    
    try_t8: 
    addi $t0, $t0, 6250
    bge $s1, $t0, invert_t8
    addi $t0, $t0, -6250
    j try_t9
    
    invert_t8: 
    li $t8, 1
    
    try_t9: 
    addi $t0, $t0, 3125
    bge $s1, $t0, invert_t9
    addi $t0, $t0, -3125
    j print_numbers
    
    invert_t9: 
    li $t9, 1
    
    print_numbers: #each register will hold a point after the radix point so now we print them in order 
    move $a0, $t5
    li $v0, 1
    syscall
    move $a0, $t6
    syscall
    move $a0, $t7
    syscall
    move $a0, $t8
    syscall
    move $a0, $t9
    syscall
    la $a0, new_line_char
    li $v0, 4
    syscall 
    j exit 
    
#END OF PART 3 OF ASSIGNMENT ------------------------------------------------------------------------------------------------------------


#START OF PART 4 OF ASSIGNMENT ----------------------------------------------------------------------------------------------------------
r_operation: 
    #we will begin by validating and saving each argument into a saved register as its decimal value 
    li $t1, 10 
    li $t2, 31
    li $t3, 63
    
    li $s2, 0 #we can assume that the second argument will be 0 
    
    #validate and store third argument (RS) 
    li $s3, 0 #will store third argument in decimal representation 
    lw $s0, addr_arg2 
    lbu $t0, 0($s0)
    addi $t0, $t0, -48 #subtract 48 to ascii value to get actual decimal value
    mul $t0, $t0, $t1 
    add $s3, $s3, $t0
    lbu $t0, 1($s0) 
    addi $t0, $t0, -48
    add $s3, $s3, $t0 
    bgt $s3, $t2, invalid_args #if the third argument is greater than 31
    bltz $s3, invalid_args
    
    #validate and store fourth argument (RT) 
    li $s4, 0 #will store third argument in decimal representation 
    lw $s0, addr_arg3 
    lbu $t0, 0($s0)
    addi $t0, $t0, -48 #subtract 48 to ascii value to get actual decimal value
    mul $t0, $t0, $t1
    add $s4, $s4, $t0
    lbu $t0, 1($s0) 
    addi $t0, $t0, -48 
    add $s4, $s4, $t0 
    bgt $s4, $t2, invalid_args #if the third argument is greater than 31
    bltz $s4, invalid_args
    
    #validate and store fifth argument (RD) 
    li $s5, 0 #will store third argument in decimal representation 
    lw $s0, addr_arg4 
    lbu $t0, 0($s0)
    addi $t0, $t0, -48 #subtract 48 to ascii value to get actual decimal value
    mul $t0, $t0, $t1
    add $s5, $s5, $t0
    lbu $t0, 1($s0) 
    addi $t0, $t0, -48 
    add $s5, $s5, $t0 
    bgt $s5, $t2, invalid_args #if the third argument is greater than 31
    bltz $s4, invalid_args
    
    #validate and store sixth argument (shamt) 
    li $s6, 0 #will store third argument in decimal representation 
    lw $s0, addr_arg5 
    lbu $t0, 0($s0)
    addi $t0, $t0, -48 #subtract 48 to ascii value to get actual decimal value
    mul $t0, $t0, $t1 
    add $s6, $s6, $t0
    lbu $t0, 1($s0) 
    addi $t0, $t0, -48
    add $s6, $s6, $t0 
    bgt $s6, $t2, invalid_args #if the third argument is greater than 31
    bltz $s6, invalid_args
    
    #validate and store seventh argument (funct) 
    li $s7, 0 #will store third argument in decimal representation 
    lw $s0, addr_arg6 
    lbu $t0, 0($s0)
    addi $t0, $t0, -48 #subtract 48 to ascii value to get actual decimal value
    mul $t0, $t0, $t1 
    add $s7, $s7, $t0
    lbu $t0, 1($s0) 
    addi $t0, $t0, -48
    add $s7, $s7, $t0 
    bgt $s7, $t3, invalid_args #if the third argument is greater than 63
    bltz $s7, invalid_args
    
    #AT THIS POINT $s2 = OPCODE , $s3 = RS , $s4 = RT , $s5 = RD , $s6 = SHAMT , $s7 = FUNCT 
    #OUR $s1 REGISTER WILL HOLD THE FINAL ENCODING IN 32 BIT
    
shifting_and_combining_values: 
    li $s1, 0 
    sll $s3, $s3, 21
    or $s1, $s1, $s3 
    sll $s4, $s4, 16
    or $s1, $s1, $s4
    sll $s5, $s5, 11 
    or $s1, $s1, $s5 
    sll $s6, $s6, 6
    or $s1, $s1, $s6
    or $s1, $s1, $s7 
    
    #print the hexidecimal representation 
    move $a0, $s1
    li $v0, 34
    syscall
    la $a0, new_line_char
    li $v0, 4
    j exit
    
    
#END OF PART 4 OF ASSIGNMENT -------------------------------------------------------------------------------------------------------------

#START OF PART 5 OF ASSIGNMENT -----------------------------------------------------------------------------------------------------------

p_operation: 
   lw $s0, addr_arg1
   lbu $s1, 0($s0) #first card in $s1
   lbu $s2, 1($s0) #second card in $s2
   lbu $s3, 2($s0) #third card in $s3
   lbu $s4, 3($s0) #fourth card in $s4
   lbu $s5, 4($s0) #fifth card in $s5 
   
 check_big_bobtail: 
   lw $s0, addr_arg1 #reset address of arg 1 
   li $t0, 6 #counter
   li $t1, 0 #will be used to load value of suit
   li $t4, 0 #will hold num of clubs
   li $t5, 0 #will hold num of spades
   li $t6, 0 #will hold num of diomands
   li $t7, 0 #will hold num of hearts 

 
   check_big_bobtail_card: #first we will check if there are four cards with the same suit 
   addi $t0, $t0, -1  
   beqz $t0, check_for_four_or_five
   lbu $s6, 0($s0) #in this check, we will check each card suit one by one 
   addi $s0, $s0, 1
   andi $s6, $s6, 0x00F0
   srl $s6, $s6, 4 #move suit to LSB 
   li $t1, 4
   beq $s6, $t1, increment_clubs 
   li $t1, 5
   beq $s6, $t1, increment_spades 
   li $t1, 6
   beq $s6, $t1, increment_diomands
   li $t1, 7
   beq $s6, $t1, increment_hearts 
   
   increment_clubs:
   addi $t4, $t4, 1
   j check_big_bobtail_card
   
   increment_spades:
   addi $t5, $t5, 1
   j check_big_bobtail_card
      
   increment_diomands:
   addi $t5, $t5, 1
   j check_big_bobtail_card 
   
   increment_hearts: 
   addi $t5, $t5, 1
   j check_big_bobtail_card
 	
   check_for_four_or_five: #check if any suit has four cards 
   li $t1, 4
   li $t2, 5 #check if there are 5 consecutives
   li $s7, 4 #this will save which suit has four consecutive cards
   beq $t2, $t4, check_five_consecutives 
   beq $t1, $t4, check_consecutives
   li $s7, 5
   beq $t2, $t5, check_five_consecutives 
   beq $t1, $t5, check_consecutives
   li $s7, 6
   beq $t2, $t6, check_five_consecutives 
   beq $t1, $t6, check_consecutives
   li $s7, 7
   beq $t2, $t7, check_five_consecutives 
   beq $t1, $t7, check_consecutives
   j check_fullhouse
   
   check_consecutives: #now that we know we have four cards of the same suit we can check if they are consecutive
   lw $s0, addr_arg1 #reset address of arg 1 
   li $t0, 6 #counter
   li $t4, 0 #will hold card1
   li $t5, 0 #will hold card2
   li $t6, 0 #will hold card3
   li $t7, 0 #will hold card4
   
   storing_cards: 
   addi $t0, $t0, -1  
   beqz $t0, check_four_cards
   lbu $s6, 0($s0) #in this check, we will check each card suit one by one 
   addi $s0, $s0, 1
   andi $t9, $s6, 0x00F0
   srl $t9, $t9, 4 #move suit to LSB 
   andi $s6, $s6, 0x000F
   bne $t9, $s7, storing_cards
   beqz $t4, store_card1
   beqz $t5, store_card2
   beqz $t6, store_card3
   beqz $t7, store_card4
   
   store_card1: 
   move $t4, $s6
   j storing_cards
   
   store_card2: 
   move $t5, $s6
   j storing_cards
   
   store_card3: 
   move $t6, $s6
   j storing_cards
   
   store_card4: 
   move $t7, $s6 
   j storing_cards
   
   
   check_four_cards:  #at this point $t4 $t5 $t6 $t7 hold the rank values, we must check if they are consecutive 
   #first find the value that is the lowest and store it in $t8
   bgt $t4, $t5, t4_GT_t5
   bgt $t4, $t6, t4_GT_t6
   bgt $t4, $t7, t4_GT_t7  
   move $t8, $t4
   j check_part_2
   
   t4_GT_t5: 
   bgt $t5, $t6, t4_GT_t6
   bgt $t5, $t7, t4_GT_t7
   move $t8, $t5
   j check_part_2
   
   t4_GT_t6:
   bgt $t6, $t7, t4_GT_t7
   move $t8, $t6
   
   t4_GT_t7: 
   move $t8, $t7
   
   check_part_2: 
   confirm1: 
   beq $t8, $t4, confirm2
   beq $t8, $t5, confirm2
   beq $t8, $t6, confirm2
   beq $t8, $t7, confirm2 
   j check_fullhouse
   
   confirm2:
   addi $t8, $t8, 1  
   beq $t8, $t4, confirm3
   beq $t8, $t5, confirm3
   beq $t8, $t6, confirm3
   beq $t8, $t7, confirm3 
   j check_fullhouse
   
   confirm3:
   addi $t8, $t8, 1  
   beq $t8, $t4, confirm4
   beq $t8, $t5, confirm4
   beq $t8, $t6, confirm4
   beq $t8, $t7, confirm4 
   j check_fullhouse
   
   confirm4:
   addi $t8, $t8, 1  
   beq $t8, $t4, print_big_bobtail
   beq $t8, $t5, print_big_bobtail
   beq $t8, $t6, print_big_bobtail
   beq $t8, $t7, print_big_bobtail
   j check_fullhouse
   
   check_five_consecutives: #check if the five cards of the same suit, if four of them are consecutive 
   li $s6, 0 #temporary for swaps 
   
   sort_register_s1: 
   bgt $s1, $s2, swap_s1_s2
   bgt $s1, $s3, swap_s1_s3
   bgt $s1, $s4, swap_s1_s4
   bgt $s1, $s5, swap_s1_s5
   j sort_register_s2
   
   swap_s1_s2:
   move $s6, $s1
   move $s1, $s2
   move $s2, $s6
   bgt $s1, $s3, swap_s1_s3
   bgt $s1, $s4, swap_s1_s4
   bgt $s1, $s5, swap_s1_s5
   j sort_register_s2
   
   swap_s1_s3:
   move $s6, $s1 
   move $s1, $s3 
   move $s3, $s6
   bgt $s1, $s4, swap_s1_s4
   bgt $s1, $s5, swap_s1_s5
   j sort_register_s2
   
   swap_s1_s4: 
   move $s6, $s1
   move $s1, $s4
   move $s4, $s6
   bgt $s1, $s5, swap_s1_s5
   j sort_register_s2
   
   swap_s1_s5: 
   move $s6, $s1
   move $s1, $s5 
   move $s5, $s6
   j sort_register_s2
   
   sort_register_s2: 
   bgt $s2, $s3, swap_s2_s3
   bgt $s2, $s4, swap_s2_s4
   bgt $s2, $s5, swap_s2_s5
   j sort_register_s3
   
   swap_s2_s3:
   move $s6, $s2
   move $s2, $s3
   move $s3, $s6 
   bgt $s2, $s4, swap_s2_s4
   bgt $s2, $s5, swap_s2_s5
   j sort_register_s3
   
   swap_s2_s4:
   move $s6, $s2
   move $s2, $s4
   move $s4, $s6
   bgt $s2, $s5, swap_s2_s5
   j sort_register_s3
   
   swap_s2_s5:
   move $s6, $s2
   move $s2, $s5
   move $s5, $s6
   j sort_register_s3 
   
   sort_register_s3:
   bgt $s3, $s4, swap_s3_s4
   bgt $s3, $s5, swap_s3_s5
   j sort_register_s4
   
   swap_s3_s4: 
   move $s6, $s3
   move $s3, $s4
   move $s4, $s6
   bgt $s3, $s5, swap_s3_s5
   j sort_register_s4
   
   swap_s3_s5:
   move $s6, $s3
   move $s3, $s5
   move $s5, $s6
   j sort_register_s4
   
   sort_register_s4: 
   bgt $s4, $s5, swap_s4_s5
   j check_after_sort
   
   swap_s4_s5: 
   move $s6, $s4
   move $s4, $s5
   move $s5, $s6
   j check_after_sort 
   
   check_after_sort: #after the registers holding the 5 cards have been sorted check for consecutives 
   addi $s1, $s1, 1
   bne $s1, $s2, check_s2_to_s5 #if the first card is not one more than the next we will check if s2 thru s5 are consecutive
   addi $s2, $s2, 1
   bne $s2, $s3, check_fullhouse
   addi $s3, $s3, 1
   bne $s3, $s4, check_fullhouse
   j print_big_bobtail
      
   check_s2_to_s5:
   addi $s2, $s2, 1
   bne $s2, $s3, check_fullhouse
   addi $s3, $s3, 1
   bne $s3, $s4, check_fullhouse
   addi $s4, $s4, 1
   bne $s4, $s5, check_fullhouse
     
   print_big_bobtail: 
   la $a0, big_bobtail_str
   li $v0, 4
   syscall
   j exit  
   
 check_fullhouse: 
   lw $s0, addr_arg1 #reset address of arg 1 
   li $t0, 6 #counter
   li $t1, 0 #counter for pair1
   li $t2, 0 #counter for pair2
   li $t3, 0 #will hold value of pair1
   li $t4, 0 #will hold value of pair2
   li $t5, 2
   li $t6, 3
   
   check_fullhouse_card:
   addi $t0, $t0, -1  
   beqz $t0, print_fullhouse
   lbu $s6, 0($s0) #in this check, we will check each card one by one 
   addi $s0, $s0, 1
   andi $s6, $s6, 0x000F
   beq $s6, $t3, got_pair1
   beq $s6, $t4, got_pair2 
   beqz $t1, start_pair1
   beqz $t2, start_pair2
   j check_five_and_dime
   
   start_pair1:
   move $t3, $s6
   li $t1, 1 
   j check_fullhouse_card
   
   start_pair2: 
   move $t4, $s6
   li $t2, 1 
   j check_fullhouse_card
   
   got_pair1: 
   beq $t1, $t5, got_trio_from_pair1 #if counter for pair is already 2 then this must be a trio 
   beq $t1, $t6, check_five_and_dime #if counter for pair is 3, then adding 1 more would make this not a full house
   addi $t1, $t1, 1 
   j check_fullhouse_card
   
   got_pair2: 
   beq $t2, $t5, got_trio_from_pair2 #if counter for pair is already 2 then this must be a trio 
   beq $t2, $t6, check_five_and_dime 
   addi $t2, $t2, 1 
   j check_fullhouse_card
   
   got_trio_from_pair1: 
   beq $t2, $t5, print_fullhouse #if the other pair is complete print fullhouse
   addi $t1, $t1, 1
   j check_fullhouse_card
   
   got_trio_from_pair2:
   beq $t1, $t5, print_fullhouse #if the other pair is complete print fullhouse 
   addi $t2, $t2, 1
   j check_fullhouse_card
   
      
   print_fullhouse: 
   la $a0, full_house_str
   li $v0, 4
   syscall
   j exit
   
 check_five_and_dime: 
   lw $s0, addr_arg1 #reset address of arg 1 
   li $t0, 6 #counter 
   li $t1, 0 #should eventually hold 5
   li $t2, 0 #should eventually hold 10
   li $t3, 0 #should eventually hold other1
   li $t4, 0 #should eventually hold other2
   li $t5, 0 #should eventually hold other3 
   li $t6, 0x5 #temp for 5 check
   li $t7, 0xA #temp for 10 check
 
   
   check_five_and_dime_card:
   addi $t0, $t0, -1  
   beqz $t0, print_five_and_dime
   lbu $s6, 0($s0) #in this check, we will check each card one by one 
   addi $s0, $s0, 1
   andi $s6, $s6, 0x000F
   beq $s6, $t6, got_five
   beq $s6, $t7, got_ten
   
   got_other_one:
   bgtz $t3, got_other_two #if first other is filled try the next
   bgt $s6, $t7, check_skeet #if greater than 10 cannot be five and dime
   blt $s6, $t6, check_skeet #if less than 5 cannot be five and dime 
   move $t3, $s6
   j check_five_and_dime_card
   
   got_other_two:
   beq $s6, $t3, check_skeet
   bgtz $t4, got_other_three #if second other is filled try the next
   bgt $s6, $t7, check_skeet #if greater than 10 cannot be five and dime
   blt $s6, $t6, check_skeet #if less than 5 cannot be five and dime 
   move $t4, $s6
   j check_five_and_dime_card
   
   got_other_three:
   beq $s6, $t4, check_skeet 
   bgtz $t5, check_skeet #if all others are filled it cannot be five and dime 
   bgt $s6, $t7, check_skeet #if greater than 10 cannot be five and dime
   blt $s6, $t6, check_skeet #if less than 5 cannot be five and dime 
   move $t5, $s6
   j check_five_and_dime_card

   got_five:
   beq $t1, $t6, check_skeet #if $t1 already holds a 5 it cannot be five and dime
   li $t1, 5
   j check_five_and_dime_card
   
   got_ten: 
   beq $t2, $t7, check_skeet #if $t1 already holds a 10 it cannot be five and dime
   li $t2, 10
   j check_five_and_dime_card
      
   print_five_and_dime: 
   la $a0, five_and_dime_str
   li $v0, 4
   syscall
   j exit
   
 check_skeet:
   lw $s0, addr_arg1 #reset address of arg 1 
   li $t0, 6 #counter 
   li $t1, 0 #should eventually hold 2
   li $t2, 0 #should eventually hold 5
   li $t3, 0 #should eventually hold 9
   li $t4, 0 #should eventually hold (1,4,5,6,7,8)
   li $t5, 0 #should eventually hold (1,4,5,6,7,8) but must be unique from $t4 
   li $t6, 0x2 #temp for 2 check
   li $t7, 0x5 #temp for 5 check
   li $t8, 0x9 #temp for 9 check

   
   check_skeet_card:
   addi $t0, $t0, -1  
   beqz $t0, print_skeet
   lbu $s6, 0($s0) #in this check, we will check each card one by one 
   addi $s0, $s0, 1
   andi $s6, $s6, 0x000F
   beq $s6, $t6, got_two
   beq $s6, $t7, got_five1
   beq $s6, $t8, got_nine 
   
   got_other1: 
   bgtz $t4, got_other2 #branch to other card if first one is filled
   bgt $s6, $t8, check_blaze #if other card is greater than 9 it cannot be skeet
   blt $s6, $t6, check_blaze #if other card is less than 2 it cannot be skeet
   move $t4, $s6
   j check_skeet_card
   
   got_other2:
   bgtz $t5, check_blaze #if both other cards are filled it cannot be a skeet 
   bgt $s6, $t8, check_blaze #if other card is greater than 9 it cannot be skeet
   blt $s6, $t6, check_blaze #if other card is less than 2 it cannot be skeet
   move $t5, $s6
   j check_skeet_card
   
   got_two:
   beq $t1, $t6, check_blaze #if $t1 already holds a two it cannot be skeet  
   li $t1, 2
   j check_skeet_card
   
   got_five1:
   beq $t2, $t7, check_blaze #if $t2 already holds a three it cannot be skeet
   li $t2, 5
   j check_skeet_card 
   
   got_nine: 
   beq $t3, $t8, check_blaze #if $t2 already holds a nine it cannot be skeet
   li $t3, 9
   j check_skeet_card
   
   print_skeet: 
   beq $t4, $t5, check_blaze #if both other cards are equal they cannot be a skeet 
   la $a0, skeet_str
   li $v0, 4
   syscall
   j exit
   
 check_blaze: #isolate the least significant byte in order to check that the rank is either jack king or queen 
   lw $s0, addr_arg1 #reset address of arg 1 
   li $t6, 0xB
   li $t7, 0xC
   li $t8, 0xD
   
   blaze_card_1: 
   andi $t1, $s1, 0x000F #isolate the LSB of first card
   beq $t1, $t6 , blaze_card_2
   beq $t1, $t7 , blaze_card_2
   bne $t1, $t8 , print_high_card
   
   blaze_card_2: 
   andi $t2, $s2, 0x000F #isolate the LSB of second card
   beq $t2, $t6 , blaze_card_3
   beq $t2, $t7 , blaze_card_3
   bne $t2, $t8 , print_high_card
   
   blaze_card_3: 
   andi $t3, $s3, 0x000F #isolate the LSB of third card
   beq $t3, $t6 , blaze_card_4
   beq $t3, $t7 , blaze_card_4
   bne $t3, $t8 , print_high_card
   
   blaze_card_4: 
   andi $t4, $s4, 0x000F #isolate the LSB of fourth card
   beq $t4, $t6 , blaze_card_5
   beq $t4, $t7 , blaze_card_5
   bne $t4, $t8 , print_high_card
   
   blaze_card_5: 
   andi $t5, $s5, 0x000F #isolate the LSB of fifth card
   beq $t5, $t6 , print_blaze
   beq $t5, $t7 , print_blaze
   bne $t5, $t8 , print_high_card
   
   print_blaze:
   la $a0, blaze_str
   li $v0, 4
   syscall
   j exit
   
   print_high_card: #if it is not any of the other ones, we print high card 
   la $a0, high_card_str
   li $v0, 4
   syscall
   
#END OF PART 5 OF ASSIGNMENT -------------------------------------------------------------------------------------------------------------

exit:
    li $v0, 10
    syscall
