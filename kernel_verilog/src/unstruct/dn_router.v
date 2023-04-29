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
    input [DW_DATA-1:0] in [1:0],
    output [DW_DATA-1:0] out [1:0]
);

    reg [DW_DATA-1:0] reg_out_left, reg_out_right;
    always @(posedge clk) begin
        if (reset) begin: reset_block
            reg_out_left <= in[0];
            reg_out_right <= in[1];
        end
        else if (set_en) begin: set_block
            reg_out_left <= in[route_signal[0]];
            reg_out_right <= in[route_signal[1]];
        end
        else if (~route_en) begin: 
            reg_out_left <= 0;
            reg_out_right <= 0;
        end
    end

    assign out[0] = reg_out_left;
    assign out[1] = reg_out_right;

endmodule