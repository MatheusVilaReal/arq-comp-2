.data

pftTxt:	.asciiz "E perfeito\n"

npftTxt:	.asciiz "Nao e perfeito\n"

newln:	.asciiz "\n"

.text
main:
	li	$v0, 5		# Carrega 5 em v0
	syscall			# print_int
	move	$a0, $v0		# Move v0 para a0
	li	$s0, 1		# Contador s0 iniciado em 1
	li	$v0, 0
	
	
L0:
	beq	$s0, $a0, L2
	div	$a0, $s0
	mfhi	$t0
	beqz	$t0, L1
	addiu	$s0, $s0, 1
	b	L0
	
L1:
	addu	$v0, $v0, $s0
	addiu	$s0, $s0, 1
	b	L0
	
L2:
	seq	$a1, $v0, $a0
	beq	$a1, 1, perfect
	
notPerfect:
	li	$v0, 4		# Seta v0 com 4
	la	$a0, npftTxt	# Carrega o endereço de npftTxt em a0
	syscall			# print_string
	j exit

perfect:
	li	$v0, 4		# Seta v0 com 4
	la	$a0, pftTxt		# Carrega o endereço de pftTxt em a0
	syscall			# print_string
	j exit
	
exit:
	li	$v0, 10		# v0 = 10
	syscall			# exit