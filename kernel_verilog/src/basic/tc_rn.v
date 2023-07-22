`timescale 1ns / 1ps

module tc_rn #(
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 4,
    parameter NUM_IN = TILE_M * TILE_K * TILE_N,
    parameter N_ADT = TILE_M,
    parameter N_STACK = TILE_N,
    parameter DW_IN = 16,
    parameter DW_DATA = 32,
    parameter DW_LINE = N_STACK*DW_DATA
) (
    input clk,
    input rst,
    input [NUM_IN*DW_IN-1:0] in,
    output [N_ADT*DW_LINE-1:0] out
);

    genvar gi;
    wire [NUM_IN*DW_DATA-1:0] wire_in;

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign wire_in[gi*DW_DATA +:DW_DATA] = {16'b0, in[gi*DW_IN +:DW_IN]};
        end
    endgenerate

    generate
        for (gi=0; gi<N_ADT; gi=gi+1) begin
            adder_tree #(
                .N_STACK(N_STACK),
                .DW_DATA(DW_DATA),
                .NUM_IN(TILE_K)
            ) u_adder_tree (
                .clk(clk),
                .rst(rst),
                .in(wire_in[gi*TILE_K*DW_LINE +:TILE_K*DW_LINE]),
                .out(out[gi*DW_LINE +:DW_LINE])
            );
        end
    endgenerate

endmodule