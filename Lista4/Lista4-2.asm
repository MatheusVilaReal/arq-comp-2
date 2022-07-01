.data

squares:	.space 190		# Vetor squares

sumTxt:	.asciiz "sum = "

newln:	.asciiz "\n"

.text
main: 
	li	$v0, 5		# Carrega 5 em v0
	syscall			# print_int
	move	$a0, $v0		# Carrega o endereço de squares
	li	$v0, 0		# Seta v0 com 0
	la	$a1, squares	# Carrega o endereço de squares em a1
	jal	storeValues		# Chama storeValues
	la	$a1, squares	# Carrega o endereço de squares em a1
	jal	computeSum		# Chama computeSum
	move	$a2, $v0		# Move o retorno de computeSum para a2
	li	$v0, 4		# Seta v0 com 4
	la	$a0, sumTxt		# Carrega o endereço de sumTxt
	syscall			# print_string
	move	$a0, $a2		
	li	$v0, 1		# Seta v0 com 1
	syscall			# print_int
	li	$v0, 4		# Seta v0 com 4
	la	$a0, newln		# Carrega o endereço de newln em a0
	syscall			# print_string
	li	$v0, 10		# Seta v0 com 10
	syscall			# exit
	
storeValues:
	li	$s0, 0

L0:
	mult	$s0, $s0		# s0 * s0
	mflo 	$t1			# salva em t1
	sw	$t1, ($a1)		# *squares = t1
	addiu	$a1, $a1, 4		# avança 4 endereços em squares
	addiu $s0, $s0, 1		# contador s0 incrementado em 1
	blt	$s0, $a0, L0	# se s0 menor que n, repita L0
	
	jr	$ra			# retorne
	
computeSum:
	li	$s0, 0		# Inicializa s0 com 0
	
L1:
	lw	$t1, ($a1)
	add	$v0, $v0, $t1	# v0 = v0 + *squares
	addiu	$a1, $a1, 4		# avança 4 endereços em squares
	addiu $s0, $s0, 1 	# contador s0 incrementado em 1
	blt	$s0, $a0, L1	# se s0 menor que n, repita L1
	
	jr	$ra			# retorne v0
