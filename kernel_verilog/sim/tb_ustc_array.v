`timescale 1ns / 1ps

module tb_ustc_array();
parameter N_UNIT = 32;
parameter NUM_XBAR = 4;
parameter N_XBAR_IN = 8;
parameter DW_DATA = 8;
parameter DW_ROW = 4;
parameter DW_CTRL = 4;
parameter DW_IDX = 4;
parameter DW_OUT = 16;

reg clk;
reg reset;
// input 
reg [N_UNIT*DW_DATA-1:0] in_a;
reg [N_XBAR_IN*DW_DATA-1:0] in_b;
reg [N_UNIT*DW_IDX-1:0] in_a_col;
reg [N_UNIT*DW_ROW-1:0] in_a_row;
reg [N_UNIT*DW_CTRL-1:0] in_a_ctrl;
// output
wire [N_UNIT*DW_OUT-1:0] out;

always #5 clk = ~clk;

initial begin
    clk = 1;
    reset = 1;
    in_a = {8'd2,
            8'd0, 8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7,
            8'd1, 8'd5,
            8'd0, 8'd1, 8'd2, 8'd3, 8'd4, 8'd6, 8'd7,
            8'd7,
            8'd5,
            8'd0, 8'd1, 8'd2, 8'd3, 8'd5, 8'd6,
            8'd0, 8'd1, 8'd3, 8'd4, 8'd6, 8'd7};
    in_b = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
    in_a_col = {4'd2,
            4'd7, 4'd6, 4'd5, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0,
            4'd5, 4'd1,
            4'd7, 4'd6, 4'd4, 4'd3, 4'd2, 4'd1, 4'd0,
            4'd7,
            4'd5,
            4'd6, 4'd5, 4'd3, 4'd2, 4'd1, 4'd0,
            4'd7, 4'd6, 4'd4, 4'd3, 4'd1, 4'd0};
    in_a_row = {4'd7,
            4'd6, 4'd6, 4'd6, 4'd6, 4'd6, 4'd6, 4'd6, 4'd6,
            4'd5, 4'd5,
            4'd4, 4'd4, 4'd4, 4'd4, 4'd4, 4'd4, 4'd4,
            4'd3,
            4'd2,
            4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1,
            4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0};
    in_a_ctrl = {4'b0111,
            4'b1010, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1001,
            4'b1010, 4'b1001,
            4'b1010, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1001,
            4'b0111,
            4'b0111,
            4'b1010, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1001,
            4'b1010, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1001};
    #10
    reset = 0;
    #100 $finish;
end

ustc_array u_ustc_array (
    .clk(clk),
    .reset(reset),
    .in_a(in_a),
    .in_b(in_b),
    .in_a_col(in_a_col),
    .in_a_row(in_a_row),
    .in_a_ctrl(in_a_ctrl),
    .out(out)
);

endmodule