`timescale 1ns / 1ps

module col_test #(
    parameter M = 16,
    parameter N = 16,
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 1,
    parameter NUM_IN = M,
    parameter DW_DATA = 8,
    parameter DW_POS = 4,
    parameter NUM_OUT = NUM_IN,
    parameter T_OUT = M,
    parameter DW_OUT = NUM_OUT*DW_DATA
) (
    input clk,
    input rst,
    input [DW_POS-1:0] col,
    // input [NUM_IN*DW_POS-1:0] row,
    input [NUM_IN*DW_DATA-1:0] in,
    // input input_en,
    // input out_en,
    // output out_valid,
    output [DW_OUT-1:0] out
);
    
    reg [DW_DATA-1:0] reg_col [M-1:0];
    // reg [DW_DATA-1:0] reg_out [M-1:0];
    reg [DW_POS-1:0] reg_pos;
    wire [DW_DATA-1:0] wire_in [M-1:0];

    genvar gi;
    generate
        for (gi=0; gi<M; gi=gi+1) begin
            assign wire_in[gi] = in[gi*DW_DATA +:DW_DATA];
        end
    endgenerate

    integer i;

    // set reg pos
    always @(posedge clk) begin
        if (rst) begin
            reg_pos <= 0;
        end
        else begin
            reg_pos <= col;
        end
    end

    // set reg col
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<M; i=i+1) begin
                reg_col[i] <= 0;
            end
        end
        else if (col == reg_pos) begin // accumulate
            for (i=0; i<M; i=i+1) begin
                reg_col[i] <= reg_col[i] + wire_in[i];
            end
        end
        else begin // fresh line
            for (i=0; i<M; i=i+1) begin
                reg_col[i] <= wire_in[i];
            end
        end
    end

    // set out
    generate
        for (gi=0; gi<M; gi=gi+1) begin
            assign out[gi*DW_DATA +:DW_DATA] = reg_col[gi];
        end
    endgenerate

endmodule