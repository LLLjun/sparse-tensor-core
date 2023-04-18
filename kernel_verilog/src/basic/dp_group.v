`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jun Liu
// 
// Create Date: 04/05/2023 03:08:58 PM
// Design Name: 
// Module Name: core
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

module dp_group
#(parameter N_UNIT = 4,
  parameter N_MUL = 4,
  parameter DW_MUL = 8,
  parameter DW_ADD = 32,
  parameter DW_UNIT_IN = DW_MUL * N_MUL)
(
  input clk,
  input reset,
  input enable,
  input signed [DW_UNIT_IN-1:0]    in_a,
  input signed [N_UNIT*DW_UNIT_IN-1:0]    in_b,
  input [1:0]                   in_valid,
  output signed [N_UNIT*DW_ADD-1:0]  out
);

  genvar i;
  generate
    for (i=0; i<N_UNIT; i=i+1) begin: u_dp_unit
      dp_unit #(
        .N_MUL(N_MUL),
        .DW_MUL(DW_MUL),
        .DW_ADD(DW_ADD)
      )
      dp_unit_inst(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in_a(in_a),
        .in_b(in_b[(i+1)*DW_UNIT_IN-1:i*DW_UNIT_IN]),
        .in_valid(in_valid),
        .out(out[(i+1)*DW_ADD-1:i*DW_ADD])
      );
    end
  endgenerate

endmodule
