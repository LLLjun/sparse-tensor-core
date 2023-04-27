`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Jun Liu
//
// Create Date: 04/21/2023 03:08:58 PM
// Design Name:
// Module Name: compact_unit
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


/*
  E.g., one group

  0 x 0 x   a0 b0 c0 d0
  0 x x 0   a1 b1 c1 d1   =>   [a1 a3] [b1 b3] [c1 c3] [d1 d3]
            a2 b2 c2 d2
            a3 b3 c3 d3

*/

module compact_unit
#(parameter M_TILE = 8, K_TILE_A = 2, N_TILE = 4,
  parameter DW_DATA = 8, DW_INT = 32,
  parameter EXPAND = 2,

  parameter K_TILE_B = K_TILE_A * EXPAND,
  parameter DW_IN_INDEX = DW_INT * M_TILE * K_TILE_A,
  parameter DW_IN_VALUE = DW_DATA * K_TILE_B * N_TILE,
  parameter DW_OUT_VALUE = DW_DATA * M_TILE * K_TILE_A * N_TILE
)
(
  input                                 clk,
  input                                 reset,
  input                                 enable,
  input [DW_IN_INDEX-1:0]               in_a_index,
  input signed [DW_IN_VALUE-1:0]        in_b_value,
  output reg signed [DW_OUT_VALUE-1:0]  out,
  output reg                            out_valid
);

  integer i, j, k;

  wire [DW_INT-1:0] index [M_TILE*K_TILE_A-1:0];
  wire [DW_DATA-1:0] value [K_TILE_B*N_TILE-1:0];

  genvar gi, gj;
  generate
    for (gi=0; gi<M_TILE; gi=gi+1) begin
      for (gj=0; gj<K_TILE_A; gj=gj+1) begin
        assign index[gi*K_TILE_A+gj] = in_a_index[DW_INT*(gi*K_TILE_A+gj)+:DW_INT];
      end
    end
    for (gi=0; gi<N_TILE; gi=gi+1) begin
      for (gj=0; gj<K_TILE_B; gj=gj+1) begin
        assign value[gi*K_TILE_B+gj] = in_b_value[DW_DATA*(gi*K_TILE_B+gj)+:DW_DATA];
      end
    end
  endgenerate


  always @(posedge reset or posedge clk) begin
    if (reset) begin : init_block
      out <= 0;
      out_valid <= 1'b0;
    end
    else begin
      if (enable) begin : execute_block
        out_valid <= 1'b1;
        for (i=0; i<M_TILE; i=i+1) begin
          for (j=0; j<N_TILE; j=j+1) begin
            for (k=0; k<K_TILE_A; k=k+1) begin
              out[DW_DATA*((i*N_TILE+j)*K_TILE_A+k)+:DW_DATA] <= value[j*K_TILE_B+index[i*K_TILE_A+k]];
            end
          end
        end
      end
      else begin
        out_valid <= 1'b0;
      end
    end
  end


endmodule
