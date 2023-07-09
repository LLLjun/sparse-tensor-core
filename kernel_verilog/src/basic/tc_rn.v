`timescale 1ns / 1ps

module tc_rn #(
    parameter NUM_IN = 32,
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter N_ADT = TILE_M,
    parameter DW_DATA = 8
) (
    input clk,
    input rst,
    input [NUM_IN*DW_DATA-1:0] in,
    output [N_ADT*DW_DATA-1:0] out
);

    genvar gi;
    generate
        for (gi=0; gi<N_ADT; gi=gi+1) begin
            adder_tree #(
                .DW_DATA(DW_DATA),
                .NUM_IN(TILE_K)
            ) u_adder_tree (
                .clk(clk),
                .rst(rst),
                .in(in[gi*TILE_K*DW_DATA +:TILE_K*DW_DATA]),
                .out(out[gi*DW_DATA +:DW_DATA])
            );
        end
    endgenerate

endmodule