#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	k:			.asciiz "k = "
	n:			.asciiz "n = "
	equals:		.asciiz " = "
	
.text
main:
	la	$a0, k
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall				# Lê k
	move	$s0, $v0
	la	$a0, n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall				# Lê n
	move	$s1, $v0
	move	$a0, $s0
	move	$a1, $s1
	jal	pow				# Chamada para o procedimento
	move	$a1, $v0
	move	$a0, $s0
	li	$v0, 1
	syscall
	li	$a0, 94
	li	$v0, 11
	syscall
	move	$a0, $s1
	li	$v0, 1
	syscall
	la	$a0, equals
	li	$v0, 4
	syscall
	move	$a0, $a1
	li	$v0, 1
	syscall				# Impressão do resultado
	li	$v0, 10
	syscall
	
# a0: k, a1: n
pow:
	bne	$a1, $zero, rec		# Enquanto expoente > 0, continuar
	li	$v0, 1			# Se não, retorne 1
	jr	$ra
rec:	subi	$sp, $sp, 4			
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	subi	$a1, $a1, 1			# Decrementa expoente
	jal	pow				# Recursão
	mul	$v0, $v0, $a0		# Multiplicar retorno pela base n vezes
	lw	$ra, ($sp)			# Desempilha o endereço de retorno
	addi	$sp, $sp, 4
	jr	$ra