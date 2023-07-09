`timescale 1ns / 1ps

module adder_tree #(
    parameter NUM_IN = 8,
    parameter N_LEVELS = 3,
    parameter DW_DATA = 8
) (
    input clk,
    input rst,
    input [NUM_IN*DW_DATA-1:0] in,
    output [DW_DATA-1:0] out
);

    wire [DW_DATA-1:0] wire_in [NUM_IN-1:0];
    reg [DW_DATA-1:0] reg_lv2 [3:0];
    reg [DW_DATA-1:0] reg_lv3 [1:0];
    reg [DW_DATA-1:0] reg_out;

    genvar gi;
    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign wire_in[gi] = in[gi*DW_DATA +:DW_DATA];
        end
    endgenerate

    integer i;
    always @(posedge clk) begin
        if (rst) begin
            reg_lv2[0] <= 0;
            reg_lv2[1] <= 0;
            reg_lv2[2] <= 0;
            reg_lv2[3] <= 0;
            reg_lv3[0] <= 0;
            reg_lv3[1] <= 0;
            reg_out <= 0;
        end
        else begin
            reg_lv2[0] <= wire_in[0] + wire_in[1];
            reg_lv2[1] <= wire_in[2] + wire_in[3];
            reg_lv2[2] <= wire_in[4] + wire_in[5];
            reg_lv2[3] <= wire_in[6] + wire_in[7];
            reg_lv3[0] <= reg_lv2[0] + reg_lv2[1];
            reg_lv3[1] <= reg_lv2[2] + reg_lv2[3];
            reg_out    <= reg_lv3[0] + reg_lv3[1];
        end
    end
    
    assign out = reg_out;

endmodule