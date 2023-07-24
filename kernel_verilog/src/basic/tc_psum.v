`timescale 1ns / 1ps

module tc_psum #(
    parameter M = 16,
    parameter N = 16,
    parameter TILE_M = 4,
    parameter TILE_N = 4,
    parameter NUM_IN = TILE_M * TILE_N,
    parameter DW_DATA = 32,
    parameter DW_POS = 4,
    parameter NUM_OUT = M * N,
    parameter T_OUT = M,
    parameter DW_OUT = NUM_OUT*DW_DATA
) (
    input clk,
    input rst,
    input [DW_POS-1:0] col,
    input [DW_POS-1:0] row,
    input [NUM_IN*DW_DATA-1:0] in,
    input input_en,
    input out_en,
    output out_valid,
    output [DW_OUT-1:0] out
);
    reg [DW_DATA-1:0] reg_cache [M-1:0][N-1:0];
    reg [DW_DATA-1:0] reg_add [M-1:0][TILE_N-1:0];
    reg [DW_POS-1:0] reg_col;

    wire [DW_DATA-1:0] wire_in [TILE_M-1:0][TILE_N-1:0];

    genvar gi, gj;
    generate
        for (gi=0; gi<TILE_M; gi=gi+1) begin
            for (gj=0; gj<TILE_N; gj=gj+1) begin
                assign wire_in[gi][gj] = in[(gi*TILE_N+gj)*DW_DATA +:DW_DATA];
            end
        end
    endgenerate

    // set reg pos
    always @(posedge clk) begin
        if (rst) begin
            reg_col <= 0;
        end
        else if (input_en) begin
            reg_col <= col;
        end
        else begin
            reg_col <= 0;
        end
    end


    // reg cache
    integer i, j;
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<N; j=j+1) begin
                    reg_cache[i][j] <= 0;
                end
            end
        end
        else if (col != reg_col) begin
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<TILE_N; j=j+1) begin
                    reg_cache[i][reg_col+j] <= reg_add[i][j];
                end
            end
        end
    end

    // reg add
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<TILE_N; j=j+1) begin
                    reg_add[i][j] <= 0;
                end
            end
        end
        else if (col == reg_col) begin // accumulate
            for (i=0; i<TILE_M; i=i+1) begin
                for (j=0; j<TILE_N; j=j+1) begin
                    reg_add[row+i][j] <= reg_add[row+i][j] + wire_in[i][j];
                end
            end
        end
        else begin // fresh line
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<TILE_N; j=j+1) begin
                    reg_add[i][j] <= 0;
                end
            end
        end
    end

    generate
        for (gi=0; gi<M; gi=gi+1) begin
            for (gj=0; gj<N; gj=gj+1) begin
                assign out[(gi*N+gj)*DW_DATA +:DW_DATA] = reg_cache[gi][gj];
            end
        end
    endgenerate
    assign out_valid = out_en;

endmodule