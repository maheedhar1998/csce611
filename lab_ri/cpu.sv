/* MIPS CPU module implementation */

module cpu (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [31:0] gpio_in,		/* GPIO input */

/**** outputs ****************************************************************/

	output [31:0] gpio_out	/* GPIO output */

);

/* your code here */
	logic [31:0] a;
	logic [31:0] b;
	logic [3:0] op;
	logic [4:0] shamt;
	logic [31:0] hi;
	logic [31:0] lo;
	logic zero;

	logic clk;
	logic rst;
	logic we;
	logic [4:0] read1;
	logic [4:0] read2;
	logic [4:0] write;
	logic [31:0] wrdat;
	logic [31:0] rdat1;
	logic [31:0] rdat2;
		
	alu ordenador(.a(a),
						.b(b),
						.op(op),
						.shamt(shamt),
						.hi(hi),
						.lo(lo),
						.zero(zero));
	
	regfile dastha(.clk(clk),
						.rst(rst),
						.we(we),
						.readaddr1(read1),
						.readaddr2(read2),
						.writeaddr(write),
						.writedata(wrdat),
						.readdata1(rdat1),
						.readdata2(rdat2));
	
endmodule
