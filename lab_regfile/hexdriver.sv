module hexdriver (input [3:0] val, output reg [6:0] HEX);

	/* your code here */
	always_comb
	case(val)
		0: HEX = 7'h40; //0
		1: HEX = 7'h79; //1
		2: HEX = 7'h24;
		3: HEX = 7'h30;
		4: HEX = 7'h19;
		5: HEX = 7'h12;
		6: HEX = 7'h02;
		7: HEX = 7'h78;
		8: HEX = 7'h00;
		9: HEX = 7'h10;
		10: HEX = 7'h08;
		11: HEX = 7'h03;
		12: HEX = 7'h46;
		13: HEX = 7'h21;
		14: HEX = 7'h06;
		15: HEX = 7'h0E;
		default: HEX = 7'h7F;
	endcase
endmodule
