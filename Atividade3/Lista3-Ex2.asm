########################################################################
# aluno:	MATHEUS PIRES VILA REAL
# N°:		202000560352
########################################################################
.data
	ent1:	.asciiz	"Insira a string: "
	str1:	.space	100
	
.text
main:
	la	$a0, ent1
	la	$a1, str1
	jal	leitura
	la	$a0, str1
	jal	ePalindromo
	move	$a0, $v0
	li	$v0, 1
	syscall
	li	$v0, 10
	syscall

leitura:
	li	$v0, 4
	syscall
	move	$a0, $a1
	li	$a1, 100
	li	$v0, 8
	syscall
	jr	$ra
	
strlen:				# a0: string
	move	$t0, $a0
	li	$v0, -2
s1:	lb	$t1, ($t0)
	addiu	$v0, $v0, 1
	addiu	$t0, $t0, 1
	bne	$t1, $zero, s1
	jr	$ra
	
removeEspacos:				#a0: string
	move	$t0, $a0
r1:	lb	$t1, ($t0)
	bge	$t1, 32, remocao		# 32 = espaço em ascii
r2:	addiu	$t0, $t0, 1
r3:	bne	$t1, $zero, r1
	move	$v0, $a0
	jr	$ra
	
remocao:
	bge	$t1, 65, r2			# 65 = A em ascii
	move	$t2, $t0
r4:	lb	$t3, 1($t2)
	sb	$t3, ($t2)
	addiu	$t2, $t2, 1
	bne	$t3, $zero, r4
	b	r3
	
pMaiusculo:				#a0: string
	move	$t0, $a0
p1:	lb	$t1, ($t0)
	bgt	$t1, 96, capitalize
p2:	addiu	$t0, $t0, 1
	bne	$t1, $zero, p1
	move	$v0, $a0
	jr	$ra

capitalize:
	bgt	$t1, 122, p2		# del
	addi	$t1, $t1, -32
	sb	$t1, ($t0)
	b	p2
	
ePalindromo:			#a0: string, a1: tamanho
	move	$t9, $ra
	jal	removeEspacos
	move	$a0, $v0
	jal	pMaiusculo
	move	$a0, $v0
	jal	strlen
	li	$s0, 0		# l
	addi	$s1, $v0, -1	# h
	move	$t0, $a0		# str[l]
	add	$t1, $t0, $s1	# str[h]
	li	$v0, 1		# retorno
l1:	lb	$t2, ($t0)
	lb	$t3, ($t1)
	bne	$t2, $t3, nPal
	addi	$s1, $s1, -1
	addi	$t1, $t1, -1
	addiu	$s0, $s0, 1
	addiu	$t0, $t0, 1
	bgt	$s1, $s0, l1	# while(h > l)
	jr	$t9
nPal: li	$v0, 0
	jr	$t9