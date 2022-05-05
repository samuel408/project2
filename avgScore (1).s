
   
.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded up) with dropped scores removed: "
space: .asciiz " "
check1:.asciiz "outer loop"
check2: .asciiz "inner loop "
check3: .asciiz " not max "

newline: .asciiz "\n"

.text 

# This is the main program.
# It first asks user to enter the number of assignments.
# It then asks user to input the scores, one at a time.
# It then calls selSort to perform selection sort.
# It then calls printArray twice to print out contents of the original and sorted scores.
# It then asks user to enter the number of (lowest) scores to drop.
# It then calls calcSum on the sorted array with the adjusted length (to account for dropped scores).
# It then prints out average score with the specified number of (lowest) scores dropped from the calculation.
main: 
	addi $sp, $sp -4
	sw $ra, 0($sp)
	li $v0, 4 
	la $a0, str0 
	syscall 
	li $v0, 5	# Read the number of scores from user
	syscall
	move $s0, $v0	# $s0 = numScores
	move $t0, $0
	la $s1, orig	# $s1 = orig
	la $s2, sorted	# $s2 = sorted 
	#mul $s3 , $s0, 4 # Number of bytes we need determined by the user
	move $s3,$s0

	
loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2
	add $t1, $t1, $s1
	li $v0, 5	# Read elements from user
	syscall
	sw $v0, 0($t1)
	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	move $a0, $s0
	jal selSort	# Call selSort to perform selection sort in original array
	
	li $v0, 4 
	la $a0, str2 
	syscall
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	addi $a3, $zero, 0 # 
	jal printArray	# Print original scores
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	addi $a3, $zero, 1
	jal printArray	# Print sorted scores
	
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5	# Read the number of (lowest) scores to drop
	syscall

	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it
	#move $a0, $v0 #save the return value in a0
	#add $v0, $v0, 0
	#li $v0, 1
	#move $a0, $v0
	#syscall 
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
	
printArray:
	move $t7, $a0 # Storing a0(address of the array) into a temporary register
	li $t0, 0 # Using t0 for i
	
printloop:
	bge $t0, $a1, exit_printloop #if i >= length of array stop the loop

	lw $t5, ($t7) #load content of array at t7 index
	addi $t7, $t7, 4 #increment counter by 4
	
	#print number
	li $v0, 1 
	move $a0, $t5
	syscall
	# print space
	li $v0 , 4
	la $a0, space
	syscall
	
	addi $t0, $t0, 1 #increase i by 1
	
	j printloop
	

exit_printloop:
	# Print new line after program finishes printing the array
	li $v0, 4 
	la $a0, newline 
	syscall 
	
	jr $ra
	
	# Your implementation of printList here	\
	
	#addi $s3, $zero, 20
	#addi $t4, $zero, 0
	
	#bne $a3, $zero, sortedPrint
	
#while:
 	#beq $t4, $s3, exit
	#lw $t6, orig($t4)
	#addi $t4, $t4, 4

	#print current number
	#li $v0,1 
	#move $a0, $t6
	#syscall

	# print space
	#li $v0 , 4
	#la $a0, space
	#syscall
	
	#j while
	
#sortedPrint:
#While:
	
 	#beq $t4,$s3, exit
	#lw $t6, sorted($t4)
	#addi $t4,$t4,4

	#print current number
	#li $v0, 1 
	#move $a0, $t6
	#syscall

	# add space
	#li $v0 , 4
	#la $a0, space
	#syscall
	
	#j While
	

	


	
	
# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	# Your implementation of selSort here
	# Your implementation of selSort here
	addi $t4, $zero, 0 #set $t4 to 0 
	addi $t7, $s3,4 # length-1  
	move $a2,$s3
	mul $s3,$s3,4

	
	matchArr: # coppies orginal array into sorted  array to be able to sort
	beq $t4,$s3, sort
	 # calls loop
	lw $t6, orig($t4)
	sw $t6, sorted($t4)
	addi $t4,$t4,4
	
	j matchArr
	

	
sort:
move $t0, $zero #set $t0 to 0  i =0
      move $s3,$a2 # restoring s3 to original value
      oFor:
li $v0, 4 
	la $a0, check1 
	syscall 
	
	addi $t1,$t0,1 #j =i+1
	move  $t5,$t0#max stored
	
	innerFor:
	li $v0, 4 
	la $a0, check2 
	syscall 
	###
	sll $t6,$t0,2
	sll $t7,$t1,2
	add $t6, $s2,$t6
	add $t7, $s2,$t7
	lw $t2,0($t6)
	lw $t3, 0($t7)

	blt $t3,$t2 , notMax
	move $t5, $t1 #max INDEX
	#addi $t1, $t1, 1
	# jinnerFor 
	
	notMax:
	li $v0, 4 
	la $a0, check3 
	syscall 
	###
	addi $t1, $t1,1
	#addi $s3, $s3 -1
	blt $t1, $s0, innerFor

	### swap
	sll  $t2,$t0 ,2
	add $t2,$t2,$s2
	lw $t2,0($t2)#loads value at i

	sll  $t3,$t5 ,2 #values not index
	add $t3,$t3,$s2
	lw $t3,0($t3) #loads MAX VALUE


	sll $t6,$t0,2# values not index
	add $t6,$s2,$t6
	sw $t3,0($t6)

	sll $t7,$t5,2# values not index
	add $t7,$s2,$t7
	sw $t2,0($t7)
	###
	addi $t0,$t0,1
	addi $t4 , $s0,-1
	
	  # check
	li $v0, 1 
	move $a0, $t0
	syscall
	
	blt $t0,$t4, oFor	
	
	Exit : # kills loops
	jr $ra
	
    
	
	jr $ra

	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:  
	#addi $sp, $sp, -100
	#sw $s0, 0($sp)    # save s0 because we overwrite it
        #sw $ra, 4($sp)    # save $ra because jal overwrites it

	#beq $a1, $zero, basecase
	#addi $t0, $a1, -1
	#sll $t0, $t0, 2
	#add $t0, $t0, $a0
	#lw $s0, 0($t0)       # s0 = sorted[size-1]
	#addi $a1, $a1, -1    # set arguments
	#jal calcSum          # call calcSum(arr, size - 1)
	
	#add $s0, $v0, $s0   # s0 = s0 + sum(arr,size-1)
	#move $v0, $s0        # put result in v0
	
	#j sum_end

#basecase: 
	#add $v0, $zero, 0   # put result in v0

#sum_end: 
	#lw $s0, 0($sp)    # restore $s0
	#lw $ra, 4($sp)      # restore $ra
	#addi $sp, $sp, 100
	#jr $ra
	#move $t5, $s0 # Use t5 for len
	#mul $t5, $t5, 4 #size in bytes
	
	#slt $t6, $t5, $zero 
	#beq $t5, $t6, finalsum

	#addi $t5, $t5, -4
	
	
	#j calcSum
	#li $v0, 1
	#move $a0, $t5
	#syscall
	# Your implementation of calcSum here
	#bgt $t5, $s0, finalsum
	
	#li $t5, 5          # this is my representation of "i"
	#la $t6, orig
	
	#mul $t7, $t7, 4    # scale by 4
	#addu $t7, $t7, $t6 # add offset and base together
	#lw $t7, ($t7)      # fetch the data
	
	#li $v0,1 
	#move $a0, $t7
	#syscall
	
#finalsum:
	#li $v0, 10
	#syscall 
	jr $ra
