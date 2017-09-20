//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module ALU3(LEDR, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY);
    input [9:0] SW;
	input [2:0] KEY;
    output [7:0] LEDR;
	output [9:0] HEX0;
	output [9:0] HEX1;
	output [9:0] HEX2;
	output [9:0] HEX3;
	output [9:0] HEX4;
	output [9:0] HEX5;
	
	wire [7:0] ALUout;
	wire [7:0] AaddOne;
	wire [7:0] AaddB;
	wire [7:0] AverilogB;
	wire [7:0] AXORB;
	wire [7:0] HighorLow;
	wire [7:0] LeftShift;
	wire [7:0] RightShift;
	wire [7:0] Multiplication;
	wire clock;
	
	assign clock = KEY[0];
	
	reg [7:0] q;
	
	//A + 1
	adderCircuit a1(.A(SW[3:0]), .B(4'b0000), .cin(1'b1), .S(AaddOne[3:0]), .cout(AaddOne[4]));
	assign AaddOne[5] = 1'b0;
	assign AaddOne[6] = 1'b0;
	assign AaddOne[7] = 1'b0;
	
	//A + B
	adderCircuit a2(.A(SW[3:0]), .B(q[3:0]), .cin(1'b0), .S(AaddB[3:0]), .cout(AaddB[4]));
	assign AaddB[5] = 1'b0;
	assign AaddB[6] = 1'b0;
	assign AaddB[7] = 1'b0;
	
	//A + B
	verilogCircuit v1(.A(SW[3:0]), .B(q[3:0]), .cin(1'b0), .S(AverilogB[3:0]), .cout(AverilogB[4]));
	assign AverilogB[5] = 1'b0;
	assign AverilogB[6] = 1'b0;
	assign AverilogB[7] = 1'b0;
	
	//AXORB
	xorAB x1(.A(SW[3:0]), .B(q[3:0]), .S(AXORB[7:0]));
	
	//1 or 0
	highLow h1(.A(SW[3:0]), .B(q[3:0]), .S(HighorLow[7:0]));
	
	//Left shift B by A bits
	assign LeftShift [7:0] = q << SW[3:0];
	//Right shift B by A bits
	assign RightShift [7:0] = q >> SW[3:0];
	// A times B
	assign Multiplication = SW[3:0] * q;
	mux7to1 m1(.SW(SW[7:0]),
		.KEY(KEY[2:0]),
		.ALUout(ALUout[7:0]),  
		.AaddOne(AaddOne[7:0]), 
		.AaddB(AaddB[7:0]), 
		.AverilogB(AverilogB[7:0]), 
		.AXORB(AXORB[7:0]), 
		.HighorLow(HighorLow[7:0]),
		.LeftShift(LeftShift[7:0]),
		.RightShift(RightShift[7:0]),
		.Multiplication(Multiplication[7:0]));
	
	display d0(.s0(SW[0]),
		.s1(SW[1]),
		.s2(SW[2]),
		.s3(SW[3]),
        .m0(HEX0[0]),
		.m1(HEX0[1]),
		.m2(HEX0[2]),
		.m3(HEX0[3]),
		.m4(HEX0[4]),
		.m5(HEX0[5]),
		.m6(HEX0[6]));

	assign HEX1[6:0] = 7'b0000000;
	assign HEX2[6:0] = 7'b0000000;
	assign HEX3[6:0] = 7'b0000000;
	
	display d4(.s0(q[0]),
		.s1(q[1]),
		.s2(q[2]),
		.s3(q[3]),
        .m0(HEX4[0]),
		.m1(HEX4[1]),
		.m2(HEX4[2]),
		.m3(HEX4[3]),
		.m4(HEX4[4]),
		.m5(HEX4[5]),
		.m6(HEX4[6]));
	
	display d5(.s0(q[4]),
		.s1(q[5]),
		.s2(q[6]),
		.s3(q[7]),
        .m0(HEX5[0]),
		.m1(HEX5[1]),
		.m2(HEX5[2]),
		.m3(HEX5[3]),
		.m4(HEX5[4]),
		.m5(HEX5[5]),
		.m6(HEX5[6]));
		
	always @(posedge clock)
	begin
		if (SW[9] == 1'b0)
			q <= 8'b0;
		else
			q <= ALUout[7:0];
	end
	
	assign LEDR[7:0] = ALUout[7:0];
endmodule

module mux7to1(SW, KEY, ALUout, AaddOne, AaddB, AverilogB, AXORB, HighorLow, LeftShift, RightShift, Multiplication);
	input [7:0] SW;
	input [2:0] KEY;
	output reg [7:0] ALUout;
	
	input [7:0] AaddOne;
	input [7:0] AaddB;
	input [7:0] AverilogB;
	input [7:0] AXORB;
	input [7:0] HighorLow;
	input [7:0] LeftShift;
	input [7:0] RightShift;
	input [7:0] Multiplication;
	
	always @*
	begin
		case(SW[7:5])
		3'b000: ALUout[7:0] = AaddOne[7:0];
		3'b001: ALUout[7:0] = AaddB[7:0];
		3'b010: ALUout[7:0] = AverilogB[7:0];
		3'b011: ALUout[7:0] = AXORB[7:0];
		3'b100: ALUout[7:0] = HighorLow[7:0];
		3'b101: ALUout[7:0] = LeftShift[7:0];
		3'b110: ALUout[7:0] = RightShift[7:0];
		3'b111: ALUout[7:0] = Multiplication[7:0];
		default: ALUout[7:0] = 8'b00000000;
		endcase
	end
endmodule

// 00000001 or 00000000
module highLow(A, B, S);
	input [3:0] A;
	input [3:0] B;
	
	output [7:0] S;
	
	assign S[0] = (| A[3:0]) | (| B[3:0]);
	assign S[1] = 1'b0;
	assign S[2] = 1'b0;
	assign S[3] = 1'b0;
	assign S[4] = 1'b0;
	assign S[5] = 1'b0;
	assign S[6] = 1'b0;
	assign S[7] = 1'b0;
endmodule

// A XOR'd with B for lower 4 bits, A or B for the upper 4 bits
module xorAB(A, B, S);
	input [3:0] A;
	input [3:0] B;
	
	output [7:0] S;
	
	assign S[0] = A[0] ^ B[0];
	assign S[1] = A[1] ^ B[1];
	assign S[2] = A[2] ^ B[2];
	assign S[3] = A[3] ^ B[3];
	assign S[4] = A[0] | B[0];
	assign S[5] = A[1] | B[1];
	assign S[6] = A[2] | B[2];
	assign S[7] = A[3] | B[3];
endmodule

// Using verilog addition
module verilogCircuit(A, B, cin, S, cout);
	input [3:0] A;
	input [3:0] B;
	input cin;
	
	output [7:0] S;
	output cout;
	
	wire c1;
	wire c2;
	wire c3;
	
	verilogAdder v0(.A(A[0]), .B(B[0]), .cin(cin), .S(S[0]), .cout(c1));
	verilogAdder v1(.A(A[1]), .B(B[1]), .cin(c1), .S(S[1]), .cout(c2));
	verilogAdder v2(.A(A[2]), .B(B[2]), .cin(c2), .S(S[2]), .cout(c3));
	verilogAdder v3(.A(A[3]), .B(B[3]), .cin(c3), .S(S[3]), .cout(cout));
endmodule

module verilogAdder(A, B, cin, S, cout);
	input A, B, cin;
	output S, cout;
	
	assign {cout, S} = A + B + cin;
endmodule

// Using and and or addition
module adderCircuit(A, B, cin, S, cout);
	input [3:0] A;
	input [3:0] B;
	input cin;
	
	output [7:0] S;
	output cout;
	
	wire c1;
	wire c2;
	wire c3;
	
	fullAdder a0(.A(A[0]), .B(B[0]), .cin(cin), .S(S[0]), .cout(c1));
	fullAdder a1(.A(A[1]), .B(B[1]), .cin(c1), .S(S[1]), .cout(c2));
	fullAdder a2(.A(A[2]), .B(B[2]), .cin(c2), .S(S[2]), .cout(c3));
	fullAdder a3(.A(A[3]), .B(B[3]), .cin(c3), .S(S[3]), .cout(cout));
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