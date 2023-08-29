`timescale 1ns / 1ps

module ustc_psum #(
    parameter M = 16,
    parameter N = 16,
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 4,
    parameter NUM_IN = TILE_M * TILE_K,
    parameter N_STACK = TILE_N,
    parameter DW_DATA = 32,
    parameter DW_POS = 4,
    parameter DW_CTRL = 4,
    parameter DW_LINE = N_STACK*DW_DATA + DW_POS + DW_CTRL,
    parameter NUM_OUT = M * N,
    parameter T_OUT = M,
    parameter DW_OUT = NUM_OUT*DW_DATA
) (
    input clk,
    input rst,
    input [DW_POS-1:0] col,
    input [NUM_IN*DW_LINE-1:0] in,
    input input_en,
    input out_en,
    output out_valid,
    output [DW_OUT-1:0] out
);
    reg [DW_DATA-1:0] reg_cache [M-1:0][N-1:0];
    reg [DW_DATA-1:0] reg_add [M-1:0][TILE_N-1:0];
    reg [DW_POS-1:0] reg_col;
    
    integer i, j;
    genvar gi, gj;

    wire [N_STACK*DW_DATA-1:0] wire_in_data [NUM_IN-1:0];
    wire [DW_POS-1:0] wire_in_row [NUM_IN-1:0];
    wire [DW_CTRL-1:0] wire_in_ctrl [NUM_IN-1:0];

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign {wire_in_ctrl[gi], wire_in_row[gi], wire_in_data[gi]} = in[gi*DW_LINE +:DW_LINE];
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
            for (i=0; i<NUM_IN; i=i+1) begin
                if (wire_in_ctrl[i][DW_CTRL-2] == 1) begin
                    for (j=0; j<TILE_N; j=j+1) begin
                        reg_add[wire_in_row[i]][j] <= reg_add[wire_in_row[i]][j] + wire_in_data[i][j*DW_DATA +:DW_DATA];
                    end
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