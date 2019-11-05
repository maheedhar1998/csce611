/* RPN calculator module implementation */

module rpncalc (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [1:0 ] mode,		/* mode from SW17 and SW16 */
	input [3:0 ] key,		/* value from KEYs */

					/* Remember that the 2 bit mode and
					 * 4 bit key value are used to
					 * uniquely identify one of 16
					 * operations. Also keep in mind that
					 * they keys are onehot (i.e. only one
					 * key is pressed at a time -- if
					 * more than one key is pressed at a
					 * time, the behavior is undefined
					 * (i.e. you may choose your own
					 * behavior). */

	input [15:0] val,		/* 16 bit value from SW15...SW0 */

/**** outputs ****************************************************************/

	output [15:0] top,		/* 16 bit value at the top of the
					 * stack, to be shown on HEX3...HEX0 */

	output [15:0] next,		/* 16 bit value second-to-top in the
					 * stack, to be shown on HEX7...HEX4 */

	output [7:0] counter		/* counter value to show on LEDG */

);

/* your code here */
	logic [0:0] push;
	logic [0:0] pop;
	logic [0:0] pop_duece;
	logic [0:0] full;
	logic [0:0] empty;
	logic [0:0] command;
	logic [3:0] key_pichle;
	logic [31:0] dat;
	logic [31:0] stack_yi;
	logic [31:0] stack_er;
	logic [3:0] operation;
	logic [31:0] high;
	logic [31:0] low;
	logic [0:0] zero;
	assign dat = {mode, key} == 6'b00_0111 ? {16'b0, val} : low;
	assign command = (key_pichle != key);
	stack dStack(.clk(clk), .rst(rst), .pop(pop), .pop_duece(pop_duece), .push(push), .data_in(dat), .stackCounter(counter),
						.stack_top(stack_yi), .stack_two(stack_er), .full(full), .empty(empty));
	assign top = stack_yi[15:0];
	assign next = stack_er[15:0];
	alu ordenador(.a(stack_yi), .b(stack_er), .op(operation), .shamt(stack_yi[4:0]),
						.hi(high), .lo(low), .zero(zero));
	always_ff @(posedge clk) key_pichle <= key;
	always_ff @(posedge command) begin
		case({mode, key})
			6'b00_0111: begin // push
				push = 1'b1;
				pop = 1'b0;
				pop_duece = 1'b0;
			end
			6'b00_1011: begin // pop
				pop = 1'b1;
				pop_duece = 1'b0;
				push = 1'b0;
			end
			6'b00_1101: begin // add
				pop_duece = 1'b1;
				pop = 1'b0;
				push = 1'b0;
				operation = 4'b0100;
			end
			6'b00_1110: begin // sub
				pop_duece = 1'b1;
				pop = 1'b0;
				push = 1'b0;
				operation = 4'b0101;
			end
			default: begin
				push = 1'b0;
				pop = 1'b0;
			end
		endcase
	end
/* don't forget to...
 *
 * - instantiate the register file
 * - hard-code readaddr1 to address of the top of the stack
 * - hard-code readaddr2 to the address of the next-to-top of the stack
 *
 */

endmodule
