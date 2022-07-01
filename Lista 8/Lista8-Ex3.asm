#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	entrada:		.asciiz "Número de alunos: "
	ent1:			.asciiz "Insira a nota do aluno "
	ent2:			.asciiz " ["
	ent3:			.asciiz "]: "
	ent4:			.asciiz ": "
	errmsg:		.asciiz "\nERRO: N deve ser menor ou igual a 8!\n"
	media_aluno:	.asciiz "\nMédia do aluno "
	media_turma:	.asciiz "\nMédia da turma: "
	num_aprovados:	.asciiz "\n\nNúmero de aprovados: "
	num_reprovados:	.asciiz "\nNúmero de reprovados: "
	
	.align 3
	dbl_6:		.double 6.0

.text
main:
	l.d	$f24, dbl_6
	la	$a0, entrada
	li	$v0, 4
	syscall				# Imprime entrada
	li	$v0, 5
	syscall				# Lê inteiro n
	move	$s0, $v0			# Salva n em $s0
	sll	$a0, $v0, 3			
	mul	$a0, $a0, 3			
	li	$v0, 9			# Aloca n * 8 * 3 bytes para a matriz
	syscall
	move	$s1, $v0			# Endereço da matriz em s1
	move	$a0, $s1			# Endereço da matriz
	move	$a1, $s0			# n linhas
	li	$a2, 3			# 3 colunas
	jal	matrix_read
	move	$a0, $s1
	move	$a1, $s0
	li	$a2, 3
	jal	matrix_print
	li	$a1, 3
	li	$t0, 0
	li	$t1, 0			# Contadores
	li	$t2, 1			# Constante 1
	move	$a3, $s1
ma1:	move	$a0, $a3
	jal	media				# Calcula a média dos 3 elementos próximos ao ponteiro para matriz
	c.lt.d  $f0, $f24			#
	movf	$t1, $t2			# Se >= 6, aluno aprovado e somado no contador de aprovados
	add	$s2, $s2, $t1
	move	$a3, $a0
	la	$a0, media_aluno
	li	$v0, 4
	syscall				# Imprime a média do aluno
	move	$a0, $t3
	li	$v0, 1
	syscall
	la	$a0, ent4
	li	$v0, 4
	syscall
	mov.d $f12, $f0
	li	$v0, 3
	syscall
	addi	$t3, $t3, 1
	blt	$t3, $s0, ma1		# Repete
	move	$a0, $s1
	mul	$a1, $s0, 3
	jal	media				# Calcula média para todos os elementos da matriz
	la	$a0, media_turma
	li	$v0, 4
	syscall
	mov.d	$f12, $f0
	li	$v0, 3
	syscall				# Imprime média da turma
	la	$a0, num_aprovados
	li	$v0, 4
	syscall
	move	$a0, $s2
	li	$v0, 1
	syscall				# Imprime número de aprovados
	la	$a0, num_reprovados
	li	$v0, 4
	syscall
	sub	$a0, $s0, $s2
	li	$v0, 1
	syscall				# Imprime número de reprovados
	li	$v0, 10
	syscall

# t0: contador de linha, t1: contador de coluna
indice:				# Calcula e retorna um ponteiro para o elemento da matriz de índice [t0][t1]
	mul	$v0, $t0, $a2
	add	$v0, $v0, $t1
	sll	$v0, $v0, 3		# 8 bytes por elemento por ser uma matriz de double
	add	$v0, $v0, $a3
	jr	$ra
	
# a0: matriz, a1: linhas, a2: colunas
matrix_read:			# Realiza leitura de a1*a2 elementos e grava na matriz
	subi	$sp, $sp, 4
	sw	$ra, ($sp)		# Guarda endereço de retorno na stack
	move	$a3, $a0		# Guarda ponteiro para a matriz em a3
l1:	la	$a0, ent1		#
	li	$v0, 4		#
	syscall			#
	move	$a0, $t0		#
	li	$v0, 1		#
	syscall			#
	la	$a0, ent2		#
	li	$v0, 4		#
	syscall			# Imprime mensagem de leitura
	move	$a0, $t1		#
	li	$v0, 1		#
	syscall			#
	la	$a0, ent3
	li	$v0, 4
	syscall
	li	$v0, 7
	syscall			# Lê um double
	jal	indice
	s.d	$f0, ($v0)		# Salva no índice
	addi	$t1, $t1, 1
	blt	$t1, $a2, l1
	li	$t1, 0
	addi	$t0, $t0, 1
	blt	$t0, $a1, l1	# Repete
	li	$t0, 0
	lw	$ra, ($sp)		# Restaura endereço de retorno e retorna
	addi	$sp, $sp, 4
	move	$v0, $a3
	jr	$ra
	
# a0: matriz, a1: linhas, a2: colunas
matrix_print:				# Imprime a matriz
	subi	$sp, $sp, 4			
	sw	$ra, ($sp)
	move	$a3, $a0	
	li	$t0, 0
	li	$t1, 0
e1:	jal	indice
	l.d	$f12, ($v0)
	li	$v0, 3
	syscall
	la	$a0, 32
	li	$v0, 11
	syscall
	addi	$t1, $t1, 1
	blt	$t1, $a2, e1
	la	$a0, 10
	syscall
	li	$t1, 0
	addi	$t0, $t0, 1
	blt	$t0, $a1, e1
	li	$t0, 0
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	move	$v0, $a3
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