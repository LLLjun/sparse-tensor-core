`timescale 1ns / 1ps

module ustc_dn #(
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 4,
    parameter NUM_XBAR = TILE_M,
    parameter N_XBAR_IN = TILE_K,
    parameter N_STACK = TILE_N,
    parameter N_LINE = TILE_M * TILE_K,
    parameter N_UNIT = TILE_M * TILE_K * TILE_N,
    parameter DW_DATA = 8,
    parameter DW_IDX = 4,
    parameter DW_LINE = DW_DATA * N_STACK
) (
    input clk,
    input reset,
    input [TILE_M*TILE_K*DW_DATA-1:0] in_a,
    input [TILE_K*TILE_N*DW_DATA-1:0] in_b,
    input [N_LINE*DW_IDX-1:0] idx,
    output [N_UNIT*DW_DATA-1:0] out_a,
    output [N_UNIT*DW_DATA-1:0] out_b
);

    wire [N_XBAR_IN*DW_IDX-1:0] wire_idx [NUM_XBAR-1:0];
    reg [DW_LINE-1:0] reg_out_a_stack [N_LINE-1:0];

    genvar gi;
    integer i;

    generate
        for (gi=0; gi<NUM_XBAR; gi=gi+1) begin
            assign wire_idx[gi] = idx[gi*N_XBAR_IN*DW_IDX +: N_XBAR_IN*DW_IDX];
        end
    endgenerate

    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<N_LINE; i=i+1) begin
                reg_out_a_stack[i] <= 0;
            end
        end
        else begin
            for (i=0; i<N_LINE; i=i+1) begin
                reg_out_a_stack[i] <= {N_STACK{in_a[i*DW_DATA +:DW_DATA]}};
            end
        end
    end

    generate
        for (gi=0; gi<N_LINE; gi=gi+1) begin
            assign out_a[gi*DW_LINE +:DW_LINE] = reg_out_a_stack[gi];
        end
    endgenerate

    generate
        for (gi=0; gi<NUM_XBAR; gi=gi+1) begin
            ustc_crossbar #(
                .DW_DATA(DW_LINE),
                .N(N_XBAR_IN),
                .NUM_PER_LINE(N_STACK)
            ) u_ustc_crossbar (
                .clk(clk),
                .reset(reset),
                .idx(wire_idx[gi]),
                .in(in_b),
                .out(out_b[gi*N_XBAR_IN*DW_LINE +: N_XBAR_IN*DW_LINE])
            );
        end
    endgenerate

endmodule