`timescale 1ns / 1ps

module tb_fan();
parameter DW_DATA = 8;
parameter N = 8;
parameter N_ADDERS = N-1;

reg [N_ADDERS-1:0] add_en;
reg [N_ADDERS-1:0] bypass_en;
reg [6*N_ADDERS-1:0] sel;
reg [DW_DATA*N-1:0] in;
reg [2*N-1:0] edge_tag_in;
wire [2*N_ADDERS-1:0] out_valid;
wire [DW_DATA*2*N_ADDERS-1:0] out;

initial begin
    in = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
    add_en    = 7'b1101101;
    bypass_en = 7'b0010000;
    sel = {3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd2, 3'd1, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0};
    edge_tag_in = {16'b1000_0110_0001_1001};
    #60 $finish;
end

fan_tree #(
    .DW_DATA(DW_DATA),
    .N(N)
) u_fan_tree (
    .add_en(add_en),
    .bypass_en(bypass_en),
    .sel(sel),
    .in(in),
    .edge_tag_in(edge_tag_in),
    .out_valid(out_valid),
    .out(out)
);

endmodule