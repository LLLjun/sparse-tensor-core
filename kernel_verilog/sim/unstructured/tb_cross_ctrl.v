`timescale 1ns / 1ps

module tb_cross_ctrl();
parameter N = 8;
parameter DW_DATA = 8;
parameter DW_IDX = 3;

reg clk;
reg reset;
reg [N*DW_IDX-1:0] in;
wire [N*N-1:0] ctrl;

always #5 clk = ~clk;

initial begin
    clk = 1'b1;
    reset = 1'b1;
    #10
    in = {3'd6, 3'd4, 3'd5, 3'd2, 3'd1, 3'd7, 3'd2, 3'd0};
    // in = {8'd4, 8'd3, 8'd2, 8'd1};
    // ctrl = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
    reset = 1'b0;
    #60
    $finish;
end

cross_ctrl #(
    .DW_DATA(DW_DATA),
    .DW_IDX(DW_IDX),
    .NUM_IN(N)
) u_ustc_crossbar (
    .clk(clk),
    .ctrl(ctrl),
    .idx(in)
);

endmodule