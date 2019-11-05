module CSCE611_alu_testbench;

	logic [31:0] a, b;
	logic [3 :0] op;
	logic [4 :0] shamt;

	// actual values
	logic[31:0] hi, lo;
	logic[0 :0] zero;

	// expected values
	logic[31:0] hi_e, lo_e;
	logic[0 :0] zero_e;

	logic [147:0] vectors [999:0]; // 1e3 148 bit test vectors
	logic [147:0] current; // current test vector
	logic [31:0] i; //vector subscript
	logic [3:0] enable; // test vector enable
	logic [31:0] error; // error counter

	initial begin
		a     = 0;
		b     = 0;
		op    = 0;
		shamt = 0;
		i     = 0;
		error = 0;
	end

	/* instantiate the ALU we plan to test */
	alu dut (a, b, op, shamt, hi, lo, zero);

	initial begin
		// load test vectors from disk
		// TODO
		$readmemh("vectors.dat", vectors);
		for (i = 0; i < 1000; i = i + 1) begin

			current = vectors[i];

			/* pull out enable, a, b, ... signals to stimulate the
			 * ALU */
			// TODO
			enable = current[147:144];
			a = current[143:112];
			b = current[111:80];
			shamt = current[76:72];
			op = current[71:68];
			hi_e = current[67:36];
			lo_e = current[35:4];
			zero_e = current[0:0];
			// check to see if this test vector is unused
			if (enable == 4'b1111) begin

				/* give the ALU time to respond */
				#5;

				// check the result
				// TODO
				if (hi_e != hi) begin
					$display("hi is wrong: a: %h	b: %h	%h	%h", a, b, hi, hi_e);
				end
				if(lo_e != lo) begin
					$display("lo is wrong: a: %h	b: %h	%h	%h", a, b, lo, lo_e);
				end
				if(zero_e != zero) begin
					$display("zero is wrong: a: %h	b: %h	%h	%h", a, b, zero, zero_e);
				end
			end // if (current[3:0] 4'b1111) begin

		end // for (i = 0; i < 1000; i++) begin

		// tell the simulator we're done
		$stop();

	end // initial begin

endmodule
