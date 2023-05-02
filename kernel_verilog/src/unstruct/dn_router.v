`timescale 1ns / 1ps

module dn_router
#(
    parameter DW_DATA = 8
)(
    input clk,
    input reset,
    input set_en,
    input route_en,
    input [1:0] route_signal,
    input [DW_DATA*2-1:0] in,
    output [DW_DATA*2-1:0] out
);

    reg [DW_DATA-1:0] reg_out_left, reg_out_right;
    always @(posedge clk) begin
        if (reset) begin: reset_block
            reg_out_left <= in[0];
            reg_out_right <= in[1];
        end
        else if (set_en) begin: set_block
            // set left out
            if (route_signal[0]) begin
                reg_out_left <= in[2*DW_DATA-1:DW_DATA];
            end
            else begin
                reg_out_left <= in[DW_DATA-1:0];
            end
            // set right out
            if (route_signal[1]) begin
                reg_out_right <= in[2*DW_DATA-1:DW_DATA];
            end
            else begin
                reg_out_right <= in[DW_DATA-1:0];
            end
        end
        else if (~route_en) begin: route_block
            reg_out_left <= 0;
            reg_out_right <= 0;
        end
    end

    assign out = {reg_out_left, reg_out_right};

endmodule