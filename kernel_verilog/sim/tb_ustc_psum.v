`timescale 1ns / 1ps

module tb_ustc_psum();
parameter M = 16;
parameter N = 16;
parameter tileM = 4;
parameter tileK = 8;
parameter tileN = 1;
parameter NUM_IN = 32;
parameter DW_DATA = 8;
parameter DW_ROW = 4;
parameter DW_COL = 4;
parameter DW_CTRL = 4;
parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL;
parameter NUM_OUT = N;
parameter DW_OUT = NUM_OUT*DW_DATA;

reg clk;
reg rst;
reg [DW_COL-1:0] col;
reg [NUM_IN*DW_LINE-1:0] in;
reg out_en;
wire out_valid;
wire [DW_OUT-1:0] out;

always #5 clk = ~clk;

initial begin
    clk = 1'b1;
    rst = 1'b1;
    col = 0;
    out_en = 1;
    in = {16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h7405, 16'h0000, 16'h0000, 16'h0000,
          16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000,
          16'h7304, 16'h0000, 16'h0000, 16'h0000, 16'h7203, 16'h0000, 16'h0000, 16'h0000,
          16'h7102, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h7001, 16'h0000};
    #10
    rst = 1'b0;
    #60
    $finish;
end

ustc_psum #(
    .DW_DATA(DW_DATA)
) u_ustc_psum (
    .clk(clk),
    .rst(rst),
    .col(col),
    .in(in),
    .out_en(out_en),
    .out_valid(out_valid),
    .out(out)
);

endmodule