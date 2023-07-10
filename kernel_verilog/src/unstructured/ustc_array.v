`timescale 1ns / 1ps

module ustc_array #(
    parameter N_UNIT = 32,
    parameter NUM_XBAR = 4,
    parameter N_XBAR_IN = 8,
    parameter DW_DATA = 8,
    parameter DW_ROW = 4,
    parameter DW_CTRL = 4,
    parameter DW_IDX = 4,
    parameter DW_OUT = 16
) (
    input clk,
    input reset,
    // input 
    input [N_UNIT*DW_DATA-1:0] in_a,
    input [N_XBAR_IN*DW_DATA-1:0] in_b,
    input [N_UNIT*DW_IDX-1:0] in_a_col,
    input [N_UNIT*DW_ROW-1:0] in_a_row,
    input [N_UNIT*DW_CTRL-1:0] in_a_ctrl,
    // output
    output [N_UNIT*DW_OUT-1:0] out
);
    wire [N_UNIT*DW_DATA-1:0] wire_in_a, wire_in_b, wire_dp_out;
    reg [N_UNIT*DW_OUT-1:0] reg_fan_in;
    wire wire_in_a_valid;

    // in a late for 1 cycle
    delay_unit #(
        .DW_DATA(N_UNIT*DW_DATA),
        .W_SHIFT(1)
    ) u_delay_in_a (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .in(in_a),
        .out_valid(wire_in_a_valid),
        .out(wire_in_a)
    );

    integer i;
    always @(posedge clk) begin
        for (i=0; i<N_UNIT; i=i+1) begin
            reg_fan_in[i*DW_OUT +: DW_DATA] <= wire_dp_out[i*DW_DATA +:DW_DATA];
            reg_fan_in[i*DW_OUT+DW_DATA +: DW_ROW] <= in_a_row[i*DW_ROW +:DW_ROW];
            reg_fan_in[i*DW_OUT+DW_DATA+DW_ROW +: DW_CTRL] <= in_a_ctrl[i*DW_CTRL +:DW_CTRL];
        end
    end
    
    ustc_dn #(
        .DW_DATA(DW_DATA)
    ) u_ustc_dn (
        .clk(clk),
        .reset(reset),
        .in(in_b),
        .idx(in_a_col),
        .out(wire_in_b)
    );

    multiplier_array #(
        .N_UNIT(N_UNIT),
        .DW_DATA(DW_DATA)
    ) u_dp_group (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .in_a(wire_in_a),
        .in_b(wire_in_b),
        .in_valid(2'b11),
        .out(wire_dp_out)
    );

    ustc_fan #(
        .DW_DATA(DW_DATA)
    ) u_ustc_fan (
        .clk(clk),
        .rst(reset),
        .in(reg_fan_in),
        .out(out)
    );

endmodule