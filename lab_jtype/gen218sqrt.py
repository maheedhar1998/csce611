import math
import sys
for i in range(0, (2**18-1)):
  print("// reset","\n1_00000000_00000000",sep="")
  print("// gpio_in val",bin(i),"gpio_out val",math.sqrt(i))
  res = "{:09.5f}".format(math.sqrt(i))[:3]+"{:09.5f}".format(math.sqrt(i))[4:]
  print("0_",hex(i)[2:].rjust(8,'0'),"_",res,sep="")

