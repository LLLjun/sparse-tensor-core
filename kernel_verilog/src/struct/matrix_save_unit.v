module matrix_save_unit 
#(parameter M_TILE = 4, N_TILE = 4,
  parameter M_EXPAND = 4,
  parameter N_SECTION = 10,
  parameter DW_DATA = 32, DW_MEM_WRITE = 2048) 
(
  input                             clk,
  input                             rst,
  input                             en,
  /* ------- controller ------- */
  input                             sel_acc_buf,
  input                             col_buf,
  input                             row_buf,
  // valid number per M_EXPAND
  input [2:0]                       block_type,
  /* ------- data ------- */
  input signed [M_TILE*M_EXPAND*N_TILE*DW_DATA-1:0] in,
  output reg signed [DW_MEM_WRITE-1:0]    out,
  output reg                              out_valid,
  // 
  output reg                              out_state
);



endmodule