//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module SHIFT(LEDR, SW, KEY);
    input [9:0] SW;
	input [3:0] KEY;
    output [9:0] LEDR;
	
	wire [7:0] out;
	wire in;
	assign in = KEY[3] & out[7];
	
	logicShift s1(in, KEY[2], SW[7], KEY[1], KEY[0], SW[9], out[7]);
	logicShift s2(out[7], KEY[2], SW[6], KEY[1], KEY[0], SW[9], out[6]);
	logicShift s3(out[6], KEY[2], SW[5], KEY[1], KEY[0], SW[9], out[5]);
	logicShift s4(out[5], KEY[2], SW[4], KEY[1], KEY[0], SW[9], out[4]);
	logicShift s5(out[4], KEY[2], SW[3], KEY[1], KEY[0], SW[9], out[3]);
	logicShift s6(out[3], KEY[2], SW[2], KEY[1], KEY[0], SW[9], out[2]);
	logicShift s7(out[2], KEY[2], SW[1], KEY[1], KEY[0], SW[9], out[1]);
	logicShift s8(out[1], KEY[2], SW[0], KEY[1], KEY[0], SW[9], out[0]);
	
	assign LEDR[7:0] = out[7:0];
endmodule

module logicShift(in, shift, load_val, load_n, clk, reset_n, out);
	input in;
	input shift;
	input load_val;
	input load_n;
	input clk;
	input reset_n;
	output out;
	
	wire data_from_other_mux;
	wire data_to_dff;
	
	mux2to1 m0(
		.x(out), // out
		.y(in), // in
		.s(shift), //shift
		.m(data_from_other_mux)); // data_from_other_mux
   
	mux2to1 m1(
        .x(load_val), //load_val
        .y(data_from_other_mux), //data_from_other_mux
        .s(load_n), //load_n
        .m(data_to_dff)); //data_to_dff
	
	flipflop f0(
		.data(data_to_dff), //data_to_dff
		.q(out), //out
		.clock(clk), //clk
		.reset_n(reset_n)); //reset_n
endmodule

module mux2to1(x, y, s, m);
    input x;
    input y; 
    input s;
    output m; 
	
    assign m = s & y | ~s & x;
endmodule

module flipflop(data, q, clock, reset_n);
	input clock;
	input data;
	input reset_n;
	output q;
	reg q;
	
	always @(posedge clock)
	begin
	if (reset_n == 1'b0)
		q <= 0;
	else
		q <= data;
	end
endmodule
