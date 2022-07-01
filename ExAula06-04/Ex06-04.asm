#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################

.data
    BUF: 	.asciiz " "
    PATH:	.asciiz "./data.txt"
    ERROR:	.asciiz "PATH não encontrado!\n"

.text
main:
	la	$a0, PATH 				# Nome do arquivo
	li 	$a1, 0 				# Somente leitura
	jal 	abertura 				# Retorna file descriptor no sucesso
	move 	$s0, $v0				# Salva o file descriptor em $s0
m1:	move	$a0, $s0 				# Parâmetro file descriptor
	la	$a1, BUF 				# Buffer de entrada
	li	$a2, 1 				# 1 caractere por leitura
	li	$a3, 4
	jal	fgetword 				# Retorna em $v0 o num. de carac.
	move	$a0, $v0
	lb	$s2, ($v0)
	jal	parse_int
	add	$s1, $s1, $v0
	bnez	$s2, m1				
	move	$a0, $s1
	li	$v0, 1
	syscall
	li	$v0, 16 				# Código para fechar o arquivo
	move	$a0, $s0 				# Parâmetro file descriptor
	syscall 					# Fecha o arquivo
	li	$v0, 10 				# Código para finalizar o programa
	syscall 					# Finaliza o programa

#	Lê uma palavra (delimitada por espaços) do arquivo aberto em a0
fgetword:	# (a0: file descriptor, a1: buffer de entrada, a2: n de caracteres, a3: n de caracteres leitura)
	subi	$t1, $a3, 1
	move	$t0, $a0
	li	$v0, 9
	move	$a0, $a3
	syscall
	move	$v1, $v0
	move	$t2, $v0
	move	$a0, $t0
	li	$t0, 0
f1:	li	$v0, 14 				# Código de leitura de arquivo
	syscall 					# Faz a leitura de 1 caractere
	beqz	$v0, fret
	lb	$t3, ($a1)
	beq	$t3, 10, fret
	beq	$t3, 32, fret
	beq	$t3, 0, fret
	sb	$t3, ($v1)
	addiu	$v1, $v1, 1
	addiu	$t0, $t0, 1
	blt	$t0, $t1, f1
fret:	sb	$zero, 1($v1)
	move	$v0, $t2
	jr	$ra
	
#	Recebe uma string, converte para inteiro e converte
parse_int:	# (a0: string)
	li	$v0, 0
	b	p1
p1:	lb	$t0, ($a0)
	beqz	$t0, p2
	mul	$v0, $v0, 10
	add	$t0, $t0, -48
	add	$v0, $v0, $t0
	addiu	$a0, $a0, 1
	b	p1
p2:	jr	$ra

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
