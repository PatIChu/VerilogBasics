//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module ALU(LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY);
    input [9:0] SW;
	input [2:0] KEY;
    output [9:0] LEDR;
	output [9:0] HEX0;
	output [9:0] HEX1;
	output [9:0] HEX2;
	output [9:0] HEX3;
	output [9:0] HEX4;
	output [9:0] HEX5;
	output [7:0] ALUout;
	SW[7:4]
	SW[3:0]
	display u0(.s0(SW[4]);
		.s1(SW[5]);
		.s2(SW[6]);
		.s3(SW[7]);
        .m0(HEX0[0]);
		.m1(HEX0[1]);
		.m2(HEX0[2]);
		.m3(HEX0[3]);
		.m4(HEX0[4]);
		.m5(HEX0[5]);
		.m6(HEX0[6]);)
	
	display u1(.s0(1'b0);
		.s1(1'b0);
		.s2(1'b0);
		.s3(1'b0);
        .m0(HEX1[0]);
		.m1(HEX1[1]);
		.m2(HEX1[2]);
		.m3(HEX1[3]);
		.m4(HEX1[4]);
		.m5(HEX1[5]);
		.m6(HEX1[6]);)
	
	display u2(.s0(SW[0]);
		.s1(SW[1]);
		.s2(SW[2]);
		.s3(SW[3]);
        .m0(HEX2[0]);
		.m1(HEX2[1]);
		.m2(HEX2[2]);
		.m3(HEX2[3]);
		.m4(HEX2[4]);
		.m5(HEX2[5]);
		.m6(HEX2[6]);)
	
	display u3(.s0(1'b0);
		.s1(1'b0);
		.s2(1'b0);
		.s3(1'b0);
        .m0(HEX3[0]);
		.m1(HEX3[1]);
		.m2(HEX3[2]);
		.m3(HEX3[3]);
		.m4(HEX3[4]);
		.m5(HEX3[5]);
		.m6(HEX3[6]);)
	
	display u4(.s0(ALUout[3]);
		.s1(ALUout[2]);
		.s2(ALUout[1]);
		.s3(ALUout[0]);
        .m0(HEX4[0]);
		.m1(HEX4[1]);
		.m2(HEX4[2]);
		.m3(HEX4[3]);
		.m4(HEX4[4]);
		.m5(HEX4[5]);
		.m6(HEX4[6]);)
		
	display u5(.s0(ALUout[7]);
		.s1(ALUout[6]);
		.s2(ALUout[5]);
		.s3(ALUout[4]);
        .m0(HEX5[0]);
		.m1(HEX5[1]);
		.m2(HEX5[2]);
		.m3(HEX5[3]);
		.m4(HEX5[4]);
		.m5(HEX5[5]);
		.m6(HEX5[6]);)
		
endmodule

module adderCircuit(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;
	wire c1;
	wire c2;
	wire c3;
	wire c4;
	
	fullAdder u0(.A(SW[4]), .B(SW[0]), .cin(SW[8]), .S(LEDR[0]), .cout(c1));
	fullAdder u1(.A(SW[5]), .B(SW[1]), .cin(c1), .S(LEDR[1]), .cout(c2));
	fullAdder u2(.A(SW[6]), .B(SW[2]), .cin(c2), .S(LEDR[2]), .cout(c3));
	fullAdder u3(.A(SW[7]), .B(SW[3]), .cin(c3), .S(LEDR[3]), .cout(c4));
	assign LEDR[4] = c4;
endmodule

module fullAdder(A, B, cin, S, cout);
	input A, B, cin;
	output S, cout;
	
	assign S = A ^ B ^ cin;
	assign cout = (A & B) | (A & cin) | (B & cin);
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