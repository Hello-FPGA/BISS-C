`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Create by Engineer: yaxingshi
// Create Date: 2023-02-27 11:47:09
// Last Modified by:   yaxingshi
// Last Modified time: 2023-10-30 20:02:36
// Design Name: 
// Module Name: biss_c
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

module biss_c (
    input  wire 		clk,      // clock, no more than 100Mhz
    input  wire 		rst,      // reset signal，active high
    input  wire 		request, //active at rising edge, request to read position_data from slave
    input  wire[7:0] 	resolution_bits,// encolder position data bits,26-32 		
    input  wire[7:0] 	ma_clk_divider,//ma clock divider, if clk is 100Mhz, ma_clk_divider is 25, the ma is 2Mhz = 100Mhz/(25*2), max 255
    output wire 		ma,       // master clock “MA�? transmits position acquisition requests and timing information (clock) from master to encoder
    input  wire  		slo,      // slave output position_data SLO信号 “SLO�? transfers position position_data from encoder to master, synchronised to MA. A typical request cycle proceeds as follow
    output wire [31:0] 	position_data, 	 // position data output, right aligned
    output wire 		position_data_valid,       // 数据准备好标�?
    output reg			error,//error mask, active 0
    output reg 			warn,//warn mask, active 0
    output wire[7:0]	state_debug,
    input wire ignore_crc_data,//active high
    input wire if_shift_ma_clk,//
    output reg [9:0] ma_slo_delay_ticks,
	output reg [5:0] crc_check_value_debug,
	output wire [5:0] shifted_crc_data_debug
);

//CRC CHECK
reg input_bit;
reg input_bit_valid;
wire clear_crc;
reg [5:0] crc_check_value;
wire [5:0] crc_check_value_uninverted;
//assign crc_check_value_debug = crc_check_value;
// 内部寄存�?
reg [5:0] shift_counter;//input shifted data counter
reg [31:0] shifted_position_data;//input shifted position data
reg [5:0] shifted_crc_data;//input  shifted crc data
assign shifted_crc_data_debug = shifted_crc_data;

reg [3:0] state, next_state;
reg  sample_clk;
reg   sample_clk_reg;
wire  sample_clk_fallingedge;
always @(posedge clk) begin
	sample_clk_reg<=sample_clk;
end
assign sample_clk_fallingedge = sample_clk_reg&(~sample_clk);
//assign sample_clk = ma;
assign state_debug = state; 
// 状�?�机定义
localparam IDLE = 0;
localparam REQUEST = 1;
localparam WAIT_START = 2;
localparam REVEIVE_ZERO = 3;
localparam RECEIVE_POSITION_DATA = 4;
localparam RECEIVE_ERROR = 5;
localparam RECEIVE_WARNING = 6;
localparam RECEIVE_CRC = 7;
localparam CHECK_CRC = 8;
localparam OUTPUT_DATA = 9;

// 状�?�转�?
always @(posedge clk) begin : proc_state
	if(rst ) begin
		state <= IDLE;
	end else begin
		state <= next_state;
	end
end

always @(*) begin : proc_next_state
	if (rst) begin
		next_state = IDLE;
	end else begin
		case (state)
		IDLE: 
			if (request==1'b1 && slo==1'b1) begin
				next_state = REQUEST;
			end else begin
				next_state = IDLE;
			end
		REQUEST://avoid miss the request
			if (sample_clk_fallingedge==1'b1 && slo==1'b0) begin
				next_state = WAIT_START;
			end else begin
				next_state = REQUEST;
			end
		WAIT_START:
			if (sample_clk_fallingedge==1'b1 &&slo==1'b1) begin
				next_state = REVEIVE_ZERO;
			end else begin
				next_state = WAIT_START;
			end
		REVEIVE_ZERO:
			if (sample_clk_fallingedge==1'b1 &&slo==1'b0) begin
				next_state = RECEIVE_POSITION_DATA;
			end else begin
				next_state = REVEIVE_ZERO;
			end
		RECEIVE_POSITION_DATA:
			if (shift_counter==resolution_bits) begin
				next_state = RECEIVE_ERROR;
			end else begin
				next_state = RECEIVE_POSITION_DATA;
			end
		RECEIVE_ERROR:
			if (sample_clk_fallingedge==1'b1) begin
				next_state = RECEIVE_WARNING;
			end else begin
				next_state = RECEIVE_ERROR;
			end
		RECEIVE_WARNING:
			if (sample_clk_fallingedge==1'b1) begin
				next_state = RECEIVE_CRC;
			end else begin
				next_state = RECEIVE_WARNING;
			end
		RECEIVE_CRC:
			if (shift_counter== 6) begin
				next_state = CHECK_CRC;
			end else begin
				next_state = RECEIVE_CRC;
			end
		CHECK_CRC:
			if (sample_clk==1'b1) begin
				next_state = OUTPUT_DATA;
			end else begin
				next_state = CHECK_CRC;
			end
		OUTPUT_DATA: 
			next_state = IDLE;		
		default : next_state = IDLE;
		endcase
	end
end

//receive shift position_data ,MSB first 

always @(posedge clk) begin : proc_shift_counter
	if(state==RECEIVE_POSITION_DATA || state == RECEIVE_CRC) begin
		if (sample_clk_fallingedge==1'b1) begin
			shift_counter <= shift_counter + 1'b1;
		end		
	end else begin
		shift_counter <= 0;
	end
end

always @(posedge clk) begin : proc_shifted_data
	if(rst||state==REQUEST) begin
		shifted_position_data <= 0;
	end else if(state==RECEIVE_POSITION_DATA && sample_clk_fallingedge==1'b1) begin
		shifted_position_data <= {shifted_position_data[30:0], slo};
	end else if (state == CHECK_CRC && shifted_crc_data!=crc_check_value && (ignore_crc_data==1'b0)) begin
		shifted_position_data <= 'hffffffff;//-1 error data
	end else if (state == CHECK_CRC && error==1'b0) begin
		shifted_position_data <= 'hfffffffe;//-2 error data
	end
end
assign position_data = shifted_position_data;
assign position_data_valid = state == OUTPUT_DATA;

always @(posedge clk) begin : proc_error
	if(rst) begin
		error <= 1'b1;// 1 means right code, 0 means error  code
	end else if(state == RECEIVE_ERROR) begin
		error <= slo;
	end
end

always @(posedge clk) begin : proc_warn
	if(rst) begin
		warn <= 1'b1;//0 means user should clear the sensor
	end else if(state == RECEIVE_WARNING) begin
		warn <= slo;
	end
end

always @(posedge clk) begin : proc_shifted_crc_data
	if(rst) begin
		shifted_crc_data <= 0;
	end else if(state == RECEIVE_CRC && sample_clk_fallingedge == 1'b1) begin
		shifted_crc_data <= {shifted_crc_data[4:0], slo};
	end
end

//sample_clk



//inst sample clcok output

	wire clk_i;
	wire rst_ni;
	wire clk_o;
	wire [27:0] high_ticks;
	wire [27:0] low_ticks;
	assign clk_i = clk;
	assign rst_ni = (state!=IDLE) ;
	assign high_ticks = ma_clk_divider;
	assign low_ticks = ma_clk_divider;
	assign ma = clk_o;


clk_div #(
	.DEFAULT_LEVEL(1),//default clk output level,0 or 1
	.DYNAMIC_RECONFIG(1)
	) i_clk_div (
	.clk_i     (clk_i     ),
	.rst_ni    (rst_ni    ),
	.en        (1'b1      ),
	.clk_o     (clk_o     ),
	.high_ticks(high_ticks),
	.low_ticks (low_ticks )
);
//get the delay ticks
wire ma_clk_posedge;
reg ma_clk_reg;
reg ma_clk_reg2;
reg ma_clk_reg3;
reg [7:0] ma_clk_counter;
//reg [9:0] ma_slo_delay_ticks;
reg measure_delay;
always @(posedge clk) begin : proc_ma_clk_reg
	ma_clk_reg<=ma;
	ma_clk_reg2<=ma_clk_reg;
	ma_clk_reg3<=ma_clk_reg2;
end
assign ma_clk_posedge= ma&(~ma_clk_reg);
always @(posedge clk) begin : proc_ma_clk_counter
	if(state==IDLE || rst ==1'b1) begin
		ma_clk_counter <= 0;
	end else if(ma_clk_posedge==1'b1) begin
		ma_clk_counter <= ma_clk_counter + 1'b1;
	end
end
always @(posedge clk) begin : proc_measure_delay
	if(state==IDLE)begin
		measure_delay <= 1'b0;
	end else if(ma_clk_counter==2 && slo==1'b1) begin
		measure_delay <= 1'b1;
	end else if(slo==1'b0) begin
		measure_delay <= 1'b0;
	end
end
always @(posedge clk) begin : proc_delay_counter
	if(rst) begin
		ma_slo_delay_ticks <= 1;
	end else if(measure_delay==1'b1) begin
		ma_slo_delay_ticks <= ma_slo_delay_ticks+1;
	end 
end

always @(posedge clk) begin
	if(if_shift_ma_clk==1'b1) begin
		sample_clk <= ma_clk_reg3;
	end else begin
		sample_clk <= ma;
	end
end


//crc check logic
always @(posedge clk) begin
	if(state==RECEIVE_POSITION_DATA || state == RECEIVE_ERROR || state ==RECEIVE_WARNING) begin
		input_bit_valid <= sample_clk_fallingedge==1'b1;
		input_bit <=slo;
	end else begin
		input_bit_valid <= 1'b0;
		input_bit <=1'b0;
	end
end
assign clear_crc = state==IDLE;
CRC_Unit inst_CRC_Unit (
	.CLK(clk),
	.BITVAL(input_bit), 
	.BITSTRB(input_bit_valid), 
	.CLEAR(clear_crc), 
	.CRC(crc_check_value_uninverted));

always @(posedge clk) begin : proc_crc_check_value_uninverted
	crc_check_value<=~crc_check_value_uninverted;
end

always @(posedge clk) begin : proc_crc_check_value_debug
	if(rst) begin
		crc_check_value_debug <= 0;
	end else if(position_data_valid) begin
		crc_check_value_debug <= crc_check_value;
	end
end
endmodule
