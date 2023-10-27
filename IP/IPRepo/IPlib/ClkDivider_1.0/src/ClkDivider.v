`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JXInst http://www.jxinst.com/
// Create by Engineer: yaxingshi
// Create Date: 2020-01-06 14:44:09
// Last Modified by:   yaxingshi
// Last Modified time: 2020-09-14 08:54:26
// Design Name: 
// Module Name: ClkDivider
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

//`define ENABLE_TRIGGER_SYNC

module ClkDivider #(
    parameter integer ENABLE_SYNC_DELAY = 0,
    parameter integer ENABLE_TRIGGER_SYNC=1,// enable divider sync, so different borads divider out can have same phrase
	  parameter integer NUM_OF_CHANNELS=4,// MAX number will be limited to 4
    
    parameter integer RATIO_0 = 20,// default channel 0 divider
    parameter integer DYNAMIC_RECONFIG_0=1, // using reconfig
    parameter integer RISING_EDGE_0=0,// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100
    
    parameter integer RATIO_1 = 20,// default channel 0 divider
    parameter integer DYNAMIC_RECONFIG_1=1, // using reconfig
    parameter integer RISING_EDGE_1=0,// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
    
    parameter integer RATIO_2 = 20,// default channel 0 divider
    parameter integer DYNAMIC_RECONFIG_2=1, // using reconfig
    parameter integer RISING_EDGE_2=0,// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100
   
    parameter integer RATIO_3 = 20,// default channel 0 divider
    parameter integer DYNAMIC_RECONFIG_3=1, // using reconfig
    parameter integer RISING_EDGE_3=0// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
	
)(
  input  wire clk_i,      // Clock
  input  wire rst_ni,     // Asynchronous reset active low
  output wire divider_0,       // divided clock out
  output wire divider_1,       // divided clock out
  output wire divider_2,       // divided clock out
  output wire divider_3,       // divided clock out
//`ifdef ENABLE_TRIGGER_SYNC
  input sync_pulse,
  input trigger_in,
  input is_slave,
  output master_trigger,
  output trigger_valid,
  input [7:0]trigger_valid_delay_cycles,
//`endif  
  input wire [NUM_OF_CHANNELS-1:0]enable_divider,

  input wire [27:0]high_ticks_0, //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]low_ticks_0,//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]high_ticks_1, //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]low_ticks_1,//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]high_ticks_2, //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]low_ticks_2,//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]high_ticks_3, //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  input wire [27:0]low_ticks_3//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1IG==1
	);

//`ifdef ENABLE_TRIGGER_SYNC
wire trigger_out_delay;
wire trigger_out;
assign trigger_valid=ENABLE_SYNC_DELAY?trigger_out_delay:trigger_out;

generate
  if (ENABLE_TRIGGER_SYNC==1) begin
    trigger_sync #(
      .ACTIVE_RISING_EDGE(1),
      .ENABLE_POSITION_COUNT(0),
      .ENABLE_SYNC_DELAY(ENABLE_SYNC_DELAY)
      ) ClkManagerTriggerSync (
      .ref_clk(clk_i),
      .rst_n                                (rst_ni),
      .sync_pulse                           (sync_pulse),
      .sync_enable                          (trigger_in),
      .enable_high_precision_synchronization(1),
      .is_slave                             (is_slave),
      .master_trigger                       (master_trigger),
      .trigger_out                          (trigger_out),
      .delay_count                          (trigger_valid_delay_cycles),
      .trigger_out_delay                    (trigger_out_delay)
      );
  end else begin
    assign trigger_out =1'b1;
  end
endgenerate

//`endif
wire reset;
assign reset=trigger_out&rst_ni;
generate
	if (NUM_OF_CHANNELS==1) begin
		clk_div #(
    		.RATIO (RATIO_0),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_0), // using reconfig
    		.RISING_EDGE(RISING_EDGE_0)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_0(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[0]),
  			.clk_o(divider_0),       // divided clock out
  			.high_ticks(high_ticks_0), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_0)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
	end else if (NUM_OF_CHANNELS==2) begin
		clk_div #(
    		.RATIO (RATIO_0),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_0), // using reconfig
    		.RISING_EDGE(RISING_EDGE_0)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_0(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[0]),
        .clk_o(divider_0),       // divided clock out
  			.high_ticks(high_ticks_0), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_0)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
		clk_div #(
    		.RATIO (RATIO_1),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_1), // using reconfig
    		.RISING_EDGE(RISING_EDGE_1)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_1(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[1]),  			
        .clk_o(divider_1),       // divided clock out
  			.high_ticks(high_ticks_1), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_1)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
	end else if (NUM_OF_CHANNELS==3) begin
		clk_div #(
    		.RATIO (RATIO_0),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_0), // using reconfig
    		.RISING_EDGE(RISING_EDGE_0)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_0(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
         .en(enable_divider[0]), 			
        .clk_o(divider_0),       // divided clock out
  			.high_ticks(high_ticks_0), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_0)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
		clk_div #(
    		.RATIO (RATIO_1),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_1), // using reconfig
    		.RISING_EDGE(RISING_EDGE_1)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_1(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[1]),
  			.clk_o(divider_1),       // divided clock out
  			.high_ticks(high_ticks_1), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_1)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
		clk_div #(
    		.RATIO (RATIO_2),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_2), // using reconfig
    		.RISING_EDGE(RISING_EDGE_2)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_2(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[2]),
  			.clk_o(divider_2),       // divided clock out
  			.high_ticks(high_ticks_2), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_2)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
	end else if (NUM_OF_CHANNELS==4) begin
		clk_div #(
    		.RATIO (RATIO_0),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_0), // using reconfig
    		.RISING_EDGE(RISING_EDGE_0)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_0(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[0]),
  			.clk_o(divider_0),       // divided clock out
  			.high_ticks(high_ticks_0), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_0)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
		clk_div #(
    		.RATIO (RATIO_1),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_1), // using reconfig
    		.RISING_EDGE(RISING_EDGE_1)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_1(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[1]),
  			.clk_o(divider_1),       // divided clock out
  			.high_ticks(high_ticks_1), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_1)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
		clk_div #(
    		.RATIO (RATIO_2),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_2), // using reconfig
    		.RISING_EDGE(RISING_EDGE_2)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_2(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[2]),
  			.clk_o(divider_2),       // divided clock out
  			.high_ticks(high_ticks_2), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_2)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
		clk_div #(
    		.RATIO (RATIO_3),// default divider
    		.DYNAMIC_RECONFIG(DYNAMIC_RECONFIG_3), // using reconfig
    		.RISING_EDGE(RISING_EDGE_3)// default will be falling edge, for FirmDrive sync, generate the sync_pulse signal like pxie_sync100 
		)clk_div_channel_3(
  			.clk_i(clk_i),      // Clock
  			.rst_ni(reset),     // Asynchronous reset active low
        .en(enable_divider[3]),
  			.clk_o(divider_3),       // divided clock out
  			.high_ticks(high_ticks_3), //dynamic config the high ticks for output clk only enable when DYNAMIC_RECONFIG==1
  			.low_ticks(low_ticks_3)//dynamic config the low ticks for output clk only enable when DYNAMIC_RECONFIG==1
		);
	end
endgenerate
endmodule