#############################################################
# aluno:	MATHEUS PIRES VILA REAL
# nº:		202000560352
#############################################################	
.data

	entA:	.asciiz	"Insira o valor de Vet["
	ent2:	.asciiz	"]: "
	n:	.asciiz	"Insira o valor de n: "
	vetc:	.asciiz	"Vetcomp = "

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
	jal	compact_array
	move	$t0, $v0
	la	$a0, vetc
	li	$v0, 4
	syscall
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
	
compact_array:					# a0, a1
	move	$t0, $a0
	li	$s0, 0
c1:	lw	$t1, ($t0)
	beq	$t1, 0, compact
c2:	addiu	$s0, $s0, 1
	addiu	$t0, $t0, 4
	blt	$s0, $a1, c1
	move	$v0, $a0
	jr	$ra

compact:
	move	$s1, $s0
	move	$t2, $t0
c3:	lw	$t1, 4($t2)
	sw	$t1, ($t2)
	addiu	$s1, $s1, 1
	addiu	$t2, $t2, 4
	blt	$s1, $a1, c3
	addiu	$a1, $a1, -1
	b	c2

	
