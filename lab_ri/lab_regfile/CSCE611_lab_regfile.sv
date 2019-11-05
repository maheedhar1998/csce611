
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module CSCE611_lab_regfile(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,

	//////////// LED //////////
	output		     [8:0]		LEDG,
	output		    [17:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		    [17:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
	output		     [6:0]		HEX6,
	output		     [6:0]		HEX7
);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================
	logic [15:0] top;
	logic [15:0] two;
	logic [7:0] count;
	logic [0:0] rst;
	assign rst = {SW[17:16], KEY} == 6'b11_1101 ? 1'b1 : 1'b0;
	rpncalc rpn(.clk(CLOCK_50), .rst(rst), .mode(SW[17:16]), .key(KEY), .val(SW[15:0]), .top(top), .next(two), .counter(count));
	hexdriver hex0(.val(top[3:0]), .HEX(HEX0));
	hexdriver hex1(.val(top[7:4]), .HEX(HEX1));
	hexdriver hex2(.val(top[11:8]), .HEX(HEX2));
	hexdriver hex3(.val(top[15:12]), .HEX(HEX3));
	hexdriver hex4(.val(two[3:0]), .HEX(HEX4));
	hexdriver hex5(.val(two[7:4]), .HEX(HEX5));
	hexdriver hex6(.val(two[11:8]), .HEX(HEX6));
	hexdriver hex7(.val(two[15:12]), .HEX(HEX7));
	assign LEDG = {1'b0, count};
	
endmodule
