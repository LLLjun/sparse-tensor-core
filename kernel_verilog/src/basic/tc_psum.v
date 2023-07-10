`timescale 1ns / 1ps

module tc_psum #(
    parameter M = 16,
    parameter N = 16,
    parameter TILE_M = 4,
    parameter TILE_K = 8,
    parameter TILE_N = 1,
    parameter NUM_IN = 4,
    parameter DW_DATA = 8,
    parameter DW_POS = 4,
    parameter NUM_OUT = N,
    parameter T_OUT = M,
    parameter DW_OUT = NUM_OUT*DW_DATA
) (
    input clk,
    input rst,
    input [DW_POS-1:0] col,
    input [DW_POS-1:0] row,
    input [TILE_M*DW_DATA-1:0] in,
    input input_en,
    input out_en,
    output out_valid,
    output [DW_OUT-1:0] out
);
    
    integer i, j;
    genvar gi;
    reg [7:0] count;
    reg state, next_state;
    parameter IDLE = 0;
    parameter INPUT  = 1;
    parameter OUTPUT = 2;

    reg [DW_DATA-1:0] reg_cache [M-1:0][N-1:0];
    wire [DW_DATA-1:0] wire_in_data [NUM_IN-1:0];
    reg [DW_DATA-1:0] reg_out [NUM_OUT-1:0];
    reg reg_out_valid;

    generate
        for (gi=0; gi<TILE_M; gi=gi+1) begin
            assign wire_in_data[gi] = in[gi*DW_DATA +:DW_DATA];
        end
    endgenerate
    
    always @(posedge clk) begin
        if (rst) begin // reset
            for (i=0; i<M; i=i+1) begin
                for (j=0; j<N; j=j+1) begin
                    reg_cache[i][j] <= 0;
                end
            end
            for (i=0; i<NUM_OUT; i=i+1) begin
                reg_out[i] <= 0;
            end
        end
        else if (state == INPUT) begin // sum
            for (i=0; i<TILE_M; i=i+1) begin
                reg_cache[row+i][col] <= reg_cache[row+i][col] + wire_in_data[i];
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
        if (rst) begin
            next_state <= IDLE;
            count <= 0;
            reg_out_valid <= 0;
        end
        else if (state==IDLE) begin
            if (input_en)
                next_state <= INPUT;
        end
        else if (state==INPUT) begin
            reg_out_valid <= 0;
            if (out_en) begin
                count <= 0;
                next_state <= OUTPUT;
            end
            else begin
                next_state <= INPUT;
            end
        end
        else if (state == OUTPUT) begin
            reg_out_valid <= 1;
            if (count < T_OUT) begin
                count <= count + 1;
            end
            else begin
                next_state <= INPUT;
            end
        end
    end

    assign out_valid = reg_out_valid;
    generate
        for (gi=0; gi<NUM_OUT; gi=gi+1) begin
            assign out[gi*DW_DATA +:DW_DATA] = reg_out[gi];
        end
    endgenerate

endmodule