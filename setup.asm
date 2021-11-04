.text
	addi t0, zero, 400
	addi t1, zero, 255
	sub t2, t0, t1
	andi t2, t0, 1094
	ori t2, t0, 1094
	xori t2, t0, 1094
	sw t0, 0(zero)
	lw t1, 0(zero)
	beq t0, zero, beq_fail
	beq t0, t1, beq_success
	addi t0, zero, 2
	
beq_success:
	addi t0, zero, 1
	jal s1, test_jal
	
beq_fail:
	addi t0, zero, 0
	
test_jal:
	addi t0, zero, 123
	addi t1, zero, 123
	bne t0, t1, bne_fail
	bne t0, zero, bne_success
	
bne_fail:
	addi t0, zero, 0

bne_success:
	addi t0, zero, 1
	lui t0, 555
	auipc t1, 4
	
