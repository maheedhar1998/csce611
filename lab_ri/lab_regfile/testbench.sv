module CSCE611_regfile_testbench;
	logic [0:0] clk;
	logic [0:0] rst;
	logic [17:0] SW;
	logic [15:0] top;
	logic [15:0] two;
	logic [7:0] count;
	logic [3:0] KEY;
	logic [23:0] vectors [99:0]; // 1e2 24 bit test vectors
	logic [23:0] current; // current test vector
	logic [6:0] i; //vector subscript

	always begin
		clk = 1'b1;
		#5;
		clk = 1'b0;
		#5;
	end
	assign rst = {SW[17:16], KEY} == 6'b11_1101 ? 1'b1 : 1'b0;
	rpncalc abacus(.clk(clk), .rst(rst), .mode(SW[17:16]), .key(KEY), .val(SW[15:0]), .top(top), .next(two), .counter(count));
	initial begin
		$readmemh("vectors.dat", vectors);
		for (i = 0; i < 100; i = i + 1) begin
			current = vectors[i];
			SW[17:16] = current[21:20];
			SW[15:0] = current[19:4];
			KEY = current[3:0];
			$display("%h, %h", top, two);
			#9;
		end // initial begin
		// tell the simulator we're done
		$stop();
	end
endmodule
