`timescale 1ns / 1ps

module tb_dn_benes();
parameter DW_DATA = 8;
parameter N = 8;
parameter N_LEVELS = 5;

reg sys_clk;
reg reset;
reg set_en;
reg route_en;
reg [N_LEVELS*N-1:0] route_signals;
reg [DW_DATA*N-1:0] in;
wire [DW_DATA*N-1:0] out;

initial begin
    sys_clk = 1'b1;
    reset = 1'b0;
    set_en = 1'b0;
    route_en = 1'b0;
    route_signals = 40'b10100101_10011001_10101010_10011001_10100101;
    in = {8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7, 8'd8};
end

always #5 sys_clk = ~sys_clk;
initial begin
    #10
    reset = 1'b1;
    #10
    reset = 1'b0;
    set_en = 1'b1;
    //route_signal = 2'b01;
    //#10
    //set_en = 1'b0;
    //route_en = 1'b1;
    //#10
    //set_en = 1'b1;
    //route_signal = 2'b11;
    //#10
    //set_en = 1'b0;
    //route_en = 1'b1;
    #60 $finish;
end

dn_benes #(
    .DW_DATA(DW_DATA),
    .N(N)
) u_dn_benes (
    .clk(sys_clk),
    .reset(reset),
    .set_en(set_en),
    .route_en(route_en),
    .route_signals(route_signals),
    .in(in),
    .out(out)
);

//TODO: bug to fix: might be delay due to latches

endmodule