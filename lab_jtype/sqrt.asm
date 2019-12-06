.text
  sra $4,$4,0 # GPIO Read
  ori $3,$zero,256 # step
  sll $3,$3,14 # step fixed pt
  li $2,0 # x
  sll $4,$4,14
  li $11,100000
  #sll $11,$11,14
  loop:
    mult $2,$2 # X^2
    mflo $5 # move from lo
    srl $5,$5,14 # gets rid of extra precision in lo
    mfhi $10 # move from hi
    sll $10,$10,18 # gets rid of overflow in hi
    or $5,$10,$5
    sub $6,$5,$4 # x^2-s (val)
    slt $7,$6,$zero # val<0
    bne $7,$zero,stepUp # if(val<0)
    sub $2,$2,$3 # x=x-step
    srl $3,$3,1 # step=step/2
    j stepCheck
  stepUp:
    add $2,$2,$3 # x=x+step
    srl $3,$3,1 # step=step/2
    j stepCheck
  stepCheck:
    bne $3,$zero,loop
    or $8,$zero,$2
    mult $8,$11
    mflo $8
    mfhi $12
    sll $12,$12,18
    srl $8,$8,14
    or $8,$8,$12
    #srl $8,$8,14
    #andi $9,$8,1
    #bne $9,$zero,oneMore
    #addi $8,$8,2
    #srl $8,$8,1
  oneMore:
	li	$2,429496730	# regs(2) <= 0.1
	li	$3,10		# regs(3) <= 10
	or $4,$zero,$8	# user input (replace with sra)
	
	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5

	multu	$4,$2
	mfhi	$4		# regs(4) <= whole part of product
	mflo	$5		# regs(5) <= fractional part of product
	multu	$5,$3
	mfhi	$5		# regs(5) <= modulo value
	sll	$5,$5,28
	srl	$6,$6,4
	or	$6,$6,$5
				# insert srl here to output register 6 to hex displays
	srl $6,$6,0