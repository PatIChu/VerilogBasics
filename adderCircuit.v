//SW[7:4] for A number
//SW[3:0] for B number
//SW[8] as c in

//LEDR[4:0] output display

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