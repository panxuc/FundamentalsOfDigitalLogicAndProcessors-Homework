module InstructionMemory(
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])

			// -------- Paste Binary Instruction Below (Inst-q2.txt, Inst-q3.txt)
			8'd0:	Instruction <= 32'h8c080000;
			8'd1:	Instruction <= 32'h8c090004;
			8'd2:	Instruction <= 32'h8c0a0008;
			8'd3:	Instruction <= 32'h8c0b000c;
			8'd4:	Instruction <= 32'h8c0c0010;
			8'd5:	Instruction <= 32'h8c0d0014;
			8'd6:	Instruction <= 32'h8c0e0018;
			8'd7:	Instruction <= 32'h8c0f001c;
			8'd8:	Instruction <= 32'h010c802d;
			8'd9:	Instruction <= 32'h012d202d;
			8'd10:	Instruction <= 32'h02048020;
			8'd11:	Instruction <= 32'h010e882d;
			8'd12:	Instruction <= 32'h012f202d;
			8'd13:	Instruction <= 32'h02248820;
			8'd14:	Instruction <= 32'h0200882e;
			8'd15:	Instruction <= 32'h014c902d;
			8'd16:	Instruction <= 32'h016d202d;
			8'd17:	Instruction <= 32'h02449020;
			8'd18:	Instruction <= 32'h014e982d;
			8'd19:	Instruction <= 32'h016f202d;
			8'd20:	Instruction <= 32'h02649820;
			8'd21:	Instruction <= 32'h0240982e;
			8'd22:	Instruction <= 32'hac100020;
			8'd23:	Instruction <= 32'hac110024;
			8'd24:	Instruction <= 32'hac120028;
			8'd25:	Instruction <= 32'hac13002c;
			8'd26:	Instruction <= 32'h0810001a;
			// -------- Paste Binary Instruction Above
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
