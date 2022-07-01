#############################################################
# aluno:	MATHEUS PIRES VILA REAL
# nº:		202000560352
#############################################################
.data

	entA:	.asciiz	"Insira o valor de Vet["
	ent2:	.asciiz	"]: "
	n:	.asciiz	"Insira o valor de n: "

.text

main:
	la	$a0, n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a3, $v0
	mulo	$a0, $a3, 4
	li	$v0, 9
	syscall
	move	$a0, $v0
	move	$a1, $a3
	jal	leitura
	move	$a0, $v0
	move	$a1, $a3
	jal	escrita
	move	$t8, $v0
	mulo	$a0, $a3, 4
	li	$v0, 9
	syscall
	move	$a0, $v0
	jal	leitura
	move	$a0, $v0
	move	$a1, $a3
	jal	escrita
	move	$t9, $v0
	mulo	$a0, $a3, 4
	li	$v0, 9
	syscall
	move	$a2, $v0
	move	$a0, $t8
	move	$a1, $t9
	jal	mix
	move	$a0, $v0
	move	$a1, $a3
	jal	escrita
	li	$v0, 10
	syscall
	
leitura:
	move	$t0, $a0
	move	$t1, $t0
	li	$t2, 0
l:	la	$a0, entA
	li	$v0, 4
	syscall
	move	$a0, $t2
	li	$v0, 1
	syscall
	la	$a0, ent2
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	sw	$v0, ($t1)
	add	$t1, $t1, 4
	addi	$t2, $t2, 1
	blt	$t2, $a1, l
	move	$v0, $t0
	jr	$ra
	
escrita:
	move	$t0, $a0
	move	$t1, $t0
	li	$t2, 0
e:	lw	$a0, ($t1)
	li	$v0, 1
	syscall
	li	$a0, 32
	li	$v0, 11
	syscall
	add	$t1, $t1, 4
	addi	$t2, $t2, 1
	blt	$t2, $a1, e
	li	$a0, 10
	li	$v0, 11
	syscall
	move	$v0, $t0
	jr	$ra
	
mix:						# a0, a1, a2, a3
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	move	$t3, $a3
	li	$s0, 0
m1:	lw	$t4, ($a0)
	sw	$t4, ($t2)
	addiu	$a0, $a0, 4
	addiu	$t2, $t2, 4
	addiu	$s0, $s0, 1
	blt	$s0, $t3, m1
	li	$s0, 0
	move	$t2, $a2
m2:	lw	$t4, ($t1)
	sw	$t4, ($t2)
	addiu	$t1, $t1, 8
	addiu	$t2, $t2, 8
	addiu	$s0, $s0, 2
	blt	$s0, $t3, m2
	move	$t2, $a2
	move	$v0, $t2
	jr	$ra

	
