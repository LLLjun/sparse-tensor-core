`timescale 1ns / 1ps

module tc_array #(
    parameter N_UNIT = 32,
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter DW_DATA = 8
) (
    input clk,
    input reset,
    // input 
    input [N_UNIT*DW_DATA-1:0] in_a,
    input [TILE_K*DW_DATA-1:0] in_b,
    // output
    output [TILE_M*DW_DATA-1:0] out
);

    wire [N_UNIT*DW_DATA-1:0] wire_dp_out;
    
    multiplier_array #(
        .N_UNIT(N_UNIT),
        .DW_DATA(DW_DATA)
    ) u_dp_group (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .in_a(in_a),
        .in_b({4{in_b}}),
        .in_valid(2'b11),
        .out(wire_dp_out)
    );

    tc_rn #(
        .DW_DATA(DW_DATA)
    ) u_tc_rn (
        .clk(clk),
        .rst(rst),
        .in(wire_dp_out),
        .out(out)
    );

endmodule