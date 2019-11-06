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
	
	// alu signals
	logic [31:0] a;
	logic [31:0] b;
	logic [3:0] op;
	logic [4:0] shamt;
	logic [31:0] hi;
	logic [31:0] lo;
	logic zero;
		
	// program mem, program counter, current inst
	logic [31:0] instruction_yadh [4095:0];
	logic [11:0] instr_count;
	logic [31:0] instr_ex;
	
	// writeback sign
	logic regwrite_WB,regwrite_EX;
	logic [4:0] writeaddr_WB;
	logic [31:0] wr_dat;
	
	// cpu internal
	logic [5:0] op_instr;
	logic [4:0] rs;
	logic [4:0] rt;
	logic [4:0] rd;
	logic [31:0] hi_instr;
	logic [31:0] lo_instr;
	logic [4:0] rdrt;
	logic [31:0] alusrc;
	logic [1:0] regsel;
	logic [5:0] funct;
	logic [15:0] imm;
	
	// alu
	alu ordenador(.a(a),
						.b(alusrc),
						.op(op),
						.shamt(shamt),
						.hi(hi),
						.lo(lo),
						.zero(zero));
	
	// regfile
	regfile dastha(.clk(clk),
						.rst(rst),
						.we(regwrite_WB),
						.readaddr1(rs),
						.readaddr2(rt),
						.writeaddr(writeaddr_WB),
						.writedata(wr_dat),
						.readdata1(a),
						.readdata2(b));
	initial begin
		$readmemh("instmem.dat", instruction_yadh);
	end
	always_ff @(posedge clk, posedge rst) begin
		if(rst) begin
			instr_count <= 12'b0;
			instr_ex <= 32'b0;
		end else begin
			instr_count <= instr_count++;
			instr_ex <= instruction_yadh[instr_count];
		end
	end
	// pipeline registers
	always_ff @(posedge clk,posedge rst) begin
		if (rst) begin
			regwrite_WB <= 1'b0;
		end else begin
			regwrite_WB <= regwrite_EX;
			writeaddr_WB <= rdrt;
			if (regsel == 2'b00) wr_dat <= lo;
			else if (regsel == 2'b01) wr_dat <= lo_instr;
			else if (regsel == 2'b10) wr_dat <= hi_instr;
			else write_data <= gpio_in;
		end
	end
	
	// assigns
	assign op_instr = instr_ex[31:26];
	assign rs = instr_ex[25:21];
	assign rt = instr_ex[20:16];
	assign rd = instr_ex[15:11];
	assign funct = instr_ex[5:0];
	assign imm = instr_ex[15:0];
	
	// control unit
	always_comb begin
		regwrite_EX = 1'b0;		 // don't write a register
		shamt = instr_ex[10:6]; // default shamt
		if(op_instr == 6'b000000) begin
			if (funct == 6'b100000) begin // add
				op = 4'b0100;
				regwrite_EX = 1'b1;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b100001) begin // addu
				op = 4'b0100;
				regwrite_EX = 1'b1;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b100010) begin // sub
				op = 4'b0101;
				regwrite_EX = 1'b1;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b100001) begin // subu
				op = 4'b0101;
				regwrite_EX = 1'b1;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b011000) begin // mult
				op = 4'b0110; 
				alusrc = b;
				hi_instr = hi;
				lo_instr = lo;
			end else if (funct == 6'b011001) begin // multu
				op = 4'b0111; 
				alusrc = b;
				hi_instr = hi;
				lo_instr = lo;
			end else if (funct == 6'b100100) begin // AND
				regwrite_EX = 1'b1;
				op = 4'b0000;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b100101) begin // OR
				regwrite_EX = 1'b1;
				op = 4'b0001;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b100110) begin // XOR
				regwrite_EX = 1'b1;
				op = 4'b0011;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b100111) begin // NOR
				regwrite_EX = 1'b1;
				op = 4'b0010;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b000000 && shamt != 5'b0) begin // sll
				regwrite_EX = 1'b1;
				op = 4'b1000;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b000000 && shamt == 5'b0) begin // nop
				regwrite_EX = 1'b0;
				op = 4'b1000;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b000010 && shamt != 5'b0) begin // srl
				regwrite_EX = 1'b1;
				op = 4'b1001;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b000010 && shamt == 5'b0) begin //gpio write
				gpio_out = 32'b0;
			end else if (funct == 6'b000011 && shamt != 5'b0) begin // sra
				regwrite_EX = 1'b1;
				op = 4'b1010;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b000011 && shamt == 5'b0) begin //gpio read
				regsel = 2'b11;
			end else if (funct == 6'b101010) begin // slt
				regwrite_EX = 1'b1;
				op = 4'b1100;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b101011) begin // sltu
				regwrite_EX = 1'b1;
				op = 4'b1101;
				rdrt = rd;
				alusrc = b;
				regsel = 2'b00;
			end else if (funct == 6'b010000) begin // mfhi
				regwrite_EX = 1'b1;
				rdrt = rd;
				regsel = 2'b10;
			end else if (funct == 6'b010010) begin // mflo
				regwrite_EX = 1'b1;
				rdrt = rd;
				regsel = 2'b01;
			end
		end else if (op_instr == 6'b001111) begin // lui
			regwrite_EX = 1'b1;
			alusrc = {imm, 16'b0};
			rdrt = rt;
			op = 4'b0100;
			regsel = 2'b00;
		end else if (op_instr == 6'b001000) begin // addi
			regwrite_EX = 1'b1;
			alusrc = {{16{imm[15]}},imm};
			rdrt = rt;
			op = 4'b0100;
			regsel = 2'b00;
		end else if (op_instr == 6'b001001) begin // addiu
			regwrite_EX = 1'b1;
			alusrc = {{16{imm[15]}},imm};
			rdrt = rt;
			op = 4'b0100;
			regsel = 2'b00;
		end else if (op_instr == 6'b001100) begin // ANDi
			regwrite_EX = 1'b1;
			alusrc = {16'b0, imm};
			rdrt = rt;
			op = 4'b0000;
			regsel = 2'b00;
		end else if (op_instr == 6'b001101) begin // ORi
			regwrite_EX = 1'b1;
			alusrc = {16'b0, imm};
			rdrt = rt;
			op = 4'b0001;
			regsel = 2'b00;
		end else if (op_instr == 6'b001110) begin // XORi
			regwrite_EX = 1'b1;
			alusrc = {16'b0, imm};
			rdrt = rt;
			op = 4'b0011;
			regsel = 2'b00;
		end else if (op_instr == 6'b001010) begin // slti
			regwrite_EX = 1'b1;
			alusrc = {{16{imm[15]}},imm};
			rdrt = rt;
			op = 4'b1100;
			regsel = 2'b00;
		end
	end
endmodule
