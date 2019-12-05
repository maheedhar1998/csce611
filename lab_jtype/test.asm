.text
  li $4,1 #0
  li $5,2 #1
  beq $4,$5,target1 #2
  b:
    bne $4,$5,target2 #3
  c:
    bgez $4,target3 #4
  d:
    jal target4 #5
  j exit #6
  target1:
    j b #7 
  target2:
    j c #8
  target3:
    j d #9
  target4:
    jr $31 #10
  exit:
  
