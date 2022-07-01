####################################################
# aluno: MATHEU PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	BUF: 	.asciiz " "
	PATH:	.asciiz "./dados1.txt"
	ERROR:	.asciiz "PATH não encontrado!\n"
	ODD:		.asciiz "Número de ímpares: "
	EVEN:	.asciiz "Número de pares: "
	BIGGEST:	.asciiz "Maior número: "
	SMALLEST:	.asciiz "Menor número: "
	SUM:		.asciiz "Soma dos números: "
	SORT_1:	.asciiz "Ordenação em ordem crescente:\n"
	SORT_2:	.asciiz "Ordenação em ordem decrescente:\n"	
	
.macro println(%str)

	move	$t6, $v0
	la	$a0, %str
	li	$v0, 4
	syscall
	move	$v0, $t6

.end_macro
	
.macro println_int(%int)

	move	$t5, $a0
	move	$t6, $v0
	move	$a0, %int
	li	$v0, 1
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	move	$a0, $t5
	move	$v0, $t6

.end_macro

.text
main:
	la	$a0, PATH 				# Nome do arquivo
	li 	$a1, 0 				# Somente leitura
	jal 	abertura 				# Retorna file descriptor no sucesso
	move $s0, $v0				# Salva o file descriptor em $s0
m1:	move	$a0, $s0 				# Parâmetro file descriptor
	la	$a1, BUF 				# Buffer de entrada
	jal	fgetint
	subi	$sp, $sp, 4
	sw	$v0, ($sp)
	addi	$s1, $s1, 1
	bnez	$v1, m1
m2:	move	$a1, $s1
	move	$a0, $sp
	li	$t1, 0
	move	$t2, $sp
	li	$t3, 2147483647
	li	$t4, -2147483648
m3:	lw	$t0, ($t2)
	add	$t9, $t9, $t0
	addi	$t2, $t2, 4
	bgt	$t0, $t4, maior
m4:	blt	$t0, $t3, menor
m5:	addi	$t1, $t1, 1
	not	$t6, $t0
	andi	$t5, $t0, 1
	andi	$t6, $t6, 1
	add	$t7, $t7, $t5
	add	$t8, $t8, $t6
	blt	$t1, $s1, m3
	println(SMALLEST)
	println_int($t3)
	println(BIGGEST)
	println_int($t4)
	println(ODD)
	println_int($t7)
	println(EVEN)
	println_int($t8)
	println(SUM)
	println_int($t9)
	move	$a0, $sp
	move	$a1, $s1
	li	$a2, 0
	jal	bubble_sort
	println(SORT_1)
	move	$a0, $v0
	move	$a1, $s1
	jal	array_print
	move	$a0, $sp
	move	$a1, $s1
	li	$a2, 1
	jal	bubble_sort
	println(SORT_2)
	move	$a0, $v0
	move	$a1, $s1
	jal	array_print
	sll	$s1, $s1, 2
	add	$sp, $sp, $s1
	li	$v0, 16 				# Código para fechar o arquivo
	move	$a0, $s0 				# Parâmetro file descriptor
	syscall 					# Fecha o arquivo
	li	$v0, 10 				# Código para finalizar o programa
	syscall 					# Finaliza o programa

maior:	
	move	$t4, $t0
	b	m4	

menor:
	move	$t3, $t0
	b	m5

# (a0: file descriptor, a1: buffer de entrada)
fgetint:
	li	$v1, 1
	li	$a2, 1
	li	$t1, 0
	li	$t2, 0
f1:	li	$v0, 14 				# Código de leitura de arquivo
	syscall 					# Faz a leitura de 1 caractere
	beqz	$v0, f3
	lb	$t0, ($a1)
	beq	$t0, 10, f1
	beq	$t0, 13, f1
	beq	$t0, 32, f2
	beq	$t0, 45, minus
	subi	$t0, $t0, 48
	mul	$t1, $t1, 10
	add	$t1, $t1, $t0
	b	f1
f3:	li	$v1, 0
f2:	move	$v0, $t1
	beqz	$t2, jre
	mul	$v0, $v0, -1
jre:	jr	$ra

minus:
	li	$t2, 1
	b	f1
	
array_print:			#a0: vetor, a1: tamanho
	subi	$sp, $sp, 4
	sw	$a0, ($sp)
	li	$t0, 0
	move	$a3, $a0
a1:	lw	$a0, ($a3)
	li	$v0, 1
	syscall
	li	$a0, 32
	li	$v0, 11
	syscall
	addi	$a3, $a3, 4
	addi	$t0, $t0, 1
	blt	$t0, $a1, a1
	li	$a0, 10
	li	$v0, 11
	syscall
	lw	$v0, ($sp)
	addi	$sp, $sp, 4
	jr	$ra

abertura:
	li	$v0, 13 # Código de abertura de arquivo
	syscall # Tenta abrir o arquivo
	bgez	$v0, a # if(file_descriptor >= 0) goto a
	la	$a0, ERROR # else erro: carrega o endereço da string
	li	$v0, 4 # Código de impressão de string
	syscall # Imprime o erro
	li	$v0, 10 # Código para finalizar o programa
	syscall # Finaliza o programa
a:	jr	$ra # Retorna para a main

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
	
reverse:
	bge	$t3, $t4, b2
	jal	swap
	b	b2

swap:
	sw	$t4, ($a0)	# swap
	sw	$t3, 4($a0)	# swap
	jr	$ra