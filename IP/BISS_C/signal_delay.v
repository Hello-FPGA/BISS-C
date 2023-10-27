`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JXInst http://www.jxinst.com/
// Create by Engineer: yaxingshi
// Create Date: 2019-09-26 22:39:14
// Last Modified by:   yaxingshi
// Last Modified time: 2023-03-24 14:11:46
// Design Name: 
// Module Name: signal_delay
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

module signal_delay #(
parameter integer DELAY_DEFALUT_CLK=16 
	)
	(
	input clk,    // Clock
	input signal_in, // Clock Enable
	output signal_out  // Asynchronous reset active low
	
);

	function integer log2(input integer value);
	  begin
	  	value=value-1;
	    for (log2=0; value>0; log2=log2+1)
	      value = value>>1;
	  end
	endfunction
reg [DELAY_DEFALUT_CLK-1:0] shift_regs=-1;
assign signal_out=shift_regs[DELAY_DEFALUT_CLK-1];
		always @(posedge clk) begin : proc_delay
			shift_regs[0]<=signal_in;
		end

genvar i; 
generate
	for (i = 1; i < DELAY_DEFALUT_CLK; i=i+1) begin
		always @(posedge clk) begin : proc_delay
			shift_regs[i]<=shift_regs[i-1];
		end
	end

endgenerate


endmodule