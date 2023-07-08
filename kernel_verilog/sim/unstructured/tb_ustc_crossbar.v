`timescale 1ns / 1ps

module tb_ustc_crossbar();
parameter N = 8;
parameter DW_DATA = 8;
parameter DW_IDX = 3;
parameter NUM_PER_LINE = 1;

reg clk;
reg reset;
reg [N*DW_IDX-1:0] idx;
reg [N*DW_DATA-1:0] in;
wire [N*DW_DATA-1:0] out;

always #5 clk = ~clk;

initial begin
    clk = 1'b1;
    reset = 1'b1;
    in = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
    idx = {3'd6, 3'd4, 3'd5, 3'd2, 3'd1, 3'd7, 3'd2, 3'd0};
    // in = {8'd4, 8'd3, 8'd2, 8'd1};
    // ctrl = {4'b0001, 4'b0010, 4'b0100, 4'b1000};
    #10
    reset = 1'b0;
    #20
    idx = {3'd7, 3'd6, 3'd5, 3'd4, 3'd3, 3'd2, 3'd1, 3'd0};
    #60
    $finish;
end

ustc_crossbar #(
    .DW_DATA(DW_DATA),
    .N(N),
    .NUM_PER_LINE(NUM_PER_LINE)
) u_ustc_crossbar (
    .clk(clk),
    .reset(reset),
    .idx(idx),
    .in(in),
    .out(out)
);

endmodule