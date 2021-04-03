// Verilog test fixture created from schematic /home/peter/pd_2/cnt4b.sch - Thu Mar  4 03:42:33 2021

`timescale 1ns / 1ps

module cnt4b_cnt4b_sch_tb();

// Inputs
   reg count;
   reg clk;
   reg clear;

// Output
   wire Q0;
   wire Q1;
   wire Q2;
   wire Q3;
   wire carry;
   wire terminate;

// Bidirs

// Instantiate the UUT
   cnt4b UUT (
		.CE(count), 
		.CLK(clk), 
		.CLR(clear), 
		.Q0(Q0), 
		.Q1(Q1), 
		.Q2(Q2), 
		.Q3(Q3), 
		.carry(carry), 
		.terminate(terminate)
   );

// Simulate clock
always
begin
	clk = 1'b1;
	#20;
	clk = 1'b0;
	#20;
end		

// Run some tests
initial 
begin
	count = 1;
	clear = 0;
	#50;
	count = 1;
	#800;
	clear = 1;
	#10;
	clear = 0;
end
endmodule
