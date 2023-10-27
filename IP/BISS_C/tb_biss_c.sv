
`timescale 1ns/1ps
module tb_biss_c (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(5) clk = ~clk;//10M
	end
	logic [33:0] completed_data;
	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '1;
		repeat(10)@(posedge clk);
		srstb <= '0;
	end

	// (*NOTE*) replace reset, clock, others
	localparam                  IDLE = 0;
	localparam               REQUEST = 1;
	localparam            WAIT_START = 2;
	localparam          REVEIVE_ZERO = 3;
	localparam RECEIVE_POSITION_DATA = 4;
	localparam         RECEIVE_ERROR = 5;
	localparam       RECEIVE_WARNING = 6;
	localparam           RECEIVE_CRC = 7;
	localparam             CHECK_CRC = 8;
	localparam           OUTPUT_DATA = 9;

	logic        rst;
	logic  [7:0] ma_clk_divider;
	logic        request;
	logic  [7:0] resolution_bits;
	logic        ma;
	logic        slo;
	logic [31:0] position_data;
	logic        error;
	logic        warn;
	logic        position_data_valid;
	logic  [7:0] state_debug;
	logic        sample_clk_o;

	assign rst = srstb;
	
	//delay ma
	signal_delay #(
		.DELAY_DEFALUT_CLK(16) 
	)delay_sample_clk(
	.clk(clk),    // Clock
	.signal_in(ma), // Clock Enable
	.signal_out(sample_clk_o)  // Asynchronous reset active low
	
);

	biss_c inst_biss_c
		(
			.clk                 (clk),
			.rst                 (rst),
			.ma_clk_divider  	 (ma_clk_divider),
			.request             (request),
			.resolution_bits     (resolution_bits),
			.ma                  (ma),
			.slo                 (slo),
			.position_data       (position_data),
			.error               (error),
			.warn                (warn),
			.position_data_valid (position_data_valid),
			.state_debug         (state_debug)
		);

	task init();
		ma_clk_divider = 10;
		request            = '0;
		resolution_bits    = 32;
		slo                = '1;
		completed_data     = 0;
	endtask


task shift_position_data(input int ouput_data, input int bits_num);
	int tem_data = 0;
	for (int i = 0; i < bits_num; i++) begin
		@(posedge sample_clk_o)begin
			tem_data = ouput_data<<i;
			slo = tem_data[bits_num-1];//MSB FIRST
		end
	end
endtask : shift_position_data

task one_ack();
		@(posedge sample_clk_o)
		slo = 1;

		@(posedge sample_clk_o)
		slo = 0;//ack

		@(posedge sample_clk_o)
		slo = 1;	//start
		
		@(posedge sample_clk_o)
		slo = 0;	//zero code

		completed_data = ('he5df5c3e<<2) | 3;
		//completed_data = ~completed_data;
		shift_position_data('he5df5c3e, resolution_bits);//position data

		@(posedge sample_clk_o)
		slo = 1;	//error		

		@(posedge sample_clk_o)
		slo = 1;	//warn	

		shift_position_data('h3a,6);//crc data

		request = 1'b0;

		@(posedge sample_clk_o)
		slo = 0;	//time out	

		#100;// back to idle
		slo = 1;	
endtask : one_ack

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		#100;
		request = 1'b1;
		one_ack();

		#500;

		request = 1'b1;	
		one_ack();


	end

endmodule
