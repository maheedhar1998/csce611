/* 32 x 32 register file implementation */

module regfile (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [0:0 ] we,		/* write enable */
	input [4:0 ] readaddr1,		/* read address 1 */
	input [4:0 ] readaddr2,		/* read address 2 */
	input [4:0 ] writeaddr,		/* write address */
	input [31:0] writedata,		/* write data */

/**** outputs ****************************************************************/

	output [31:0] readdata1,	/* read data 1 */
	output [31:0] readdata2		/* read data 2 */
);


	/* your code here */
	logic [31:0][31:0] mem;
	assign readdata1 = (readaddr1 == 0) ? 0 : (writeaddr == readaddr1 && we) ? writedata : mem[readaddr1];
	assign readdata2 = (readaddr2 == 0) ? 0 : (writeaddr == readaddr2 && we) ? writedata : mem[readaddr2];
	always_ff @(posedge clk) begin
		if (we) mem[writeaddr] <= writedata;
	end
endmodule
