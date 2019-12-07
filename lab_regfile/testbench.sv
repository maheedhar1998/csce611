module CSCE611_regfile_testbench;

	logic clk;
	logic rst;
	logic enable;
	logic [15:0] top, next;
	logic [15:0] top_e, next_e;
	logic [3:0 ] key;
	logic [1:0 ] mode;
	logic [15:0] val;
	logic [7:0 ] counter;

	logic [55:0] vectors [99:0]; // 1e2 56 bit test vectors
	logic [55:0] current; // current test vector
	logic [6:0] i; //vector subscript

	always begin
		clk = 1'b1; #5;
		clk = 1'b0; #5;
	end
	
	assign rst=({mode,key} == 6'b11_1101) ? 1'b1 : 1'b0;

	rpncalc rpn(.clk(clk),
			.rst(rst),
			.mode(mode),
			.key(key),
			.val(val),
			.top(top),
			.next(next),
			.counter(counter));

	initial begin
		// load test vectors from disk
		$readmemh("vectors.dat",vectors);

		for (i = 0; i < 100; i = i + 1) begin

			current = vectors[i];
			
			enable = current[55:55];
			mode = current[53:52];
			key = current[51:48];
			val = current[47:32];
			top_e = current[31:16];
			next_e = current[15:0];
			#50;

			if(enable) begin
				$display("current %h",current);
				if (top != top_e) begin
					$display("i %d", i);
					$display("Error top %h", top);
					$display("top_e %h",top_e);
				end
				if (next != next_e) begin
					$display("i %d", i);
					$display("Error next %h", next);
					$display("next_e %h",next_e);
				end
			end

		end // for (i = 0; i < 1000; i++) begin

		// tell the simulator we're done
		$stop();

	end // initial begin

endmodule
