// USE SW[1], SW[0] for speed
// USE HEX0 for display
// SW[9] = Clear, SW[8] = Enabke

module RateDivider(SW, CLOCK_50, HEX0);
    input [9:0] SW;
	input CLOCK_50;
	output [9:0] HEX0;
	
	wire [28:0] q;
	wire [3:0] out;
	wire enable;
	wire rate;
	reg [28:0] d;
	
	always @(*)						// Triggered every time clock rises
	begin
		case(SW[1:0])
		2'b00: d = 1'b0;
		2'b01: d = 27'b10111110101111000010000000
		2'b10: d = 28'b101111101011110000100000000
		2'b11: d = 29'b1011111010111100001000000000
		default: d = 1'b1;
		endcase
	end
	
	divider m0(.d(d[28:0]), .clock(CLOCK_50), .reset_n(SW[9]), .enable(SW[8]), .q(q[28:0]));
	
	assign enable = (q[7:0] == 8'b0) ? 1 : 0;
	
	counter c0(.clock(CLOCK_50), .reset_n(SW[9]), .enable(enable), .out(out[3:0]));
	
	display d0(.s0(out[0]),
		.s1(out[1]),
		.s2(out[2]),
		.s3(out[3]),
        .m0(HEX0[0]),
		.m1(HEX0[1]),
		.m2(HEX0[2]),
		.m3(HEX0[3]),
		.m4(HEX0[4]),
		.m5(HEX0[5]),
		.m6(HEX0[6]));
endmodule

module counter(clock, reset_n, enable, out);
	input clock;								// Declare clock
	input reset_n;								// Declare reset_n
	input enable;								// Declare enable
	output reg [3:0] out;						// Declare q
	
	always @(posedge clock)						// Triggered every time clock rises
	begin
		if (reset_n == 1'b0)					// When reset_n is 0
			out <= 0;							// Set q = 0
		else if (enable == 1'b1)				// Increment q only when enable is 1
			out <= out + 1'b1;
	end
endmodule

module divider(d, clock, reset_n, enable, q);
	input [28:0] d;								// Declare d
	input clock;								// Declare clock
	input reset_n;								// Declare reset_n
	input enable;								// Declare par_load and enable
	output reg [28:0] q;							// Declare q
	
	always @(posedge clock)						// Triggered every time clock rises
	begin
		if (reset_n == 1'b0)					// When reset_n is 0
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