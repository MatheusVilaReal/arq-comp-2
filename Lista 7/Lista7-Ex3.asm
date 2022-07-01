####################################################
# aluno: MATHEU PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	buffer:	.asciiz "   "
	file:	.asciiz "vet.dat"
	error:	.asciiz "Nao foi possível abrir o arquivo"
	
	vet:	.word 5, 10, 15, 20
	
.text
main:
	la	$a0, file
	li	$a1, 1
	jal	fopen
	move	$s0, $v0
	li	$v0, 5
	syscall
	blt	$v0, 0, failure
	bge	$v0, 4, failure
	sll	$v0, $v0, 2
	lw	$t0, vet($v0)
	addi	$t0, $t0, 1
	sw	$t0, vet($v0)
	la	$a1, buffer
	li	$a2, 3
	la	$a3, vet
	li	$t9, 10
m1:	lw	$t0, ($a3)
	div	$t0, $t9
	mfhi	$t3
	addi	$t3, $t3, 48
	sb	$t3, 1($a1)
	mflo	$t3
	addi	$t3, $t3, 48
	sb	$t3, ($a1)
	move	$a0, $s0
	li	$v0, 15
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall
	li	$a0, 32
	li	$v0, 11
	syscall
	addi	$a3, $a3, 4
	addi	$t1, $t1, 1
	blt	$t1, 4, m1
	move	$a0, $s0
	li	$v0, 16
	syscall
	li	$v0, 10
	syscall
	
failure:
	la	$a0, error
	li	$v0, 4
	syscall
	li	$v0, 10
	syscall
	
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