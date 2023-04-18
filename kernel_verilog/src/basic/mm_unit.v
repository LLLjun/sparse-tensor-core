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


// m,k,n = 16,16,16 8bit
// m_tile,k_tile,n_tile = 4,4,4

module mm_unit
#(parameter M = 16, K = 16, N = 16,
  // parameter M_TILE = 4, K_TILE = 4, N_TILE = 4,
  parameter N_GROUP = 4, N_MUL = 4, N_UNIT = 4,   // m_tile,k_tile,n_tile
  parameter DW_MUL = 8,
  parameter DW_ADD = 32,
  parameter DW_CORE_IN_A = DW_MUL * N_MUL * N_GROUP,
  parameter DW_CORE_IN_B = DW_MUL * N_MUL * N_UNIT,
  parameter DW_CORE_OUT = DW_ADD * N_UNIT * N_GROUP,
  parameter DW_MM_OUT = DW_ADD * N,  // 一行
  parameter DW_INT = 8,
  parameter W_SHIFT = 5)
(
  input clk,
  input reset,
  input enable,
  input [DW_INT-1:0]                ptr_m, ptr_n,
  input signed [DW_CORE_IN_A-1:0]   in_a,
  input signed [DW_CORE_IN_B-1:0]   in_b,
  input [1:0]                       in_valid,
  output signed [DW_MM_OUT-1:0]   out
);

  // shift for adder tree
  reg [DW_INT-1:0] ptr_shift_m [W_SHIFT-1:0];
  reg [DW_INT-1:0] ptr_shift_n [W_SHIFT-1:0];
  wire signed [DW_CORE_OUT-1:0] psum;
  // todo
  reg psum_valid;


  always @(posedge clk) begin
    if (reset) begin : init_block
      integer i;
      for (i=0; i<W_SHIFT; i=i+1) begin
        ptr_shift_m[i] <= 0;
        ptr_shift_n[i] <= 0;
      end
      // psum <= 0;
      psum_valid <= 1'b0;
    end
    else begin
      if (enable) begin : execute_block
        integer i;
        for (i=0; i<W_SHIFT-1; i=i+1) begin
          ptr_shift_m[i] <= ptr_shift_m[i+1];
          ptr_shift_n[i] <= ptr_shift_n[i+1];
        end
        ptr_shift_m[W_SHIFT-1] <= ptr_m;
        ptr_shift_n[W_SHIFT-1] <= ptr_n;

        // todo
        psum_valid <= 1'b1;
      end
    end
  end


core #(
  .N_GROUP(N_GROUP),
  .N_UNIT(N_UNIT),
  .N_MUL(N_MUL),
  .DW_MUL(DW_MUL),
  .DW_ADD(DW_ADD)
)
u_core (
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .in_a(in_a),
  .in_b(in_b),
  .in_valid(in_valid),
  .out(psum)
);

mm_adder #(
  .M(M), .N(N),
  .M_TILE(N_GROUP), .N_TILE(N_UNIT),
  .DW_ADD(DW_ADD),
  .DW_INT(DW_INT)
)
u_mm_adder (
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .ptr_row(ptr_shift_m[0]), .ptr_col(ptr_shift_n[0]),
  .in(psum),
  .in_valid(psum_valid),
  .out(out)
);


endmodule
