`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Jun Liu
//
// Create Date: 04/07/2023 02:05:40 PM
// Design Name:
// Module Name: tb_stc
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


module tb_stc();
// parameter setup
parameter M = 16, K = 16, N = 16;
parameter M_TILE = 4, K_TILE = 4, N_TILE = 4;
parameter DW_MUL = 8;
parameter DW_ADD = 32;
parameter DENSITY = 4;
parameter DW_INT = 32;
parameter W_SHIFT = 6;      // adder tree

parameter DW_CORE_IN_A = DW_MUL * K_TILE * M_TILE;
parameter DW_IN_INDEX = DW_INT * K_TILE * M_TILE;
parameter DW_CORE_IN_B = DENSITY * DW_MUL * K_TILE * N_TILE;
parameter DW_MM_OUT = DW_ADD * N;

parameter FILE_PATH_A = "../test_file/matrix_multiple/matrix_a_value.txt";
parameter FILE_A_IDEX = "../test_file/matrix_multiple/matrix_a_index.txt";
parameter FILE_PATH_B = "../test_file/matrix_multiple/matrix_b.txt";
parameter FILE_PATH_S = "../test_file/matrix_multiple/matrix_s.txt";

/*iverilog */
// initial
// begin
//   $dumpfile("tb_stc.vcd");        //生成的vcd文件名称
//   $dumpvars(0, tb_stc);    //tb模块名称
// end
/*iverilog */

// for simulator
integer i, tmp;
integer file_a_value, file_a_index, file_b, file_s;
integer mi, ki, ni;

integer iter_m = $ceil(M/M_TILE);
integer iter_k = $ceil(K/K_TILE);
integer iter_n = $ceil(N/N_TILE);
reg signed [DW_MUL-1:0] A_matrix [M*K-1:0];
reg signed [DW_INT-1:0] A_matrix_index [M*K-1:0];
reg signed [DW_MUL-1:0] B_matrix [DENSITY*K*N-1:0];
reg signed [DW_ADD-1:0] S_matrix [M*N-1:0];
wire signed [DW_ADD-1:0] OUT_SECTION [M_TILE*N_TILE-1:0];

// interface to struct_unit
reg sys_clk;
reg reset;
reg enable;
reg [1:0] in_valid;
reg [DW_INT-1:0] ptr_m, ptr_k, ptr_n;
reg signed [DW_CORE_IN_A-1:0] IN_A;
reg signed [DW_IN_INDEX-1:0] IN_A_INDEX;
reg signed [DW_CORE_IN_B-1:0] IN_B;
wire signed [DW_MM_OUT-1:0] OUT;

// connection
genvar j;
generate
  for (j=0; j<M_TILE*N_TILE; j=j+1) begin
    assign OUT_SECTION[j] = OUT[j*DW_ADD+:DW_ADD];
  end
endgenerate

//信号初始化
initial begin
  sys_clk = 1'b1;
  reset   = 1'b0;
  enable  = 1'b0;
  in_valid= 2'b00;
  ptr_m = 0;
  ptr_k = 0;
  ptr_n = 0;
  IN_A = 0;
  IN_B = 0;

  // load file
  file_a_value = $fopen(FILE_PATH_A, "r");
  file_a_index = $fopen(FILE_A_IDEX, "r");
  for (i=0; i<M*K; i=i+1) begin
    tmp = $fscanf(file_a_value, "%d", A_matrix[i]);
    tmp = $fscanf(file_a_index, "%d", A_matrix_index[i]);
  end
  $fclose(file_a_value);
  $fclose(file_a_index);
  file_b = $fopen(FILE_PATH_B, "r");
  for (i=0; i<DENSITY*K*N; i=i+1) begin
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

  for (ptr_m=0; ptr_m<iter_m; ptr_m=ptr_m+1) begin
    for (ptr_k=0; ptr_k<iter_k; ptr_k=ptr_k+1) begin
      for (ptr_n=0; ptr_n<iter_n; ptr_n=ptr_n+1) begin
        // input B
        for (ni=0; ni<N_TILE; ni=ni+1) begin
          for (ki=0; ki<DENSITY*K_TILE; ki=ki+1) begin
            IN_B[DW_MUL*(ni*DENSITY*K_TILE+ki)+:DW_MUL] = B_matrix[(ptr_n*N_TILE+ni)*K+ptr_k*DENSITY*K_TILE+ki];
          end
        end
        // input A
        if (ptr_n == 0) begin
          in_valid = 2'b11;
          for (mi=0; mi<M_TILE; mi=mi+1) begin
            for (ki=0; ki<K_TILE; ki=ki+1) begin
              IN_A[DW_MUL*(mi*K_TILE+ki)+:DW_MUL] = A_matrix[(ptr_m*M_TILE+mi)*K+ptr_k*K_TILE+ki];
            end
          end
        end
        else begin
          in_valid = 2'b01;
        end
        #10;
      end
    end
  end

  #100 $finish;

end

//例化待测设计
struct_unit #(
  .M(M), .K(K), .N(N),
  .N_GROUP(M_TILE),
  .N_UNIT(N_TILE),
  .N_MUL(K_TILE),
  .DW_MUL(DW_MUL),
  .DW_ADD(DW_ADD),
  .DW_INT(DW_INT),
  .W_SHIFT(W_SHIFT)
)
u_struct_unit (
  .clk(sys_clk),
  .reset(reset),
  .enable(enable),
  .ptr_m(ptr_m), .ptr_n(ptr_n),
  .in_a(IN_A),
  .in_b(IN_B),
  .in_valid(in_valid),
  .out(OUT)
);

endmodule
