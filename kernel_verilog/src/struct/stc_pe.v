`timescale 1ns / 1ps


module stc_pe
#(parameter N_MUL = 8,
  parameter DW_MUL = 32, DW_ADD = 32,

  parameter DW_IN = DW_MUL * N_MUL)
(
  input                         clk,
  input                         rst,
  input signed [DW_IN-1:0]      in_a,
  input signed [DW_IN-1:0]      in_b,
  output signed [4*DW_ADD-1:0]  out
);

  integer i;

  reg signed [DW_ADD-1:0] reg_multiplier_o [N_MUL-1:0];
  wire signed [DW_MUL-1:0] in_a_wire [N_MUL-1:0];
  wire signed [DW_MUL-1:0] in_b_wire [N_MUL-1:0];
  wire signed [DW_ADD*N_MUL-1:0] multiplier_o;

  genvar gi;
  generate
    for (gi=0; gi<N_MUL; gi=gi+1) begin
      assign multiplier_o[DW_ADD*gi+: DW_ADD] = reg_multiplier_o[gi];
    end
  endgenerate

  always @(posedge rst or posedge clk) begin
    if (rst) begin : init_block
      for (i=0; i<N_MUL; i=i+1) begin
        reg_multiplier_o[i] <= 0;
      end
    end
    else begin : excute_block
      // @xiahao: use DSP IP, FP32*FP32->FP32
      for (i=0; i<N_MUL; i=i+1) begin
        reg_multiplier_o[i] <= in_a_wire[i] * in_b_wire[i];
      end
    end
  end

  reduction_network_fp32 u_reduction_network_fp32 (
    .clk(clk),
    .rst(rst),
    .func(func),
    .in(multiplier_o),
    .out(out)
  );

endmodule
