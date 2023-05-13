`timescale 1ns / 1ps


// parallel 4 4 4, 8bit

module dp_group #(
  parameter N_UNIT = 32,
  parameter DW_DATA = 8
)(
  input clk,
  input reset,
  input enable,
  input signed [N_UNIT*DW_DATA-1:0]    in_a,
  input signed [N_UNIT*DW_DATA-1:0]    in_b,
  input [1:0]                   in_valid,
  output signed [N_UNIT*DW_DATA-1:0]  out
);

  genvar i;
  generate
    for (i=0; i<N_UNIT; i=i+1) begin: u_dp_unit
      dp_unit #(
        .DW_DATA(DW_DATA)
      )
      dp_unit_inst(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in_a(in_a[i*DW_DATA +:DW_DATA]),
        .in_b(in_b[i*DW_DATA +:DW_DATA]),
        .in_valid(in_valid),
        .out(out[i*DW_DATA +:DW_DATA])
      );
    end
  endgenerate

endmodule
