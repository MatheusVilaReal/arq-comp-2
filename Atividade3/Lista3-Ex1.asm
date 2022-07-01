########################################################################
# aluno:	MATHEUS PIRES VILA REAL
# N°:		202000560352
########################################################################
.data
	ent1:	.asciiz	"Insira a string1: "
	ent2:	.asciiz	"Insira a string2: "
	str1:	.space	100
	str2:	.space	100
	str3:	.space	200
	
.text
main:
	la	$a0, ent1
	la	$a1, str1
	jal	leitura			# Leitura string 1
	la	$a0, ent2
	la	$a1, str2
	jal	leitura			# Leitura string 2
	la	$a0, str1			# Parâmetro 1 - string 1
	la	$a1, str2			# Parâmetro 2 - string 2
	la	$a2, str3			# Parâmetro 3 - string 3
	jal 	intercala			# Intercalamento string 1 e 2, retorna string 3 em $v0
	move	$a0, $v0			# Move retorno para a a0
	li	$v0, 4
	syscall				# Imprime string
	li	$v0, 10
	syscall				# Exit

leitura:
	li	$v0, 4
	syscall
	move	$a0, $a1
	li	$a1, 100
	li	$v0, 8
	syscall
	jr	$ra

intercala:					# a1, a2 e a3
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2			# Salvando parâmetros nos registradores temporários
	li	$s0, 200			# Tamanho máximo de string 3
	li	$s1, 0			# Contador
	li	$s3, 1
	li	$s4, 1
i1:	lb	$t3, ($t0)
	beq	$t3, $zero, s2
	beq	$t3, 10, s2
	bne	$s3, $zero, e2
i2:	lb	$t4, ($t1)
	beq	$t4, $zero, s3
	beq	$t4, 10, s3
	bne	$s4, $zero, e3
i3:	addiu	$s1, $s1, 1
	bgt	$s1, $s0, return_intercala
	b	i1
	
s2:	
	li	$s3, 0
	b	i2
s3:	
	li	$s4, 0
	b	i3
e2:
	sb	$t3, ($t2)			# Carrega string1[i] e salva em string3[i]
	addiu	$t2, $t2, 1
	addiu	$t0, $t0, 1
	b	i2
e3:
	sb	$t4, ($t2)
	addiu	$t2, $t2, 1
	addiu	$t1, $t1, 1
	b	i3

return_intercala:
	sb	$zero, ($t2)
	move	$v0, $a2
	jr	$ra
	
