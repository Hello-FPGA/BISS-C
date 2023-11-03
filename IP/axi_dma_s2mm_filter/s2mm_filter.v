`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Create by Engineer: yaxingshi
// Create Date: 2023-11-03 11:42:00
// Last Modified by:   yaxingshi
// Last Modified time: 2023-11-03 12:15:36
// Design Name: 
// Module Name: s2mm_filter
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

module s2mm_filter #(
	parameter WIDTH = 32
	)(
	input axis_aclk,
	input axis_aresetn,

	input s_axis_tvalid,
	input [WIDTH-1:0]s_axis_tdata,
	input s_axis_tlast,
	input [WIDTH/8-1:0]s_axis_tkeep,
	output s_axis_tready,

	output m_axis_tvalid,
	output [WIDTH-1:0]m_axis_tdata,
	output m_axis_tlast,
	output [WIDTH/8-1:0]m_axis_tkeep,
	input m_axis_tready,

	input en,//active at the risingedge
	input [25:0]counter//the max width is 26
);

wire filter_enable;
reg [25:0]counter_internal;

always @(posedge axis_aclk) begin : proc_counter_internal
	if(~axis_aresetn || ~en) begin
		counter_internal <= 0;
	end else if(counter_internal<=counter && s_axis_tvalid==1'b1 && m_axis_tready==1'b1)begin
		counter_internal <= counter_internal + 1'b1;
	end
end

assign 	filter_enable = counter_internal<=counter && en==1'b1;
assign 	m_axis_tvalid = filter_enable?s_axis_tvalid:'b0;
assign 	m_axis_tdata = filter_enable?s_axis_tdata:'b0;
assign 	m_axis_tlast = counter_internal == counter;
assign 	m_axis_tkeep = filter_enable?s_axis_tkeep:'b0;
assign 	s_axis_tready = m_axis_tready;

endmodule : s2mm_filter