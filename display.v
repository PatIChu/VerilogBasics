//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module mux(HEX0, SW);
    input [9:0] SW;
    output [9:0] HEX0;

    display u0(
        .s0(SW[0]);
		.s1(SW[1]);
		.s2(SW[2]);
		.s3(SW[3]);
        .m0(HEX0[0]);
		.m1(HEX0[1]);
		.m2(HEX0[2]);
		.m3(HEX0[3]);
		.m4(HEX0[4]);
		.m5(HEX0[5]);
		.m6(HEX0[6]);
        );
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
