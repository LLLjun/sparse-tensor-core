`timescale 1ns / 1ps

module tb_core();

parameter N_UNIT = 8;
parameter N_ADDERS = N_UNIT - 1;
parameter N_BUSLINE = 2*(N_ADDERS);
parameter TILE_K = 4;
parameter DW_DATA = 8;
parameter N_LEVELS = 2*$clog2(N_UNIT)-1;


reg sys_clk;
reg reset;
reg enable;
// input 
reg signed [N_UNIT*DW_DATA-1:0] in_a;
reg signed [TILE_K*DW_DATA-1:0] in_b;
reg [1:0] in_valid;
// control signals
reg [N_LEVELS*N_UNIT-1:0] route_signals, route_signals_a, route_signals_b;
reg [N_ADDERS-1:0] add_en;
reg [N_ADDERS-1:0] bypass_en;
reg [6*N_ADDERS-1:0] sel;
reg [2*N_UNIT-1:0] edge_tag_in;
// output
wire signed [N_BUSLINE*DW_DATA-1:0] out_bus;
wire [N_BUSLINE-1:0] out_valid;


//生成时钟
always #5 sys_clk = ~sys_clk;
initial begin
    sys_clk = 1;
    add_en    = 7'b1101101;
    bypass_en = 7'b0010000;
    sel = {3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd2, 3'd1, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0};
    edge_tag_in = {16'b1000_0110_0001_1001};
    route_signals_a = 40'b10101010_10100110_10101010_10100110_10101010;
    route_signals_b = 40'b01011010_00111010_01011000_01100100_00000110;
    in_a = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
    in_b = {8'd4, 8'd3, 8'd2, 8'd1};
end

initial begin
    #10
    reset = 1'b1;
    #10
    reset = 1'b0;
    enable = 1'b1;
    in_valid= 2'b10;
    route_signals = route_signals_a;
    #30
    in_valid= 2'b01;
    route_signals = route_signals_b;

    // #10
    // in_valid= 2'b00;


    #100 $finish;

end

//例化待测设计
core #(
    .N_UNIT(N_UNIT),
    .TILE_K(TILE_K),
    .DW_DATA(DW_DATA)
)
u_core_0 (
    .clk(sys_clk),
    .reset(reset),
    .enable(enable),
    .in_a(in_a),
    .in_b(in_b),
    .in_valid(in_valid),
    .route_signals(route_signals),
    .add_en(add_en),
    .bypass_en(bypass_en),
    .sel(sel),
    .edge_tag_in(edge_tag_in),
    .out_bus(out_bus),
    .out_valid(out_valid)
);

endmodule