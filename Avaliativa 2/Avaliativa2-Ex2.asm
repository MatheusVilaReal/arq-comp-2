#####################################################
# nome: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	read:			.asciiz "Insira o valor de vet["
	dp:			.asciiz "Desvio padrão = "
	comma:		.asciiz ", "
	bracket:		.asciiz "]: "
	
	# Vetor
	.align	3
	vet:			.space 80
	
	# Valores ASCII dos caracteres
	.align 	0
	line_feed:		.byte	10
	
	.align 	0
	abre_colchetes:	.byte	91
	
	.align	0
	fecha_colchetes:	.byte 93
.text
main:
	la	$a0, vet
	li	$a1, 10
	jal	array_read				# Realiza leitura dos valores do vetor
	la	$a0, vet
	li	$a1, 10
	jal 	array_print				# Calcula o desvio padrão
	la	$a0, vet
	li	$a1, 10
	jal 	desvio_padrao			# Calcula o desvio padrão
	mov.d	$f12, $f0
	la	$a0, dp
	li	$v0, 4
	syscall
	li	$v0, 3
	syscall					# Imprime o resultado
	li	$v0, 10
	syscall
	
#a0: vetor, a1: tamanho
array_read:
	subi	$sp, $sp, 4				# Empilha 4 bytes
	sw	$a0, ($sp)				# Salva endereço original na pilha
	move	$a3, $a0				# Move ponteiro para o vetor de a0 para a3
r1:	la	$a0, read
	li	$v0, 4
	syscall					# Imprime read
	move	$a0, $t0
	li	$v0, 1
	syscall					# Imprime a variável contadora (índice)
	la	$a0, bracket
	li	$v0, 4
	syscall					# Imprime fecha colchetes e dois pontos
	li	$v0, 7
	syscall					# Lê um double
	s.d	$f0, ($a3)				# Salva o double lido na posição do vetor apontada por a3
	addi	$a3, $a3, 8				# Move o ponteiro 8 bytes à frente
	addi	$t0, $t0, 1				# Incrementa contador
	blt	$t0, $a1, r1			# Se contador < tamanho, repita r1
	lw	$v0, ($sp)				# Lê o endereço de retorno salvo na stack
	addi	$sp, $sp, 4				# Desempilha 4 bytes
	jr	$ra					
	
# a0: vetor, a1: tamanho
array_print:
	subi	$sp, $sp, 4				# Empilha 4 bytes
	sw	$a0, ($sp)				# Salva endereço de retorno na stack
	move	$a3, $a0				# Move ponteiro para o vetor para $a3
	li	$t0, 0				# Variável contadora
	lb	$a0, abre_colchetes
	li	$v0, 11
	syscall					# Imprime abre colchetes
p1:	l.d	$f12, ($a3)				# Lê o double na posição apontada por $a3
	li	$v0, 3
	syscall					# Imprime o double
	addi	$a3, $a3, 8				# Move ponteiro 8 bytes à frente
	addi	$t0, $t0, 1				# Incrementa contador
	bge	$t0, $a1, p2			# Se contador <= tamanho, pule pra p2
	la	$a0, comma
	li	$v0, 4
	syscall					# Imprime vírgula para separar elementos
	b	p1					# Pule para p1
p2:	lb	$a0, fecha_colchetes
	li	$v0, 11
	syscall					# Imprime fecha colchetes
	lb	$a0, line_feed			
	li	$v0, 11
	syscall					# Imprime quebra de linha
	lw	$v0, ($sp)				# Restaura endereço de retorno
	addi	$sp, $sp, 4				# Desempilha 4 bytes
	jr	$ra
	
# a0: vetor, a1: tamanho
media:
	li	$t0, 0				# Contador
	mov.d	$f0, $f2
m1:	l.d	$f4, ($a0)				# Lê o double na posição apontada por a0
	add.d	$f0, $f0, $f4			# Soma o double em f0
	addi	$a0, $a0, 8				# Move ponteiro à frente em 8 bytes
	addi	$t0, $t0, 1				# Incrementa contador
	blt	$t0, $a1, m1			# Se contador < tamanho, repita m1
	mtc1.d  $a1, $f4
	cvt.d.w $f4, $f4				# Converte tamanho para double
	div.d	$f0, $f0, $f4			# Divide somatório por tamanho
	jr	$ra
	
# a0: vetor, a1: tamanho			
desvio_padrao:					
	subi	$sp, $sp, 4				# Empilha 4 bytes
	sw	$ra, ($sp)				# Salva endereço de retorno na stack
	move	$a3, $a0				# Move ponteiro em a0 para a3
	jal	media					
	mov.d	$f4, $f0				# Calcula a média e salva em f4
	li	$t0, 0				# Contador
	mov.d	$f0, $f30 				#
d1:	l.d	$f6, ($a3)				# Lê o double na posição apontada por a0
	sub.d	$f8, $f6, $f4			# v[i] - media
	mul.d	$f8, $f8, $f8			# (v[i] - media)²
	add.d	$f0, $f0, $f8			# Soma (v[i] - media)²
	addi	$a3, $a3, 8				# Move ponteiro à frente em 8 bytes
	addi	$t0, $t0, 1				# Incrementa contador
	blt	$t0, $a1, d1			# Se contador < tamanho, repita m1
	subi	$a1, $a1, 1				# Calcula tamanho - 1
	mtc1.d  $a1, $f4					
	cvt.d.w $f4, $f4				# Converte (tamanho - 1) para double
	div.d	$f0, $f0, $f4			# Somatório / tamanho - 1 (variância)
	sqrt.d  $f0, $f0				# Raiz quadrada
	lw	$ra, ($sp)				# Restaura endereço de retorno
	addi	$sp, $sp, 4				# Desempilha 4 bytes
	jr	$ra