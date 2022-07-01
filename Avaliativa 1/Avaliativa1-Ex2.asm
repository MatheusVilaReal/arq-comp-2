################################################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 					
################################################################################
.data
	msg:		.asciiz "Insira um número (com mais de 10 dígitos): "
	error:	.asciiz "ERRO: O número deve ter mais de 10 dígitos\n"
	msg_neh:	.asciiz "O número inserido não é palíndromo.\n"
	msg_eh:	.asciiz "O número inserido é palíndromo.\n"
	
	str:		.space 1000
#------------------------------------------------------------------------------#
.text
main:
	la	$a0, msg		# Carrega o endereço da string msg em a0
	li	$v0, 4		# Código de syscall 4, para imprimir string na tela
	syscall			# Chamada de sistema para impressão de string
	la 	$a0, str		# Leitura de string
	li	$a1, 1000		# Número máximo de dígitos do número a ser lida
	li	$v0, 8
	syscall
	jal	strlen		# Função para calcular o tamanho da string a ser lid
	blt	$v0, 10, erro	# Se o número de dígitos da string lida for menor ou igual a 10
	rem	$t9, $v0, 2		# Se o número de dígitos for ímpar, não é palíndromo
	bnez	$t9, neh
	move	$a1, $v0		# Tamanho da string em a1
	jal	ePalindromo		# Chamada para ePalindromo
	beqz	$v0, neh		# Se 0, não é palíndromo
	la	$a0, msg_eh		# Mensagem de palíndromo
	li	$v0, 4
	syscall
	b	exit
neh:	la	$a0, msg_neh	# Mensagem de não é palíndromo
	li	$v0, 4
	syscall
exit:	li	$v0, 10		# Saída
	syscall
	
erro:
	la	$a0, error		# Exibe mensagem de erro caso a string tenha numero de digitos menor que 10
	li	$v0, 4
	syscall
	b	main			# Retorna para ler outro numero

# Calculao tamanho de uma string
strlen:				# a0: string
	move	$t0, $a0		# Move ponteiro pra t0
	li	$v0, -2		# Carrega retorno inicial com -2
s1:	lb	$t1, ($t0)		# Lê um caractere apontado por t0
	addiu	$v0, $v0, 1		# Soma 1 no tamanho da string
	addiu	$t0, $t0, 1		# Soma um no ponteiro da string
	bne	$t1, $zero, s1	# Enquanto t1 não for igual a 0, repita
	jr	$ra			# Retorno
		
#a0: string, a1: tamanho
ePalindromo:
	subi	$a2, $a1, 1		# a2 = tamanho - 1
	add	$a2, $a2, $a0	# Ponteiro para o final da string
	li	$v0, 1		# retorno
l1:	lb	$t0, ($a0)		# le caractere apontado pelo começo da string
	lb	$t1, ($a2)		# le caractere apontado pelo final da string
	bne	$t0, $t1, nPal	# Se não forem iguais, não é palindromo
	addi	$a0, $a0, 1		# Move ponteiro do início para frente
	subi	$a2, $a2, 1		# Move ponteiro do final para trás
	bge	$a2, $a0, l1	# Se ponteiro do final ainda estiver na frente do ponteiro do início, repita
	jr	$ra			# Retorno
nPal: li	$v0, 0		# Se não for palíndromo, retorna 0
	jr	$ra
