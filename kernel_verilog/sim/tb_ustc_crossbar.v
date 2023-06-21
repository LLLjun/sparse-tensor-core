`timescale 1ns / 1ps

module tb_ustc_crossbar();
parameter N = 8;
parameter DW_DATA = 8;

reg clk;
reg reset;
reg [N*N-1:0] ctrl;
reg [N*DW_DATA-1:0] in;
wire [N*DW_DATA-1:0] out;

always #5 clk = ~clk;

initial begin
    clk = 1'b1;
    reset = 1'b1;
    in = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
    ctrl = {8'b10000000, 8'b01000000, 8'b00100000, 8'b00010000, 8'b00001000, 8'b00000100, 8'b00000010, 8'b00000001};
    // in = {8'd4, 8'd3, 8'd2, 8'd1};
    // ctrl = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
    #10
    reset = 1'b0;
    #60
    $finish;
end

ustc_crossbar #(
    .DW_DATA(DW_DATA),
    .N(N)
) u_ustc_crossbar (
    .clk(clk),
    .reset(reset),
    .ctrl(ctrl),
    .in(in),
    .out(out)
);

endmodule