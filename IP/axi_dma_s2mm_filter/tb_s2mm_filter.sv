
`timescale 1ns/1ps
module tb_s2mm_filter (); /* this is automatically generated */

	// clock
	logic clk;
	initial begin
		clk = '0;
		forever #(5) clk = ~clk;
	end

	// synchronous reset
	logic srstb;
	initial begin
		srstb <= '0;
		repeat(10)@(posedge clk);
		srstb <= '1;
	end

	// (*NOTE*) replace reset, clock, others
	parameter WIDTH = 32;

	logic               axis_aresetn;
	logic               s_axis_tvalid;
	logic   [WIDTH-1:0] s_axis_tdata;
	logic               s_axis_tlast;
	logic [WIDTH/8-1:0] s_axis_tkeep;
	logic               s_axis_tready;
	logic               m_axis_tvalid;
	logic   [WIDTH-1:0] m_axis_tdata;
	logic               m_axis_tlast;
	logic [WIDTH/8-1:0] m_axis_tkeep;
	logic               m_axis_tready;
	logic               en;
	logic        [25:0] counter;
	assign axis_aresetn = srstb;
	s2mm_filter #(
			.WIDTH(WIDTH)
		) inst_s2mm_filter (
			.axis_aclk     (clk),
			.axis_aresetn  (axis_aresetn),
			.s_axis_tvalid (s_axis_tvalid),
			.s_axis_tdata  (s_axis_tdata),
			.s_axis_tlast  (s_axis_tlast),
			.s_axis_tkeep  (s_axis_tkeep),
			.s_axis_tready (s_axis_tready),
			.m_axis_tvalid (m_axis_tvalid),
			.m_axis_tdata  (m_axis_tdata),
			.m_axis_tlast  (m_axis_tlast),
			.m_axis_tkeep  (m_axis_tkeep),
			.m_axis_tready (m_axis_tready),
			.en            (en),
			.counter       (counter)
		);

	task init();
		axis_aresetn  = '0;
		s_axis_tvalid = '0;
		s_axis_tdata  = '0;
		s_axis_tlast  = '0;
		s_axis_tkeep  = '0;
		m_axis_tready = '0;
		en            = '0;
		counter       = '0;
	endtask


	initial begin
		// do something

		init();
		counter = 10;
		repeat(20)@(posedge clk);
		m_axis_tready = 1;
		en            = '1;
		
		for(int i =0; i<20; i++)begin
		repeat(5)@(posedge clk);		
		s_axis_tvalid = 1'b1;
		repeat(1)@(posedge clk);		
		s_axis_tvalid = 1'b0;
		end
		
		m_axis_tready = 0;
		repeat(2)@(posedge clk);
		m_axis_tready = 1;
		repeat(20)@(posedge clk);




	end

endmodule
