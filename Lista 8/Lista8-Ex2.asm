#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 # 
#####################################################
.data
	# Strings
	n:			.asciiz "Número de iterações (n > 0) = "
	x:			.asciiz "x = "
	cos_x:		.asciiz "cos(x) = "
	
	dbl_1:		.double 1.0
	
.text
main:
	la	$a0, n
	li	$v0, 4
	syscall				# Imprime n
	li	$v0, 5
	syscall				# Lê um inteiro n
	blt	$v0, 1, main		# Se n < 1, leia de novo
	move	$s0, $v0			# s0 = n
	la	$a0, x
	li	$v0, 4
	syscall				# Imprime x
	li	$v0, 7
	syscall				# Lê um double x
	mov.d	$f12, $f0
	move	$a0, $s0			# f12 = x, a0 = n
	jal	cos				# Chamada para cosseno
	la	$a0, cos_x			
	li	$v0, 4
	syscall				# Imprime cos(x) = 
	mov.d	$f12, $f0
	li	$v0, 3
	syscall				# Imprime o resultado
	li	$v0, 10
	syscall

# a0: n
factorial:
	l.d	$f0, dbl_1		# Retorna ao menos 1
f1:	blt	$a0, 2, f2		# Se n < 2, encerre
	mtc1.d  $a0, $f12		# 
	cvt.d.w $f12, $f12	# Converte n para double
	mul.d	$f0, $f0, $f12	# n! = n(n - 1)(n - 2)(n - 3)...
	subi	$a0, $a0, 1		# n -= 1
	b	f1			# Repita
f2:	jr	$ra

# f12: base, a0: exp
pow:
	l.d	$f0, dbl_1		# Retorna ao menos 1
p1:	beqz	$a0, p2
	mul.d	$f0, $f0, $f12	# Multiplica f12 a0 vezes
	subi	$a0, $a0, 1
	b	p1
p2:	jr	$ra
	
# f12: x, a0: n
cos:
	subi	$sp, $sp, 4
	sw	$ra, ($sp)		# Salva endereço de retorno na stack
	move	$a3, $a0		# Tamanho em a3
	mov.d	$f14, $f12		# Salva valores originais de x e de n
	l.d	$f2, dbl_1
	sub.d	$f2, $f30, $f2	# constante -1
	li	$t0, 0		# Contador k
	li	$t1, 0		# 2k
c1:	mov.d	$f12, $f2
	move	$a0, $t0		# Calcula (-1)^k
	jal	pow
	mov.d	$f4, $f0
	mov.d	$f12, $f14
	move	$a0, $t1
	jal	pow			# Calcula x^2k
	mov.d	$f6, $f0
	move	$a0, $t1
	jal	factorial		# Calcula (2k)!
	mul.d $f4, $f4, $f6	
	div.d	$f4, $f4, $f0	# (-1)^k*x^(2k)/(2k)!
	add.d	$f8, $f8, $f4	# Somatório em f8
	addi	$t0, $t0, 1
	addi	$t1, $t1, 2		# Incrementa contadores
	blt	$t0, $a3, c1
	mov.d	$f0, $f8		# Valor de retorno
	lw	$ra, ($sp)		# Restaura endereço de retorno
	addi	$sp, $sp, 4		# Desempilha 4 bytes da stack
	jr	$ra
	
