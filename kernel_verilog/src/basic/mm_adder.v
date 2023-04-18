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

module mm_adder
#(parameter M = 16, N = 16,
  parameter M_TILE = 4, N_TILE = 4,
  parameter DW_ADD = 32,
  parameter DW_IN = DW_ADD * M_TILE * N_TILE,
  parameter DW_OUT = DW_ADD * N,     // 每次一行输出
  parameter DW_INT = 8
)
(
  input clk,
  input reset,
  input enable,
  input [DW_INT-1:0]          ptr_row, ptr_col,
  input signed [DW_IN-1:0]    in,
  input                       in_valid,
  output signed [DW_OUT-1:0]  out
);

  reg signed [DW_ADD-1:0] global_buffer [M*N-1:0];
  // reg signed [DW_ADD-1:0] reg_in [M_TILE*N_TILE-1:0];
  // 处理什么时候输出的问题
  
  // parameter compare = N / N_TILE - 1;
  // reg [DW_INT-1:0] cnt_in;


  always @(posedge clk) begin
    if (reset) begin : init_block
      integer i;
      for (i=0; i<M*N; i=i+1) begin
        global_buffer[i] <= 0;
      end
      // out_valid <= 0;
    end
    else begin
      if (enable) begin
        if (in_valid) begin : execute_block
          integer i, j;
          for (i=0; i<M_TILE; i=i+1) begin
            for (j=0; j<N_TILE; j=j+1) begin
              global_buffer[(ptr_row*M_TILE+i)*N+(ptr_col*N_TILE+j)] <= in[DW_ADD*(i*N_TILE+j)+:DW_ADD] + global_buffer[(ptr_row*M_TILE+i)*N+(ptr_col*N_TILE+j)];
            end
          end
        end
      end
    end
  end



endmodule
