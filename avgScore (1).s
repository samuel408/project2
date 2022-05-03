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
check: .asciiz "WE WORK "

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
	mul $s3 , $s0, 4

	
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
	addi $a3,$zero,0 # 
	jal printArray	# Print original scores
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	addi $a3, $zero,1
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
	
	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
	# Your implementation of printList here	\
	
	#addi $s3, $zero, 20
	addi $t4, $zero, 0
	
	bne $a3,$zero, sortedPrint
	while:
	
 	beq $t4,$s3, exit
	lw $t6, orig($t4)
	addi $t4,$t4,4

	#print current number
	li $v0,1 
	move $a0, $t6
	syscall

	# add space
	li $v0 , 4
	la $a0, space
	syscall
	
	j while
	
	sortedPrint:
	While:
	
 	beq $t4,$s3, exit
	lw $t6, sorted($t4)
	addi $t4,$t4,4

	#print current number
	li $v0,1 
	move $a0, $t6
	syscall

	# add space
	li $v0 , 4
	la $a0, space
	syscall
	
	j While
	
	


	exit : # kills loops
	
	
		jr $ra


	
	
# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	# Your implementation of selSort here
	addi $t4, $zero, 0 #set $t4 to 0 
	addi $t7, $s3,-4 # length-1  
	
	matchArr: # coppies orginal array into sorted  array to be able to sort
	beq $t4,$s3, forLoop # calls loop
	lw $t6, orig($t4)
	sw $t6, sorted($t4)
	addi $t4,$t4,4
	
	j matchArr
	
addi $t4, $zero, 0 #set $t4 to 0  i =0
addi $t0 , $t4, 4#j = i +1


     
     
     	forLoop:
		 beq $t4, $s3,Exit
        	lw $t6, sorted($t4) #set $t4 to 0  also holds i	//int maxIndex = i;
        	j nestedLoop
        	

     		
     		

     	
     	
     	nestedLoop:
     	     		beq $t0, $t7,swap
     	     		lw $t1, sorted($t0)#holds sorted[j]
     	     		lw $t2, sorted($t6)# holds sorted[maxindex]
     	     		bgt $t1,$t2, newMax
     	     		
     	newMax: 
     	move $t6, $t0
     	addi $t0,$t0,4 #j++
     	j nestedLoop	   
     	
     
       swap:
       move $t3,$t2 #temp = sorted[maxIndex];
       lw $t5, sorted($t4)#holds sorted[i]
       sw $t5, sorted($t6)# sorted[maxIndex] = sorted[i];
       sw $t3, sorted ($t4) #  sorted[i] = temp;


         addi $t4,$t4,4#i++
         
          j forLoop  		
     
	
	
	 
	
	Exit : # kills loops
	jr $ra
	
      # check
	#li $v0 , 4
	#la $a0, check
	#syscall
	
	
	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
calcSum:
	# Your implementation of calcSum here
	
	jr $ra
	
