.text
  li $4,0x64
  sra $4,$4,0 # GPIO Read (n)
  ori $3,$zero,1 # y
  sll $3,$3,14 # y fixed pt
  or $2,$zero,$4 # x
  sll $4,$4,14 # fixed pt input (n)
  sll $2,$2,14 # fixed pt x
  loop:
    sub $5,$2,$3 # x-y
    addu $2,$2,$3 # x=x+y
    srl $2,$2,1 # x=x/2
    or $20,$zero,$2 # cp x for divide
    or $21,$zero,$4 # cp n for divide
    andi $8,$3,0x8fffffff
    li $9,0x8fffffff
    beq $8,$9,end
    jal divide
    or $3,$zero,$21 # y = n/x
    bne $5,$zero,loop
    j end
  divide: # n/x
    subu $21,$21,$2
    subi $20,$20,1
    bne $20,$zero,divide
    jr $31
  end:
    or $6,$zero,$2
