`timescale 1ns / 1ps

module memblock(DIN,DOUT_1,DOUT_2,ADDR_1,ADDR_2,WE,clk, en1, en2);
	
	parameter OFFS_1 = 0;
	parameter OFFS_2 = 0;
	parameter WORDSIZE = 16;
	parameter BLOCKSIZE = 1024;
	parameter INIT_FILE = "";
	parameter INIT_FLAG = 0;
	
	input  [WORDSIZE-1:0] DIN,ADDR_1,ADDR_2;
	output reg [WORDSIZE-1:0] DOUT_1,DOUT_2;
	input WE,clk;
	output wire en1,en2;
	
	reg [WORDSIZE-1:0] memory [BLOCKSIZE-1:0];
	wire [WORDSIZE-1:0] a1, a2;
	
	assign a1 = (ADDR_1 - OFFS_1);
	assign a2 = (ADDR_2 - OFFS_2);
	assign en1 = (ADDR_1 - OFFS_1 < BLOCKSIZE) && (ADDR_1 >= OFFS_1); 
	assign en2 = (ADDR_2 - OFFS_2 < BLOCKSIZE) && (ADDR_2 >= OFFS_2);	
	
	always @(posedge clk) begin
      if (en1) begin
         if (WE)
            memory[a1] <= DIN;
         DOUT_1 <= memory[a1];
      end
      if (en2)
         DOUT_2 <= memory[a2];
   end
	
	initial
		if (INIT_FLAG == 1) $readmemh(INIT_FILE, memory, 0, BLOCKSIZE-1);
	
endmodule
