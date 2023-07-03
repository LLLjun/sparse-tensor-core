`timescale 1ns / 1ps

module ustc_dn #(
    parameter NUM_XBAR = 4,
    parameter N_XBAR_IN = 8,
    parameter N_DN_IN = NUM_XBAR * N_XBAR_IN,
    parameter DW_DATA = 32,
    parameter DW_IDX = 4,
    parameter NUM_PER_LINE = 1,
    parameter DW_LINE = DW_DATA * NUM_PER_LINE
) (
    input clk,
    input reset,
    input [N_XBAR_IN*DW_LINE-1:0] in,
    input [N_DN_IN*DW_IDX-1:0] idx,
    output [N_DN_IN*DW_LINE-1:0] out
);

    wire [N_XBAR_IN*DW_IDX-1:0] wire_idx [NUM_XBAR-1:0];

    genvar gi;

    generate
        for (gi=0; gi<NUM_XBAR; gi=gi+1) begin
            assign wire_idx[gi] = idx[gi*N_XBAR_IN*DW_IDX +: N_XBAR_IN*DW_IDX];
        end
    endgenerate

    generate
        for (gi=0; gi<NUM_XBAR; gi=gi+1) begin
            ustc_crossbar #(
                .DW_DATA(DW_DATA),
                .N(N_XBAR_IN),
                .NUM_PER_LINE(NUM_PER_LINE)
            ) u_ustc_crossbar (
                .clk(clk),
                .reset(reset),
                .idx(wire_idx[gi]),
                .in(in),
                .out(out[gi*N_XBAR_IN*DW_LINE +: N_XBAR_IN*DW_LINE])
            );
        end
    endgenerate

endmodule