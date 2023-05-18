`timescale 1ns / 1ps

module reduction_network_fp32
#(parameter DW_DATA = 32,

  parameter NUM_IN = 8,
  parameter DW_IN = NUM_IN * DW_DATA)
(
  input                         clk,
  input                         rst,
  input                         func,
  input signed [DW_IN-1:0]      in,
  output signed [4*DW_DATA-1:0] out
);

  // localparam ADDER_LEVEL = $clog2(NUM_IN);
  localparam NUM_ADDER = NUM_IN / 2;
  localparam NUM_RNER = NUM_IN - 1 - NUM_ADDER;
  integer i;
  genvar gi;

  reg signed [DW_DATA-1:0]    reg_adder_o   [NUM_ADDER-1:0];
  wire [DW_DATA-1:0] wire_add_result [NUM_IN/2-1:0];
  wire signed [DW_DATA-1:0]   wire_adder_in [NUM_IN-1:0];
  wire signed [2*DW_DATA-1:0] wire_rn1_o    [1:0];
  wire [NUM_IN/2-1:0] s_axis_a_tready, s_axis_b_tready, m_axis_result_tvalid;

  always @(posedge rst or posedge clk) begin
    if (rst) begin : init_block
      for (i=0; i<NUM_ADDER; i=i+1) begin
        reg_adder_o[i]  <= 0;
      end
    end
    else begin : calc_block
      // @xiahao: use IP, FP32+FP32->FP32
      // adder tree for input level
      for (i=0; i<NUM_IN/2; i=i+1) begin
        // reg_adder_o[i] <= wire_adder_in[2*i] + wire_adder_in[2*i+1];
        reg_adder_o[i] <= wire_add_result[i];
      end
    end
  end

  generate
    for (gi=0; gi<NUM_IN; gi=gi+1) begin
      assign wire_adder_in[gi] = in[DW_DATA*gi+: DW_DATA];
    end
  endgenerate

  generate
    for (gi=0; gi<NUM_IN/2; gi=gi+1) begin: fp_add
      floating_point_1 your_instance_name (
        .aclk(clk),                                  // input wire aclk
        .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
        .s_axis_a_tready(s_axis_a_tready[gi]),            // output wire s_axis_a_tready
        .s_axis_a_tdata(wire_adder_in[2*gi]),              // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
        .s_axis_b_tready(s_axis_b_tready[gi]),            // output wire s_axis_b_tready
        .s_axis_b_tdata(wire_adder_in[2*gi+1]),              // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(m_axis_result_tvalid[gi]),  // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
        .m_axis_result_tdata(wire_add_result[gi])    // output wire [31 : 0] m_axis_result_tdata
      );
    end
  endgenerate

  generate
    for (gi=0; gi<2; gi=gi+1) begin : u_rn1_unit
      rn_node #(
        .DW_DATA(DW_DATA),
        .NUM_IN_SECTION(1)
      ) 
      rn_node_inst (
        .clk(clk),
        .rst(rst),
        .in_a(reg_adder_o[2*gi]),
        .in_b(reg_adder_o[2*gi+1]),
        .func(func),
        .out(wire_rn1_o[gi])
      );
    end
    for (gi=0; gi<1; gi=gi+1) begin : u_rn2_unit
      rn_node #(
        .DW_DATA(DW_DATA),
        .NUM_IN_SECTION(2)
      ) 
      rn_node_inst (
        .clk(clk),
        .rst(rst),
        .in_a(wire_rn1_o[0]),
        .in_b(wire_rn1_o[1]),
        .func(func),
        .out(out)
      );
    end
  endgenerate

endmodule


module rn_node 
#(parameter DW_DATA = 32,
  parameter NUM_IN_SECTION = 2,

  parameter DW_IN = DW_DATA * NUM_IN_SECTION,
  parameter DW_OUT = DW_IN * 2)
(
  input                       clk,
  input                       rst,
  input signed [DW_IN-1:0]    in_a,
  input signed [DW_IN-1:0]    in_b,
  input                       func,
  output signed [DW_OUT-1:0]  out
);

  integer i;

  wire [DW_DATA-1:0] wire_add_result;
  reg signed [DW_DATA-1:0] out_reg [2*NUM_IN_SECTION-1:0];
  wire s_axis_a_tready, s_axis_b_tready, m_axis_result_tvalid;

  genvar gi;
  generate
    for (gi=0; gi<2*NUM_IN_SECTION; gi=gi+1) begin
      assign out[DW_DATA*gi+: DW_DATA] = out_reg[gi];
    end
  endgenerate

  always @(posedge clk or posedge rst) begin
    if (rst) begin : init_block
      for (i=0; i<2*NUM_IN_SECTION; i=i+1) begin
        out_reg[i] <= 0;
      end
    end
    else begin : execute_block
      // forward
      if (func) begin
        for (i=0; i<NUM_IN_SECTION; i=i+1) begin
          out_reg[i] <= in_a[DW_DATA*i+: DW_DATA];
        end
        for (i=0; i<NUM_IN_SECTION; i=i+1) begin
          out_reg[i+NUM_IN_SECTION] <= in_b[DW_DATA*i+: DW_DATA];
        end
      end
      // accumulation
      else begin
        // TODO as adder_tree_fp32
        // out_reg[0] <= in_a[0+: DW_DATA] + in_b[0+: DW_DATA];
        out_reg[0] <= wire_add_result;
        for (i=1; i<2*NUM_IN_SECTION; i=i+1) begin
          out_reg[i] <= 0;
        end
      end
    end
  end
  
  floating_point_1 your_instance_name (
        .aclk(clk),                                  // input wire aclk
        .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
        .s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
        .s_axis_a_tdata(in_a[0+: DW_DATA]),              // input wire [31 : 0] s_axis_a_tdata
        .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
        .s_axis_b_tready(s_axis_b_tready),            // output wire s_axis_b_tready
        .s_axis_b_tdata(in_b[0+: DW_DATA]),              // input wire [31 : 0] s_axis_b_tdata
        .m_axis_result_tvalid(m_axis_result_tvalid),  // output wire m_axis_result_tvalid
        .m_axis_result_tready(1'b1),  // input wire m_axis_result_tready
        .m_axis_result_tdata(wire_add_result)    // output wire [31 : 0] m_axis_result_tdata
  );


endmodule
