//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module mux(LEDR, SW);
    input [9:0] SW;
    output [9:0] LEDR;

    mux7to1 u0(
		.MuxSelect(SW[9:7]),
		.Input(SW[6:0]),
		.Out(EDR[0])
        );
endmodule

module mux7to1(MuxSelect, Input, Out);
	input [2:0] MuxSelect;
	input [6:0] Input;
	output Out;
	
	always @(*)
	begin
		case(MuxSelect[2:0])
		3'b000: assign Out = Input[0];
		3'b001: assign Out = Input[1];
		3'b010: assign Out = Input[2];
		3'b011: assign Out = Input[3];
		3'b100: assign Out = Input[4];
		3'b101: assign Out = Input[5];
		3'b110: assign Out = Input[8];
		endcase
	end
endmodule
