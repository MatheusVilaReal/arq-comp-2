################################################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 					
################################################################################
.data
	msg:		.asciiz "Insira um número n: "
	eh:		.asciiz "Número é perfeito"
	neh:		.asciiz "Número nao é perfeito"
#------------------------------------------------------------------------------#
.text
	la	$a0, msg		# Carrega o endereço da string msg em a0
	li	$v0, 4		# Código de syscall 4, para imprimir string na tela
	syscall			# Chamada de sistema para impressão de string
	li	$v0, 5		# Código de syscall 5, para leitura de inteiro
	syscall			# Chamada de sistema para leitura de inteiro
	ble	$v0, 1, l4		# Se n == 1, não é perfeito
	move	$s0, $v0		# Salva o inteiro (n) lido em s0
	li	$a0, 1		# Inicializa a0 (o somatório dos divisores) com 1
	li	$t0, 2		# Inicializa t0 = i (variável contadora) com 2
	mul	$t1, $t0, $t0	# Inicializa t1 (condição de parada do loop) com t0 * t0
l1:	rem	$t2, $s0, $t0	# Calcula n % i
	bnez	$t2, l3		# Se n % i == 0, então:
	add	$a0, $a0, $t0	# 	somatorio += i
	beq	$t1, $s0, l3	# 	Se i * i != n, então:
	div	$t3, $s0, $t0	#		t3 = n / i
	add	$a0, $a0, $t3	#		somatorio += t3
l3:	addi	$t0, $t0 ,1		# i++
	mul	$t1, $t0, $t0	# Atualiza valor de t1 = i * i
	ble	$t1, $s0, l1	# Se t1 <= n, repita l1
	bne	$a0, $s0, l4	# Se somatorio == n, então:
	la	$a0, eh		# Imprime mensagem de número perfeito na tela
	li	$v0, 4
	syscall
	b	exit			# Finaliza o programa
l4:	la	$a0, neh		# se não:
	li	$v0, 4		# Imprime mensagem de número não perfeito na tela
	syscall
exit:	li 	$v0, 10
	syscall