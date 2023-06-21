`timescale 1ns / 1ps

module tb_ustc_benes();
parameter DW_DATA = 8;
parameter N = 8;
parameter N_LEVELS = 5;

reg sys_clk;
reg reset;
reg en;
reg [N_LEVELS*N-1:0] route_signals;
reg [DW_DATA*N-1:0] in;
wire [DW_DATA*N-1:0] out;

initial begin
    sys_clk = 1'b1;
    reset = 1'b0;
    en = 1'b0;
    route_signals = 40'b01011010_00111010_01011000_01100100_00000110; // 
    in = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
end

always #5 sys_clk = ~sys_clk;
initial begin
    #10
    reset = 1'b1;
    #10
    reset = 1'b0;
    en = 1'b1;
    //route_signal = 2'b01;
    #100
    en = 1'b0;
    #100
    en = 1'b1;
    route_signals = 40'b10101010_10101010_10101010_10101010_10101010;
    //#10
    //en = 1'b0;
    #60 $finish;
end

ustc_benes #(
    .DW_DATA(DW_DATA),
    .N(N)
) u_benes (
    .clk(sys_clk),
    .reset(reset),
    .set_en(en),
    .route_en(en),
    .route_signals(route_signals),
    .in(in),
    .out(out)
);


endmodule