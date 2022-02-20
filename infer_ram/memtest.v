`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:36:10 05/12/2021
// Design Name:   mmu
// Module Name:   /home/peter/repos/infer_ram/memtest.v
// Project Name:  infer_ram
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mmu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module memtest;

	// Inputs
	reg [15:0] CPU_addr;
	reg [15:0] CPU_wdata;
	reg CPU_wenable;
	reg [7:0] CPU_progc;
	reg [15:0] GPU_addr;
	reg [15:0] DSP_addr;
	reg [15:0] DSP_wdata;
	reg DSP_wenable;
	reg clk;

	// Outputs
	wire [15:0] CPU_rdata;
	wire CPU_ready;
	wire [15:0] CPU_instr;
	wire CPU_iready;
	wire [15:0] GPU_rdata;
	wire GPU_ready;
	wire [15:0] DSP_rdata;
	wire DSP_ready;

	// Instantiate the Unit Under Test (UUT)
	mmu uut (
		.CPU_addr(CPU_addr), 
		.CPU_rdata(CPU_rdata), 
		.CPU_wdata(CPU_wdata), 
		.CPU_ready(CPU_ready), 
		.CPU_wenable(CPU_wenable), 
		.CPU_progc(CPU_progc), 
		.CPU_instr(CPU_instr), 
		.CPU_iready(CPU_iready), 
		.GPU_addr(GPU_addr), 
		.GPU_rdata(GPU_rdata), 
		.GPU_ready(GPU_ready), 
		.DSP_addr(DSP_addr), 
		.DSP_rdata(DSP_rdata), 
		.DSP_wdata(DSP_wdata), 
		.DSP_ready(DSP_ready), 
		.DSP_wenable(DSP_wenable), 
		.clk(clk)
	);

	always begin
		clk = 1'b0;
		#10;
		clk = 1'b1;
		#10;
	end
	
	initial begin
		// Initialize Inputs
		CPU_addr = 0;
		CPU_wdata = 0;
		CPU_wenable = 0;
		CPU_progc = 0;
		GPU_addr = 0;
		DSP_addr = 0;
		DSP_wdata = 0;
		DSP_wenable = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      CPU_addr = 1;
		#100;
		CPU_addr = 20;
		#100;
		CPU_addr = 10'b0000000010;
		CPU_wdata = 69420;
		CPU_wenable = 1;
		CPU_progc = 24;
		GPU_addr = 72;
		#20;
		CPU_wenable = 0;
		DSP_addr = 10;
		DSP_wdata = 55;
		DSP_wenable = 1;
		#20;
		CPU_addr = 20;
		DSP_wenable = 0;
		GPU_addr = 0;
		#40;
		CPU_wdata = 255;
		CPU_wenable = 1;
		DSP_addr = 1;
		#20;
		CPU_wenable = 0;
		#20;
		CPU_addr = 10'b0000000010;
		#5
		DSP_addr = 10;
		CPU_addr = 10 + 3072 + 3072 + 1024;
		GPU_addr = 1;
		#250;
		CPU_addr = 0;
		DSP_addr = 0;
		#20;
		CPU_wenable = 1;
		CPU_wdata = 69;
		#20;
		CPU_wenable = 0;
		// Add stimulus here

	end
      
endmodule

