`timescale 1ns / 1ps

module adder_tree_fp32
#(parameter NUM_IN = 8,

  parameter DW_DATA = 32,
  parameter DW_IN = NUM_IN * DW_DATA)
(
  input                         clk,
  input                         rst,
  input signed [DW_IN-1:0]      in,
  output signed [DW_DATA-1:0]   out
);

  // localparam ADDER_LEVEL = $clog2(NUM_IN);
  localparam NUM_ADDER = NUM_IN - 1;
  localparam ADDER_IN_BEG = (NUM_IN/2) - 1;
  integer i;
  genvar gi;

  wire signed [DW_DATA-1:0] wire_adder_in [NUM_IN-1:0];
  reg signed [DW_DATA-1:0]  reg_adder_o   [NUM_ADDER-1:0];

  assign out = reg_adder_o[0];
  generate
    for (gi=0; gi<NUM_IN; gi=gi+1) begin
      assign wire_adder_in[gi] = in[DW_DATA*gi+: DW_DATA];
    end
  endgenerate

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
        reg_adder_o[i+ADDER_IN_BEG] <= wire_adder_in[2*i] + wire_adder_in[2*i+1];
      end
      // adder tree for other level
      for (i=0; i<ADDER_IN_BEG; i=i+1) begin
        reg_adder_o[i] <= reg_adder_o[2*i+1] + reg_adder_o[2*i+2];
      end
    end
  end

endmodule
