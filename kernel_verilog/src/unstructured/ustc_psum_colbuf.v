`timescale 1ns / 1ps

module ustc_psum_colbuf #(
    parameter M       = 16,
    parameter N       = 16,
    parameter NUM_IN  = 32,
    parameter DW_DATA = 8,
    parameter DW_ROW  = 4,
    parameter DW_COL  = 4,
    parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL,
    parameter NUM_OUT = M*N,
    parameter DW_OUT  = NUM_OUT*DW_DATA
) (
    input                      clk,
    input                      rst,
    input [DW_COL-1:0]         col,
    input [NUM_IN*DW_LINE-1:0] in,
    input                      input_en,
    input                      output_en,
    output                     out_valid,
    output [DW_OUT-1:0]        out
);

    integer i, j;
    genvar gi;
    reg [7:0] count;
    reg [1:0] state, next_state;
    parameter IDLE = 0;
    parameter INPUT = 1;
    parameter OUTPUT = 2;

    reg [DW_DATA-1:0] reg_matrix [M-1:0][N-1:0];
    reg [DW_DATA-1:0] reg_col [M-1:0];
    reg [DW_DATA-1:0] reg_out [NUM_OUT-1:0];
    reg               reg_out_valid;
    reg [DW_COL-1:0]  reg_last_col;
    
    wire [DW_DATA-1:0] wire_in_data [NUM_IN-1:0];
    wire [DW_ROW-1:0]  wire_in_row [NUM_IN-1:0];
    wire [DW_CTRL-1:0] wire_in_ctrl [NUM_IN-1:0];

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign {wire_in_ctrl[gi], wire_in_row[gi], wire_in_data[gi]} = in[gi*DW_LINE +:DW_LINE];
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
        else if (output_en) begin
            next_state <= OUTPUT;
        end
        else begin
            next_state <= state;
        end
    end

    always @(posedge clk) begin
        state <= next_state;
    end

    always @(posedge clk) begin
        if (rst) begin
            reg_last_col <= 0;
        end
        else begin
            reg_last_col <= col;
        end
    end

    // set reg_col
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<M; i=i+1) begin
                reg_col[i] <= 0;
            end
        end
        else if (state == INPUT) begin
            if (col == reg_last_col) begin
                for (i=0; i<NUM_IN; i=i+1) begin
                    reg_col[wire_in_row[i]] <= reg_col[wire_in_row[i]] + wire_in_data[i];
                end
            end
            else begin
                for (i=0; i<M; i=i+1) begin
                    for (j=0; j<NUM_IN; j=j+1) begin