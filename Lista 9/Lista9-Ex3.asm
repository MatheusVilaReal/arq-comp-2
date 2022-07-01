#####################################################
# aluno: MATHEUS PIRES VILA REAL	nº 202000560352 #
#####################################################
.data
	# Strings
	n:			.asciiz "n = "
	alfabeto:		.asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

.macro swap(%a, %b)
	lb	$t7, (%a)
	lb	$t8, (%b)
	sb	$t8, (%a)
	sb	$t7, (%b)
	li	$t7, 0
	li	$t8, 0
.end_macro	

.text
main:
	la	$a0, n
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall				# Lê n
	sb	$zero, alfabeto($v0)	# Insere terminador na posição delimitada pelo usuário
	move	$s0, $v0
	la	$a3, alfabeto
	li	$a1, 0
	subi	$a2, $s0, 1
	jal	permute			# Chamada para permute
	li	$v0, 10
	syscall
	
# a3: string, a1: índice inicial, a2: índice final
permute:
	bne	$a1, $a2, rec		# Enquanto expoente > 0, continuar
	move	$a0, $a3
	li	$v0, 4			# Se não, imprima a string
	syscall
	li	$a0, 10
	li	$v0, 11
	syscall
	jr	$ra
rec:	subi	$sp, $sp, 4			
	sw	$ra, ($sp)			# Guarda endereço de retorno na stack
	move	$t0, $a1
r1:	subi	$sp, $sp, 4			
	sw	$t0, ($sp)			# Salva contador na stack
	add	$t1, $a3, $a1
	subi	$sp, $sp, 4			
	sw	$t1, ($sp)			# Salva ponteiro de início na stack
	add	$t2, $a3, $t0
	subi	$sp, $sp, 4			
	sw	$t2, ($sp)			# Salva ponteiro de final na stack
	swap($t1, $t2)			# Inverte
	subi	$sp, $sp, 4			
	sw	$a1, ($sp)			# Salva indice inicial na stack
	addi	$a1, $a1, 1			# Incrementa índice inicial
	jal	permute			# Recursão
	lw	$a1, ($sp)			# Restaura índice inicial
	addi	$sp, $sp, 4
	lw	$t1, ($sp)			# Restaura ponteiro inicial
	addi	$sp, $sp, 4
	lw	$t2, ($sp)			# Restaura ponteiro final
	addi	$sp, $sp, 4
	swap($t1, $t2)			# backtrack
	lw	$t0, ($sp)			# Restaura contador
	addi	$sp, $sp, 4
	addi	$t0, $t0, 1			# Incrementa contador
	ble	$t0, $a2, r1		# Enquanto contador <= índice final, repita
	lw	$ra, ($sp)			# Restaura o endereço de retorno
	addi	$sp, $sp, 4
	jr	$ra