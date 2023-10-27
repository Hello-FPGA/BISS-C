`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JXInst http://www.jxinst.com/
// Create by Engineer: yaxingshi
// Create Date: 2020-01-06 11:39:02
// Last Modified by:   yaxingshi
// Last Modified time: 2020-01-06 23:32:01
// Design Name: 
// Module Name: clk_div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// derived from a clk input, user can set a const RATIO or set dynamic reconfig
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_div #(
    parameter integer RATIO = 20,// default divider
    parameter integer DYNAMIC_RECONFIG=0, // using reconfig
    parameter integer RISING_EDGE=0// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
)(
  input  wire clk_i,      // Clock
  input  wire rst_ni,     // Asynchronous reset active low
  input  wire en,          // enable clock divider output, active high
  output wire clk_o,       // divided clock out
  input wire [27:0]high_ticks, //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]low_ticks//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
);
    function integer log2(input integer value);
      begin
        value=value-1;
        for (log2=0; value>0; log2=log2+1)
          value = value>>1;
      end
    endfunction

    localparam integer BIT_WIDTH=DYNAMIC_RECONFIG?27+1:log2(RATIO)+1;
    reg [BIT_WIDTH-1:0] counter_q;//MAX value 8
    reg clk_q;
    wire ready_to_reverse;

    assign ready_to_reverse=DYNAMIC_RECONFIG?(counter_q >= (clk_q?high_ticks:low_ticks)):(counter_q==RATIO>>1);

//reg rst_reg0,rst_reg1;
reg en_reg;
reg en_reg0;
always @(posedge clk_i) begin
    en_reg0<=en;
    en_reg<=en_reg0;
end

generate
    if (RISING_EDGE==1) begin

        always @(posedge clk_i or negedge rst_ni) begin
            if (~rst_ni | ~en_reg) begin
                clk_q <= 0;
            end else if (ready_to_reverse)begin
                clk_q <= ~clk_q;
             end
        end
        always @(posedge clk_i or negedge rst_ni) begin : proc_counter_q
            if(~rst_ni| ~en_reg) begin
                counter_q <= 0;
            end else if (ready_to_reverse) begin
                counter_q <= 1;
            end else begin
                counter_q <= counter_q+1;
            end
        end
    end else begin
        always @(negedge clk_i) begin
            if (~rst_ni| ~en_reg) begin
                clk_q <= 0;
            end else if (ready_to_reverse)begin
                clk_q <=  ~clk_q;
            end
        end
        always @(negedge clk_i  or negedge rst_ni) begin : proc_counter_q
            if(~rst_ni| ~en_reg) begin
                counter_q <= 0;
            end else if (ready_to_reverse) begin
                counter_q <= 1;
            end else begin
                counter_q <= counter_q+1;
            end
        end  
    end
endgenerate

    // output assignment - bypass in testmode
    assign clk_o = clk_q;
endmodule