`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JXInst http://www.jxinst.com/
// Create by Engineer: yaxingshi
// Create Date: 2020-01-06 14:25:52
// Last Modified by:   yaxingshi
// Last Modified time: 2020-01-06 16:16:10
// Design Name: 
// Module Name: clk_div_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_div_tb (
	
);


bit clk_i;
bit rst_ni;
bit clk_o_1;
bit clk_o_2;
bit clk_o_3;
bit clk_o_4;
bit [27:0]high_ticks;
bit [27:0]low_ticks;

always #5 clk_i=~clk_i;

ClkDivider #(
	.NUM_OF_CHANNELS(4))
	 DUT(
.divider_0(clk_o_1),
.divider_1(clk_o_2),
.divider_2(clk_o_3),
.divider_3(clk_o_4),
.high_ticks_0(2),
.low_ticks_0(3),

.high_ticks_1(1),
.low_ticks_1(1),

.high_ticks_2(4),
.low_ticks_2(1),

.high_ticks_3(6),
.low_ticks_3(3),
.*
);

initial begin
	rst_ni=0;
	#100;
	rst_ni=1;
	high_ticks=5;
	low_ticks=5;
	#1000;
	high_ticks=8;
	low_ticks=3;
	#1000;
end
endmodule