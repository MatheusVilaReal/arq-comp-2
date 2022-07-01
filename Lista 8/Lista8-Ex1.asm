####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
####################################################
.data
	msg:			.asciiz "Insira o número de elementos do vetor: "
	insert_msg:	.asciiz "Insira o valor de vetor["
	comma:		.asciiz ", "
	bracket:		.asciiz "]: "
	ocorre:		.asciiz " ocorre "
	vez:			.asciiz " vez\n"
	vezes:		.asciiz " vezes\n"
	
	array:		.word 0
	
.text
main:
	li	$s1, -1
	la	$a0, msg
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s0, $v0
	sll	$a0, $v0, 2
	li	$v0, 9
	syscall
	sw	$v0, array
	la	$a0, array
	move	$a1, $s0
	jal	array_read
	la	$a0, array
	move	$a1, $s0
	jal	array_print
	la	$a0, array
	move	$a1, $s0
	jal	array_count
	li	$v0, 10
	syscall
	
array_read:			#a0: array, a1: tamanho
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
r1:	la	$a0, insert_msg
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall
	la	$a0, bracket
	li	$v0, 4
	syscall
	li	$v0, 6
	syscall
	s.s	$f0, ($a3)
	addi	$a3, $a3, 4
	addi	$t0, $t0, 1
	blt	$t0, $a1, r1
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	li	$t0, 0
	jr	$ra
	
array_print:				#a0: array, a1: tamanho
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
	li	$a0, 91
	li	$v0, 11
	syscall
p1:	l.s	$f12, ($a3)
	li	$v0, 2
	syscall
	addi	$a3, $a3, 4
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
	
array_count:				#a0: array, a1: tamanho
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
	move	$t0, $a1
c1:	subi	$sp, $sp, 4			# index[n] = [0..n]
	subi	$t0, $t0, 1
	sw	$t0, ($sp)
	bgt	$t0, $zero, c1	
	li	$t0, 0
c2:	lw	$t1, ($sp)
	blt	$t1, $zero, c3
	sll	$t1, $t1, 2
	add	$t1, $t1, $a3
	l.s	$f12, ($t1)
	li	$v0, 2
	syscall
	la	$a0, ocorre
	li	$v0, 4
	syscall
	addi	$t1, $t1, 4			# array_ptr = *(array_ptr + 1)
	addi	$t2, $t0, 1			# counter = i + 1
	addi	$t3, $sp, 4			# *index_ptr = *(stack_ptr + 1)
	li	$t4, 1				# qtd = 1
cnt:	l.s	$f6, ($t1)
	c.eq.s $f6, $f12
	bc1f	q					# se array[i] == array[counter], então
	add	$t4, $t4, 1			# qtd++
	sw	$s1, ($t3)			# index[counter] = -1
q:	addi	$t1, $t1, 4			# array_ptr++
	addi	$t2, $t2, 1			# counter++
	addi	$t3, $t3, 4			# index_ptr++
	blt	$t2, $a1, cnt			# se counter < n, repita cnt
	move	$a0, $t4
	li	$v0, 1
	syscall
	beq	$t4, 1, singular
	la	$a0, vezes
	li	$v0, 4
	syscall
c3:	addi	$sp, $sp, 4
	addi	$t0, $t0, 1
	blt	$t0, $a1, c2
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	li	$t0, 0
	li	$t1, 0
	li	$t2, 0
	li	$t3, 0
	li	$t4, 0
	jr	$ra

singular:
	la	$a0, vez
	li	$v0, 4
	syscall
	b c3