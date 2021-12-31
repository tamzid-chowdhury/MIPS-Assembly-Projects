#tamzid chowdhury
#tamchowdhury
#111454408

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
memcpy:
   
    blez $a2, invalid_n
    li $t0, 0 #counter for loop
    
    copy_loop: 
    beq $t0, $a2, done_memcpy
    lbu $t1, 0($a1) #load character of src into t1
    sb $t1, 0($a0) #store character into dest
    addi $t0, $t0, 1
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    j copy_loop
    
    
    invalid_n:
    li $v0, -1
    j end_memcpy
    
    done_memcpy:
    move $v0, $a2
    
    end_memcpy: 
    jr $ra
    
    
strcmp:
    li $t0, '\0'
    lbu $t1, 0($a0) #string 1
    lbu $t2, 0($a1) #string 2
    
    beq $t1, $t0, s2_negate_length #if string1 is empty return length of stirng 2 negated
    beq $t2, $t0, s1_length #if string2 is empty return length of string 1 
    
    compare_strings: 
    lbu $t1, 0($a0)
    lbu $t2, 0($a1)
    bne $t1, $t2, ascii_diff
    beq $t1, $t0, both_empty
    addi $a0, $a0, 1 
    addi $a1, $a1, 1 
    j compare_strings
    
    s2_negate_length:
    beq $t2, $t0, both_empty #if string 2 is empty then both are empty 
    li $t3, 0 #counter
    addi $a1, $a1, 1 
    loop_s2:
    lbu $t2, 0($a1)
    addi $t3, $t3, -1
    addi $a1, $a1, 1
    bne $t2, $t0, loop_s2
    move $v0, $t3
    j done_strcmp
    
    s1_length: 
    li $t3, 0 #counter
    addi $a0, $a0, 1 
    loop_s1: 
    lbu $t1, 0($a0) 
    addi $t3, $t3, 1
    addi $a0, $a0, 1 
    bne $t1, $t0, loop_s1
    move $v0, $t3
    j done_strcmp
    
    ascii_diff: #t1, #t2 ascii difference
    sub $v0, $t1, $t2
    j done_strcmp
    
    
    both_empty:
    li $v0, 0 
    done_strcmp: 
    jr $ra

initialize_hashtable:
    blez $a1, set_invalid
    blez $a2, set_invalid
    li $v0, 0 
    
    sw $a1, 0($a0)
    sw $0, 4($a0) 
    sw $a2, 8($a0) 
    
    mul $t0, $a1, $a2 #t0 is now our limit for counter 
    li $t1, 0 #our counter
    
    loop_thru_elements:
    sb $0, 12($a0) 
    addi $t1, $t1, 1 
    beq $t1, $t0, done_init
    addi $a0, $a0, 1
    j loop_thru_elements
    
    
    
    set_invalid: 
    li $v0, -1
    done_init: 
    jr $ra

hash_book: 

    lw $t0, 0($a0) #load capacity into t0 
    
    li $t1, 0 #accumulator 
    loop_thru_isbn:
    lbu $t2, 0($a1) 
    beq $t2, $0, get_hash_function
    add $t1, $t1, $t2
    addi $a1, $a1, 1
    j loop_thru_isbn
    
    get_hash_function: #sum % capacity 
    div $t1, $t0
    mfhi $v0 
    
    jr $ra

get_book:
    addi $sp, $sp, -28
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp) 
    sw $s4, 20($sp)  
    sw $s5, 24($sp)
    
    move $s0, $a0 #books hashtable
    move $s1, $a1 #isbn 
    lbu $s4, 0($s0) #capacity
    
    
    jal hash_book 
    move $s2, $v0 #starting index 
    move $s5, $v0 #need an extra copy of starting index 
    li $s3, 1 #number of entries 
    
    addi $s0, $s0, 12 #start from the elements feild of the struct 
    beqz $s2, check_index
    
    li $t0, 0 #counter
    reach_first_index: 
    addi $s0, $s0, 68
    addi $t0, $t0, 1 
    bne $t0, $s2, reach_first_index
    
    check_index: 
    lbu $t0, 0($s0) 
    beqz $t0, empty_entry
    li $t1, 0xff 
    beq $t0, $t1, get_next_index 
    compare_isbn: 
    move $a0, $s1 #isbn
    move $a1, $s0 #current isbn
    jal strcmp
    beqz $v0, found_isbn
    j get_next_index 
    
    
    get_next_index: 
    addi $s2, $s2, 1 
    bne $s2, $s4, skip_wrap_around
    addi $t0, $s2, -1 
    li $t1, -68
    mul $t0, $t0, $t1
    add $s0, $s0, $t0 #we return to index 0 
    li $s2, 0 
    beq $s2, $s5, not_found
    addi $s3, $s3, 1 
    j check_index 
    skip_wrap_around:
    beq $s2, $s5, not_found 
    addi $s3, $s3, 1 
    addi $s0, $s0, 68 
    j check_index 
    
    
    
    
    empty_entry: 
    li $v0, -1
    move $v1, $s3
    j done_get_book 
    
    not_found:
    li $v0, -1 
    move $v1, $s3
    j done_get_book 
    
    found_isbn: 
    move $v0, $s2
    move $v1, $s3 
    j done_get_book
    
    
    done_get_book: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp) 
    lw $s3, 16($sp) 
    lw $s4, 20($sp)  
    lw $s5, 24($sp) 
    addi $sp, $sp, 28 	
    jr $ra

add_book:
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
    
    
    move $s0, $a0 #hash table
    move $s1, $a1 #isbn 
    move $s2, $a2 #title
    move $s3, $a3 #author
    lbu $s7, 0($s0) #capicty
    lbu $t1, 1($s0) #size 
    move $t9, $a0
    addi $t9, $t9, 4 #t9 holds address of size 
   
    beq $s7, $t1, full_table
    
    addi $sp, $sp, -4
    sw $t9, 0($sp) 
    jal get_book
    lw $t9, 0($sp) 
    addi $sp, $sp, 4 
    
    bgez $v0, book_already_in_table
    
    move $a0, $s0
    move $a1, $s1
    
    addi $sp, $sp, -4
    sw $t9, 0($sp) 
    jal hash_book 
    lw $t9, 0($sp) 
    addi $sp, $sp, 4 
    
    move $s4, $v0 #starting index 
    move $s5, $v0 #need an extra copy of starting index 
    li $s6, 1 #number of entries 
    
    addi $s0, $s0, 12 #start from the elements feild of the struct 
    beqz $s4, check_index1
    
    li $t0, 0 #counter
    reach_first_index1: 
    addi $s0, $s0, 68
    addi $t0, $t0, 1 
    bne $t0, $s4, reach_first_index1
    
    check_index1: 
    lbu $t0, 0($s0) 
    beqz $t0, increment_size
    li $t1, 0xff 
    beq $t0, $t1, increment_size 
    j get_next_index1 
    
    
    get_next_index1: 
    addi $s4, $s4, 1 
    bne $s4, $s7, skip_wrap_around1
    addi $t0, $s4, -1 
    li $t1, -68
    mul $t0, $t0, $t1
    add $s0, $s0, $t0 #we return to index 0 
    li $s4, 0 
    addi $s6, $s6, 1 
    j check_index1
    skip_wrap_around1:
    addi $s6, $s6, 1 
    addi $s0, $s0, 68 
    j check_index1
    
    increment_size:
    lw $t0, 0($t9) 
    addi $t0, $t0, 1 
    sw $t0, 0($t9) 
    move $v0, $s4
    move $v1, $s6 
    
    add_isbn: #s1 
    move $a0, $s0
    move $a1, $s1
    li $a2, 14
    addi $sp, $sp, -8 
    sw $v0, 0($sp) 
    sw $v1, 4($sp) 
    jal memcpy
    lw $v0, 0($sp) 
    lw $v1, 4($sp) 
    addi $sp, $sp, 8 
    addi $s0, $s0, 14

    
    li $t0, 0
    li $t1, 24
    add_title: #s2
    lbu $t3, 0($s2) 
    beqz $t3, append_null
    sb $t3, 0($s0) 
    addi $s2, $s2, 1 
    addi $s0, $s0, 1
    addi $t0, $t0, 1
    bne $t0, $t1, add_title
    sb $0, 0($s0) 
    addi $s0, $s0, 1
    j add_author
    append_null: 
    sb $0, 0($s0)
    addi $s0, $s0, 1
    addi $t0, $t0, 1 
    bne $t0, $t1, append_null
    sb $0, 0($s0) 
    addi $s0, $s0, 1
    
    add_author: 
    li $t0, 0
    li $t1, 24
    add_author_loop: #s3
    lbu $t3, 0($s3) 
    beqz $t3, append_null1
    sb $t3, 0($s0) 
    addi $s3, $s3, 1 
    addi $s0, $s0, 1
    addi $t0, $t0, 1
    bne $t0, $t1, add_author_loop
    sb $0, 0($s0) 
    addi $s0, $s0, 1 
    j done_add_book
    append_null1: 
    sb $0, 0($s0)
    addi $s0, $s0, 1
    addi $t0, $t0, 1 
    bne $t0, $t1, append_null1
    sb $0, 0($s0)  
    addi $s0, $s0, 1 
    j done_add_book 
    
    
    
    full_table: 
    li $v0, -1
    li $v1, -1 
    j done_add_book
    
    
    book_already_in_table: 
    done_add_book: 
    sw $0, 0($s0) #store 0 into book sales  
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

delete_book:
    addi $sp, $sp, -16
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    
    move $s0, $a0 #books
    move $s1, $a1 #isbn 
    lw $s2, 4($s0) #size of books 
    
    jal get_book 
    bltz $v0, nothing_to_delete
    addi $s2, $s2, -1 
    sw $s2, 4($s0) #decrement size of books 
    
    addi $s0, $s0, 12 #start from the elements feild of the struct 
    beqz $v0, delete_index
    
    li $t0, 0 #counter
    reach_index: 
    addi $s0, $s0, 68
    addi $t0, $t0, 1 
    bne $t0, $v0, reach_index 
    
    delete_index:
    li $t0, 0 
    li $t1, 68
    li $t2, 0xff
    delete_index_loop: 
    sb $t2, 0($s0) 
    addi $t0, $t0, 1
    addi $s0, $s0, 1
    bne $t0, $t1, delete_index_loop
    j done_delete_book 
    
    nothing_to_delete: 
    li $v0, -1 
    j done_delete_book 
    
    done_delete_book: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp)  
    addi $sp, $sp, 16 	
    jr $ra

hash_booksale:
    lw $t0, 0($a0) #capacity 
    li $t3, 10 #for modulo division
    
    li $t1, 0 #accumulator 
    loop_thru_isbn1:
    lbu $t2, 0($a1) 
    beq $t2, $0, loop_thru_id
    add $t1, $t1, $t2
    addi $a1, $a1, 1
    j loop_thru_isbn1
    
    loop_thru_id: #module division 
    div $a2, $t3
    mflo $a2
    mfhi $t4
    add $t1, $t1, $t4
    bnez $a2, loop_thru_id
       
    
    get_hash_function1: #sum % capacity 
    div $t1, $t0
    mfhi $v0 
    
    jr $ra
is_leap_year:
    li $t0, 1582 
    lw $a0, 0($a0) 
    
    blt $a0, $t0, before_1582 
    
    # if (year mod 4 != 0) then not_leap_year 
    li $t0, 4 
    div $a0, $t0            	# hi = year mod 4 
    mfhi $t0                	# $t1 = hi, which is the remainder
    bne $t0, $0, ordinary_year   # if $t1 != 0 go to ordinary_year
    
    # if (year % 100 != 0) then go to leap_year
    li $t0, 100 
    div $a0, $t0            # hi = year % 100 
    mfhi $t0               	# $t1 = hi 
    bne $t0, $0, leap_year	# if $t1 != 0 go to leap_year
    
    # if (year % 400 != 0) then go to ordinary_year
    li $t0, 400 
    div $a0, $t0           		# hi = year % 400 
    mfhi $t0               		# $t1 = hi 
    bne $t0, $0, ordinary_century_year  	# if $t1 != 0 go to ordinary_year
    j leap_year 
    
    before_1582:
    li $v0, 0 
    j done_leap 
    
    ordinary_year: 
    li $v0, 0 
    find_next_year: 
    addi $a0, $a0, 1
    addi $v0, $v0, -1  
    li $t0, 4 
    div $a0, $t0            	# hi = year mod 4 
    mfhi $t0                	# $t1 = hi, which is the remainder
    bne $t0, $0, find_next_year
    li $t0, 100 
    div $a0, $t0            # hi = year % 100 
    mfhi $t0               	# $t1 = hi 
    bne $t0, $0, done_leap
    li $t0, 400 
    div $a0, $t0           		# hi = year % 400 
    mfhi $t0               		# $t1 = hi 
    beq $t0, $0, done_leap 
    addi $v0, $v0, -4 
    j done_leap
    
    ordinary_century_year:
    li $v0, -4 
    j done_leap 
    
    leap_year:
    li $v0, 1
    j done_leap 
    
    done_leap:
    jr $ra

datestring_to_num_days:
    addi $sp, $sp, -12
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
     
   
    move $s0, $a1 #end date
    
    jal convert_string_to_num
    move $s1, $v0 #num of days for start date
    
    move $a0, $s0
    jal convert_string_to_num 
    move $t0, $v0 #num of days for end date
    
    blt $t0, $s1, invalid_interval
    sub $v0, $t0, $s1 
    j done_datestring
    
    invalid_interval:
    li $v0, -1 
    
    done_datestring: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp)  
    addi $sp, $sp, 12 	
    jr $ra
    
convert_string_to_num: #helper function which will convert the string into number of days since 1600-01-01
    addi $sp, $sp, -24
    sw $ra, 0($sp) 
    sw $s0, 4($sp) #year
    sw $s1, 8($sp) #month
    sw $s2, 12($sp) #day 
    sw $s3, 16($sp) #total
    sw $s4, 20($sp) 
    
    li $s3, 0 #total number of days 
    
    
    get_year: #get year as a word
    li $s0, 0 
    lbu $t0, 0($a0) 
    addi $t0, $t0, -48
    li $t1, 1000
    mul $t0, $t0, $t1
    add $s0, $s0, $t0
    lbu $t0, 1($a0) 
    addi $t0, $t0, -48
    li $t1, 100
    mul $t0, $t0, $t1
    add $s0, $s0, $t0
    lbu $t0, 2($a0) 
    addi $t0, $t0, -48
    li $t1, 10
    mul $t0, $t0, $t1
    add $s0, $s0, $t0
    lbu $t0, 3($a0) 
    addi $t0, $t0, -48
    add $s0, $s0, $t0
    
    get_month: 
    li $s1, 0 
    lbu $t0, 5($a0) 
    addi $t0, $t0, -48
    li $t1, 10
    mul $t0, $t0, $t1
    add $s1, $s1, $t0
    lbu $t0, 6($a0) 
    addi $t0, $t0, -48
    add $s1, $s1, $t0
    
    get_date: 
    li $s2, 0 
    lbu $t0, 8($a0) 
    addi $t0, $t0, -48
    li $t1, 10
    mul $t0, $t0, $t1
    add $s2, $s2, $t0
    lbu $t0, 9($a0) 
    addi $t0, $t0, -48
    add $s2, $s2, $t0
    
    add_days: 
    addi $s2, $s2, -1
    add $s3, $s3, $s2
    
    add_months: 
    addi $s1, $s1, -1 
    li $t0, 1
    bne $t0, $s1, feb
    addi $s3, $s3, 31
    j check_if_leap_year
    feb:
    li $t0, 2
    bne $t0, $s1, mar
    addi $s3, $s3, 59
    j check_if_leap_year
    mar:
    li $t0, 3
    bne $t0, $s1, april
    addi $s3, $s3, 90
    j check_if_leap_year
    april:
    li $t0, 4
    bne $t0, $s1, may
    addi $s3, $s3, 120
    j check_if_leap_year
    may:
    li $t0, 5
    bne $t0, $s1, june
    addi $s3, $s3, 151
    j check_if_leap_year
    june:
    li $t0, 6
    bne $t0, $s1, july
    addi $s3, $s3, 181
    j check_if_leap_year
    july:
    li $t0, 7
    bne $t0, $s1, august
    addi $s3, $s3, 212
    j check_if_leap_year
    august:
    li $t0, 8
    bne $t0, $s1, september
    addi $s3, $s3, 243
    j check_if_leap_year
    september:
    li $t0, 9
    bne $t0, $s1, october
    addi $s3, $s3, 273
    j check_if_leap_year
    october:
    li $t0, 10
    bne $t0, $s1, november
    addi $s3, $s3, 304
    j check_if_leap_year
    november:
    li $t0, 11
    bne $t0, $s1, check_if_leap_year
    addi $s3, $s3, 334
    
    check_if_leap_year:
    li $t0, 1 
    beq $t0, $s1, add_years_init
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    move $a0, $sp
    jal is_leap_year
    lw $s0, 0($sp) 
    addi $sp, $sp, 4
    bltz $v0, add_years_init
    addi $s3, $s3, 1 
    
    add_years_init:
    li $s4, 1600
    beq $s0, $s4, done_conversion
    addi $s0, $s0, -1 
    add_years:
    addi $sp, $sp, -4
    sw $s0, 0($sp)
    move $a0, $sp
    jal is_leap_year
    lw $s0, 0($sp) 
    addi $sp, $sp, 4
    bltz $v0, add_ordinary
    li $t0, 366
    add $s3, $s3, $t0
    addi $s0, $s0, -1
    blt $s0, $s4, done_conversion
    j add_years
    add_ordinary:
    li $t0, 365
    add $s3, $s3, $t0
    addi $s0, $s0, -1 
    blt $s0, $s4, done_conversion
    j add_years
     
    
    
    
    
    
     
    done_conversion: 
    move $v0, $s3 	
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp)  
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    addi $sp, $sp, 24	
    jr $ra 
    
    
sell_book:
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
    
    move $s0, $a0 #sales
    move $s1, $a1 #books
    move $s2, $a2 #isbn
    move $s3, $a3 #customer_id
    move $s4, $t0 #saledate
    move $s5, $t1 #saleprice
    
    lw $t0, 0($a0) #sales capacity
    lw $s6, 4($a0) #sales size 
    
    beq $t0, $s6, full_sales_table 
    
    #check if book is in books table 
    move $a0, $s1
    move $a1, $s2
    jal get_book 
    bltz $v0, book_doesnt_exist
    
    #since it exists, increment book sale by 1 
    addi $s1, $s1, 12 #start from the elements feild of the struct 
    beqz $v0, increment_times_sold
    
    li $t0, 0 #counter
    reach_index1: 
    addi $s1, $s1, 68
    addi $t0, $t0, 1 
    bne $t0, $v0, reach_index1
    
    increment_times_sold: 
    lw $t0, 64($s1)
    addi $t0, $t0, 1
    sw $t0, 64($s1) 
    
    #hash book sales 
    move $a0, $s0 
    move $a1, $s2
    move $a2, $s3
    jal hash_booksale
    
    move $s7, $v0 #starting index 
    li $s1, 1 #number of entries treat this as a saved register
    lw $t8, 0($s0) #capacity of sales treat as saved register
    
    addi $s0, $s0, 12
    beqz $v0, check_sale 
    
    li $t0, 0 #counter
    reach_index2: 
    addi $s0, $s0, 28
    addi $t0, $t0, 1 
    bne $t0, $v0, reach_index2
    
    check_sale: 
    lbu $t0, 0($s0) 
    beqz $t0, insert_sale 
    addi $s7, $s7, 1
    bne $s7, $t8, skip_wrap_around3
    addi $t0, $s7, -1 
    li $t1, -28
    mul $t0, $t0, $t1
    add $s0, $s0, $t0
    li $s7, 0
    addi $s1, $s1, 1 
    j check_sale
    skip_wrap_around3: 
    addi $s0, $s0, 28
    addi $s1, $s1, 1 
    j check_sale 
    
    
    insert_sale: 
    #insert isbn
    move $a0, $s0
    move $a1, $s2
    li $a2, 14
    jal memcpy
    addi $s0, $s0, 14
    #insert two bytes
    sb $0, 0($s0)
    sb $0, 1($s0)
    addi $s0, $s0, 2 
    #insert customer id
    sw $s3, 0($s0) 
    addi $s0, $s0, 4
    #insert sale date
    addi $sp, $sp, -12
    li $t0, '1' 
    sb $t0, 0($sp) 
    li $t0, '6'
    sb $t0, 1($sp) 
    li $t0, '0'
    sb $t0, 2($sp) 
    li $t0, '0'
    sb $t0, 3($sp)
    li $t0, '-'
    sb $t0, 4($sp) 
    li $t0, '0'
    sb $t0, 5($sp)  
    li $t0, '1' 
    sb $t0, 6($sp) 
    li $t0, '-'
    sb $t0, 7($sp) 
    li $t0, '0'
    sb $t0, 8($sp) 
    li $t0, '1'
    sb $t0, 9($sp)
    li $t0, '\0'
    sb $t0, 10($sp) 
    move $a0, $sp 
    move $a1, $s4 
    jal datestring_to_num_days
    addi $sp, $sp, 12
    addi $v0, $v0, 1 
    sw $v0, 0($s0) 
    addi $s0, $s0, 4
    #insert sale price
    sw $s5, 0($s0) 
    addi $s0, $s0, 4 
    move $v0, $s7
    move $v1, $s1
    j done_sell_book
       
    
    
    book_doesnt_exist:
    li $v0, -2
    li $v1, -2 
    j done_sell_book 
    
    full_sales_table: 
    li $v0, -1 
    li $v1, -1 
    j done_sell_book 
    
    done_sell_book:
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

compute_scenario_revenue:
    move $t1, $a1 #num sales
    move $t2, $a2 #scenerio 
    
    addi $t3, $a0, 24 #t3 points to price of the first sale 

    
    li $t4, 28
    addi $t5, $t1, -1 
    mul $t4, $t4, $t5
    add $t4, $t3, $t4 #t4 points to the price of the last sale 
    
    li $v0, 0 #total revenue 
    li $t6, 1 #initialize days with day 1 this will be incremented until day(num sales) 
    
    li $t0, 1
    move $t7, $t1
    
    get_bit: 
    addi $t7, $t7, -1 #num sales - 1
    bltz $t7, finish_computing
    li $t0, 1 
    sllv $t0, $t0, $t7
    and $t8, $t0, $t2
    srlv $t8, $t8, $t7 
    beqz $t8, sell_left
    j sell_right 
    
    sell_left:
    lw $t9, 0($t3) 
    mul $t9, $t9, $t6
    add $v0, $v0, $t9 
    addi $t3, $t3, 28 
    addi $t6, $t6, 1 
    j get_bit

    
    sell_right:
    lw $t9, 0($t4) 
    mul $t9, $t9, $t6
    add $v0, $v0, $t9
    addi $t4, $t4, -28 
    addi $t6, $t6, 1 
    j get_bit
    
    finish_computing:	
    jr $ra

maximize_revenue:
    addi $sp, $sp, -24
    sw $ra, 0($sp) 
    sw $s0, 4($sp) 
    sw $s1, 8($sp) 
    sw $s2, 12($sp) 
    sw $s3, 16($sp) 
    sw $s4, 20($sp) 
    
    move $s0, $a0 #sales list 
    move $s1, $a1 #num of sales
       
    li $s3, 1 #upper bound 
    
    li $t0, 0 #counter
    li $t1, 2 #multiplier
    loop_power: 
    mul $s3, $s3, $t1
    addi $t0, $t0, 1 
    bne $t0, $s1, loop_power
    
    get_bounds:
    li $s2, 0 #lower bound
    addi $s3, $s3, 0 #upper bound 
    
    li $s4, 0 #optimal revenue 
    compute_revenue_loop: 
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal compute_scenario_revenue
    bgt $v0, $s4, new_optimal
    back_to_loop: 
    addi $s2, $s2, 1 
    bne $s2, $s3, compute_revenue_loop
    move $v0, $s4
    j done_optimal
    
    
    new_optimal:
    move $s4, $v0
    j back_to_loop 
    
    done_optimal: 
    lw $ra, 0($sp) 
    lw $s0, 4($sp) 
    lw $s1, 8($sp) 
    lw $s2, 12($sp)  
    lw $s3, 16($sp) 
    lw $s4, 20($sp) 
    addi $sp, $sp, 24
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
