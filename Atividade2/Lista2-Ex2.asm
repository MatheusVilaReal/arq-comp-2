#############################################################
# aluno:	MATHEUS PIRES VILA REAL
# nº:		202000560352
#############################################################
.data

	entA:	.asciiz	"Insira o valor de Vet["
	ent2:	.asciiz	"]: "
	n:	.asciiz	"Insira o valor de n: "
	maior:.asciiz	"Maior elemento: ["
	menor:.asciiz	"Menor elemento: ["
	f:	.asciiz	"] = "

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
	move	$t9, $v0
	li	$s0, 0
	li	$t1, -999999
	li	$t2, 0

largest:	
	lw	$t0, ($a0)
	bgt	$t0, $t1, updateLargest
	addiu	$a0, $a0, 4
	addiu	$s0, $s0, 1
	blt	$s0, $a1, largest
	la	$a0, maior
	li	$v0, 4
	syscall
	move	$a0, $t2
	li	$v0, 1
	syscall
	la	$a0, f
	li	$v0, 4
	syscall
	move	$a0, $t1
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	li	$s0, 0
	li	$t1, 100000000
	li	$t2, 0

smallest:	
	lw	$t0, ($t9)
	blt	$t0, $t1, updateSmallest
	addiu	$t0, $t0, 4
	addiu	$s0, $s0, 1
	blt	$s0, $a1, smallest
	la	$a0, menor
	li	$v0, 4
	syscall
	move	$a0, $t2
	li	$v0, 1
	syscall
	la	$a0, f
	li	$v0, 4
	syscall
	move	$a0, $t1
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	li	$v0, 10
	syscall

updateLargest:
	move	$t1, $t0
	move	$t2, $s0
	addiu	$a0, $a0, 4
	addiu	$s0, $s0, 1
	b	largest
	
updateSmallest:
	move	$t1, $t0
	move	$t2, $s0
	addiu	$a0, $a0, 4
	addiu	$s0, $s0, 1
	b	smallest
	
	
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

	
