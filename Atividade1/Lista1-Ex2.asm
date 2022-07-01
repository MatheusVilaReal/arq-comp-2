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
	move	$a1, $v0
	mulo	$a0, $a1, 4
	li	$v0, 9
	syscall
	move	$a0, $v0
	jal	leitura
	move	$a0, $v0
	jal	escrita
	move	$a0, $v0
	jal	rotate_array
	move	$t0, $v0
	move	$a0, $t0
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
	
rotate_array:					# a0, a1
	move	$t0, $a0
	addiu	$t1, $a1, -1
	li	$s0, 0
	lw	$t9, ($t0)
r1:	lw	$t2, ($t0)
	sw	$t2, 4($t0)
	addiu	$t0, $t0, 4
	addiu	$s0, $s0, 1
	blt	$s0, $t1, r1
	move	$v0, $a0
	jr	$ra

	
