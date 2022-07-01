####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	msg:		.asciiz "Insira o valor de N (< 8): "
	ent1:	.asciiz "Insira o caractere da matriz["
	ent2:	.asciiz "]["
	ent3:	.asciiz "]: "
	errmsg:	.asciiz "ERRO: N deve ser menor ou igual a 8!\n"
	
.text
main:
	move	$s0, $sp
	la	$a0, msg
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	ble	$v0, 8, m1
	li	$v0, 4
	la	$a0, errmsg
	syscall
	b	main
m1:	move	$a1, $v0
	move	$a2, $v0
	mul	$v0, $v0, $v0
	subi	$v0, $v0, 1
	ori	$v0, $v0, 3
	addi	$v0, $v0, 1
	sub	$sp, $sp, $v0
	move	$a0, $sp
	sub	$sp, $sp, 4
	sw	$a1, ($sp)
	jal	matrix_read
	move	$a0, $v0
	lw	$a1, ($sp)
	jal	ceasar_code
	move	$a0, $v0
	lw	$a1, ($sp)
	lw	$a2, ($sp)
	jal	matrix_print
	move	$sp, $s0
	li	$v0, 10
	syscall			# saída

indice:				# calcula o indice
	mul	$v0, $t0, $a2
	add	$v0, $v0, $t1
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
	li	$v0, 12
	syscall
	move	$t3, $v0
	li	$a0, 10
	li	$v0, 11
	syscall
	move	$t2, $t3
	jal	indice
	sb	$t2, ($v0)
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
	
matrix_print:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	move	$a3, $a0
	li	$t0, 0
	li	$t1, 0
e1:	jal	indice
	lb	$a0, ($v0)
	li	$v0, 11
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
	
ceasar_code:		# a0: matriz, a1: tamanho
	mul	$a1, $a1, $a1
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	li	$t2, 127
cc1:	lb	$t0, ($a0)
	subi	$t0, $t0, 29
	div	$t0, $t2
	mfhi	$t0
	addi	$t0, $t0, 32
	sb	$t0, ($a0)
	addi	$a0, $a0, 1
	addi	$t1, $t1, 1
	blt	$t1, $a1, cc1
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	jr	$ra