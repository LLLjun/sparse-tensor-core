`timescale 1ns / 1ps

module tb_fan();
parameter DW_DATA = 8;
parameter N = 32;
parameter N_ADDERS = N-1;

reg [N_ADDERS-1:0] add_en;
reg [N_ADDERS-1:0] bypass_en;
reg [6*N_ADDERS-1:0] sel;
reg [DW_DATA*N-1:0] in;
reg [2*N-1:0] edge_tag_in;
wire [2*N_ADDERS-1:0] out_valid;
wire [DW_DATA*2*N_ADDERS-1:0] out;

initial begin
    in = {8'd31, 8'd30, 8'd29, 8'd28, 8'd27, 8'd26, 8'd25, 8'd24, 8'd23, 8'd22, 8'd21, 8'd20, 8'd19, 8'd18, 8'd17, 8'd16, 8'd15, 8'd14, 8'd13, 8'd12, 8'd11, 8'd10, 8'd9, 8'd8, 8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
    add_en    = 31'b1111111011111111110111011111011;
    bypass_en = 31'b0000000000000000001000100000100;
    sel = {3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd6, 3'd2, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd2, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd1, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0};
    edge_tag_in = {8'b10000000, 8'b00000001, 8'b10000000, 8'b00000000, 8'b00000110, 8'b00000110, 8'b00000000, 8'b01100001};
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