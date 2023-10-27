

module biss_c_top #
	(
		// Users to add parameters here
		parameter integer BISS_CHANNEL_WIDTH = 8,
		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 8
	)
	(

    	output wire[BISS_CHANNEL_WIDTH-1:0] 		ma,       // master clock “MA” transmits position acquisition requests and timing information (clock) from master to encoder
    	input  wire[BISS_CHANNEL_WIDTH-1:0]  		slo,      // slave output position_data SLO信号 “SLO” transfers position position_data from encoder to master, synchronised to MA. A typical request cycle proceeds as follow
    	output wire[BISS_CHANNEL_WIDTH-1:0]		error,//error mask, active 0
    	output wire[BISS_CHANNEL_WIDTH-1:0] 		warn,//warn mask, active 0
    	output wire[7:0]	state_debug,

		input wire ext_sample_clk,
		output wire sample_clk_output,
		input  wire sample_en,//active high

		output reg [32*BISS_CHANNEL_WIDTH-1:0]s_axis_tdata,
		output reg s_axis_tvalid,
		output wire s_axis_tlast,


		// User ports ends
		// Do not modify the ports beyond this line
		// Global Clock Signal
		input wire  axi_aclk,
		// Global Reset Signal. This Signal is Active LOW
		input wire  axi_aresetn,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	
);
    function integer log2(input integer value);
      begin
        value=value-1;
        for (log2=0; value>0; log2=log2+1)
          value = value>>1;
      end
    endfunction
wire clk;
assign clk = axi_aclk;
assign rst = ~(axi_aresetn);
	reg  [BISS_CHANNEL_WIDTH-1:0]single_point_data_valid;
	reg  [31:0] single_point_data;
	wire [5:0]crc_check_value_debug;
	wire [5:0]shifted_crc_data_debug;
	wire [BISS_CHANNEL_WIDTH-1:0]ignore_crc_data;

	wire [9:0]ma_slo_delay_ticks_debug;
//axi lite register
	wire [31:0] slv_reg0;
	wire [31:0] slv_reg1;
	wire [31:0] slv_reg2;
	wire [31:0] slv_reg3;
	wire [31:0] slv_reg4;
	wire [31:0] slv_reg5;
	wire [31:0] slv_reg6;
	wire [31:0] slv_reg7;
	wire [31:0] slv_reg8;
	wire [31:0] slv_reg9;
	wire [31:0] slv_reg10;

axi_lite#(
.C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
.C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
	) i_axi_lite (
	.slv_reg0     (slv_reg0     ),
	.slv_reg1     (slv_reg1     ),
	.slv_reg2     (slv_reg2     ),
	.slv_reg3     (slv_reg3     ),
	.slv_reg4     (slv_reg4     ),
	.slv_reg5     (slv_reg5     ),
	.slv_reg6     (slv_reg6     ),
	.slv_reg7     (slv_reg7     ),
	.slv_reg8     (slv_reg8     ),
	.slv_reg9     (slv_reg9     ),
	.slv_reg10    (slv_reg10    ),
	//input 
	.slv_reg11    (shifted_crc_data_debug    ),
	.slv_reg12    (crc_check_value_debug    ),
	//input
	.slv_reg13    (single_point_data_valid    ),//slv_reg13
	.slv_reg14    (single_point_data    ),//slv_reg14
	.slv_reg15    (ma_slo_delay_ticks_debug),
	.S_AXI_ACLK   (axi_aclk   ),
	.S_AXI_ARESETN(axi_aresetn),
	.S_AXI_AWADDR (S_AXI_AWADDR ),
	.S_AXI_AWVALID(S_AXI_AWVALID),
	.S_AXI_AWREADY(S_AXI_AWREADY),
	.S_AXI_WDATA  (S_AXI_WDATA  ),
	.S_AXI_WVALID (S_AXI_WVALID ),
	.S_AXI_WREADY (S_AXI_WREADY ),
	.S_AXI_BRESP  (S_AXI_BRESP  ),
	.S_AXI_BVALID (S_AXI_BVALID ),
	.S_AXI_BREADY (S_AXI_BREADY ),
	.S_AXI_ARADDR (S_AXI_ARADDR ),
	.S_AXI_ARVALID(S_AXI_ARVALID),
	.S_AXI_ARREADY(S_AXI_ARREADY),
	.S_AXI_RDATA  (S_AXI_RDATA  ),
	.S_AXI_RRESP  (S_AXI_RRESP  ),
	.S_AXI_RVALID (S_AXI_RVALID ),
	.S_AXI_RREADY (S_AXI_RREADY )
);
	

	wire soft_reset;
	assign soft_reset = slv_reg0[0];//default should be 0, no soft_reset
	wire is_ext_sample_clk;
	assign is_ext_sample_clk = slv_reg1[0];
	wire is_single_point_mode;
	assign is_single_point_mode = slv_reg2[0];
	wire single_point_data_read_en;
	assign single_point_data_read_en = slv_reg3[0];
	reg single_point_data_read_en_reg;
	wire single_point_data_read_en_posedge;
	assign single_point_data_read_en_posedge = single_point_data_read_en&(~single_point_data_read_en_reg);
	always @(posedge clk) begin
		single_point_data_read_en_reg <= single_point_data_read_en;
	end

	
	wire clk_i;
	wire internel_sample_clk;
	reg internel_sample_clk_reg;
	wire internel_sample_clk_posedge;
	assign internel_sample_clk_posedge = internel_sample_clk&(~internel_sample_clk_reg);
	always @(posedge clk) begin
		internel_sample_clk_reg<=internel_sample_clk;
	end
	wire [27:0] internel_sample_clk_high_ticks;
	wire [27:0] internel_sample_clk_low_ticks;
	assign internel_sample_clk_high_ticks = slv_reg4[27:0];
	assign internel_sample_clk_low_ticks = internel_sample_clk_high_ticks;
	assign clk_i = clk;
clk_div #(
	.DEFAULT_LEVEL(0),
	.DYNAMIC_RECONFIG(1)
	)i_internel_sampleclk_div (
	.clk_i     (clk_i     ),
	.rst_ni    (~soft_reset  ),
	.en        (sample_en    ),
	.clk_o     (internel_sample_clk     ),
	.high_ticks(internel_sample_clk_high_ticks),
	.low_ticks (internel_sample_clk_low_ticks )
);

	reg ext_sample_clk_reg;
	wire ext_sample_clk_posedge;
	always @(posedge clk) begin
		ext_sample_clk_reg<=ext_sample_clk&sample_en;
	end
	assign ext_sample_clk_posedge = ext_sample_clk & (~ext_sample_clk_reg);

	reg request;
	wire [7:0] resolution_bits;
	assign resolution_bits = slv_reg6[7:0];
	reg [7:0] ma_clk_divider;
	//assign ma_clk_divider = slv_reg5[7:0];
	always @(posedge clk) begin
		ma_clk_divider<=slv_reg5[7:0];
	end
	wire [31:0] position_data[BISS_CHANNEL_WIDTH-1:0];
	wire [BISS_CHANNEL_WIDTH-1:0]position_data_valid;
always @(posedge clk) begin : proc_request
	if(is_single_point_mode) begin
		request <= single_point_data_read_en_posedge;
	end else if(is_ext_sample_clk==1'b1) begin
		request <= ext_sample_clk_posedge;//externel mode
	end else begin
		request <= internel_sample_clk_posedge;//internel mode
	end
end

assign sample_clk_output = ext_sample_clk?ext_sample_clk:internel_sample_clk;
assign ignore_crc_data = slv_reg7;
reg [31:0] channel_enable; // active low
//assign channel_enable = slv_reg8;

reg [log2(BISS_CHANNEL_WIDTH)-1:0]channel_index;// = slv_reg9;//channel numbers for multichannel configuration ,N-1
always @(posedge clk) begin
	channel_index<=slv_reg9;
	channel_enable<=slv_reg8;
end
wire [7:0]state_debug_internel[BISS_CHANNEL_WIDTH-1:0];
assign state_debug = state_debug_internel[channel_index];//channel 0

wire [5:0]crc_check_value_debug_internel  [BISS_CHANNEL_WIDTH-1:0];
wire [5:0]shifted_crc_data_debug_internel [BISS_CHANNEL_WIDTH-1:0];
wire [9:0]ma_slo_delay_ticks [BISS_CHANNEL_WIDTH-1:0];
wire [BISS_CHANNEL_WIDTH-1:0]if_shift_ma_clk;
assign if_shift_ma_clk = slv_reg10;
assign crc_check_value_debug = crc_check_value_debug_internel[channel_index];
assign shifted_crc_data_debug = shifted_crc_data_debug_internel[channel_index];
assign ma_slo_delay_ticks_debug = ma_slo_delay_ticks[channel_index];

genvar i;
for (i = 0; i < BISS_CHANNEL_WIDTH; i = i+1) begin
	biss_c i_biss_c (
		.clk                (clk                ),
		.rst                (rst |  soft_reset  | channel_enable[i]),
		.request            (request            ),
		.resolution_bits    (resolution_bits    ),
		.ma_clk_divider     (ma_clk_divider     ),
		.ma                 (ma[i]                 ),
		.slo                (slo[i]                ),
		.position_data      (position_data[i]      ),
		.position_data_valid(position_data_valid[i]),
		.error              (error[i]              ),
		.warn               (warn[i]               ),
		.state_debug        (state_debug_internel[i]),
		.ignore_crc_data    (ignore_crc_data[i]),
		.if_shift_ma_clk       (if_shift_ma_clk[i]),
		.ma_slo_delay_ticks    (ma_slo_delay_ticks[i]),
		.crc_check_value_debug (crc_check_value_debug_internel[i]),
		.shifted_crc_data_debug(shifted_crc_data_debug_internel[i])
	);
	
	always @(posedge clk) begin : proc_s_axis_tdata
		s_axis_tdata[(32*i+32-1) : 32*i]<=position_data[i];
	end
end

//assign s_axis_tdata = position_data;
//assign s_axis_tvalid = |position_data_valid;

always @(posedge clk) begin : proc_single_point_data
	if(rst |  soft_reset)
		single_point_data <= 0;
	else if(position_data_valid[channel_index]) begin
		single_point_data <= position_data[channel_index];
	end 
end
always @(posedge clk) begin : proc_single_point_data_valid
	if(rst |  soft_reset ) begin
		single_point_data_valid <= 0;
	end else if(position_data_valid!=0) begin
		single_point_data_valid <= position_data_valid;
	end
end



/**要考虑不同channel数据到达时间不一致的情形
* 1、all delay N ticks
* 2 check if all channels valid before next sample clock
*
**/
reg [27:0] delay_counter;
reg output_data_valid_flag;
always @(posedge clk) begin : proc_output_data_valid_flag
	if(s_axis_tvalid==1'b1 || rst ||  soft_reset) begin
		output_data_valid_flag <= 0;
	end else if(position_data_valid!=0) begin
		output_data_valid_flag <= 1'b1;
	end
end
always @(posedge clk) begin : proc_delay_counter
	if(s_axis_tvalid==1'b1 || rst ||  soft_reset) begin
		delay_counter <= 0;
	end else if(output_data_valid_flag==1'b1) begin
		delay_counter <= delay_counter + 1'b1;
	end
end
always @(posedge clk) begin : proc_s_axis_tvalid
	if (s_axis_tvalid==1'b1 || rst ||  soft_reset) begin
		s_axis_tvalid<=0;
	end else if (delay_counter==internel_sample_clk_high_ticks) begin
		s_axis_tvalid<=output_data_valid_flag;
	end	
end


assign s_axis_tlast = s_axis_tvalid;

endmodule : biss_c_top


