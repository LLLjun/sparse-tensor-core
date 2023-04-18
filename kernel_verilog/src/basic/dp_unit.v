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

module dp_unit
#(parameter N_MUL = 4,
  parameter DW_MUL = 8,
  parameter DW_ADD = 32,
  parameter DW_IN = DW_MUL * N_MUL)
(
  input clk,
  input reset,
  input enable,
  input signed [DW_IN-1:0]    in_a,
  input signed [DW_IN-1:0]    in_b,
  // input signed [DW_IN-1:0]    in_psum,
  input [1:0]                   in_valid,
  output signed [DW_ADD-1:0]  out
  // output out_valid
);

  // one level input and output
  reg signed [DW_MUL-1:0] reg_multiplier_ia [N_MUL-1:0];
  reg signed [DW_MUL-1:0] reg_multiplier_ib [N_MUL-1:0];
  reg signed [2*DW_MUL-1:0] reg_multiplier_o [N_MUL-1:0];
  reg signed [DW_ADD-1:0] reg_adder_o [N_MUL-1:0];
  // reg signed [DW_ADD-1:0] sum;
  parameter j = (N_MUL/2)-1;
  
  assign out = reg_adder_o[N_MUL-1];

  always @(posedge clk) begin
    if (reset) begin : init_block
      integer i;
      for (i=0; i<N_MUL; i=i+1) begin
        reg_multiplier_ia[i] <= 0;
        reg_multiplier_ib[i] <= 0;
        reg_multiplier_o[i] <= 0;
        reg_adder_o[i] <= 0;
      end
    end
    else begin
      if (enable) begin : calc_block
        integer i;
        for (i=0; i<N_MUL; i=i+1) begin
          reg_multiplier_o[i] <= reg_multiplier_ia[i] * reg_multiplier_ib[i];
        end
        // adder tree input
        for (i=0; i<N_MUL/2; i=i+1) begin
          reg_adder_o[i+j] <= reg_multiplier_o[2*i] + reg_multiplier_o[2*i+1];
        end
        // adder tree
        for (i=0; i<j; i=i+1) begin
          reg_adder_o[i] <= reg_adder_o[2*i+1] + reg_adder_o[2*i+2];
        end

        reg_adder_o[N_MUL-1] <= reg_adder_o[0];

        if (in_valid[1] == 1'b1) begin : write_ia_block
          integer i_v1;
          for (i_v1=0; i_v1<N_MUL; i_v1=i_v1+1) begin
            // bug: 7e <= fe (why?)
            reg_multiplier_ia[i_v1] <= in_a[i_v1*DW_MUL+:DW_MUL];
          end
        end
        if (in_valid[0] == 1'b1) begin : write_ib_block
          integer i_v0;
          for (i_v0=0; i_v0<N_MUL; i_v0=i_v0+1) begin
            reg_multiplier_ib[i_v0] <= in_b[i_v0*DW_MUL+:DW_MUL];
          end
        end

      end
    end

  end

endmodule
