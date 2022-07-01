#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	cpf:			.asciiz "xxxxxxxxx-xx"
	insira:		.asciiz "Insira o CPF para validar (xxxxxxxxx-xx): "
	msg_erro:		.asciiz "ERRO: Formato digitado inválido, tente novamente.\n"
	msg_invalido:	.asciiz "CPF inválido.\n"
	msg_valido:		.asciiz "CPF válido.\n"

.text
main:
	la	$a0, insira
	li	$v0, 4
	syscall
	la	$a0, cpf
	li	$a1, 13
	li	$v0, 8
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	lb	$t0, cpf+9
	bne	$t0, 45, erro
	jal	digito_1				# Verifica dígito verif 1
	lb	$t0, cpf+10
	bne	$t0, $v0, invalido
	jal	digito_2				# Verifica dígito verif 2
	lb	$t0, cpf+11
	bne	$t0, $v0, invalido
	
valido:
	la	$a0, msg_valido
	li	$v0, 4
	syscall
	li	$v0, 10
	syscall
	
invalido:
	la	$a0, msg_invalido
	li	$v0, 4
	syscall
	li	$v0, 10
	syscall
	
digito_1:
	li	$v0, 48
	li	$t0, 0
	li	$a0, 0
	li	$a1, 10
d11:	lb	$t1, cpf($t0)
	subi	$t1, $t1, 48
	mul	$t1, $t1, $a1
	add	$a0, $a0, $t1
	subi	$a1, $a1, 1
	addi	$t0, $t0, 1
	blt	$t0, 9, d11			# Soma todos os dígitos multiplicando por 10, 9, 8, 7...
	rem	$a2, $a0, 11		# Verifica se resto > 2
	ble	$a2, 2, d12
	mul	$a2, $a2, -1
	addi	$v1, $a2, 11		# Valor numérico em v1
	add	$v0, $v0, $v1		# Valor ASCII em v0
d12:	jr	$ra
	
digito_2:
	li	$v0, 48
	li	$t0, 0
	li	$a0, 0
	li	$a1, 11
d21:	lb	$t1, cpf($t0)
	subi	$t1, $t1, 48
	mul	$t1, $t1, $a1
	add	$a0, $a0, $t1
	subi	$a1, $a1, 1
	addi	$t0, $t0, 1
	blt	$t0, 9, d21			# Soma todos os dígitos multiplicando por 11, 10, 9, 8...
	lb	$t1, cpf+10		
	subi	$t1, $t1, 48
	mul	$t1, $t1, $a1
	add	$a0, $a0, $t1		# Verifica primeiro dígito verificador
	rem	$a2, $a0, 11		# Verifica se resto > 2
	ble	$a2, 2, d22
	mul	$a2, $a2, -1
	addi	$v1, $a2, 11		# Valor numérico em v1
	add	$v0, $v0, $v1		# Valor ASCII em v0
d22:	jr	$ra
	
erro:
	la	$a0, msg_erro
	li	$v0, 4
	syscall				# Mensagem de erro.
	b	main