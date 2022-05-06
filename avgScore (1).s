
   
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

	addi $t1,$t0,1 #j =i+1
	move  $t5,$t0#max stored
	
	innerFor:
	
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
	#addi $t4 , $s0,-1
	
	  # check
	#li $v0, 1 
	#move $a0, $t0
	#syscall
	
	blt $t0,$t4, oFor	
	
	
	Exit : # kills loops
	
	lw $t0, sorted($zero)
	addi $t1 ,$zero, 4
	lw $t2, sorted($t1)
	
	bgt $t2, $t0, else 
	else:
	sw $t0, sorted($t1)
	sw $t2, sorted($zero)
	
	jr $ra
	
    
	


	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:  
	
	#a1 =total length of scores in sorted to add up and find the average 

	 mul $t0, $a1, 4 #multiplies by 4 for byte width
	 addi $t0,$t0,-4
	  addi $sp,$sp,-4# backs up the stack enough to fit the remaining scores
	  
	  #clear temp registers
	  
	  addi $t1,$zero,0 #clears temp
	  addi $t2,$zero,0 #clear temp
	  li $t3,-4
	  
	  
	
	 recurse:
	 beq $t0,$t3,fExit # checks if 0

	 
	 lw $t2, sorted($t0)
	 add $t1, $t1,$t2
	  sw $t1, 0($sp)
	 
	 
	addi $t0,$t0,-4 #subtracts length
	j recurse 
	
	
	fExit :
	li $v0, 1 
	move $a0, $t1
	syscall
	
	move $a0,$t1
	
	 
	jr $ra
