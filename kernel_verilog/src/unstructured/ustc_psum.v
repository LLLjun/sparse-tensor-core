`timescale 1ns / 1ps

module ustc_psum #(
    parameter M = 16,
    parameter N = 16,
    parameter tileM = 4,
    parameter tileK = 8,
    parameter tileN = 1,
    parameter NUM_IN = 32,
    parameter DW_DATA = 32,
    parameter DW_ROW = 4,
    parameter DW_COL = 4,
    parameter DW_CTRL = 4,
    parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL,
    parameter NUM_OUT = N,
    parameter T_OUT = M,
    parameter DW_OUT = NUM_OUT*DW_DATA
) (
    input clk,
    input rst,
    input [DW_COL-1:0] col,
    input [NUM_IN*DW_LINE-1:0] in,
    input out_en,
    output out_valid,
    output [DW_OUT-1:0] out
);
    
    integer i, j;
    genvar gi;
    reg [7:0] count;
    reg state, next_state;
    parameter INPUT  = 0;
    parameter OUTPUT = 1;

    reg [DW_DATA-1:0] reg_cache [M-1:0][N-1:0];
    wire [DW_DATA-1:0] wire_in_data [NUM_IN-1:0];
    wire [DW_ROW-1:0] wire_in_row [NUM_IN-1:0];
    wire [DW_CTRL-1:0] wire_in_ctrl [NUM_IN-1:0];
    reg [DW_DATA-1:0] reg_out [NUM_OUT-1:0];
    reg reg_out_valid;

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign {wire_in_ctrl[gi], wire_in_row[gi], wire_in_data[gi]} = in[gi*DW_LINE +:DW_LINE];
        end
    endgenerate
    
    always @(posedge clk) begin
        if (rst) begin // reset
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<N; j=j+1) begin
                    reg_cache[i][j] <= 0;
                end
            end
            count <= 0;
            state <= INPUT;
        end
        else if (state == INPUT) begin // sum
            for (i=0; i<NUM_IN; i=i+1) begin
                if (wire_in_ctrl[i][DW_CTRL-2] == 1) begin
                    reg_cache[wire_in_row[i]][col] <= reg_cache[wire_in_row[i]][col]+wire_in_data[i];
                end
            end
        end
        else begin //output
            for (i=0; i<NUM_OUT; i=i+1) begin
                reg_out[i] <= reg_cache[count][i];
            end
        end
    end

    always @(posedge clk) begin
        state <= next_state;
        if (state==INPUT) begin
            reg_out_valid <= 0;
            if (out_en) begin
                count <= 0;
                next_state <= OUTPUT;
            end
            else begin
                next_state <= INPUT;
            end
        end
        if (state == OUTPUT) begin
            reg_out_valid <= 1;
            if (count < T_OUT) begin
                count <= count + 1;
            end
            else begin
                next_state <= INPUT;
            end
        end
    end


endmodule