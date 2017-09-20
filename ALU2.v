//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module ALU(LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY);
    input [7:0] SW;
	input [2:0] KEY;
    output [7:0] LEDR;
	output [9:0] HEX0;
	output [9:0] HEX1;
	output [9:0] HEX2;
	output [9:0] HEX3;
	output [9:0] HEX4;
	output [9:0] HEX5;
	wire [7:0] ALUout;
	
	wire c1;
	wire c2;
	wire c3;
	wire c4;
	wire c5;
	wire c6;
	wire c7;
	wire c8;
	wire c9;
	
	wire [7:0] AaddOne;
	wire [7:0] AaddB;
	wire [7:0] AverilogB;
	wire [7:0] AXORB;
	wire [7:0] HighorLow;

	fullAdder u0(.A(SW[4]), .B(1'b0), .cin(1'b1), .S(AaddOne[0]), .cout(c1));
	fullAdder u1(.A(SW[5]), .B(1'b0), .cin(c1), .S(AaddOne[1]), .cout(c2));
	fullAdder u2(.A(SW[6]), .B(1'b0), .cin(c2), .S(AaddOne[2]), .cout(c3));
	fullAdder u3(.A(SW[7]), .B(1'b0), .cin(c3), .S(AaddOne[3]), .cout(AaddOne[4]));
	assign AaddOne[5] = 1'b0;
	assign AaddOne[6] = 1'b0;
	assign AaddOne[7] = 1'b0;
	
	fullAdder u4(.A(SW[4]), .B(SW[0]), .cin(1'b0), .S(AaddB[0]), .cout(c4));
	fullAdder u5(.A(SW[5]), .B(SW[1]), .cin(c4), .S(AaddB[1]), .cout(c5));
	fullAdder u6(.A(SW[6]), .B(SW[2]), .cin(c5), .S(AaddB[2]), .cout(c6));
	fullAdder u7(.A(SW[7]), .B(SW[3]), .cin(c6), .S(AaddB[3]), .cout(AaddB[4]));
	assign AaddB[5] = 1'b0;
	assign AaddB[6] = 1'b0;
	assign AaddB[7] = 1'b0;
	
	verilogAdder u8(.A(SW[4]), .B(SW[0]), .cin(1'b0), .S(AverilogB[0]), .cout(c7));
	verilogAdder u9(.A(SW[5]), .B(SW[1]), .cin(c7), .S(AverilogB[1]), .cout(c8));
	verilogAdder u10(.A(SW[6]), .B(SW[2]), .cin(c8), .S(AverilogB[2]), .cout(c9));
	verilogAdder u11(.A(SW[7]), .B(SW[3]), .cin(c9), .S(AverilogB[3]), .cout(AverilogB[4]));
	assign AverilogB[5] = 1'b0;
	assign AverilogB[6] = 1'b0;
	assign AverilogB[7] = 1'b0;
	
	assign AXORB[0] = SW[0] ^ SW[4];
	assign AXORB[1] = SW[1] ^ SW[5];
	assign AXORB[2] = SW[2] ^ SW[6];
	assign AXORB[3] = SW[3] ^ SW[7];
	assign AXORB[4] = SW[0] | SW[4];
	assign AXORB[5] = SW[1] | SW[5];
	assign AXORB[6] = SW[2] | SW[6];
	assign AXORB[7] = SW[3] | SW[7];
	
	assign HighorLow[0] = (| SW[3:0]) | (| SW[7:4]);
	assign HighorLow[1] = 1'b0;
	assign HighorLow[2] = 1'b0;
	assign HighorLow[3] = 1'b0;
	assign HighorLow[4] = 1'b0;
	assign HighorLow[5] = 1'b0;
	assign HighorLow[6] = 1'b0;
	assign HighorLow[7] = 1'b0;
	
	mux7to1 m1(.SW(SW[7:0]),
		.KEY(KEY[2:0]),
		.ALUout(ALUout[7:0]),  
		.AaddOne(AaddOne[7:0]), 
		.AaddB(AaddB[7:0]), 
		.AverilogB(AverilogB[7:0]), 
		.AXORB(AXORB[7:0]), 
		.HighorLow(HighorLow[7:0]));
	
	display d0(.s0(SW[4]),
		.s1(SW[5]),
		.s2(SW[6]),
		.s3(SW[7]),
        .m0(HEX0[0]),
		.m1(HEX0[1]),
		.m2(HEX0[2]),
		.m3(HEX0[3]),
		.m4(HEX0[4]),
		.m5(HEX0[5]),
		.m6(HEX0[6]));
	
	display d1(.s0(1'b0),
		.s1(1'b0),
		.s2(1'b0),
		.s3(1'b0),
        .m0(HEX1[0]),
		.m1(HEX1[1]),
		.m2(HEX1[2]),
		.m3(HEX1[3]),
		.m4(HEX1[4]),
		.m5(HEX1[5]),
		.m6(HEX1[6]));
	
	display d2(.s0(SW[0]),
		.s1(SW[1]),
		.s2(SW[2]),
		.s3(SW[3]),
        .m0(HEX2[0]),
		.m1(HEX2[1]),
		.m2(HEX2[2]),
		.m3(HEX2[3]),
		.m4(HEX2[4]),
		.m5(HEX2[5]),
		.m6(HEX2[6]));
	
	display d3(.s0(1'b0),
		.s1(1'b0),
		.s2(1'b0),
		.s3(1'b0),
        .m0(HEX3[0]),
		.m1(HEX3[1]),
		.m2(HEX3[2]),
		.m3(HEX3[3]),
		.m4(HEX3[4]),
		.m5(HEX3[5]),
		.m6(HEX3[6]));
	
	display d4(.s0(ALUout[0]),
		.s1(ALUout[1]),
		.s2(ALUout[2]),
		.s3(ALUout[3]),
        .m0(HEX4[0]),
		.m1(HEX4[1]),
		.m2(HEX4[2]),
		.m3(HEX4[3]),
		.m4(HEX4[4]),
		.m5(HEX4[5]),
		.m6(HEX4[6]));
		
	display d5(.s0(ALUout[4]),
		.s1(ALUout[5]),
		.s2(ALUout[6]),
		.s3(ALUout[7]),
        .m0(HEX5[0]),
		.m1(HEX5[1]),
		.m2(HEX5[2]),
		.m3(HEX5[3]),
		.m4(HEX5[4]),
		.m5(HEX5[5]),
		.m6(HEX5[6]));
	
	assign LEDR[7:0] = ALUout[7:0];
endmodule

module mux7to1(SW, KEY, ALUout, AaddOne, AaddB, AverilogB, AXORB, HighorLow);
	input [7:0] SW;
	input [2:0] KEY;
	output reg [7:0] ALUout;
	
	input [7:0] AaddOne;
	input [7:0] AaddB;
	input [7:0] AverilogB;
	input [7:0] AXORB;
	input [7:0] HighorLow;
	
	always @*
	begin
		case(KEY[2:0])
		3'b000: ALUout[7:0] = AaddOne[7:0];
		3'b001: ALUout[7:0] = AaddB[7:0];
		3'b010: ALUout[7:0] = AverilogB[7:0];
		3'b011: ALUout[7:0] = AXORB[7:0];
		3'b100: ALUout[7:0] = HighorLow[7:0];
		3'b101: ALUout[7:0] = SW[7:0];
		default: ALUout[7:0] = 8'b00000000;
		endcase
	end
endmodule

module verilogAdder(A, B, cin, S, cout);
	input A, B, cin;
	output S, cout;
	
	assign {cout, S} = A + B + cin;
endmodule

module adderCircuit(A, B, cin, s, cout);
	input [3:0] AC;
	input [3:0] BC;
	input cin;
	
	output [7:0] s;
	output cout;
	
	wire c1;
	wire c2;
	wire c3;
	
	fullAdder u0(.A(AC[0]), .B(BC[0]), .cin(cin), .S(s[0]), .cout(c1));
	fullAdder u1(.A(AC[1]), .B(BC[1]), .cin(c1), .S(s[1]), .cout(c2));
	fullAdder u2(.A(AC[2]), .B(BC[2]), .cin(c2), .S(s[2]), .cout(c3));
	fullAdder u3(.A(AC[3]), .B(BC[3]), .cin(c3), .S(s[3]), .cout(cout));
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