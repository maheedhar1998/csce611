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

/* note that this is the same as for lab RI, so if your cpu.sv for lab RI uses
 * the same inputs and outputs as above (which it should), you can overwrite
 * this file with the one you used for the RI lab and start from there.
 * 
 * as usual, you may change "output" to "output logic" if you so desire, but
 * the names and widths of the module's signals must be kept the same.

endmodule
