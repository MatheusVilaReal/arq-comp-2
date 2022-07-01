#####################################################
# nome: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	n:		.asciiz "n = "
	p:		.asciiz "p = "
	arr:		.asciiz "arranjo(n, p) = "

.text
main:
	la	$a0, n
	li	$v0, 4
	syscall			# Imprime a mensagem n
	li	$v0, 5
	syscall			# Lê um inteiro (n)
	move	$s0, $v0
	la	$a0, p
	li	$v0, 4
	syscall			# Imprime a mensagem p
	li	$v0, 5
	syscall			# Lê um inteiro (p)
	move	$a0, $s0		# a0 = n
	move	$a1, $v0		# a1 = p
	jal	arranjo		# Chama arranjo(n, p)
	move	$a0, $v0
	li	$v0, 1
	syscall			# Imprime o resultado
	li	$v0, 10
	syscall			# Encerra programa
	
# a0: n
fatorial:
	li	$v0, 1		# Retorna ao menos 1
f1:	blt	$a0, 2, f2		# Se n < 2, n! = 1
	mul	$v0, $v0, $a0	# n! = n(n - 1)(n - 2)(n - 3)...
	subi	$a0, $a0, 1
	b	f1			# Repita
f2:	jr	$ra
	
# a0: n, a1: p
arranjo:
	subi	$sp, $sp, 4		# Empilha 4 bytes
	sw	$ra, ($sp)		# Salva endereço de retorno na stack
	move	$a2, $a0		# Salva o n original em $a2
	jal	fatorial		# Calcula n!
	move	$a3, $v0		# Salva n! em a3
	sub	$a0, $a2, $a1	# n - p
	jal	fatorial		# Calcula (n - p)!
	div	$v0, $a3, $v0	# Calcula n / (n - p)!
	lw	$ra, ($sp)		# Carrega endereço de retorno de volta em $ra
	addi	$sp, $sp, 4		# Desempilha 4 bytes
	jr	$ra