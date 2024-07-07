// Hint: ALU port may be changed (for question 3)
module ALU(
	input [32 -1:0] in1      , 
	input [32 -1:0] in2      ,
	input [5 -1:0] ALUCtl    ,
	input Sign               ,
	output reg [32 -1:0] out ,
	output reg [32 -1:0] out2,
	output zero
);
	// zero means whether the output is zero or not
	assign zero = (out == 0);
	
	wire ss;
	assign ss = {in1[31], in2[31]};
	
	wire lt_31;
	assign lt_31 = (in1[30:0] < in2[30:0]);
	
	// lt_signed means whether (in1 < in2)
	wire lt_signed;
	assign lt_signed = (in1[31] ^ in2[31])? 
		((ss == 2'b01)? 0: 1): lt_31;

	// Add your code below (for question 2 and question 3)
	wire [32-1:0] in11, in12, in13, in14, in21, in22, in23, in24;
	assign in11 = {{24{in1[7]}}, in1[7:0]};
	assign in12 = {{24{in1[15]}}, in1[15:8]};
	assign in13 = {{24{in1[23]}}, in1[23:16]};
	assign in14 = {{24{in1[31]}}, in1[31:24]};
	assign in21 = {{24{in2[7]}}, in2[7:0]};
	assign in22 = {{24{in2[15]}}, in2[15:8]};
	assign in23 = {{24{in2[23]}}, in2[23:16]};
	assign in24 = {{24{in2[31]}}, in2[31:24]};
	// different ALU operations
	always @(*)
		case (ALUCtl)
			5'b00000: out <= in1 & in2;
			5'b00001: out <= in1 | in2;
			5'b00010: out <= in1 + in2;
			5'b00110: out <= in1 - in2;
			5'b00111: out <= {31'h00000000, Sign? lt_signed: (in1 < in2)};
			5'b01100: out <= ~(in1 | in2);
			5'b01101: out <= in1 ^ in2;
			5'b10000: out <= (in2 << in1[4:0]);
			5'b11000: out <= (in2 >> in1[4:0]);
			5'b11001: out <= ({{32{in2[31]}}, in2} >> in1[4:0]);
			5'b11010: out <= in1 * in2; // mul
			5'b11100: out <= in11 * in21 + in12 * in22 + in13 * in23 + in14 * in24; // mac
			5'b11101: 
			begin
				out <= (in1[31])? 32'h0: in1; // relu
				out2 <= (in2[31])? 32'h0: in2; // relu
			end
			default: out <= 32'h0;
		endcase
		
		
	// Add your code above (for question 2 and question 3)
	
	
endmodule