//SW[2:0] data inputs
//SW[9] select signal


module Counter(SW, KEY, HEX0, HEX1);
    input [9:0] SW;
	input [3:0] KEY;
	output [9:0] HEX0;
	output [9:0] HEX1;
	
	wire [7:0] Q;
	
	counterin c0(
		.clock(KEY[0]),
		.enable(SW[1]),
		.clear(SW[0]),
		.Q(Q[7:0]));
	
	display d0(.s0(Q[0]),
		.s1(Q[1]),
		.s2(Q[2]),
		.s3(Q[3]),
        .m0(HEX0[0]),
		.m1(HEX0[1]),
		.m2(HEX0[2]),
		.m3(HEX0[3]),
		.m4(HEX0[4]),
		.m5(HEX0[5]),
		.m6(HEX0[6]));
	
	display d1(.s0(Q[4]),
		.s1(Q[5]),
		.s2(Q[6]),
		.s3(Q[7]),
        .m0(HEX1[0]),
		.m1(HEX1[1]),
		.m2(HEX1[2]),
		.m3(HEX1[3]),
		.m4(HEX1[4]),
		.m5(HEX1[5]),
		.m6(HEX1[6]));
endmodule

module counterin(clock, enable, clear, Q);
	input clock;
	input enable;
	input clear;
	
	output [7:0] Q;
	
	flipflop f0(.enable(enable), .q(Q[0]), .clock(clock), .clear(clear));
	flipflop f1(.enable(enable & Q[0]), .q(Q[1]), .clock(clock), .clear(clear));
	flipflop f2(.enable(Q[0] & Q[1]), .q(Q[2]), .clock(clock), .clear(clear));
	flipflop f3(.enable(Q[1] & Q[2]), .q(Q[3]), .clock(clock), .clear(clear));
	flipflop f4(.enable(Q[2] & Q[3]), .q(Q[4]), .clock(clock), .clear(clear));
	flipflop f5(.enable(Q[3] & Q[4]), .q(Q[5]), .clock(clock), .clear(clear));
	flipflop f6(.enable(Q[4] & Q[5]), .q(Q[6]), .clock(clock), .clear(clear));
	flipflop f7(.enable(Q[5] & Q[6]), .q(Q[7]), .clock(clock), .clear(clear));
endmodule

module flipflop(enable, q, clock, clear);
	input clock;
	input enable;
	input clear;
	output q;
	reg q;
	
	always @(posedge clock, negedge clear)
	begin
	if (clear == 1'b0)
		q <= 0;
	else if (enable == 1'b1)
		q <= q + 1'b1;
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