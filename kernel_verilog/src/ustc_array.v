`timescale 1ns / 1ps

module ustc_array #(
    parameter N_UNIT = 32,
    parameter N_ADDERS = N_UNIT - 1,
    parameter N_BUSLINE = 2*N_ADDERS,
    parameter TILE_K = 8,
    parameter DW_DATA = 32,
    parameter N_LEVELS = 2*$clog2(N_UNIT)-1
) (
    input clk,
    input reset,
    input enable,
    // input 
    input signed [N_UNIT*DW_DATA-1:0] in_a,
    input signed [TILE_K*DW_DATA-1:0] in_b,
    input [1:0] in_valid,
    // control signals
    input [N_LEVELS*N_UNIT-1:0] route_signals,
    input [N_ADDERS-1:0] add_en,
    input [N_ADDERS-1:0] bypass_en,
    input [6*N_ADDERS-1:0] sel,
    input [2*N_UNIT-1:0] edge_tag_in,
    // output
    output signed [N_BUSLINE*DW_DATA-1:0] out_bus,
    output [N_BUSLINE-1:0] out_valid
);

    wire [N_UNIT*DW_DATA-1:0] wire_dn_out;
    reg [N_UNIT*DW_DATA-1:0] reg_in_a, reg_in_b, reg_in_dn;
    wire [N_UNIT*DW_DATA-1:0] wire_dp_out;

    always @(posedge clk) begin
        if (reset) begin
            reg_in_a <= 0;
            reg_in_b <= 0;
            reg_in_dn <= 0;
        end
        else if (enable) begin
            reg_in_a <= wire_dn_out;
            reg_in_b <= wire_dn_out;
            if (in_valid[1]) begin
                reg_in_dn <= in_a;
            end
            else begin
                reg_in_dn <= {2{in_b}};
            end
        end
        else begin
            reg_in_dn <= 0;
        end
    end

    // always @(*) begin
    //     reg_in_a <= wire_dn_out;
    //     reg_in_b <= wire_dn_out;
    //     //reg_in_dn <= 0;
    // end
    
    ustc_benes #(
        .N(N_UNIT),
        .DW_DATA(DW_DATA)
    ) u_dn_benes (
        .clk(clk),
        .reset(reset),
        .set_en(enable),
        .route_en(enable),
        .route_signals(route_signals),
        .in(reg_in_dn),
        .out(wire_dn_out)
    );

    multiplier_array #(
        .N_UNIT(N_UNIT),
        .DW_DATA(DW_DATA)
    ) u_dp_group (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in_a(reg_in_a),
        .in_b(reg_in_b),
        .in_valid(in_valid),
        .out(wire_dp_out)
    );

    ustc_fan #(
        .N(N_UNIT),
        .DW_DATA(DW_DATA)
    ) u_fan_tree (
        .add_en(add_en),
        .bypass_en(bypass_en),
        .sel(sel),
        .in(wire_dp_out),
        .edge_tag_in(edge_tag_in),
        .out_valid(out_valid),
        .out(out_bus)
    );

endmodule