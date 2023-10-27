
`timescale 1ns/1ps
module tb_CRC_Unit (); /* this is automatically generated */

	// clock
	logic clk;
	logic sample_clk;
	initial begin
		clk = '0;
		forever #(5) clk = ~clk;
	end

	initial begin
		sample_clk = '0;
		forever #100 sample_clk = ~sample_clk;		
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb = '1;
		repeat(10)@(posedge clk);
		srstb = '0;
	end


	// (*NOTE*) replace reset, clock, others
	logic       BITVAL;
	logic [5:0] CRC;
	logic 		BITSTRB;

	CRC_Unit inst_CRC_Unit (.CLK(clk),.BITVAL(BITVAL), .BITSTRB(BITSTRB), .CLEAR(srstb), .CRC(CRC));

	task init();
		BITVAL  = '0;
		BITSTRB = 0;
	endtask

task shift_position_data(input int ouput_data, input int bits_num);
	logic [33:0] tem_data = 0;
	for (int i = 0; i < bits_num; i++) begin
		@(posedge sample_clk)begin
			tem_data = ouput_data<<i;
			BITVAL = tem_data[bits_num-1];//MSB FIRST
			#5;
			BITSTRB = 1;
		end
			#10;
			BITSTRB = 0;
	end
endtask : shift_position_data

	initial begin
		// do something

		init();
		repeat(10)@(posedge clk);

		shift_position_data('h977d70fb,34);
		BITSTRB = 0;
		#500;
		srstb = '1;
		#500;
		srstb = '0;
		#100;				
		shift_position_data('haa55aa55,32);
	end

endmodule
