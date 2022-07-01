.data

primes:	.space 190		# Vetor squares

newln:	.asciiz "\n"

.text

main:
	li	$t7, 2		# primes[64] = {2}
	sw	$t7, primes
	li	$v0, 5
	syscall			# read_int
	move	$a3, $v0
	li	$a0, 2		# carrega 2 em a0
	la	$t6, primes		# carrega o endereço de primes em 2
	
L3:
	beq	$a0, $a3, L4	# se a0 = a3, pule para l4
	jal	is_prime		# chama is_prime
	bne	$v0, 1, branch	# se nao for primo
	addiu	$a1, $a1, 1		# incrementa contador
	addiu	$t6, $t6, 4		# incrementa endereço
	sw	$a0, ($t6)		# salva na posição do vetor indicada por endereço
	
branch:
	addiu	$a0, $a0, 1		# se for primo
	b	L3			# repita
	
L4:
	la	$t0, primes		# salva endereço de primos em t0
L5:
	bgt	$t5, $a1, exit	# escape do loop
	lw	$a0, ($t0)		# carrega o conteudo do endereço de t0 em a0
	li	$v0, 1		# v0 = 1
	syscall			# print_int
	la	$a0, newln		
	li	$v0, 4		# imprime newln
	syscall
	addiu	$t5, $t5, 1		# incrementa t5
	addiu	$t0, $t0, 4		# incrementa o endereço
	b	L5			# repita

is_prime:
	li	$s0, 0		# inicializa contador
	la	$a2, primes		# salva endereço de primso em a2

L0:
	bgt	$s0, $a1, L1	# escape do loop se contador > a1 (n)
	lw	$t0, ($a2)		# carregue o endereço a2 em t0
	div	$a0, $t0		# divide a0 por t0		
	mfhi	$t1			# resto da divisão em t1
	beq	$t1, 0, L1		# se t1 = 0, escape do loop
	addiu	$s0, $s0, 1
	addiu	$a2, $a2, 4		# incrementos
	b 	L0			# repita

L1:
	sgt	$v0, $s0, $a1	# se s0 > a1, v0 = 1 senao v0 = 0
	jr	$ra			# retorne v0
	
exit:
	li	$v0, 10
	syscall			# exit