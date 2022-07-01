####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	msg:		.asciiz "Insira o valor de N (< 8): "
	ent1:	.asciiz "Insira o elemento da matriz["
	ent2:	.asciiz "]["
	ent3:	.asciiz "]: "
	ent4:	.asciiz "Somatório dos elementos da acima - abaixo da diagonal principal: "
	ent5:	.asciiz "Maior elemento acima da diagonal principal: "
	ent6:	.asciiz "Menor elemento abaixo da diagonal principal: "
	ent7:	.asciiz "Matriz ordenada:\n"
	errmsg:	.asciiz "ERRO: N deve ser menor ou igual a 8!\n"

.text 
main:
	la	$a0, msg
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	ble	$v0, 8, m1
	la	$a0, errmsg
	li	$v0, 4
	syscall
	b	main
m1:	move	$a1, $v0
	move	$a2, $v0
	move	$s1, $v0
	mul	$v0, $v0, $v0
	sll	$s0, $v0, 2
	sub	$sp, $sp, $s0
	move	$a0, $sp
	jal	matrix_read
	move	$a0, $v0
	move	$a2, $v1
	move	$a1, $v1
	jal	matrix_print
	move	$a0, $v0
	move	$a2, $v1
	move	$a1, $v1
	jal	matrix_diag
	move	$t0, $v0
	la	$a0, ent5
	li	$v0, 4
	syscall
	move	$v0, $t0
	move	$a0, $v0
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	la	$a0, ent6
	li	$v0, 4
	syscall
	move	$a0, $v1
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	la	$a0, ent7
	li	$v0, 4
	syscall
	move	$a0, $sp
	mul	$a1, $a1, $a1
	jal	bubble_sort
	move	$a0, $sp
	move	$a1, $s1
	move	$a2, $s1
	jal	matrix_print
	add	$sp, $sp, $s0
	li	$v0, 10
	syscall
	
indice:				# calcula o indice
	mul	$v0, $t0, $a2		# t0 = i
	add	$v0, $v0, $t1		# t1 = j
	sll	$v0, $v0, 2
	add	$v0, $v0, $a3
	jr	$ra
	
matrix_read:	
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	move	$a3, $a0
r1:	la	$a0, ent1
	li	$v0, 4
	syscall
	move $a0, $t0
	li	$v0, 1
	syscall
	la	$a0, ent2
	li	$v0, 4
	syscall
	move	$a0, $t1
	li	$v0, 1
	syscall
	la	$a0, ent3
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$t2, $v0
	jal	indice
	sw	$t2, ($v0)
	addi	$t1, $t1, 1
	blt	$t1, $a2, r1
	li	$t1, 0
	addi	$t0, $t0, 1
	blt	$t0, $a1, r1
	li	$t0, 0
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	move	$v0, $a3
	move	$v1, $a1
	jr	$ra

matrix_print:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	move	$a3, $a0
e1:	jal	indice
	lw	$a0, ($v0)
	li	$v0, 1
	syscall
	la	$a0, 32
	li	$v0, 11
	syscall
	addi	$t1, $t1, 1
	blt	$t1, $a2, e1
	la	$a0, 10
	syscall
	li	$t1, 0
	addi	$t0, $t0, 1
	blt	$t0, $a1, e1
	li	$t0, 0
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	move	$v0, $a3
	move	$v1, $a1
	jr	$ra
	
matrix_diag:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	move	$a3, $a0
	li	$t3, -2147483648
	li	$t4, 2147483647
	li	$t0, 0
	add	$t1, $t0, 1
u1:	jal	indice
	lw	$t2, ($v0)
	add	$t5, $t5, $t2
	ble	$t2, $t3, u2
	move	$t3, $t2
u2:	addi	$t1, $t1, 1
	blt	$t1, $a2, u1
	add	$t0, $t0, 1
	addi	$t1, $t0, 1
	blt	$t0, $a1, u1
	li	$t0, 1
	li	$t1, 0
l1:	jal	indice
	lw	$t2, ($v0)
	sub	$t5, $t5, $t2
	bge	$t2, $t4, l2
	move	$t4, $t2
l2:	addi	$t1, $t1, 1
	blt	$t1, $t0, l1
	add	$t0, $t0, 1
	li	$t1, 0
	blt	$t0, $a1, l1
	la	$a0, ent4
	li	$v0, 4
	syscall
	move	$a0, $t5
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	move	$v0, $t3
	move	$v1, $t4
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra

bubble_sort:			# a0: array, a1: tamanho
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	subi	$a1, $a1, 1
	li	$t0, 0
	li	$t1, 0
	subi	$a1, $a1, 1	# a1 = lim_i = n - 1
	sub	$t2, $a1, $t0  # t2 = lim_j = n - i - 1
b1:	lw	$t3, ($a0)
	lw	$t4, 4($a0)
	ble	$t3, $t4, b2
	sw	$t4, ($a0)	# swap
	sw	$t3, 4($a0)	# swap
b2:	add	$a0, $a0, 4
	addi	$t1, $t1, 1	# j++
	blt	$t1, $t2, b1 	# inner loop
	addi	$t0, $t0, 1	# i++
	sub	$t2, $a1, $t0  # t2 = n - i - 1
	blt	$t0, $a1, b1 	# outer loop
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
