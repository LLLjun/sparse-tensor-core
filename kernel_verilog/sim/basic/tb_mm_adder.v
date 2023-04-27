`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Jun Liu
//
// Create Date: 04/07/2023 02:05:40 PM
// Design Name:
// Module Name: tb_mm_adder
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


module tb_mm_adder();
// parameter setup
parameter M = 4, K = 4, N = 4;
parameter M_TILE = 2, K_TILE = 2, N_TILE = 2;
parameter DW_ADD = 32;
parameter DW_INT = 32;

parameter DW_IN = DW_ADD * M_TILE * N_TILE;
parameter DW_OUT = DW_ADD * N;

parameter FILE_PATH_A = "D:/sparse-tensor-core/test_file/mm_adder/matrix_a.txt";
parameter FILE_PATH_B = "D:/sparse-tensor-core/test_file/mm_adder/matrix_b.txt";
parameter FILE_PATH_S = "D:/sparse-tensor-core/test_file/mm_adder/matrix_s.txt";

/*iverilog */
// initial
// begin
//   $dumpfile("tb_mm_adder.vcd");
//   $dumpvars(0, tb_mm_adder);
// end
/*iverilog */

// for simulator
integer i, tmp;
integer file_a, file_b, file_s;
integer mi, ni;

integer iter_m = $ceil(M/M_TILE);
integer iter_n = $ceil(N/N_TILE);
reg signed [DW_ADD-1:0] A_matrix [M*N-1:0];
reg signed [DW_ADD-1:0] B_matrix [N*N-1:0];
reg signed [DW_ADD-1:0] S_matrix [M*N-1:0];
wire signed [DW_ADD-1:0] OUT_SECTION [M_TILE*N_TILE-1:0];

// interface to mm_unit
reg sys_clk;
reg reset;
reg enable;
reg [DW_INT-1:0]          ptr_m, ptr_n;
reg signed [DW_IN-1:0]    IN;
reg                       in_valid;
wire signed [DW_OUT-1:0]  OUT;
wire [1:0]                out_flag;

// connection
genvar j;
generate
  for (j=0; j<M_TILE*N_TILE; j=j+1) begin
    assign OUT_SECTION[j] = OUT[j*DW_ADD+:DW_ADD];
  end
endgenerate

// 
initial begin
  sys_clk = 1'b1;
  reset   = 1'b0;
  enable  = 1'b0;
  in_valid= 1'b0;
  ptr_m = 0;
  ptr_n = 0;
  IN = 0;

  // load file
  file_a = $fopen(FILE_PATH_A, "r");
  for (i=0; i<M*N; i=i+1) begin
    tmp = $fscanf(file_a, "%d", A_matrix[i]);
  end
  $fclose(file_a);
  file_b = $fopen(FILE_PATH_B, "r");
  for (i=0; i<M*N; i=i+1) begin
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
  #10

  in_valid = 1'b1;
  for (ptr_m=0; ptr_m<iter_m; ptr_m=ptr_m+1) begin
    for (ptr_n=0; ptr_n<iter_n; ptr_n=ptr_n+1) begin
      // input
      for (mi=0; mi<M_TILE; mi=mi+1) begin
        for (ni=0; ni<N_TILE; ni=ni+1) begin
          IN[DW_ADD*(mi*N_TILE+ni)+:DW_ADD] = A_matrix[(ptr_m*M_TILE+mi)*N+ptr_n*N_TILE+ni];
        end
      end
      #10;
    end
    for (ptr_n=0; ptr_n<iter_n; ptr_n=ptr_n+1) begin
      // input
      for (mi=0; mi<M_TILE; mi=mi+1) begin
        for (ni=0; ni<N_TILE; ni=ni+1) begin
          IN[DW_ADD*(mi*N_TILE+ni)+:DW_ADD] = B_matrix[(ptr_m*M_TILE+mi)*N+ptr_n*N_TILE+ni];
        end
      end
      #10;
    end
  end
  in_valid = 1'b0;

  #100 $finish;

end


mm_adder #(
  .M(M), .K(K), .N(N),
  .M_TILE(M_TILE), .K_TILE(K_TILE), .N_TILE(N_TILE),
  .DW_ADD(DW_ADD),
  .DW_INT(DW_INT)
)
u_mm_adder (
  .clk(sys_clk),
  .reset(reset),
  .enable(enable),
  .ptr_row(ptr_m), .ptr_col(ptr_n),
  .in(IN),
  .in_add_valid(in_valid),
  .out(OUT),
  .out_flag(out_flag)
);

endmodule
