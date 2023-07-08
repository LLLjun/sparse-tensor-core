`timescale 1ns / 1ps

module cross_ctrl #(
    NUM_IN = 8,
    DW_DATA = 32,
    DW_IDX = 3
) (
    input clk,
    input [NUM_IN*DW_IDX-1:0] idx,
    output [NUM_IN*NUM_IN-1:0] ctrl
);
    reg reg_ctrl[NUM_IN-1:0][NUM_IN-1:0];
    wire [DW_IDX-1:0] wire_idx [NUM_IN-1:0];
    integer i, j;
    genvar gi, gj;

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign wire_idx[gi] = idx[gi*DW_IDX +: DW_IDX];
        end
    endgenerate

    always @(posedge clk) begin
        for (i=0; i<NUM_IN; i=i+1) begin
            for (j=0; j<NUM_IN; j=j+1) begin
                if (i == wire_idx[j])
                    reg_ctrl[i][j] = 1;
                else 
                    reg_ctrl[i][j] = 0;
            end
        end
    end

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            for (gj=0; gj<NUM_IN; gj=gj+1) begin
                assign ctrl[gi*NUM_IN+gj] = reg_ctrl[gi][gj];
            end
        end
    endgenerate

endmodule