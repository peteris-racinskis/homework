`timescale 1ns / 1ps
//////////////////////////////////
/*
	Wordsize: 16bit
	Bit-endianness:  little endian [n:0]
	Word-endianness: little endian [m:0]
	Memory ranges: 
	>>>> CPU <<<<
		[255:0]				
			- r/w, but this is the program memory
		[CPURAM-1:256] 	
			- r/w general purpose memory 1
		[GPUBUF+CPURAM-1:CPURAM] 
			- r/w, accessible to GPU as ro
		[DSPBUF+GPUBUF+CPURAM-1:GPUBUF+CPURAM] 
			- r/w, accessible to DSP as ro
		[DSPRAM+DSPBUF+GPUBUF+CPURAM-1:DSPBUF+GPUBUF+CPURAM] 
			- ro, general purpose memory for use by DSP
	>>>> CPU instruction memory <<<<
		[255:0]				
			- ro, program memory. 
	>>>> GPU <<<<
		[GPUBUF+CPURAM-1:CPURAM] 
			- r0, accessible to CPU as r/w
	>>>> DSP <<<<
		[DSPRAM-1:0] 
			- r/w general purpose memory
		[DSPBUF+DSPRAM-1:DSPRAM] 
			- ro, buffer for data from CPU
	>>>><<<<
*/
//////////////////////////////////
module mmu(CPU_addr,CPU_rdata,CPU_wdata,CPU_ready,CPU_wenable,CPU_progc,
     CPU_instr,CPU_iready,GPU_addr,GPU_rdata,GPU_ready,DSP_addr,DSP_rdata,
	   DSP_wdata,DSP_ready,DSP_wenable,clk
    );
	
	parameter cpur_init = "long_seq.mem"; // 3072 words
	parameter gpub_init = "long_seq.mem"; // 3072 words
	parameter dspb_init = "short_seq.mem";// 1024 words
	parameter dspr_init = "long_seq.mem"; // 3072 words
	parameter WORDSIZE = 16;
	parameter CPURAM = 3072;
	parameter GPUBUF = 3072;
	parameter DSPBUF = 1024;
	parameter DSPRAM = 3072;
	
	input		[WORDSIZE-1:0]  	CPU_addr,CPU_wdata,GPU_addr,DSP_addr,DSP_wdata;
	output	[WORDSIZE-1:0] 	CPU_rdata,CPU_instr,GPU_rdata,DSP_rdata;
	input		[7:0] 				CPU_progc;
	input 	CPU_wenable,DSP_wenable,clk;
	output 	CPU_ready,CPU_iready,GPU_ready,DSP_ready;
	
	wire [WORDSIZE-1:0] cpu_a,cpu_b,cpu_c,cpu_d,dsp_a,dsp_b,prog_a,gpu_a;
	wire [3:0] cpumode,dspmode,progmode,gpumode;
	
	assign dspmode[3:2] = 2'b00;
	assign gpumode[3:1] = 3'b000;
	assign progmode[3:1] = 3'b000;
	
	//////////////////
	// OUTPUT MUXES //
	//////////////////
	nmux4 cpu_outmux(
	  .a(cpu_a),
	  .b(cpu_b),
	  .c(cpu_c),
	  .d(cpu_d),
	  .sel(cpumode),
	  .out(CPU_rdata),
	  .rdy(CPU_ready)
	 );
	nmux4 dsp_outmux(
	 .a(dsp_a),
	 .b(dsp_b),
	 .sel(dspmode),
	 .out(DSP_rdata),
	 .rdy(DSP_ready)
	);
	nmux4 gpu_outmux(
	 .a(prog_a),
	 .sel(progmode),
	 .out(CPU_instr),
	 .rdy(CPU_iready)
	);
	nmux4 prog_outmux(
	 .a(gpu_a),
	 .sel(gpumode),
	 .out(GPU_rdata),
	 .rdy(GPU_ready)
	);
	////////////////////////////
	// DISCRETE MEMORY BLOCKS //
	////////////////////////////
	memblock #(
	.BLOCKSIZE(CPURAM),
	.INIT_FILE(cpur_init),
	.INIT_FLAG(1)
	) 
	 cpumem (
		.DIN(CPU_wdata),
		.DOUT_1(cpu_a),
		.DOUT_2(prog_a),
		.ADDR_1(CPU_addr),
		.ADDR_2({8'b0,CPU_progc}), // need to concat vector of 0s
		.WE(CPU_wenable),
		.clk(clk),
		.en1(cpumode[0]),
		.en2(progmode[0])
	);
	memblock #(
	.BLOCKSIZE(GPUBUF),
	.OFFS_1(CPURAM),
	.INIT_FILE(gpub_init),
	.INIT_FLAG(1)
	) 
	 gpubuf (
		.DIN(CPU_wdata),
		.DOUT_1(cpu_b),
		.DOUT_2(gpu_a),
		.ADDR_1(CPU_addr),
		.ADDR_2(GPU_addr),
		.WE(CPU_wenable),
		.clk(clk),
		.en1(cpumode[1]),
		.en2(gpumode[0])
	);
	memblock #(
	.BLOCKSIZE(DSPBUF),
	.OFFS_1(CPURAM+GPUBUF),
	.OFFS_2(DSPRAM),
	.INIT_FILE(dspb_init),
	.INIT_FLAG(1)
	) 
	 dspbuf (
		.DIN(CPU_wdata),
		.DOUT_1(cpu_c),
		.DOUT_2(dsp_b),
		.ADDR_1(CPU_addr),
		.ADDR_2(DSP_addr),
		.WE(CPU_wenable),
		.clk(clk),
		.en1(cpumode[2]),
		.en2(dspmode[1])
	);
	memblock #(
	.BLOCKSIZE(DSPRAM),
	.OFFS_2(CPURAM+GPUBUF+DSPBUF),
	.INIT_FILE(dspr_init),
	.INIT_FLAG(1)
	) 
	 dspmem (
		.DIN(DSP_wdata),
		.DOUT_1(dsp_a),
		.DOUT_2(cpu_d),
		.ADDR_1(DSP_addr),
		.ADDR_2(CPU_addr),
		.WE(DSP_wenable),
		.clk(clk),
		.en1(dspmode[0]),
		.en2(cpumode[3])
	);
	
endmodule
