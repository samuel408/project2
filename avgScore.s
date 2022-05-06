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
newline: .asciiz "\n"
zero_branch: .asciiz "branched to zero from ble \n"

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
	#addi $a3, $zero, 0 # 
	jal printArray	# Print original scores
	
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	#addi $a3, $zero, 1
	jal printArray	# Print sorted scores
	
	li $v0, 4 
	la $a0, str4 
	syscall 
	li $v0, 5	# Read the number of (lowest) scores to drop
	syscall

	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop 
	move $a0, $s1 # CHANGE BACK TO S2, S2 IS THE SORTED ARRAY
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it
	#Divide the return sum here
	#use a1 to divide
	
	#add $a0, $v0, $zero #move $a0, $v0
	#la $v0, 1
	#syscall
	
	#move return value($v0) into temp register
	#move 

	#j end #might need an end
	
		#This is the END of the program
		lw $ra, 0($sp)
		addi $sp, $sp, 4 #used to be 4 - # Popping the stack frame
		li $v0, 10 
		syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
	
printArray:
	move $t7, $a0 # Storing a0(address of the array) into a temporary register
	li $t0, 0 # Using t0 for i
	#move $t5, $s0
	#beq $t5, $zero, zero
	
printloop:
	#beq $s0, $zero, zero
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

#zero:
	#li $v0, 10
	#syscall
	#jr $ra

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
	
	jr $ra


# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:   #calcsum should be treated as main

#####
# We might only need to back up the stack pointer by 8 since we're saving 2 return values 
#####
	move $t3, $a1
	mul $t3, $t3, -4
	
	#print integer
	li $v0, 1
	move $a0, $t3 # This is the value we should move the stack pointer by
	syscall 
	# print newline
	li $v0 , 4
	la $a0, newline
	syscall
	
	add $sp, $sp, $t3 # Back up the stack pointer by $t3
	
	sw $ra, 0($sp)	
	
	ble $t3, $zero, return_zero
	
	sw $a0, 4($sp) 	
	# TPS 2 #11 (Prepare new input argument, i.e. m - 2)
	addi $a0, $a0, -2
	
	
	jal recursion	# Call recursion(m - 2)
	
	
return_zero:
	# print newline
	li $v0 , 4
	la $a0, zero_branch
	syscall
	
	# returning zero
	li $v0, 0
	jr $ra
	
	# End of recursion function	
	
# Implementing recursion
#recursion:
	#addi $sp, $sp, -100 # Push stack frame for local storage
	
	#sw $ra, 0($sp)	
	
	#addi $t0, $a0, 1 # Might have to add by 4    #plus one might be the arr[len -1]
	#ble $t0, $zero, not_zero # Might have to jump to recursion again 
	
	#addi $v0, $zero, 0 #update the returning value
	#j end_recur
#not_zero:
	#sw $a0, 4($sp) 	
	# TPS 2 #11 (Prepare new input argument, i.e. m - 2)
	#addi $a0, $a0, -1
	
	#jal recursion	# Call recursion(m - 2)

	# return 0 if len = 0
	#addi $v0, $zero, 0 #same thing as loading an immediate
	#jr $ra
	#j end_recur
	
#end_recur:	
	
	# TPS 2 #15 
	#lw $ra, 0($sp)

	#addi $sp, $sp, 100	# Pop stack frame 
	#jr $ra
	

