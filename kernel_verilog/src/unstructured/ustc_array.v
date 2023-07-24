`timescale 1ns / 1ps

module ustc_array #(
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 4,
    parameter N_LINE = TILE_M * TILE_K,
    parameter N_UNIT = TILE_M * TILE_K * TILE_N,
    parameter N_STACK = TILE_N,
    parameter DW_IN = 8,
    parameter DW_ROW = 4,
    parameter DW_CTRL = 4,
    parameter DW_IDX = 4,
    parameter DW_MULT = 2*DW_IN,
    parameter DW_LINE = DW_CTRL + DW_ROW + N_STACK * DW_OUT,
    parameter DW_OUT = 32
) (
    input clk,
    input reset,
    // input 
    input [TILE_M*TILE_K*DW_IN-1:0] in_a,
    input [TILE_K*TILE_N*DW_IN-1:0] in_b,
    input [N_LINE*DW_IDX-1:0] in_a_col,
    input [N_LINE*DW_ROW-1:0] in_a_row,
    input [N_LINE*DW_CTRL-1:0] in_a_ctrl,
    // output
    output [N_LINE*DW_LINE-1:0] out
);
    wire [N_UNIT*DW_IN-1:0] wire_in_a, wire_in_b;
    wire [N_UNIT*DW_MULT-1:0] wire_dp_out;
    wire [N_UNIT*DW_OUT-1:0] wire_rn_in;
    reg [N_UNIT*DW_LINE-1:0] reg_fan_in;
    wire wire_in_a_valid;

    integer i;
    genvar gi;
    always @(posedge clk) begin
        for (i=0; i<N_LINE; i=i+1) begin
            reg_fan_in[i*DW_LINE +: N_STACK*DW_OUT] <= wire_rn_in[i*N_STACK*DW_OUT +:N_STACK*DW_OUT];
            reg_fan_in[i*DW_LINE + N_STACK*DW_OUT +: DW_ROW] <= in_a_row[i*DW_ROW +:DW_ROW];
            reg_fan_in[i*DW_LINE + N_STACK*DW_OUT + DW_ROW +: DW_CTRL] <= in_a_ctrl[i*DW_CTRL +:DW_CTRL];
        end
    end
    
    ustc_dn #(
        .DW_DATA(DW_IN)
    ) u_ustc_dn (
        .clk(clk),
        .reset(reset),
        .in_a(in_a),
        .in_b(in_b),
        .idx(in_a_col),
        .out_a(wire_in_a),
        .out_b(wire_in_b)
    );

    multiplier_array #(
        .TILE_M(TILE_M),
        .TILE_K(TILE_K),
        .TILE_N(TILE_N),
        .DW_IN(DW_IN)
    ) u_dp_group (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .in_a(wire_in_a),
        .in_b(wire_in_b),
        .in_valid(2'b11),
        .out(wire_dp_out)
    );
    
    generate
        for (gi=0; gi<N_UNIT; gi=gi+1) begin
            assign wire_rn_in[gi*DW_OUT +:DW_OUT] = {16'b0, wire_dp_out[gi*DW_MULT +:DW_MULT]}; // TODO: sign kuozhan 
        end
    endgenerate

    ustc_fan #(
        .DW_DATA(DW_OUT)
    ) u_ustc_fan (
        .clk(clk),
        .rst(reset),
        .in(reg_fan_in),
        .out(out)
    );

endmodule