.text
  li $4,49 # GPIO Read
  ori $3,$zero,256 # step
  sll $3,$3,14 # step fixed pt
  li $2,0 # x
  sll $4,$4,14
  loop:
    mult $2,$2 # X^2
    mflo $5 # move from lo
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
    srl $8,$8,13
    andi $9,$8,1
    bne $9,$zero,oneMore
    addi $8,$8,2
    srl $8,$8,1
  oneMore:
