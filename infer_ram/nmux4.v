`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:57:37 05/12/2021 
// Design Name: 
// Module Name:    nmux4 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module nmux4(a,b,c,d,sel,out,rdy);
	
	parameter WORDSIZE = 16;
	input 	  [WORDSIZE-1:0] a,b,c,d;
	output reg [WORDSIZE-1:0] out;
	output rdy;
	input 	[3:0] sel;
	
	always@(a or b or c or d or sel)
		case(sel)
			4'b0001: out = a;
			4'b0010: out = b;
			4'b0100: out = c;
			4'b1000: out = d;
			default: out = 'bx;
		endcase
	
	assign rdy = (sel[0] || sel[1] || sel[2] || sel[3]);
	
endmodule
