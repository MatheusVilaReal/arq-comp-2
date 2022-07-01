####################################################
# aluno: MATHEU PIRES VILA REAL	nº 202000560352 #
####################################################

.data
	file:	.asciiz "primosgemeos.txt"
	msg:		.asciiz "Insira o valor de N: "
	op_par:	.asciiz "("
	comma:	.asciiz ", "
	end_par:	.asciiz ")\n"
	buffer:	.asciiz "     "
	error:	.asciiz "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	
.macro file_write(%file, %a, %b)

	li	$t9, 10
	move	$a0, %file
	la	$a1, op_par
	li	$a2, 1
	li	$v0, 15
	syscall
	move	$a0, %a
	la	$a1, buffer
	jal	itoa
	move	$a2, $v1
	move	$a0, %file
	li	$v0, 15
	syscall
	la	$a1, comma
	li	$v0, 15
	syscall
	la	$a1, buffer
	div	%b, $t9
	mfhi	$t7
	addi	$t7, $t7, 48
	sb	$t7, 1($a1)
	mflo	$t8
	addi	$t8, $t8, 48
	sb	$t8, ($a1)
	li	$a2, 2
	li	$v0, 15
	syscall
	la	$a1, end_par
	li	$v0, 15
	syscall

.end_macro

.text
main:
	la	$a0, file
	li	$a1, 1
	jal	fopen
	move	$s3, $v0
	la	$a0, msg
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	addi	$s0, $v0, 1
m1:	subi	$sp, $sp, 4
	sw	$s0, ($sp)
	addi	$t0, $t0, 1
	blt	$t0, $s0, m1
	move	$a0, $sp
	move	$a1, $v0
	jal	sieve_eratosthenes
	li	$t1, 2
	subi	$v1, $v1, 2
	addi	$sp, $sp, 8
m3:	lw	$t0, ($sp)
	beqz	$t0, m4
	lw	$t0, 8($sp)
	beqz	$t0, m4
	addi	$t4, $t1, 2
	file_write($s3, $t1, $t4)
m4:	addi	$t1, $t1, 1
	addi	$sp, $sp, 4
	ble	$t1, $v1, m3
	subi	$s0, $s0, 1
	sll	$s0, $s0, 2
	add	$sp, $sp, $s0
	li	$v0, 10
	syscall
	
#a0: int, a1: string, a2: str_size
itoa:
	subi	$sp, $sp, 4
	sw	$a1, ($sp)
	li	$t0, 1
i1:	mul	$t0, $t0, 10
	div	$a0, $t0
	mflo	$t1
	bgt	$t1, $zero, i1
i2:	div	$a0, $t0
	mfhi	$a0
	mflo	$t1
	beqz	$t1, i3
	addi	$t1, $t1, 48
	sb	$t1, ($a1)
	addi	$a1, $a1, 4
	addi	$t2, $t2, 1
i3:	div	$t0, $t0, 10
	bge	$t2, $a2, i4
	bnez	$a0, i2
i4:	lw	$v0, ($sp)
	move	$v1, $t2
	addi	$sp, $sp, 4
	li	$t0, 0
	li	$t1, 0
	li	$t2, 0
	jr	$ra
	
sieve_eratosthenes:					# a0: primos, a1: n
	li	$t0, 2
l1:	sll	$t3, $t0, 2
	add	$a2, $a0, $t3
	lw	$t4, ($a2)
	beqz	$t4, l3
	mul	$t5, $t0, $t0
l2:	sll	$t6, $t5, 2
	add	$a2, $a0, $t6
	sw	$zero, ($a2)
	add	$t5, $t5, $t0
	ble	$t5, $a1, l2
l3:	addi	$t0, $t0, 1
	mul	$t2, $t0, $t0
	ble	$t2, $a1, l1
	move	$v0, $a0
	move	$v1, $a1
	jr	$ra

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
