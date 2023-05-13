`timescale 1ns / 1ps

module tb_dn_router();
parameter DW_DATA = 8;

reg sys_clk;
reg reset;
reg set_en;
reg route_en;
reg [1:0] route_signal;
reg [2*DW_DATA-1:0] in;
wire [2*DW_DATA-1:0] out;

initial begin
    sys_clk = 1'b1;
    reset = 1'b0;
    set_en = 1'b0;
    route_en = 1'b0;
    route_signal = 2'b00;
    in = {8'd3, 8'd4};
end

always #5 sys_clk = ~sys_clk;
initial begin
    #10
    reset = 1'b1;
    #10
    reset = 1'b0;
    set_en = 1'b1;
    route_signal = 2'b01;
    #10
    set_en = 1'b0;
    route_en = 1'b1;
    #10
    set_en = 1'b1;
    route_signal = 2'b11;
    #10
    set_en = 1'b0;
    route_en = 1'b1;
    #60 $finish;
end

dn_router #(
    .DW_DATA(DW_DATA)
) u_dn_router (
    .clk(sys_clk),
    .reset(reset),
    .set_en(set_en),
    .route_en(route_en),
    .route_signal(route_signal),
    .in(in),
    .out(out)
);

endmodule