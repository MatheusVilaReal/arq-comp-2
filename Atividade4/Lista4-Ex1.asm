#####################################################
# aluno: MATHEUS PIRES VILA REAL	n° 202000560352 #
#####################################################

.data
	mat:	.space 48
	vet:	.space 12
	res:	.space 16
	ent1:	.asciiz "Insira o valor da matriz["
	ent2:	.asciiz "]["
	ent3:	.asciiz "]: "
	ent4:	.asciiz "Insira o valor do vetor["
	
.text	
main:
	la	$a0, mat
	li	$a1, 4
	li	$a2, 3
	jal	matrix_read
	la	$a0, vet
	jal	array_read
	la	$a0, vet
	li	$a1, 4
	li	$a2, 3
	la	$a3, mat
	la	$s0, res
	jal	multiplica
	la	$a0, res
	li	$a1, 4
	jal	array_print
	li	$v0, 10
	syscall
	
indice:				# calcula o indice
	mul	$v0, $t0, $a2
	add	$v0, $v0, $t1
	sll	$v0, $v0, 2
	add	$v0, $v0, $a3
	jr	$ra
	
matrix_read:	
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	move	$a3, $a0
l1:	la	$a0, ent1
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
	blt	$t1, $a2, l1
	li	$t1, 0
	addi	$t0, $t0, 1
	blt	$t0, $a1, l1
	li	$t0, 0
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	move	$v0, $a3
	jr	$ra

array_read:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
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
	blt	$t9, 3, v1
	addi	$v0, $a3, -3
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
escrita:
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
	jr	$ra
	
array_print:
	move	$t0, $a0
	move	$a3, $a0
	li	$s0, 0
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
	
multiplica:					# a0 = vetor, a1 = linhas, a2 = colunas, a3 = matriz, s0 = produto
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	move	$t9, $s0
	move	$v1, $a0
m1:	jal	indice
	lw	$t2, ($v0)
	lw	$t3, ($v1)
	mul	$t4, $t2, $t3
	add	$t5, $t5, $t4
	addiu	$t1, $t1, 1			# t1 = j
	addiu	$v1, $v1, 4
	blt	$t1, $a2, m1
	sw	$t5, ($s0)
	li	$t5, 0
	li	$t1, 0
	move	$v1, $a0
	addiu	$t0, $t0, 1			# t0 = i
	addiu	$s0, $s0, 4
	blt	$t0, $a1, m1
	move	$v0, $s0
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra