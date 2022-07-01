#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	msg_n:			.asciiz "n = "
	msg_a:			.asciiz "a = "
	msg_b:			.asciiz "b = "
	
.text
main:
	la	$a0, msg_a
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s0, $v0
	la	$a0, msg_b
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s1, $v0
	bgt	$s1, $s0, j
	move	$t0, $s0
	move	$s0, $s1
	move	$s1, $t0
j:	la	$a0, msg_n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s2, $v0
	li	$t0, 0			# Contador de múltiplos
	li	$t1, 1			# Multiplicador
m1:	mul	$a0, $t1, $s0
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	addi	$t0, $t0, 1
	bge	$t0, $s2, m3
	mul	$a0, $t1, $s1
	rem	$a1, $a0, $s0
	beqz	$a1, m2
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	addi	$t0, $t0, 1
m2:	addi	$t1, $t1, 1
	blt	$t0, $s2, m1
m3:	move	$a0, $sp
	move	$a1, $s2
	li	$a2, 0
	jal	bubble_sort
	move	$a0, $sp
	move	$a1, $s2
	jal	array_print
	li	$v0, 10
	syscall
	
# a0: array
array_print:
	li	$t0, 0
	move	$a3, $a0
ap1:	lw	$a0, ($a3)
	li	$v0, 1
	syscall
	li	$a0, 32
	li	$v0, 11
	syscall
	addi	$a3, $a3, 4
	addi	$t0, $t0, 1
	blt	$t0, $a1, ap1
	jr	$ra	

# a0: array, a1: tamanho, a2: crescente ou decrescente
bubble_sort:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	li	$t0, 0
	li	$t1, 0
	subi	$a1, $a1, 1	# a1 = n - 1
	sub	$t2, $a1, $t0  # t2 = n - 1 - i
b1:	lw	$a0, ($sp)
	sll	$t5, $t1, 2
	add	$a0, $a0, $t5
	lw	$t3, ($a0)
	lw	$t4, 4($a0)
	bnez	$a2, reverse
	ble	$t3, $t4, b2
	jal	swap
b2:	add	$a0, $a0, 4
	addi	$t1, $t1, 1	# j++
	blt	$t1, $t2, b1 	# for(j = 0; j < n - i - 1; j++)
	li	$t1, 0
	addi	$t0, $t0, 1	# i++
	sub	$t2, $a1, $t0  # t2 = n - i - 1
	blt	$t0, $a1, b1 	# for(i = 0; i < n - 1; i++)
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
reverse:
	bge	$t3, $t4, b2
	jal	swap
	b	b2
	
swap:
	sw	$t4, ($a0)	# swap
	sw	$t3, 4($a0)	# swap
	jr	$ra