#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	n:			.asciiz "Insira o número de elementos do vetor (n > 0): "
	insira:		.asciiz "Insira o valor de vetor["
	comma:		.asciiz ", "
	bracket:		.asciiz "]: "
	soma:			.asciiz "A soma do maior segmento do vetor é "
	obtida:		.asciiz ", obtida pela soma dos números de "
	ate:			.asciiz " até "

	# Menor valor possível para um double
	.align 3
	dbl_min:		.double 2.2250738585072014E-308
.text
main:
	la	$a0, n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move	$s0, $v0
	sll	$a0, $v0, 3
	li	$v0, 9
	syscall
	move	$s1, $v0
	move	$a0, $s1
	move	$a1, $s0
	jal	array_read			# Leitura do vetor
	move	$a0, $s1
	move	$a1, $s0
	jal	array_print			# Impressão
	move	$t1, $s0			# i = tamanho
	l.d	$f10, dbl_min		# Inicializa maior somatório conhecido
ma1:	move	$a0, $s1			# Restaura ponteiro para o vetor
	li	$t2, 0			# j = 0
	sub	$t3, $s0, $t1		
	move	$a1, $t1			# Somar de a0 até a0[t1]
ma2:	jal	somatorio
	c.le.d  $f0, $f10
	bc1f	update			# Se somatório > maior somatório conhecido, atualiza valor e guarda qual intervalo
ma3:	addi	$t2, $t2, 1			# j++
	addi	$a0, $v0, 8
	ble	$t2, $t3, ma2		# Percorrer todos os j segmentos, de um determinado tamanho i, do vetor
	li	$t2, 0 			# j zerado
	subi	$t1, $t1, 1			# Decrementa i
	bgt	$t1, 1, ma1			# Percorrer todos os tamanhos de segmentos possíveis do vetor
	la	$a0, soma
	li	$v0, 4
	syscall
	mov.d	$f12, $f10
	li	$v0, 3
	syscall
	la	$a0, obtida
	li	$v0, 4
	syscall
	l.d	$f12, ($a2)
	li	$v0, 3
	syscall
	la	$a0, ate
	li	$v0, 4
	syscall
	l.d	$f12, ($a3)
	li	$v0, 3
	syscall				# Impressão dos valores
	li	$a0, 10
	li	$v0, 11
	syscall
	li	$v0, 10
	syscall
	
update:
	mov.d	$f10, $f0
	move	$a2, $v0
	subi	$a3, $a0, 8
	b	ma3

# a0: vetor, a1: tamanho
array_read:
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
r1:	la	$a0, insira
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall
	la	$a0, bracket
	li	$v0, 4
	syscall
	li	$v0, 7
	syscall
	s.d	$f0, ($a3)
	addi	$a3, $a3, 8
	addi	$t0, $t0, 1
	blt	$t0, $a1, r1
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	li	$t0, 0
	jr	$ra
	
# a0: array, a1: tamanho
array_print:
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	move	$a3, $a0
	li	$a0, 91
	li	$v0, 11
	syscall
p1:	l.d	$f12, ($a3)
	li	$v0, 3
	syscall
	addi	$a3, $a3, 8
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
	
# a0: vetor, a1: tamanho
somatorio:
	li	$t0, 0				# Contador
	move	$v0, $a0
	mov.d	$f0, $f2
m1:	l.d	$f4, ($a0)				# Lê o double na posição apontada por a0
	add.d	$f0, $f0, $f4			# Soma o double em f0
	addi	$a0, $a0, 8				# Move ponteiro à frente em 8 bytes
	addi	$t0, $t0, 1				# Incrementa contador
	blt	$t0, $a1, m1			# Se contador < tamanho, repita m1
	jr	$ra
