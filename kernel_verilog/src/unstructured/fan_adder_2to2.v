`timescale 1ns / 1ps

module fan_adder_2to2 #(
    // for data width
    parameter N_STACK = 4,
    parameter DW_DATA = 32,
    parameter DW_ROW = 4,
    parameter DW_CTRL = 4,
    parameter DW_LINE = N_STACK*DW_DATA + DW_ROW + DW_CTRL,
    parameter NUM_IN = 2,
    parameter OUT_LEFT = NUM_IN / 2 - 1,
    parameter OUT_RIGHT = NUM_IN / 2,
    parameter SYMMETRY = 0
) (
    input clk,
    input rst,
    input [NUM_IN*DW_LINE-1:0] in,
    output [NUM_IN*DW_LINE-1:0] out
);
    genvar gi;
    integer i;
    wire [DW_LINE-1:0] in_line [NUM_IN-1:0];
    reg [DW_LINE-1:0] reg_out [NUM_IN-1:0];
    wire [DW_LINE-1:0] add_left, add_right;
    wire [N_STACK*DW_DATA-1:0] add_left_data, add_right_data, add_result;
    wire [DW_ROW-1:0] add_left_row, add_right_row;
    wire [DW_CTRL-1:0] add_left_ctrl, add_right_ctrl;

    // always @(posedge clk) begin
    //     for (i=0; i<NUM_IN; i=i+1) begin
    //         in_line[i] <= in[i*DW_LINE +:DW_LINE];
    //     end
    // end
    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign in_line[gi] = in[gi*DW_LINE +:DW_LINE];
        end
    endgenerate

    assign add_left  = in_line[0];
    assign add_right = in_line[1];
    assign add_left_data = add_left[0 +:N_STACK*DW_DATA];
    assign add_left_row = add_left[N_STACK*DW_DATA +:DW_ROW];
    assign add_left_ctrl = add_left[N_STACK*DW_DATA+DW_ROW +:DW_CTRL];
    assign add_right_data = add_right[0 +:N_STACK*DW_DATA];
    assign add_right_row = add_right[N_STACK*DW_DATA +:DW_ROW];
    assign add_right_ctrl = add_right[N_STACK*DW_DATA+DW_ROW +:DW_CTRL];

    always @(posedge clk) begin
        if (rst) begin: reset
            reg_out[0] <= 0;
            reg_out[1] <= 0;
        end
        else if (add_left_ctrl[DW_CTRL-1]==1 && add_right_ctrl[DW_CTRL-1]==1 && add_left_row == add_right_row) begin: add
            if (add_left_ctrl[0 +:2]==2'b01 && add_right_ctrl[0 +:2]==2'b10) begin
                reg_out[OUT_LEFT] <= {4'b0111, add_left_row, add_result};
                reg_out[OUT_RIGHT] <= 0;
            end
            else if (add_left_ctrl[0 +:2]==2'b01) begin
                reg_out[OUT_LEFT] <= 0;
                reg_out[OUT_RIGHT] <= {4'b1001, add_left_row, add_result};
            end
            else if (add_right_ctrl[0 +:2]==2'b10) begin
                reg_out[OUT_LEFT] <= {4'b1010, add_left_row, add_result};
                reg_out[OUT_RIGHT] <= 0;
            end
            else if (SYMMETRY==0) begin
                reg_out[OUT_LEFT] <= {4'b1000, add_left_row, add_result};
                reg_out[OUT_RIGHT] <= 0;
            end
            else begin
                reg_out[OUT_LEFT] <= 0;
                reg_out[OUT_RIGHT] <= {4'b1000, add_left_row, add_result};
            end
        end
        else begin: bypass
            reg_out[0] <= in_line[0];
            reg_out[1] <= in_line[1];
        end
    end

    generate
        for (gi=0; gi<NUM_IN; gi=gi+1) begin
            assign out[gi*DW_LINE +:DW_LINE] = reg_out[gi];
        end
    endgenerate

    instant_adder #(
        .N_STACK(N_STACK),
        .DW_DATA(DW_DATA)
    ) adder_u (
        .in_a(add_left_data),
        .in_b(add_right_data),
        .out(add_result)
    );

endmodule