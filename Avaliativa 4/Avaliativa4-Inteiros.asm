#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	soma:			.asciiz "Soma dos elementos da diagonal secundária: "
	ent1:			.asciiz "Insira o elemento índice ["
	ent2:			.asciiz "]["
	ent3:			.asciiz "]: "
	
.text
main:
	subi	$sp, $sp, 36		# Matriz 3x3 de inteiros ocupa 36 bytes
	move	$s0, $sp			# Guarda ponteiro para matriz estática em em s0
	move	$a0, $s0			# Ponteiro para matriz
	li	$a1, 3 			# nº de linhas
	li	$a2, 3			# nº de colunas
	jal	matrix_read			# Chamada para leitura da matriz
	move	$a0, $s0			# Ponteiro para matriz
	li	$a1, 3			# nº de linhas
	li	$a2, 3			# nº de colunas
	jal	matrix_print		# Chamada para função que imprime a matriz
	move	$a0, $s0			# Ponteiro para matriz
	li	$a1, 3			# nº de linhas
	li	$a2, 3			# nº de colunas
	jal	soma_diag_sec		# Chamada para função que soma diagonal secundária
	move	$a1, $v0
	la	$a0, soma
	li	$v0, 4
	syscall				# Imprime string soma
	move	$a0, $a1
	li	$v0, 1
	syscall				# Imprime resultado da soma
	addi	$sp, $sp, 36		# Desempilha matriz
	li	$v0, 10			#
	syscall				# Fim.

# t0: contador de linha, t1: contador de coluna
indice:					# Calcula e retorna um ponteiro para o elemento da matriz de índice [t0][t1]
	mul	$v0, $t0, $a2		# Multiplica número de linhas já processadas por número de colunas
	add	$v0, $v0, $t1		# Soma número de colunas já processdas no endereço da matriz
	sll	$v0, $v0, 2			# vezes 4 bytes por elemento por ser uma matriz de words
	add	$v0, $v0, $a3		# Calcula ponteiro final para matriz[t0][t1]
	jr	$ra				#
	
# a0: matriz, a1: linhas, a2: colunas
matrix_read:				# Realiza leitura de a1 * a2 elementos e grava na matriz
	subi	$sp, $sp, 4			#
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	move	$a3, $a0			# Guarda ponteiro para a matriz em a3
l1:	la	$a0, ent1			#
	li	$v0, 4			#
	syscall				# Imprime mensagem de leitura
	addi	$a0, $t0, 1			#
	li	$v0, 1			#
	syscall				# Imprime um nº da linha
	la	$a0, ent2			#
	li	$v0, 4			#
	syscall				# Imprime mensagem de leitura
	addi	$a0, $t1, 1			#
	li	$v0, 1			#
	syscall				# Imprime um nº da coluna
	la	$a0, ent3			#
	li	$v0, 4			# Imprime mensagem de leitura
	syscall				#
	li	$v0, 5			#
	syscall				# Lê um inteiro
	move	$v1, $v0			# Guarda inteiro em v1
	jal	indice			# Encontra o ponteiro para o índice atual
	sw	$v1, ($v0)			# Escreve no endereço
	addi	$t1, $t1, 1			# Incrementa contador de coluna
	blt	$t1, $a2, l1		# Se coluna < nº de colunas, repita
	li	$t1, 0			# Zera contador de colunas
	addi	$t0, $t0, 1			# Incrementa contador de linhas 
	blt	$t0, $a1, l1		# Se linha < nº de linhas, repita
	li	$t0, 0			# Zera t0
	lw	$ra, ($sp)			# Desempilha endereço de retorno
	addi	$sp, $sp, 4			#
	move	$v0, $a3			# Restaura endereço da matriz como valor de retorno
	jr	$ra				#
	
# a0: matriz, a1: linhas, a2: colunas
matrix_print:				# Imprime a matriz
	subi	$sp, $sp, 4			#
	sw	$ra, ($sp)			# Empilha endereço retorno
	move	$a3, $a0			# Salva ponteiro para matriz em a3
	li	$t0, 0			# Contador de linhas (i)
	li	$t1, 0			# Contador de colunas (j)
e1:	jal	indice			# Encontra o ponteiro para o índice da matriz
	lw	$a0, ($v0)			# Carrega elemento apontado pelo endereço calculado
	li	$v0, 1			#
	syscall				# Imprime matriz[i][j]
	la	$a0, 32			# Valor ASCII para o espaço
	li	$v0, 11			#
	syscall				# Imprime espaço para separar elementos
	addi	$t1, $t1, 1			# Incrementa contador de colunas
	blt	$t1, $a2, e1		# Se colunas < nº de colunas, repita
	la	$a0, 10			# Valor ASCII para quebra de linha
	syscall				# Imprime quebra de linha
	li	$t1, 0			# Zera contador de colunas
	addi	$t0, $t0, 1			# Incrementa contador de linhas
	blt	$t0, $a1, e1		# Se linhas < nº de linhas, repita
	li	$t0, 0			# Zera t0
	lw	$ra, ($sp)			#
	addi	$sp, $sp, 4			# Desempilha o endereço de retorno
	move	$v0, $a3			# Ponteiro da matriz para valor de retorno
	jr	$ra				#
	
# a0: matriz, a1: linhas, a2: colunas
soma_diag_sec:
	subi	$sp, $sp, 4			#
	sw	$ra, ($sp)			# Empilha endereço retorno
	move	$a3, $a0			# Salva ponteiro para matriz em a3
	li	$t0, 0			# Contador de linhas (i)
	li	$t1, 2			# Contador de colunas (j)
	li	$v1, 0			# Somatório dos elementos da diag. secundária
s1:	jal	indice			# Encontra o ponteiro para o índice da matriz
	lw	$t2, ($v0)			# Carrega elemento apontado pelo endereço calculado em t2
	add	$v1, $v1, $t2		# Soma ao somatório da diag. secundária
	addi	$t0, $t0, 1			# Incrementa contador de linha
	subi	$t1, $t1, 1			# Decrementa contador de coluna
	bge	$t1, $zero, s1		# Se j >= 0, repita
	move	$v0, $v1			# Estabelece valor de retorno
	lw	$ra, ($sp)			# Desempilha endereço de retorno
	addi	$sp, $sp, 4			
	jr	$ra