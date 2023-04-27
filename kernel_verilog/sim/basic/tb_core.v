`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jun Liu
// 
// Create Date: 04/07/2023 02:05:40 PM
// Design Name: 
// Module Name: tb_core
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


module tb_core();

parameter N_GROUP = 16;
parameter N_UNIT = 16;
parameter N_MUL = 16;
parameter DW_MUL = 8;
parameter DW_ADD = 32;
parameter DW_CORE_IN_A = DW_MUL * N_MUL * N_GROUP;
parameter DW_CORE_IN_B = DW_MUL * N_MUL * N_UNIT;
parameter DW_CORE_OUT = DW_ADD * N_UNIT * N_GROUP;
parameter DW_UNIT_IN = DW_MUL * N_MUL;

parameter FILE_PATH_A = "D:/sparse-tensor-core/test_file/matrix_multiple/matrix_a.txt";
parameter FILE_PATH_B = "D:/sparse-tensor-core/test_file/matrix_multiple/matrix_b.txt";
parameter FILE_PATH_S = "D:/sparse-tensor-core/test_file/matrix_multiple/matrix_s.txt";

integer i, tmp;
integer file_a, file_b, file_s;

reg sys_clk;
reg reset;
reg enable;
reg [1:0] in_valid;

reg signed [DW_MUL-1:0] A_matrix [N_GROUP*N_MUL-1:0];
reg signed [DW_MUL-1:0] B_matrix [N_UNIT*N_MUL-1:0];
reg signed [DW_ADD-1:0] S_matrix [N_GROUP*N_UNIT-1:0];

reg signed [DW_CORE_IN_A-1:0] IN_A;
reg signed [DW_CORE_IN_B-1:0] IN_B;
wire signed [DW_CORE_OUT-1:0] OUT;
wire signed [DW_ADD-1:0] OUT_SECTION [N_GROUP*N_UNIT-1:0];

genvar j;
generate
  for (j=0; j<N_GROUP*N_UNIT; j=j+1) begin
    assign OUT_SECTION[j] = OUT[j*DW_ADD+:DW_ADD];
  end
endgenerate


initial begin
  sys_clk = 1'b1;
  reset   = 1'b0;
  enable  = 1'b0;
  in_valid= 2'b00;
  IN_A = 0;
  IN_B = 0;

  // load file
  file_a = $fopen(FILE_PATH_A, "r");
  for (i=0; i<N_GROUP*N_MUL; i=i+1) begin
    tmp = $fscanf(file_a, "%d", A_matrix[i]);
    IN_A[i*DW_MUL+:DW_MUL] = A_matrix[i];
  end
  $fclose(file_a);
  file_b = $fopen(FILE_PATH_B, "r");
  for (i=0; i<N_UNIT*N_MUL; i=i+1) begin
    tmp = $fscanf(file_b, "%d", B_matrix[i]);
    IN_B[i*DW_MUL+:DW_MUL] = B_matrix[i];
  end
  $fclose(file_b);
  file_s = $fopen(FILE_PATH_S, "r");
  for (i=0; i<N_GROUP*N_UNIT; i=i+1) begin
    tmp = $fscanf(file_s, "%d", S_matrix[i]);
  end
  $fclose(file_s);

end


always #5 sys_clk = ~sys_clk;
initial begin
  #10
  reset = 1'b1;
  #10
  reset = 1'b0;
  enable = 1'b1;
  in_valid= 2'b11;
  // #10
  // in_valid= 2'b00;

  #100 $finish;

end


core #(
  .N_GROUP(N_GROUP),
  .N_UNIT(N_UNIT),
  .N_MUL(N_MUL),
  .DW_MUL(DW_MUL),
  .DW_ADD(DW_ADD)
)
u_core_0 (
  .clk(sys_clk),
  .reset(reset),
  .enable(enable),
  .in_a(IN_A),
  .in_b(IN_B),
  .in_valid(in_valid),
  .out(OUT)
);

endmodule
