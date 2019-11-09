def rst():
    print("// reset\n1_00000000_00000000")
for i in range(0,2**18):
    rst()
    print("// gpio_in val", bin(i), "gpio_out val", i)
    hx = hex(i)[2:]
    hx = hx.rjust(8, '0')
    iN = str(i).rjust(8, '0')
    print("0_",hx,"_",iN, sep="")

