`timescale 1ns / 1ps


module tb_dp_unit();
parameter DW_DATA = 8;

reg           sys_clk;
reg reset;
reg enable;
reg [1:0] in_valid;
reg signed [DW_DATA-1 : 0] A;
reg signed [DW_DATA-1 : 0] B;
wire signed [DW_DATA-1 : 0] P;

//信号初始化
initial begin
  sys_clk = 1'b1;
  reset   = 1'b0;
  enable  = 1'b0;
  in_valid= 2'b00;
  A = 0;
  B = 0;
end

//生成时钟
always #5 sys_clk = ~sys_clk;
initial begin
  #10
  reset = 1'b1;
  #10
  reset = 1'b0;
  enable = 1'b1;

  #10
  in_valid= 2'b11;
  A = {8'd2};
  B = {-8'd2};
  #10
  in_valid= 2'b10;
  A = {8'd1};
  B = {8'd1};
  #10
  in_valid= 2'b01;
  A = {8'd1};
  B = {8'd1};
  #10
  in_valid= 2'b00;
  A = {8'd2};
  B = {8'd2};
  #60 $finish;
end

//例化待测设计
dp_unit #(
  .DW_DATA(DW_DATA)
)
u_dp_unit_0 (
  .clk(sys_clk),
  .reset(reset),
  .enable(enable),
  .in_a(A),
  .in_b(B),
  .in_valid(in_valid),
  .out(P)
);

endmodule
