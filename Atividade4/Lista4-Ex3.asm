#####################################################
# aluno: MATHEUS PIRES VILA REAL	n° 202000560352 #
#####################################################

.data
	msgR:	.asciiz "Insira o número de linhas da matriz: "
	msgC:	.asciiz "Insira o número de colunas da matriz: "
	saiR:	.asciiz "Número de linhas nulas: "
	saiC:	.asciiz "Número de colunas nulas: "
	ent1:	.asciiz "Insira o valor de matriz["
	ent2:	.asciiz "]["
	ent3:	.asciiz "]: "
	
.text
main:
	la	$a0, msgR
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a1, $v0
	la	$a0, msgC
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a2, $v0
	mul	$a0, $a1, $a2
	mul	$a0, $a0, 4
	li	$v0, 9
	syscall
	move	$a0, $v0
	jal	leitura
	move	$a0, $v0
	jal	escrita
	move	$a0, $v0
	jal	linhasNulas
	move	$s0, $v0
	jal	colunasNulas
	move	$s1, $v0
	la	$a0, saiR
	li	$v0, 4
	syscall
	move	$a0, $s0
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	la	$a0, saiC
	li	$v0, 4
	syscall
	move	$a0, $s1
	li	$v0, 1
	syscall
	li	$v0, 10
	syscall
	
linhasNulas:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	li	$t3, 0
i1:	jal	indice
	lw	$t2, ($v0)
	add	$t3, $t3, $t2
	addi	$t1, $t1, 1
	blt	$t1, $a2, i1
	seq	$t4, $t3, 0
	add	$v1, $v1, $t4
	li	$t1, 0
	li	$t3, 0
	addi	$t0, $t0, 1
	blt	$t0, $a1, i1
	lw	$ra, ($sp)
	move	$v0, $v1
	jr	$ra
	
colunasNulas:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	li	$t3, 0
	li	$v1, 0
i2:	jal	indice
	lw	$t2, ($v0)
	add	$t3, $t3, $t2
	addi	$t0, $t0, 1
	blt	$t0, $a1, i2
	seq	$t4, $t3, 0
	add	$v1, $v1, $t4
	li	$t0, 0
	li	$t3, 0
	addi	$t1, $t1, 1
	blt	$t1, $a2, i2
	lw	$ra, ($sp)
	move	$v0, $v1
	jr	$ra
	
indice:				# calcula o indice
	mul	$v0, $t0, $a2
	add	$v0, $v0, $t1
	sll	$v0, $v0, 2
	add	$v0, $v0, $a3
	jr	$ra
	
leitura:	
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
