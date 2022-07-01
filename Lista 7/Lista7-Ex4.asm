####################################################
# aluno: MATHEU PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	buffer:	.asciiz " "
	file:	.asciiz "matriz.txt"
	output:	.asciiz "matriz saida.txt"
	error:	.asciiz "Não foi possível abrir o arquivo."
	
.macro index(%matrix, %i, %j, %ncol)

	mul	$v0, %i, %ncol
	add	$v0, $v0, %j
	add	$v0, $v0, %matrix
	
.end_macro
	
.text
main:
	la	$a0, file
	la	$a1, 0
	jal	fopen
	move	$s0, $v0
	la	$a0, output
	la	$a1, 1
	jal	fopen
	move	$s1, $v0
	move	$a0, $s0
	la	$a1, buffer
	li	$t9, 1
	jal	fgetint
	move	$t1, $v0 
	jal	fgetint
	move	$t2, $v0
	jal	fgetint
	move	$t8, $v0
	mul	$t3, $t1, $t2
	subi	$t5, $t3, 1
	ori	$t5, $t5, 3
	addi	$t5, $t5, 1
r3:	subi	$sp, $sp, 1
	sb	$t9, ($sp)
	addi	$t4, $t4, 1
	blt	$t4, $t3, r3
r4:	jal	fgetint
	move	$t4, $v0
	jal	fgetint
	move	$t5, $v0
	index($sp, $t4, $t5, $t2)
	sb	$zero, ($v0)
	addi	$s5, $s5, 1
	blt	$s5, $t8, r4
r5:	li	$t6, 0
r6:	move	$a0, $s1
	li	$v0, 15
	lb	$t0, ($sp)
	addi	$t0, $t0, 48
	sb	$t0, buffer
	syscall
	li	$t9, 32
	sb	$t9, buffer
	li	$v0, 15
	syscall
	addi	$sp, $sp, 1
	addi	$t6, $t6, 1
	blt	$t6, $t2, r6
	li	$t6, 0
	li	$t9, 13
	sb	$t9, buffer
	li	$v0, 15
	syscall
	li	$t9, 10
	sb	$t9, buffer
	li	$v0, 15
	syscall
	addi	$t7, $t7, 1
	blt	$t7, $t1, r6
exit:
	move	$a0, $s0
	li	$v0, 16
	syscall
	move	$a0, $s1
	li	$v0, 16
	syscall
	li	$v0, 10
	syscall
	
# (a0: file descriptor, a1: buffer de entrada)
fgetint:
	li	$a2, 1
	li	$t6, 0
	li	$t7, 0
f1:	li	$v0, 14 				# Código de leitura de arquivo
	syscall 					# Faz a leitura de 1 caractere
	blez	$v0, f2
	lb	$t0, ($a1)
	beq	$t0, 13, f1
	beq	$t0, 10, f2
	beq	$t0, 32, f2
	beq	$t0, 45, minus
	subi	$t0, $t0, 48
	mul	$t6, $t6, 10
	add	$t6, $t6, $t0
	b	f1
f2:	sgt	$v1, $v0, $zero
	move	$v0, $t6
	beqz	$t7, jre
	mul	$v0, $v0, -1
jre:	jr	$ra

minus:
	li	$t2, 1
	b	f1

fopen:
	li	$v0, 13 # Código de abertura de arquivo
	syscall # Tenta abrir o arquivo
	bgez	$v0, fo # if(file_descriptor >= 0) goto a
	la	$a0, error # else erro: carrega o endereço da string
	li	$v0, 4 # Código de impressão de string
	syscall # Imprime o erro
	li	$v0, 10 # Código para finalizar o programa
	syscall # Finaliza o programa
fo:	jr	$ra # Retorna para a main