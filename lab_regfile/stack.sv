module stack (input [0:0]clk, input [0:0]rst, input [0:0]pop, input [0:0] pop_duece, input [0:0]push, input [31:0] data_in, output [7:0] stackCounter,
					output [31:0] stack_top, output [31:0] stack_two,output full,empty);
	logic [4:0] stack_top_ptr,stack_ptr;
	assign stack_top_ptr = stack_ptr-5'b1;
	assign full = stack_top_ptr==5'd31 ? 1'd1 : 1'd0;
	assign empty = stack_ptr==5'd1 ? 1'd1 : 1'd0;
	assign stackCounter = {3'b0, stack_ptr};
	regfile stackregs(.clk(clk), .we(push || pop_duece),
									.readaddr1(stack_top_ptr[4:0]),
									.readaddr2(stack_top_ptr[4:0]-5'b1), .writeaddr(stack_ptr[4:0]),
									.writedata(data_in), .readdata1(stack_top), .readdata2(stack_two));
	always_ff @(posedge clk) begin
		if(rst) stack_ptr = 5'b1;
		else if(pop_duece) begin
			stack_ptr--;
			stack_ptr--;
		end
		else if(pop) stack_ptr--;
		else if(push) stack_ptr++;
	end
endmodule 