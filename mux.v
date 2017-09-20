//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module mux(LEDR, SW, KEY);
    input [9:0] SW;
	input [2:0] KEY;
    output [9:0] LEDR;
	
	//Clock
	reg [7:0] q;
	
	always @(posedge clock)
	begin
		if (SW[9] == 1'b0)
			q <= 8'b0;
		else
			q <= ALUout[7:0];
	end
	mux2to1 m0(
		.x(), // out
		.y(), // in 
		.s(), //shift
		.m()); // value_to_other_mux
   
    mux2to1 m1(
        .x(), //load_val
        .y(), //data_from_other_mux
        .s(), //load_n
        .m()); //data_to_dff
	
	flipflop f0(
		.data(), //data_to_dff
		.q(), //out
		.clock(), //clk
		.reset_n()); //reset_n
endmodule

module mux2to1(x, y, s, m);
    input x; //load_val
    input y; //data_from_other_mux
    input s; //load_n
    output m; //data_to_dff
  
    assign m = s & y | ~s & x;
	
endmodule

module flipflop(data, q, clock, reset_n);
	input clock;
	input d;
	input reset_n;
	output q;
	reg q;
	
	always @(posedge clk)
	begin
	if (reset_n == 1'b0)
		q <= 0;
	else
		q <= d;
	end
endmodule
