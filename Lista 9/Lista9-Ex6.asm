#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################

## FORAM USADOS DOUBLE PARA COBRIR UM INTERVALO MAIOR DE RESULTADOS,
## VISTO QUE O NÚMERO DE CATALAN RETORNA NÚMEROS MUITO GRANDES
.data
	# Strings
	msg_n:			.asciiz "n = "
	msg_resultado:		.asciiz "C(n) = "
	
	.align 3
	dbl_1:			.double 1.0
	.align 3
	dbl_4:			.double 4.0
	
.text
main:
	la	$a0, msg_n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall			# Leitura de n
	move	$s0, $v0
	move	$a0, $s0
	jal	catalan
	la	$a0, msg_resultado
	li	$v0, 4
	syscall
	mov.d	$f12, $f0
	li	$v0, 3
	syscall			# Impressão do resultado
	li	$v0, 10
	syscall

#a0: n
catalan:
	andi 	$sp, 0xfffffff8		# Corrige alinhamento da stack para valores de 8 bytes 
	subi	$sp, $sp, 8			
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	mtc1	$a0, $f12
	cvt.d.w  $f12, $f12		# Converte n inteiro para double
	l.d	$f28, dbl_1			# Constante 1.0
	jal	catalan_util		# Chama a função recursiva com ambos os n
	lw	$ra, ($sp)			# Desempilha o endereço de retorno
	addi	$sp, $sp, 8
	jr	$ra
	
# f12: n
catalan_util:
	c.eq.d  $f12, $f28
	bc1f	rec
	l.d	$f0, dbl_1
	jr	$ra
rec:	subi	$sp, $sp, 8			
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	subi	$sp, $sp, 8			
	s.d	$f12, ($sp)			# Guarda n na pilha
	sub.d	$f12, $f12, $f28		# Decrementa expoente
	jal	catalan_util		
	l.d	$f12, ($sp)			# Restaura n da pilha
	addi	$sp, $sp, 8
	l.d	$f4, dbl_4
	mul.d	$f6, $f12, $f4		# 4n
	sub.d	$f6, $f6, $f28
	sub.d	$f6, $f6, $f28		# 4n - 2
	add.d	$f8, $f12, $f28		# n + 1
	div.d	$f10, $f6, $f8		# 4n - 2 / n - 1
	mul.d	$f0, $f0, $f10 
	lw	$ra, ($sp)			# Desempilha o endereço de retorno
	addi	$sp, $sp, 8
	jr	$ra
	
