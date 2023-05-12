`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Jun Liu
//
// Create Date: 04/07/2023 02:05:40 PM
// Design Name:
// Module Name: tb_basic
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


module tb_basic();
// parameter setup
parameter M = 16, K = 16, N = 16;
parameter M_TILE = 4, K_TILE = 4, N_TILE = 4;
parameter DW_MUL = 8, DW_ADD = 32, DW_INT = 32;
parameter W_SHIFT = 5;      // delay cycle

parameter DW_MEM_IN_I = DW_MUL * K;

localparam all_cycle = M*K*N/M_TILE/K_TILE/N_TILE;

parameter FILE_PATH_A = "D:/sparse-tensor-core/test_file/matrix_multiple/matrix_a.txt";
parameter FILE_PATH_B = "D:/sparse-tensor-core/test_file/matrix_multiple/matrix_b.txt";
parameter FILE_PATH_S = "D:/sparse-tensor-core/test_file/matrix_multiple/matrix_s.txt";

/*iverilog */
//initial
//begin
//  $dumpfile("tb_basic.vcd");
//  $dumpvars(0, tb_basic);
//end
/*iverilog */

// for simulator
integer i, j, tmp;
integer file_a, file_b, file_s;

reg signed [DW_MUL-1:0] A_matrix [M*K-1:0];
reg signed [DW_MUL-1:0] B_matrix [K*N-1:0];
reg signed [DW_ADD-1:0] S_matrix [M*N-1:0];

// interface to mm_unit
reg                           sys_clk;
reg                           reset;
reg                           enable;
reg signed [DW_MEM_IN_I-1:0]  IN_I;
reg                           in_type;
reg                           in_state;
wire signed [DW_ADD-1:0]      OUT_I;
wire [1:0]                    out_state;


//信号初始�?
initial begin
  sys_clk   = 1'b1;
  reset     = 1'b0;
  enable    = 1'b0;
  IN_I      = 0;
  in_type   = 0;
  in_state  = 0;

  // todo: readmemh
  // load file
  file_a = $fopen(FILE_PATH_A, "r");
  for (i=0; i<M*K; i=i+1) begin
    tmp = $fscanf(file_a, "%d", A_matrix[i]);
  end
  $fclose(file_a);
  file_b = $fopen(FILE_PATH_B, "r");
  for (i=0; i<K*N; i=i+1) begin
    tmp = $fscanf(file_b, "%d", B_matrix[i]);
  end
  $fclose(file_b);
  file_s = $fopen(FILE_PATH_S, "r");
  for (i=0; i<M*N; i=i+1) begin
    tmp = $fscanf(file_s, "%d", S_matrix[i]);
  end
  $fclose(file_s);

end

// generate clk
always #5 sys_clk = ~sys_clk;
initial begin
  #10
  reset = 1'b1;
  #10
  reset = 1'b0;
  enable = 1'b1;
  in_state = 1'b1;
  #10

  in_state = 1'b0;
  in_type = 1'b0;
  for (i=0; i<M; i=i+1) begin
    for (j=0; j<K; j=j+1) begin
      IN_I[DW_MUL*j+:DW_MUL] = A_matrix[i*K+j];
    end
    #10;
  end

  in_type = 1'b1;
  for (i=0; i<N; i=i+1) begin
    for (j=0; j<K; j=j+1) begin
      IN_I[DW_MUL*j+:DW_MUL] = B_matrix[i*K+j];
    end
    #10;
  end

  in_state = 1'b1;
  #10
  in_state = 1'b0;
  #10

  #(10*all_cycle*2)
  $finish;

end


tc_ctrl #(
  .M        (M),
  .K        (K),
  .N        (N),
  .M_TILE   (M_TILE),
  .K_TILE   (K_TILE),
  .N_TILE   (N_TILE),
  .DW_MUL   (DW_MUL),
  .DW_ADD   (DW_ADD),
  .DW_INT   (DW_INT),
  .W_SHIFT  (W_SHIFT)
)
u_tc_ctrl (
  .clk      (sys_clk),
  .reset    (reset),
  .enable   (enable),
  .in_i     (IN_I),
  .in_type  (in_type),
  .in_state (in_state),

  .out_i    (OUT_I),
  .out_state(out_state)
);

endmodule
