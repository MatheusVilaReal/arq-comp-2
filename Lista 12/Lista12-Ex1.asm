#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################

.data
	entre:	.asciiz "Entre com o número de elementos: "
	menores:	.asciiz "Número de elementos menores que a soma: "
	impares:	.asciiz "Número de elementos ímpares: "
	produto:	.asciiz "Produto da posição do menor elemento par do vetor com a posição do maior elemento ímpar do vetor: "
	vet:		.asciiz "Vet["
	fecha_col:	.asciiz "] = "
	
	vetor:	.word 0
	
.macro println(%strptr, %intreg)

	move	$s5, %intreg
	move	$s6, $a0
	move	$s7, $a1
	la	$a0, %strptr
	li	$v0, 4
	syscall
	move	$a0, $s5
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	move	$a0, $s6
	move	$a1, $s7

.end_macro
	
.text
main:
	la	$a0, entre
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s0, $v0
	sll	$a0, $v0, 2
	li	$v0, 9
	syscall
	sw	$v0, vetor
	lw	$a0, vetor
	move	$a1, $s0
	jal	array_read
	lw	$a0, vetor
	move	$a1, $s0
	move	$a2, $v1
	jal	proc_menor_soma
	println(menores, $v0)
	lw	$a0, vetor
	move	$a1, $s0
	jal	proc_num_impar
	println(impares, $v0)
	lw	$a0, vetor
	move	$a1, $s0
	jal	proc_prod_pos
	println(produto, $v0)
	lw	$a0, vetor
	move	$a1, $s0
	li	$a2, 1
	jal	bubble_sort
	lw	$a0, vetor
	move	$a1, $s0
	jal	array_print
	li	$v0, 10
	syscall

# a0: array, a1: n
array_read:
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
r1:	la	$a0, vet
	li	$v0, 4
	syscall
	addi	$a0, $t0, 1
	li	$v0, 1
	syscall
	la	$a0, fecha_col
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	add	$v1, $v1, $v0
	sw	$v0, ($a3)
	addi	$a3, $a3, 4
	addi	$t0, $t0, 1
	blt	$t0, $a1, r1
	lw	$v0, ($sp)
	li	$t0, 0
	jr	$ra
	
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
	
# a0: vetor, a1: tamanho, a2: soma dos elementos lidos
proc_menor_soma:
	li	$v0, 0
ms1:	lw	$t1, ($a0)
	slt	$t1, $t1, $a2
	add	$v0, $v0, $t1
	addi	$t0, $t0, 1
	addi	$a0, $a0, 4
	blt	$t0, $a1, ms1
	jr	$ra

# a0: vetor, a1: tamanhaddio
proc_num_impar:
	li	$v0, 0
	li	$t0, 0
ni1:	lw	$t1, ($a0)
	rem	$t2, $t1, 2
	add	$v0, $v0, $t2
	addi	$a0, $a0, 4
	addi	$t0, $t0, 1
	blt	$t0, $a1, ni1
	jr	$ra
	
proc_prod_pos:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)
	move 	$a2, $a0
	move	$a3, $a1
	li	$t0, 0
	li	$t1, 0
	li	$t2, 0
	li	$t3, 0
	li	$t4, 999999999
	li	$t5, -99999
pp1:	lw	$t1, ($a0)
	rem	$t2, $t1, 2
	beqz	$t2, par
	beq	$t2, 1, imp
par:	blt	$t1, $t4, menor
	b	pp2
imp:	bgt	$t1, $t5, maior
	b	pp2
pp2:	addi	$t0, $t0, 1
	addi	$a0, $a0, 4
	blt	$t0, $a1, pp1
	mul	$v0, $t2, $t3
	lw	$ra, ($sp)
	addi	$sp $sp 4
	jr	$ra

menor:
	move	$t4, $t1
	addi	$t2, $t0, 1
	b	pp2
	
maior:
	move	$t5, $t1
	addi	$t3, $t0, 1
	b	pp2
	
reverse:
	bge	$t3, $t4, b2
	jal	swap
	b	b2

swap:
	sw	$t4, ($a0)	# swap
	sw	$t3, 4($a0)	# swap
	jr	$ra

bubble_sort:			# a0: array, a1: tamanho, a2: crescente ou decrescente
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
