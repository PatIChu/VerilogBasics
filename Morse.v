//SW[2:0] data inputs
//SW[9] select signal


module Morse(SW, KEY, LEDR, CLOCK_50);
    input [2:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	output [9:0] LEDR;
	
	wire [24:0] q;
	wire enable;
	reg [13:0] code;
	
	divider m0(.d(25'b1011111010111100000111111), .clock(CLOCK_50), .reset(KEY[0]), .enable(1'b1), .q(q[24:0]));
	//24999999 cycles in base 2
	//20ns for one cycle
	//2Hz
	assign enable = (q[24:0] == 24'b0) ? 1 : 0;
	
	always @(negedge KEY[1], posedge enable, negedge KEY[0])
	begin
		if (KEY[1] == 0)
			case(SW[2:0])
			3'b000: code = 15'b1010100000000;
			3'b001: code = 15'b1110000000000;
			3'b010: code = 15'b1010111000000;
			3'b011: code = 15'b1010101110000;
			3'b100: code = 15'b1011101110000;
			3'b101: code = 15'b01110101011100;
			3'b110: code = 15'b01110101110111;
			3'b111: code = 15'b01110111010100;
			default: code = 15'b00000000000000;
			endcase
		else if (KEY[0] == 1'b0)
			code <= 0;
		else if (enable == 1)
			code <= code << 1'b1;
	end
	
	assign LEDR = code[13];
endmodule

module divider(d, clock, reset, enable, q);
	input [24:0] d;								// Declare d
	input clock;								// Declare clock
	input reset;								// Declare reset_n
	input enable;								// Declare par_load and enable
	output reg [24:0] q;						// Declare q
	
	always @(posedge clock)						// Triggered every time clock rises
	begin
		if (reset == 1'b0)						// When reset_n is 0
			q <= d;								// Set q = 0
		else if (enable == 1'b1)				// Increment q only when enable is 1
			begin
				if (q == 1'b0)					// When q is the minimum value for the counter
					q <= d;						// Reset q into d
				else							// When q is not the maximum value
					q <= q - 1'b1;				// Decrement q
			end
	end
endmodule

module display(s0, s1, s2, s3, m0, m1, m2, m3, m4, m5, m6);
	input s0, s1, s2, s3;
	output m0, m1, m2, m3, m4, m5, m6;
	
	assign m0 = ~s3 & ~s2 & ~s1 & s0 | ~s3 & s2 & ~s1 & ~s0 | s3 & ~s2 & s1 & s0 | s3 & s2 & ~s1 & s0;
	assign m1 = s2 & s1 & ~s0 | s3 & s1 & s0 | s3 & s2 & ~s0 | ~s3 & s2 & ~s1 & s0;
	assign m2 = s3 & s2 & ~s0 | s3 & s2 & s1 | ~s3 & ~s2 & s1 & ~s0;
	assign m3 = ~s2 & ~s1 & s0 | s2 & s1 & s0 | ~s3 & s2 & ~s1 & ~s0 | s3 & ~s2 & s1 & ~s0;
	assign m4 = ~s3 & s0 | ~s2 & ~s1 & s0 | ~s3 & s2 & ~s1;
	assign m5 = ~s3 & ~s2 & s0 | ~s3 & ~s2 & s1 | ~s3 & s1 & s0 | s3 & s2 & ~s1 & s0;
	assign m6 = ~s3 & ~s2 & ~s1 | ~s3 & s2 & s1 & s0 | s3 & s2 & ~s1 & ~s0;
endmodule