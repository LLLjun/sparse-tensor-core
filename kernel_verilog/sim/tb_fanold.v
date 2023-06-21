`timescale 1ns / 1ps

module tb_fan();
parameter DW_DATA = 32;
parameter N = 32;
parameter N_ADDERS = N-1;

reg                   clk;
reg                   rst;
reg [N_ADDERS-1:0] add_en;
reg [N_ADDERS-1:0] bypass_en;
reg [6*N_ADDERS-1:0] sel;
reg [DW_DATA*N-1:0] in;
reg [2*N-1:0] edge_tag_in;
wire [2*N_ADDERS-1:0] out_valid;
wire [DW_DATA*2*N_ADDERS-1:0] out;

always #5 clk = ~clk;
initial begin
    clk = 1;
    rst = 1;
    in = 0;
    add_en    = 0;
    bypass_en = 0;
    sel = 0;
    edge_tag_in = 0;
    #10 
    rst = 0;
    in = {32'd31, 32'd30, 32'd29, 32'd28, 32'd27, 32'd26, 32'd25, 32'd24, 32'd23, 32'd22, 32'd21, 32'd20, 32'd19, 32'd18, 32'd17, 32'd16, 32'd15, 32'd14, 32'd13, 32'd12, 32'd11, 32'd10, 32'd9, 32'd8, 32'd7, 32'd6, 32'd5, 32'd4, 32'd3, 32'd2, 32'd1, 32'd0};
    add_en    = 31'b1111111011111111110111011111011;
    bypass_en = 31'b0000000000000000001000100000100;
    sel = {3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd6, 3'd2, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd2, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0, 3'd3, 3'd1, 3'd1, 3'd0, 3'd1, 3'd0, 3'd1, 3'd0};
    edge_tag_in = {8'b10000000, 8'b00000001, 8'b10000000, 8'b00000000, 8'b00000110, 8'b00000110, 8'b00000000, 8'b01100001};
    #100
    $finish;
end

ustc_fan #(
    .DW_DATA(DW_DATA),
    .N(N)
) u_fan (
    .clk(clk),
    .rst(rst),
    .add_en(add_en),
    .bypass_en(bypass_en),
    .sel(sel),
    .in(in),
    .edge_tag_in(edge_tag_in),
    .out_valid(out_valid),
    .out(out)
);

endmodule