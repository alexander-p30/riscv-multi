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
	addi t0, zero, 0
	addi t0, zero, 0
	addi t0, zero, 0
	addi t0, zero, 0
	addi t0, zero, 0
	addi t0, zero, 0
	addi t0, zero, 0
	
beq_success:
	addi t0, zero, 1
	
beq_fail:
	addi t0, zero, 0
