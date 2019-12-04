.text
  li $9,16384
  li $4,49 # GPIO Read
  or $3,$zero,$4 # step
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
    sra $3,$3,1 # step=step/2
    j stepCheck
  stepUp:
    add $2,$2,$3 # x=x+step
    sra $3,$3,1 # step=step/2
    j stepCheck
  stepCheck:
    slt $10,$3,$9
    bne $10,$zero,loop
    or $8,$zero,$2
    j end
  end:
