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
  parameter DW_MUL = 32, DW_ADD = 32,

  parameter DW_IN = DW_MUL * N_MUL)
(
  input                       clk,
  input                       reset,
  input                       enable,
  input signed [DW_IN-1:0]    in_a,
  input signed [DW_IN-1:0]    in_b,
  input [1:0]                 in_valid,
  output signed [DW_ADD-1:0]  out
  // output out_valid
);


  localparam addin_beg = (N_MUL/2)-1;
  integer i;

  // one level input and output
  reg signed [DW_MUL-1:0]   reg_multiplier_ia [N_MUL-1:0];
  reg signed [DW_MUL-1:0]   reg_multiplier_ib [N_MUL-1:0];
  reg signed [2*DW_MUL-1:0] reg_multiplier_o  [N_MUL-1:0];
  reg signed [DW_ADD-1:0]   reg_adder_o       [N_MUL-1:0];
  // in_valid align to input, but don't know why
  reg [1:0]                 reg_in_valid;

  assign out = reg_adder_o[N_MUL-1];

  always @(posedge reset or posedge clk) begin
    if (reset) begin : init_block
      for (i=0; i<N_MUL; i=i+1) begin
        reg_multiplier_ia[i] <= 0;
        reg_multiplier_ib[i] <= 0;
        reg_multiplier_o[i] <= 0;
        reg_adder_o[i] <= 0;
        reg_in_valid <= 0;
      end
    end
    else begin
      if (enable) begin : calc_block
        // muliple
        for (i=0; i<N_MUL; i=i+1) begin
          reg_multiplier_o[i] <= reg_multiplier_ia[i] * reg_multiplier_ib[i];
        end
        // adder tree for muliple level
        for (i=0; i<N_MUL/2; i=i+1) begin
          reg_adder_o[i+addin_beg] <= reg_multiplier_o[2*i] + reg_multiplier_o[2*i+1];
        end
        // adder tree for other level
        for (i=0; i<addin_beg; i=i+1) begin
          reg_adder_o[i] <= reg_adder_o[2*i+1] + reg_adder_o[2*i+2];
        end

        reg_adder_o[N_MUL-1] <= reg_adder_o[0];

        if (reg_in_valid[1] == 1'b1) begin : write_ia_block
          integer i_v1;
          for (i_v1=0; i_v1<N_MUL; i_v1=i_v1+1) begin
            reg_multiplier_ia[i_v1] <= in_a[i_v1*DW_MUL+:DW_MUL];
          end
        end
        if (reg_in_valid[0] == 1'b1) begin : write_ib_block
          integer i_v0;
          for (i_v0=0; i_v0<N_MUL; i_v0=i_v0+1) begin
            reg_multiplier_ib[i_v0] <= in_b[i_v0*DW_MUL+:DW_MUL];
          end
        end
        reg_in_valid <= in_valid;

      end
    end

  end

endmodule
