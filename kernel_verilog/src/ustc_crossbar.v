`timescale 1ns / 1ps

module ustc_crossbar #(
    parameter N = 8,
    parameter DW_DATA = 32,
    parameter DW_IDX = 4,
    parameter NUM_PER_LINE = 1,
    parameter DW_LINE = DW_DATA * NUM_PER_LINE
) (
    input clk,
    input reset,
    input [N*DW_LINE-1:0] in,
    input [N*DW_IDX-1:0] idx,
    output reg [N*DW_LINE-1:0] out
);

    reg [DW_LINE-1:0] reg_in [N-1:0][N-1:0][1:0];
    wire [DW_LINE-1:0] wire_out [N-1:0][N-1:0][1:0];
    reg reg_ctrl[N-1:0][N-1:0];
    wire [DW_IDX-1:0] wire_idx [N-1:0];
    integer i, j;
    genvar gi, gj;

    generate
        for (gi=0; gi<N; gi=gi+1) begin
            assign wire_idx[gi] = idx[gi*DW_IDX +: DW_IDX];
        end
    endgenerate

    always @(posedge clk) begin
        for (i=0; i<N; i=i+1) begin
            for (j=0; j<N; j=j+1) begin
                if (i == wire_idx[j])
                    reg_ctrl[i][j] = 1;
                else 
                    reg_ctrl[i][j] = 0;
            end
        end
    end

    // set connection
    always @(*) begin
        //up-left corner
        reg_in[0][0][0] <= in[0 +:DW_LINE];
        reg_in[0][0][1] <= 0;
        //left edge
        for (i=1; i<N; i=i+1) begin
            reg_in[i][0][0] <= in[i*DW_LINE +:DW_LINE];
            reg_in[i][0][1] <= wire_out[i-1][0][1];
        end
        // up edge
        for (j=1; j<N; j=j+1) begin
            reg_in[0][j][0] <= wire_out[0][j-1][0];
            reg_in[0][j][1] <= 0;
        end
        // left
        for (i=1; i<N; i=i+1) begin
            for (j=1; j<N; j=j+1) begin
                reg_in[i][j][1] <= wire_out[i-1][j][1]; // up-down
                reg_in[i][j][0] <= wire_out[i][j-1][0]; // left-right
            end
        end
        // output at down edge
        for (j=0; j<N; j=j+1) begin
            out[j*DW_LINE +:DW_LINE] <= wire_out[N-1][j][1];
        end
    end

    generate
        for (gi=0; gi<N; gi=gi+1) begin: gen_row
            for (gj=0; gj<N; gj=gj+1) begin: gen_sw
                crossbar_switch #(
                    .DW_DATA(DW_LINE)
                ) u_x_sw (
                    .clk(clk),
                    .reset(reset),
                    .ctrl(reg_ctrl[gi][gj]),
                    .in({reg_in[gi][gj][1], reg_in[gi][gj][0]}),
                    .out({wire_out[gi][gj][1], wire_out[gi][gj][0]})
                );
            end
        end
    endgenerate

endmodule