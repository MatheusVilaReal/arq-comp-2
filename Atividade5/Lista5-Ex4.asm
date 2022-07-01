#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	msg1:	.asciiz "Defina o tamanho do vetor (insira um inteiro par): "
	ent3:	.asciiz "]: "
	ent4:	.asciiz "Insira o valor do vetor["
	len:	.word	0
	arrA:	.word 0
	arrB:	.word	0
	
.text
main:
	la	$a0, msg1
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	andi	$t0, $v0, 1
	bgt	$t0, $zero, main
	sll	$t0, $v0, 2
	sw	$v0, len
	move	$a0, $t0
	li	$v0, 9
	syscall
	sw	$v0, arrA
	move	$a0, $t0
	li	$v0, 9
	syscall
	sw	$v0, arrB
	lw	$a0, arrA
	lw	$a1, len
	jal	array_read
	lw	$a0, arrA
	lw	$a1, len
	jal	array_print
	li	$a0, 10
	li	$v0, 11
	syscall
	lw	$a1, arrA
	li	$a2, 0
	lw	$a3, len
	jal	array_sort
	li	$a0, 10
	li	$v0, 11
	syscall
	lw	$a0, arrA
	lw	$a1, arrB
	lw	$a2, len
	jal	combine_first
	lw	$a1, arrA
	li	$a2, 1
	lw	$a3, len
	jal	array_sort
	lw	$a0, arrA
	lw	$a1, arrB
	lw	$a2, len
	jal	combine_last
	lw	$a0, arrB
	lw	$a1, len
	jal	array_print
	li	$a0, 10
	li	$v0, 11
	syscall
	lw	$a0, arrA
	lw	$a1, len
	lw	$a0, arrA
	lw	$a1, arrB
	lw	$a2, len
	jal	combine_last
	lw	$a0, arrA
	lw	$a1, len
	jal	array_print
	li	$v0, 10
	syscall
	
combine_first:		#a0: vetor 1, a1: vetor 2, a2: tamanho
	move	$v0, $a1
	srl	$a2, $a2, 1 
	li	$t1, 0
f1:	lw	$t0, ($a0)
	sw	$t0, ($a1)
	addiu	$a0, $a0, 4
	addiu	$a1, $a1, 4
	addiu	$t1, $t1, 1
	blt	$t1, $a2, f1
	jr	$ra
	
combine_last:		#a0: vetor 1, a1: vetor 2, a2: tamanho
	move	$v0, $a1
	move	$v1, $a2
	srl	$a2, $a2, 1 
	move	$t1, $a2
	sll	$t3, $a2, 2
	add	$a1, $a1, $t3
f2:	lw	$t0, ($a0)
	sw	$t0, ($a1)
	addiu	$a0, $a0, 4
	addiu	$a1, $a1, 4
	addiu	$t1, $t1, 1
	blt	$t1, $v1, f2
	jr	$ra
	
array_sort:				#a1: vetor, a2: crescente ou decrescente, a3: tamanho
	li	$t0, 0
	li	$t1, 0     
	add 	$t7, $0, $a3
	add 	$t7, $t7, -1   
	beq 	$t7, $zero, b5
b1:	add 	$t6, $t7, $zero
	add 	$t1, $zero, $zero
b2:	mul 	$t2, $t1, 4
	add 	$t8, $a1, $t2 
	lw 	$t4, ($t8)   
	add 	$t2, $t2, 4
	add 	$t9, $a1, $t2     
	lw 	$t5, ($t9)   
	bnez 	$a2, b3
	ble 	$t4, $t5, b4
	j 	swap
b3:	bgt 	$t4, $t5, b4
swap:	sw 	$t5, ($t8)
	sw 	$t4, ($t9)
b4:	add 	$t1, $t1, 1  
	sub 	$t6, $t7, $t0
	blt 	$t1, $t6, b2
	add 	$t0, $t0, 1
	blt	$t0, $t7, b1
b5:	jr 	$ra

array_reversesort:			#a0: vetor, $a1: tamanho
	la	$s5, r2
	move	$a2, $a0
	addi	$a3, $a1, -1
	li	$t0, 0
r1:	sub	$t2, $a3, $t0
	mulo	$a0, $t1, 4
	add	$a0, $a0, $a2
	addiu	$a1, $a0, 4
	lw	$t3, ($a0)
	lw	$t4, ($a1)
	blt	$t3, $t4, swap	
r2:	addiu	$t1, $t1, 1
	blt	$t1, $t2, r1
	li	$t1, 0
	addiu	$t0, $t0, 1
	blt	$t0, $a3, r1
	move	$v0, $a2
	addiu	$v1, $a3, 1
	jr	$ra
	
array_print:		#a0: vetor, a1: tamanho
	move	$t0, $a0
	move	$a3, $a0
ev1:	li	$v0, 1
	lw	$a0, ($t0)
	syscall
	li	$v0, 11
	li	$a0, 32
	syscall
	addi	$t0, $t0, 4
	addi	$s0, $s0, 1
	blt	$s0, $a1, ev1
	li	$s0, 0
	move	$v0, $a3
	jr	$ra

# faça uma função que leia um arquivo


	
array_read:				#a0: vetor, a1: tamanho
	move	$a2, $a0
	move	$a3, $a0
v1:	la	$a0, ent4
	li	$v0, 4
	syscall
	move	$a0, $t9
	li	$v0, 1
	syscall
	la	$a0, ent3
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	sw	$v0, ($a3)
	addi	$a3, $a3, 4
	addi	$t9, $t9, 1
	blt	$t9, $a1, v1
	move	$v0, $a2
	move	$v1, $a1
	jr	$ra
