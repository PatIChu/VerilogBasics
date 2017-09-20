//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux7to1 u0(.Switch(SW[9:0]), .Out(LEDR[0]));
endmodule

module mux7to1(Switch, Out);
	input [6:0] Switch;
	output Out;
	
	always @(SW[9:7])
	begin
		case(SW[9:7])
		3'b000: Out = SW[0];
		3'b001: Out = SW[1];
		3'b010: Out = SW[2];
		3'b011: Out = SW[3];
		3'b100: Out = SW[4];
		3'b101: Out = SW[5];
		3'b110: Out = SW[6];
		default: Out = 1'b0;
		endcase
	end
endmodule
