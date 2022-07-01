####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	msg:		.asciiz "Insira o valor de N (< 6): "
	ent1:	.asciiz "Insira o caractere da matriz["
	ent2:	.asciiz "]["
	ent3:	.asciiz "]: "
	ent4:	.asciiz "["
	ent5:	.asciiz "Número de elemento iguais em ambas as matrizes: "
	errmsg:	.asciiz "ERRO: N deve ser menor ou igual a 6!\n"

.macro print_rowcol(%row, %col)

	move $t8, $a0
	move	$t9, $v0
	la	$a0, ent4
	li	$v0, 4
	syscall
	move	$a0, %row
	li	$v0, 1
	syscall
	la	$a0, ent2
	li	$v0, 4
	syscall
	move	$a0, %col
	li	$v0, 1
	syscall
	la	$a0, ent3
	li	$v0, 4
	syscall
	add	$a0, %row, %col
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	move	$a0, $t8
	move	$v0, $t9

.end_macro

.text
main:
	la	$a0, msg
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	ble	$v0, 6, m1
	la	$a0, errmsg
	li	$v0, 4
	syscall
	b	main
m1:	move	$a1, $v0
	move	$a2, $v0
	mul	$s0, $v0, $v0
	sll	$s0, $s0, 2
	sub	$sp, $sp, $s0
	move	$a0, $sp
	jal	matrix_read
	move	$a2, $v1
	move	$a1, $v1
	move	$a0, $v0
	jal	matrix_print
	move	$a2, $v1
	move	$a1, $v1
	sub	$sp, $sp, $s0
	move	$a0, $sp
	jal	matrix_read
	move	$a2, $v1
	move	$a1, $v1
	move	$a0, $v0
	jal	matrix_print
	move	$a0, $v0
	add	$a1, $sp, $s0
	move $a2, $v1
	jal	matrix_equals
	la	$a0, ent5
	li	$v0, 4
	syscall
	move	$a0, $v1
	li	$v0, 1
	syscall
	add	$a1, $sp, $s0
	sll	$s0, $s0, 1
	add	$sp, $sp, $s0
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
	
matrix_equals:				# a0: matrix 1, a1: matriz 2, a2: tamanho
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	li	$v1, 0
q1:	move	$a3, $a0
	jal	indice
	lw	$t2, ($v0)
	move	$a3, $a1
	jal	indice
	lw	$t3, ($v0)
	bne	$t2, $t3, q2
	addi	$v1, $v1, 1
	print_rowcol($t1, $t0)
q2:	addi	$t0, $t0, 1
	blt	$t0, $a2, q1
	li	$t0, 0
	addi	$t1, $t1, 1
	blt	$t1, $a2, q1
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	move	$v0, $v1
	jr	$ra
