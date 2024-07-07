module DataMemory(
	input  reset    , 
	input  clk      ,  
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data
);
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 256;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 256 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];

	// read data from RAM_data as Read_data
	assign Read_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	integer i;
	always @(posedge reset or posedge clk)begin
		if (reset)begin
			// -------- Paste Data Memory Configuration Below (Data-q2-q3.txt)
			RAM_data[0] <= 32'hd328fef9; // X11, X12, X13, X14, to be stored in $t0
			RAM_data[1] <= 32'h0324063a; // X15, X16, X17, X18, to be stored in $t1
			RAM_data[2] <= 32'h12da0c13; // X21, X22, X23, X24, to be stored in $t2
			RAM_data[3] <= 32'hde1015d6; // X25, X26, X27, X28, to be stored in $t3

			RAM_data[4] <= 32'hdaf20624; // Y11, Y21, Y31, Y41, to be stored in $t4
			RAM_data[5] <= 32'hc31f27c9; // Y51, Y61, Y71, Y81, to be stored in $t5
			RAM_data[6] <= 32'h3ce4c0c6; // Y12, Y22, Y32, Y42, to be stored in $t6
			RAM_data[7] <= 32'h12ea09c2; // Y52, Y62, Y72, Y82, to be stored in $t7

			for (i = 8; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
			// -------- Paste Data Memory Configuration Above	
		end
		else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end
			
endmodule
