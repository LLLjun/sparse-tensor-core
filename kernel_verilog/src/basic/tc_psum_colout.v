`timescale 1ns / 1ps

module tc_psum_colout #(
    parameter M = 16,
    parameter N = 16,
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 1,
    parameter NUM_IN = 32,
    parameter DW_DATA = 8,
    parameter DW_POS = 4,
    parameter NUM_OUT = N,
    parameter T_OUT = M,
    parameter DW_OUT = NUM_OUT*DW_DATA
) (
    input clk,
    input rst,
    input [DW_POS-1:0] col,
    input [NUM_IN*DW_POS-1:0] row,
    input [NUM_IN*DW_DATA-1:0] in,
    input input_en,
    input out_en,
    output out_valid,
    output [DW_OUT-1:0] out
);
    
    // reg [7:0] count;
    reg [1:0] state, next_state;
    parameter IDLE = 0;
    parameter INPUT = 1;
    parameter OUTPUT = 2;

    reg [DW_DATA-1:0] reg_cache [M-1:0][N-1:0];
    reg [DW_DATA-1:0] reg_out [NUM_OUT-1:0];
    reg [DW_DATA-1:0] reg_add [M-1:0];
    reg reg_out_valid;

    wire [DW_DATA-1:0] wire_in [NUM_IN-1:0];
    wire [DW_POS-1:0] wire_row [NUM_IN-1:0];
    // wire [DW_POS-1:0] wire_col;

    genvar gi;
    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign wire_in[gi] = in[gi*DW_DATA +:DW_DATA];
            assign wire_row[gi] = row[gi*DW_POS +:DW_POS];
            // assign wire_col[gi] = col[gi*DW_POS +:DW_POS];
        end
    endgenerate

    // set state
    always @(posedge clk) begin
        if (rst) begin
            next_state <= IDLE;
        end
        else if (input_en) begin
            next_state <= INPUT;
        end
        else if (out_en) begin
            next_state <= OUTPUT;
        end
        else begin
            next_state <= state;
        end
    end

    always @(posedge clk) begin
        state <= next_state;
    end

    // input
    integer i, j;
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<N; j=j+1) begin
                    reg_cache[i][j] <= 0;
                end
            end
        end
        else if (state <= INPUT) begin
            for (i=0; i<M; i=i+1) begin
                reg_cache[i][col] <= reg_add[i];
            end
        end
    end

    // add
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<M; i=i+1) begin
                reg_add[i] <= reg_cache[i][col];
            end
        end
        else begin
            for (i=0; i<NUM_IN; i=i+1) begin
                reg_add[wire_row[i]] <= wire_in[i];
            end
        end
    end

    // output
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<NUM_OUT; i=i+1) begin
                reg_out[i] <= 0;
            end
        end
        else if (state == OUTPUT) begin
            for (i=0; i<NUM_OUT; i=i+1) begin
                reg_out[i] <= reg_cache[row][i];
            end
        end
    end

    always @(posedge clk) begin
        if (state == OUTPUT) begin
            reg_out_valid <= 1;
        end
        else begin
            reg_out_valid <= 0;
        end
    end

    generate
        for (gi=0; gi<NUM_OUT; gi=gi+1) begin
            assign out[gi*DW_DATA +:DW_DATA] = reg_out[gi];
        end
    endgenerate
    assign out_valid = reg_out_valid;

endmodule