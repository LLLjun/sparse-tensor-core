`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Jun Liu
//
// Create Date: 04/05/2023 03:08:58 PM
// Design Name:
// Module Name: sp_core
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


// parallel 4 4 4, 8bit

module sp_core
#(parameter N_GROUP = 8, N_UNIT = 4, N_MUL = 2,
  parameter DW_MUL = 8, DW_ADD = 32,

  parameter DW_CORE_IN_A = DW_MUL * N_MUL * N_GROUP,
  parameter DW_CORE_IN_B = DW_MUL * N_GROUP * N_MUL * N_UNIT,     // 本质上位宽都是这么大，只不过这里提前了
  parameter DW_CORE_OUT = DW_ADD * N_UNIT * N_GROUP,
  parameter DW_UNIT_IN_A = DW_MUL * N_MUL,
  parameter DW_GROUP_IN_B = DW_MUL * N_UNIT * N_MUL)
(
  input                               clk,
  input                               reset,
  input                               enable,
  input signed [DW_CORE_IN_A-1:0]     in_a,
  input signed [DW_CORE_IN_B-1:0]     in_b,
  input [1:0]                         in_valid,
  output signed [DW_CORE_OUT-1:0]     out
);

  genvar i;
  generate
    for (i=0; i<N_GROUP; i=i+1) begin: u_dp_group
      dp_group #(
        .N_UNIT       (N_UNIT),
        .N_MUL        (N_MUL),
        .DW_MUL       (DW_MUL),
        .DW_ADD       (DW_ADD)
      )
      dp_group_inst(
        .clk          (clk),
        .reset        (reset),
        .enable       (enable),
        .in_a         (in_a[DW_UNIT_IN_A*i+:DW_UNIT_IN_A]),
        .in_b         (in_b[DW_GROUP_IN_B*i+:DW_GROUP_IN_B]),    // different with basic
        .in_valid     (in_valid),
        .out          (out[DW_ADD*N_UNIT*i+:DW_ADD*N_UNIT])
      );
    end
  endgenerate

endmodule
