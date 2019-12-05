module CSCE611_jtype_testbench;
	logic [0:0] clk;
	logic [0:0] rst;
	logic [31:0] gpio_in;
	logic [31:0] gpio_out;
	logic [31:0] gpio_exp;
	logic [67:0] vectors [524299:0];
	logic [67:0] curr;
	logic [19:0] i;
	
	always begin
		clk = 1'b0;
		#5;
		clk = 1'b1;
		#5;
	end
	
	cpu ry3990x (.clk(clk), .rst(rst), .gpio_in(gpio_in), .gpio_out(gpio_out));
	
	initial begin
		$readmemh("vectors.dat", vectors);
		for(i=0; i<524300; i++) begin
			curr = vectors[i];
			rst = curr[64];
			gpio_in = curr[63:32];
			gpio_exp = curr[31:0];
			if(~rst) begin
			   #700;
			end else if (rst) begin
				#10;
			end
		end
		$stop();
	end
endmodule 