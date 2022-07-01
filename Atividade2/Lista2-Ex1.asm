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
	move	$t8, $v0
	move	$a0, $v0
	jal	leitura
	move	$a0, $v0
	jal	escrita
	li	$v0, 9
	syscall
	move	$t9, $v0
	move	$a0, $v0
	jal	leitura
	move	$a0, $v0
	jal	escrita
	move	$a0, $t8
	move	$a2, $t9
	jal	somatorio
	move	$a0, $v0
	li	$v0, 1
	syscall
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
	
somatorio:
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	li	$v0, 0
	li	$v1, 0
	li	$s1, 0

loop_par:
	lw	$t3, ($t0)
	add	$v0, $v0, $t3
	addiu	$t0, $t0, 8
	addiu	$s1, $s1, 2
	blt	$s1, $t1, loop_par
	li	$s1, 1
	
loop_impar:
	bge	$s1, $t1, return_somatorio
	lw	$t3, 4($t2)
	add	$v1, $v1, $t3
	addiu	$t2, $t2, 8
	addiu	$s1, $s1, 2
	b	loop_impar
	
return_somatorio:
	sub	$v0, $v0, $v1
	jr	$ra
