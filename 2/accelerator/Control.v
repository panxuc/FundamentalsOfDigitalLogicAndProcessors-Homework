
module Control(
	input  [6 -1:0] OpCode   ,
	input  [6 -1:0] Funct    ,
	output [2 -1:0] PCSrc    ,
	output Branch            ,
	output RegWrite          ,
	output [2 -1:0] RegDst   ,
	output MemRead           ,
	output MemWrite          ,
	output [2 -1:0] MemtoReg ,
	output ALUSrc1           ,
	output ALUSrc2           ,
	output ExtOp             ,
	output LuOp              ,
	output [4 -1:0] ALUOp
);
	
	// Add your code below (for question 2 and question 3)

	// Your code below (for question 1)
	assign PCSrc = 
		(OpCode == 6'h02 || OpCode == 6'h03)? 2'b01: //j, jal
		(OpCode == 6'h00 && Funct == 6'h08)? 2'b10: //jr
		2'b00; //others
	assign Branch = 
		(OpCode == 6'h04)? 1'b1: //beq
		1'b0; //others
	assign RegWrite =
		(OpCode == 6'h2b || OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h08))? 1'b0: //sw, j, jr
		1'b1; //others
	assign RegDst =
		(OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09))? 2'b10: //jal, jalr
		(OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b)? 2'b00: //lw, lui, addi, addiu, andi, slti, sltiu
		(OpCode == 6'h00 && Funct == 6'h2e)? 2'b11: //relu
		2'b01; //others
	assign MemRead =
		(OpCode == 6'h23)? 1'b1: //lw
		1'b0; //others
	assign MemWrite =
		(OpCode == 6'h2b)? 1'b1: //sw
		1'b0; //others
	assign MemtoReg =
		(OpCode == 6'h23)? 2'b01: //lw
		(OpCode == 6'h03)? 2'b10: //jal
		2'b00; //others
	assign ALUSrc1 =
		((OpCode == 6'h00 && Funct == 6'h00) || (OpCode == 6'h00 && Funct == 6'h02) || (OpCode == 6'h00 && Funct == 6'h03))? 1'b1: //sll, srl, sra
		1'b0; //others
	assign ALUSrc2 =
		(OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f || OpCode == 6'h08 || OpCode == 6'h09 || OpCode == 6'h0c || OpCode == 6'h0a || OpCode == 6'h0b)? 1'b1: //lw, sw, lui, addi, addiu, andi, slti, sltiu
		1'b0; //others
	assign ExtOp =
		(OpCode == 6'h0c)? 1'b0: //andi
		1'b1; //others
	assign LuOp =
		(OpCode == 6'h0f)? 1'b1: //lui
		1'b0; //others
	// Your code above (for question 1)

	// set ALUOp
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b)? 3'b101:
		(OpCode == 6'h1c && Funct == 6'h02)?3'b110:	//mul 
		3'b000; 
		
		
	assign ALUOp[3] = OpCode[0];

	// Add your code above (for question 2 and question 3)
	
endmodule