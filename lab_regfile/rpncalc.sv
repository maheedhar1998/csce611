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
	logic [0:0] pushf;
	logic [0:0] popf;
	logic [0:0] pop_duecef;
	logic [0:0] full;
	logic [0:0] empty;
	logic [0:0] command;
	logic [3:0] key_pichle;
	logic [3:0] key_pichle2;
	logic [31:0] dat;
	logic [31:0] stack_yi;
	logic [31:0] stack_er;
	logic [3:0] operation;
	logic [31:0] high;
	logic [31:0] low;
	logic [0:0] zero;
	typedef enum logic [4:0] {idle, pop, pop_duece, push, push_duece} state;
	state current, nxt;
	assign command = &key_pichle2 & ~&key_pichle;
	stack dStack(.clk(clk), .rst(rst), .pop(popf), .pop_duece(pop_duecef), .push(pushf), .data_in(dat), .stackCounter(counter),
						.stack_top(stack_yi), .stack_two(stack_er), .full(full), .empty(empty));
	assign top = stack_yi[15:0];
	assign next = stack_er[15:0];
	alu ordenador(.a(stack_yi), .b(stack_er), .op(operation), .shamt(stack_yi[4:0]),
						.hi(high), .lo(low), .zero(zero));
	always_ff @(posedge clk) begin 
		key_pichle <= key;
		key_pichle2 <= key_pichle;
	end
	always_ff @(posedge clk, posedge rst) begin
		if (rst) current <= idle;
		else current <= nxt;
	end
	always_comb begin
		nxt = current;
		// push
		if(command && ~key_pichle[3] && (mode == 2'b00) && (current == idle)) nxt = push;
		// pop
		if(command && ~key_pichle[2] && (mode == 2'b00) && (current == idle)) nxt = push;
		// pop 2 sum
		if(command && ~key_pichle[1] && (mode == 2'b00) && (current == idle)) nxt = pop;
		// pop 2 diff
		if(command && ~key_pichle[0] && (mode == 2'b00) && (current == idle)) nxt = pop;
		// pop 2 multu
		if(command && ~key_pichle[3] && (mode == 2'b01) && (current == idle)) nxt = pop;
		// pop 2 sll
		if(command && ~key_pichle[2] && (mode == 2'b01) && (current == idle)) nxt = pop;
		// pop 2 srl
		if(command && ~key_pichle[1] && (mode == 2'b01) && (current == idle)) nxt = pop;
		// pop 2 slt
		if(command && ~key_pichle[0] && (mode == 2'b01) && (current == idle)) nxt = pop;
		// pop 2 AND
		if(command && ~key_pichle[3] && (mode == 2'b10) && (current == idle)) nxt = pop;
		// pop 2 OR
		if(command && ~key_pichle[2] && (mode == 2'b10) && (current == idle)) nxt = pop;
		// pop 2 NOR
		if(command && ~key_pichle[1] && (mode == 2'b10) && (current == idle)) nxt = pop;
		// pop 2 XOR
		if(command && ~key_pichle[0] && (mode == 2'b10) && (current == idle)) nxt = pop;
		// pop 2 and reverse push 2
		if(command && ~key_pichle[3] && (mode == 2'b11) && (current == idle)) nxt = pop_duece;
		
		// move to next state
		if(current == pop) nxt = pop_duece;
		if(current == pop_duece) nxt = push;
		if(current == push) nxt = idle;
	end
	
	always_ff @(posedge clk) begin
		if(current == idle) begin
			popf = 1'b0;
			pushf = 1'b0;
			pop_duecef = 1'b0;
		end
		case({mode, key})
			6'b00_0111: begin // push
				if (current == push) begin
					pushf = 1'b1;
					dat = {16'b0,val};
				end
			end
			6'b00_1011: begin // pop
				if (current == push) popf = 1'b1;
			end
			6'b00_1101: begin // pop 2 add
				if (current == pop) begin
					operation = 4'b0100;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b00_1110: begin // pop 2 sub
				if (current == pop) begin
					operation = 4'b0101;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b01_0111: begin // pop 2 multu
				if (current == pop) begin
					operation = 4'b0111;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b01_1011: begin // pop 2 sll
				if (current == pop) begin
					operation = 4'b1000;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b01_1101: begin // pop 2 srl
				if (current == pop) begin
					operation = 4'b1001;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b01_1110: begin // pop 2 slt
				if (current == pop) begin
					operation = 4'b1100;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b10_0111: begin // pop 2 AND
				if (current == pop) begin
					operation = 4'b0000;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b10_1101: begin // pop 2 OR
				if (current == pop) begin
					operation = 4'b0001;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b10_1110: begin // pop 2 NOR
				if (current == pop) begin
					operation = 4'b0010;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b10_1111: begin // pop 2 XOR
				if (current == pop) begin
					operation = 4'b0011;
					popf = 1'b1;
				end
				if (current == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = low;
				end
			end
			6'b11_0111: begin // pop 2 reverse
				if (nxt == pop) popf = 1'b1;
				if (nxt == push) begin
					popf = 1'b0;
					pushf = 1'b1;
					dat = stack_yi;
				end
				if (nxt == idle) pushf = 1'b0;
			end
			default: begin
				pushf = 1'b0;
				popf = 1'b0;
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
