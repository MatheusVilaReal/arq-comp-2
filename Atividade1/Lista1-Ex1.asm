#############################################################
# aluno:	MATHEUS PIRES VILA REAL
# nº:		202000560352
#############################################################
.data

	ent:	.asciiz	"Insira o valor do vetor["
	ent2:	.asciiz	"]: "
	n:	.asciiz	"Insira o valor de n: "
	
.text

main:
	la	$a0, n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$a0, $v0
	mulo	#
	li	$v0, 9
	syscall
	
leitura:
	move	$t0, $a0
	move	$t1, $t0
	li	$t2, 0
l:	la	$a0, ent
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
	
swap:	#a2 e a3
	lw	$t8, ($a2)
	lw	$t9, ($a3)
	sw	$t8, ($a3)
	sw	$t9, ($a2)
	jr	$ra
	
bubble_sort:	#a0, a1
	move	$s7, $ra
	addiu	$t1, $a1, -1		# n - 1
	li	$s1, 0			# i = 0
	
loop_externo:
	bge	$s1, $t1, bubble_end	# se i < n - 1 pule para final
	move	$t0, $a0
	addiu	$t2, $a1, -1		# n - 1 - i
	sub	$t2, $t2, $s1
	li	$s2, 0			# j = 0
	
loop_interno:
	lw	$t3, ($t0)			# t3 = t0[j]
	lw	$t4, 4($t0)			# t4 = t0[j + 1]
	bgt	$t3, $t4, call_swap	# se t3 > t4, swap(t3, t4) 
	
post_call:
	addiu	$s2, $s2, 1
	addiu	$t0, $t0, 4
	blt	$s2, $t2, loop_interno	# enquanto j < n - i - 1
	addiu	$s1, $s1, 1
	b	loop_externo

bubble_end:
	move	$v0, $a0
	jr	$s7
	
call_swap:
	#move	$a2, $t0
	#move	$a3, $t0
	#addiu	$a3, $a3, 4
	la	$a2, ($t0)
	la	$a3, 4($t0)
	jal	swap
	b	post_call
	
eh_par:			# a0 e a1
	move	$t0, $a0
	move	$t1, $a1
	li	$s1, 0
	li	$v0, 0

ep:
	bge	$s1, $t1, eh_par_return
	lw	$t2, ($t0)
	and	$t3, $t2, 1
	beq	$t3, 0, sum
	addiu	$t0, $t0, 4
	addiu	$s1, $s1, 1
	b	ep
	
sum:
	add	$v0, $v0, $t2
	addiu	$t0, $t0, 4
	addiu	$s1, $s1, 1
	b	ep
	
eh_par_return:
	jr	$ra
	
k_proc:				# a0, a1, a2
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	mulo	$t3, $t2, 2
	li	$s1, 0
	li	$v0, 0

k_loop:
	bge	$s1, $t1, k_return
	lw	$t4, ($t0)
	sgt	$t5, $t4, $t2
	slt	$t6, $t4, $t3
	and	$t7, $t5, $t6
	beq	$t7, 1, k_sum
	addiu	$t0, $t0, 4
	addiu	$s1, $s1, 1
	b	k_loop
	
k_sum:
	addiu	$v0, $v0, 1
	addiu	$t0, $t0, 4
	addiu	$s1, $s1, 1
	b	k_loop
	
k_return:
	jr	$ra
	
m_proc:				# a0, a1, a2
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2
	li	$s1, 0
	li	$v0, 0

m_loop:
	bge	$s1, $t1, m_return
	lw	$t4, ($t0)
	beq	$t4, $t2, m_sum
	addiu	$t0, $t0, 4
	addiu	$s1, $s1, 1
	b	m_loop
	
m_sum:
	addiu	$v0, $v0, 1
	addiu	$t0, $t0, 4
	addiu	$s1, $s1, 1
	b	m_loop
	
m_return:
	jr	$ra
