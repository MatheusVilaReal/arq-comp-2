#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	entrada:		.asciiz "Dimensão da matriz: "
	ent1:			.asciiz "Insira o elemento índice ["
	ent2:			.asciiz "]["
	ent3:			.asciiz "]: "
	ent4:			.asciiz "\nLinha do menor elemento no geral lido: "
	ent5:			.asciiz "\nLinha do maior elemento ímpar lido: "
	ent6:			.asciiz "Não há números ímpares na matriz."
	
	# Constante maior inteiro
	.align 2
	menor_int: 		.word 2147483647
	
	# Constante menor inteiro
	.align 2
	maior_impar: 	.word -2147483648
	
.text
main:						#
	la	$a0, entrada		#
	li	$v0, 4			#
	syscall				# Imprime string entrada
	li	$v0, 5			#
	syscall				# Lê a dimensão n da matriz
	move	$s0, $v0			# Guarda n em s0
	sll	$v0, $v0, 2			#
	mul	$a0, $v0, $v0		# Calcula o tamanho da matriz em bytes, n * n * 4
	li	$v0, 	9			#
	syscall				# Aloca n * n * 4 bytes
	move	$s1, $v0			# Guarda ponteiro em s1
	move	$a0, $s1			# Ponteiro para matriz
	move	$a1, $s0			# nº de linhas
	move	$a2, $s0			# nº de colunas
	jal	matrix_read			# Chamada para leitura da matriz
	move	$a0, $s1			# Ponteiro para matriz
	move	$a1, $s0			# nº de linhas
	move	$a2, $s0			# nº de colunas
	jal	matrix_print		# Chamada para função que imprime a matriz e encontra maior ímpar e menor inteiro
	la	$a0, ent4			#
	li	$v0, 4			#
	syscall				# Imprime mensagem do menor elemento lido no geral
	move	$a0, $s2			#
	li	$v0, 1			#
	syscall				# Imprime o valor da linha do menor elemento no geral lido
	la	$a0, ent5			#
	li	$v0, 4			#
	syscall				# Imprime mensagem do maior ímpar lido no geral
	beqz	$s3, n_tem			# Se não forem encontrados ímpares, imprima uma mensagem
	move	$a0, $s3			#
	li	$v0, 1			#
	syscall				# Imprime o valor da linha do maior ímpar lido
	li	$v0, 10			#
	syscall				# Fim.

n_tem:					# Não há ímpares na matriz
	la	$a0, ent6			#
	li	$v0, 4			#
	syscall				# Imprime mensagem que indica que não foram encontrados ímpares na matriz
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
	lw	$t2, menor_int		# Inicializa variável que guarda menor valor inteiro lido
	lw	$t3, maior_impar		# Inicializa variável que guarda maior ímpar inteiro lido
e1:	jal	indice			# Encontra o ponteiro para o índice da matriz
	lw	$a0, ($v0)			# Carrega elemento apontado pelo endereço calculado
	ble	$a0, $t2, menor		# Se matriz[i][j] <= menor inteiro, pule para menor
e2:	rem	$t4, $a0, 2			# Se matriz[i][j] for ímpar..
	bnez	$t4, maior			# Pule para maior
e3:	li	$v0, 1			#
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
	
maior:
	blt	$a0, $t3, e3		# Se matriz[i][j] < maior ímpar, retorne ao método principal
	addi	$s3, $t0, 1			# Atualiza índice...
	move	$t3, $a0			# ...e o valor de maior ímpar.
	b	e3				# Retorna ao método principal
	
menor:
	addi	$s2, $t0, 1			# Atualiza índice...
	move	$t2, $a0			# ...e o valor de maior ímpar.
	b 	e2				# Retorna ao método principal