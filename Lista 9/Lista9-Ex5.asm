#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################

## FORAM USADOS DOUBLE PARA COBRIR UM INTERVALO MAIOR DE RESULTADOS,
## VISTO QUE A FUNÇÃO HIPERFATORIAL RETORNA NÚMEROS MUITO GRANDES
.data
	# Strings
	msg_n:			.asciiz "n = "
	msg_resultado:		.asciiz "H(n) = "
	
	# Constante 1
	.align 3
	dbl_1:			.double 1.0
	
.text
main:
	la	$a0, msg_n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall			# Leitura de n
	move	$s0, $v0
	move	$a0, $s0
	jal	hyperfactorial
	la	$a0, msg_resultado
	li	$v0, 4
	syscall
	mov.d	$f12, $f0
	li	$v0, 3
	syscall			# Impressão do resultado
	li	$v0, 10
	syscall
	
# f12: base, a0: exp
pow:
	l.d	$f0, dbl_1		# Retorna ao menos 1
p1:	beqz	$a0, p2
	mul.d	$f0, $f0, $f12	# Multiplica f12 a0 vezes
	subi	$a0, $a0, 1
	b	p1
p2:	jr	$ra
	
# a0: n
hyperfactorial:
	andi 	$sp, 0xfffffff8		# Corrige alinhamento da stack para valores de 8 bytes 
	subi	$sp, $sp, 4			
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	mtc1	$a0, $f12
	cvt.d.w  $f12, $f12		# Converte n inteiro para double
	l.d	$f28, dbl_1			# Constante 1.0
	jal	hyperfact_util		# Chama a função recursiva com ambos os n
	mov.d	$f0, $f2
	lw	$ra, ($sp)			# Desempilha o endereço de retorno
	addi	$sp, $sp, 4
	jr	$ra

# f12: n double, a0: n inteiro
hyperfact_util:
	bgt	$a0, $zero, rec		# Se n > 0, faça a recursão
	l.d	$f2, dbl_1			# Se não, retorne 1
	jr	$ra
rec:	subi	$sp, $sp, 4			
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	subi	$sp, $sp, 8		
	s.d	$f12, ($sp)			# Salva n double na stack
	subi	$sp, $sp, 4
	sw	$a0, ($sp)			# Salva n inteiro na stack
	sub.d	$f12, $f12, $f28		# Decrementa ambos os n
	subi	$a0, $a0, 1
	jal	hyperfact_util		# Recursão
	lw	$a0, ($sp)
	addi	$sp, $sp, 4
	l.d	$f12, ($sp)			# Restaura os dois n
	addi	$sp, $sp, 8
	jal	pow				# Calcula n^n
	mul.d	$f2, $f2, $f0		# Multiplica o retorno n vezes
	lw	$ra, ($sp)			# Desempilha o endereço de retorno
	addi	$sp, $sp, 4
	jr	$ra
