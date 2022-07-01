#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	n:			.asciiz "Insira o número de elementos do vetor (n > 0): "
	insira:		.asciiz "Insira o valor de vetor["
	comma:		.asciiz ", "
	bracket:		.asciiz "]: "
	
.text
main:
	la	$a0, n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s0, $v0
	sll	$v0, $s0, 3
	andi 	$sp, 0xfffffff8
	sub 	$sp, $sp, $v0
	move	$s1, $sp
	sub	$sp, $sp, $v0
	move	$s2, $sp
	move	$a0, $s1
	move	$a1, $s0
	jal	array_read
	move	$a0, $s1
	move	$a1, $s2
	move	$a2, $s0
	jal	array_reverse
	move	$a0, $s2
	move	$a1, $s0
	jal	array_print
	li	$v0,10
	syscall

# a0: vetor, a1: tamanho
array_read:
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
r1:	la	$a0, insira
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall
	la	$a0, bracket
	li	$v0, 4
	syscall
	li	$v0, 7
	syscall
	s.d	$f0, ($a3)
	addi	$a3, $a3, 8
	addi	$t0, $t0, 1
	blt	$t0, $a1, r1
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	li	$t0, 0
	jr	$ra
	
# a0: array, a1: tamanho
array_print:
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
	li	$a0, 91
	li	$v0, 11
	syscall
	li	$t0, 0
p1:	l.d	$f12, ($a3)
	li	$v0, 3
	syscall
	addi	$a3, $a3, 8
	addi	$t0, $t0, 1
	bge	$t0, $a1, p2
	la	$a0, comma
	li	$v0, 4
	syscall
	b	p1
p2:	li	$a0, 93
	li	$v0, 11
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	li	$t0, 0
	jr	$ra
	
# a0: array 1, a1: array 2, a2: tamanho
array_reverse:
	li	$t0, 0
	subi	$a3, $a2, 1
	sll	$a3, $a3, 3
	add	$a1, $a1, $a3
re1:	l.d	$f4, ($a0)
	s.d	$f4, ($a1)
	addi	$a0, $a0, 8
	subi	$a1, $a1, 8
	addi	$t0, $t0, 1
	blt	$t0, $a2, re1
	addi	$v0, $a1, 8
	jr	$ra