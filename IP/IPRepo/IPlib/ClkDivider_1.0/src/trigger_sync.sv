`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: JXInst http://www.jxinst.com/
// Create by Engineer: yaxingshi
// Create Date: 2019-07-03 17:40:21
// Last Modified by:   yaxingshi
// Last Modified time: 2020-03-10 10:26:53
// Design Name: 
// Module Name: trigger_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: http://git.jxinst.com:8081/FirmDrive/daqfw/daqfw-ip/issues/82
// this module for sync the signal
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
typedef enum logic [2:0]{
	SYNC_IDLE=1,
	SYNC_SIGNAL=2,
	WAIT_FOR_STABLE=4
}SYNC_STATE;

module trigger_sync #(
	parameter integer ACTIVE_RISING_EDGE=1,//trigger_out signal active rising edge or falling edge, rising edge cam be used to sync pll, falling edge can be used for low latency
	parameter integer ENABLE_POSITION_COUNT=0,// 1 enable, 0 disable position count, record the time betwwen trigger in and trigger valid 
	parameter integer ENABLE_SYNC_DELAY=1
	)(
	input  ref_clk,//
	input  sync_pulse,    // take this as a clock signal, so normaly we use PXI_CLK10 or PXI_SYNC100
	input  rst_n,
	input  sync_enable,  // Asynchronous sync input
	input  enable_high_precision_synchronization,// master devices, high active
	input  is_slave,// slave devices, high active, if is_master and is_slave both low level, trigger_sync is solo mode, no sync
	input [11:0] delay_count,//max is 1024 , delay the trigger valid signal delay_count ref_clk tick
	output logic master_trigger,// active at sync_pulse falling edge and sync_pulse posedge
	output logic trigger_out,// trigger valid signal
	output logic [7:0]position_count,//the ticks from recive master_trigger until trigger out
	output logic trigger_out_delay
);

	logic sync_enable_reg0,sync_enable_reg1;
	logic sync_enable_rising_edge;
	SYNC_STATE state, next_state;//, state_reg;
	logic solo_mode;
	logic [2:0]wait_counter;
	logic trigger_out_wire;
	logic sync_pulse_reg0,sync_pulse_reg1;
	logic sync_pulse_falling_edge;//,sync_pulse_falling_edge_first,sync_pulse_falling_edge_second;

//detect the rising edge, this logic maybe failed because the input signal is unstable
	always_ff @(posedge ref_clk) begin : proc_sync_enable
		sync_enable_reg0<=sync_enable;
		sync_enable_reg1<=sync_enable_reg0;
	end
	always_ff @(posedge ref_clk) begin : proc_sync_enable_rising_edge
		if (~rst_n) begin
			sync_enable_rising_edge<=0;
		end else if (sync_enable_reg0&(~sync_enable_reg1)) begin
			sync_enable_rising_edge<=1;
		end else if(state!=SYNC_IDLE)begin
			sync_enable_rising_edge<=0;
		end			
	end
	// sync the input trigger signal 
	always_ff @(negedge ref_clk) begin : proc_sync_pulse_reg0
		sync_pulse_reg0<=sync_pulse;
		sync_pulse_reg1<=sync_pulse_reg0;
	end

	assign sync_pulse_falling_edge=sync_pulse_reg1&(~sync_pulse_reg0);// stable falling edge
	always_ff @(posedge ref_clk) begin : proc_wait_counter
		if(next_state==SYNC_IDLE) begin
			wait_counter <= 0;
		end else if(state==WAIT_FOR_STABLE)begin
			wait_counter <= wait_counter+1;
		end
	end
	always @(posedge ref_clk) begin : proc_state
		if(~rst_n) begin
			state <= SYNC_IDLE;
		end else begin
			state<= next_state;
		end
	end
	always@(*) begin : proc_next_state
		if(~rst_n) begin
			next_state=SYNC_IDLE;
		end else begin
			case (state)
			SYNC_IDLE: 
				if (sync_enable_rising_edge) begin
					if (is_slave|sync_pulse_falling_edge) begin
						next_state=SYNC_SIGNAL;// slave trigger 
					end else 
						next_state=SYNC_IDLE;// no trigger in
				end else 
					    next_state=SYNC_IDLE;
			SYNC_SIGNAL:
				if (sync_pulse) begin
					next_state=WAIT_FOR_STABLE;
				end else 
					next_state=SYNC_SIGNAL;
			WAIT_FOR_STABLE:
				if (wait_counter[2]) begin
					next_state=SYNC_IDLE;
				end else 
					next_state=WAIT_FOR_STABLE;
			default : next_state=SYNC_IDLE;
			endcase
		end
	end	
generate
	if (ACTIVE_RISING_EDGE==1) begin
		assign trigger_out_wire=~(master_trigger&(~sync_pulse));// when solo mode ,sync_pulse can always be zero or 1
	end else begin
		assign trigger_out_wire=(master_trigger&(~sync_pulse));
	end
endgenerate


	always_ff @(posedge ref_clk) begin : proc_solo_mode
		solo_mode<=~enable_high_precision_synchronization;
	end

	//sync_enable_reg0 so there wont be a loop in here
	assign	master_trigger=solo_mode?sync_enable_reg0:(state==SYNC_SIGNAL);// delay 1clk 8ns, so slave won't triggered error


	assign trigger_out=solo_mode?sync_enable_reg0:trigger_out_wire;

generate
	if(ENABLE_POSITION_COUNT==1) begin
		always_ff @(posedge ref_clk) begin : proc_position_count//
			if(~rst_n) begin
				position_count <= 0;
			end else if(sync_enable&(state==SYNC_IDLE))begin// avoid sync_enable keep active
				position_count <= 0;
			end else if((state==SYNC_SIGNAL))begin
				position_count <= position_count+1'b1;
			end
		end
	end else
		assign position_count=1;
endgenerate

generate
	if (ENABLE_SYNC_DELAY) begin //delay rising_edge
		logic trigger_out_reg0,trigger_out_reg1;
		always_ff @(posedge ref_clk) begin : proc_trigger_out_reg
			trigger_out_reg0<=trigger_out;
			trigger_out_reg1<=trigger_out_reg0;
		end
		logic [11:0]delay_counter;
		//trigger_out_delay
		always_ff @(posedge ref_clk) begin : proc_delay_counter
			if(~rst_n|~trigger_out_reg1) begin
				delay_counter <= 0;
			end else if(trigger_out_reg1)begin
				delay_counter <= delay_counter+1;
			end
		end
		always_ff @(posedge ref_clk) begin : proc_trigger_out_delay
			if(delay_counter>=delay_count)begin
				trigger_out_delay <= trigger_out_reg1;
			end else if(~trigger_out_reg1)begin
				trigger_out_delay<=0;
			end
		end
	end
endgenerate

endmodule