####################################################
# aluno: MATHEU PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	buffer:	.asciiz " "
	in:		.asciiz "entrada2.txt"
	out:		.asciiz "saida2.txt"
	msg1:	.asciiz "Insira o caminho do arquivo a ser lido: "
	msg2:	.asciiz "Insira o caminho do arquivo a ser salvo: "
	error:	.asciiz "ERRO\nNão foi possível abrir o arquivo."
		
.text
main:
	subi	$sp, $sp, 8
	la	$a0, in
	li	$a1, 0
	jal	fopen
	sw	$v0, ($sp)
	la	$a0, out
	li	$a1, 1
	jal	fopen
	sw	$v0, 4($sp)
	lw	$a0, ($sp)
	lw	$a1, 4($sp)
	la	$a2, buffer
	jal	ftranscribe
	lw	$a0, ($sp)
	li	$v0, 16
	syscall
	lw	$a0, 4($sp)
	li	$v0, 16
	syscall
	addi	$sp, $sp, 8
	li	$v0, 10
	syscall
	
ftranscribe:		#a0: entrada,  a2: file buf, a1: saida
	subi	$sp, $sp, 8
	sw	$a0, ($sp)
	sw	$a1, 4($sp)
	move	$a1, $a2
	li	$a2, 1
	li	$t1, 42
t1:	li	$v0, 14
	lw	$a0, ($sp)
	syscall
	blez	$v0, t3
	lb	$t0, ($a1)
	beq	$t0, 65, vowel
	beq	$t0, 69, vowel	
	beq	$t0, 73, vowel
	beq	$t0, 79, vowel
	beq	$t0, 85, vowel
	beq	$t0, 97, vowel
	beq	$t0, 101, vowel	
	beq	$t0, 105, vowel
	beq	$t0, 111, vowel
	beq	$t0, 117, vowel
t2:	li	$v0, 15
	lw	$a0, 4($sp)
	syscall
	b	t1
t3:	addi	$sp, $sp, 8
	jr	$ra

vowel:
	sb	$t1, ($a1)
	b	t2
	
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