`timescale 1ns / 1ps

module fan_adder #(
    // for data width
    parameter DW_DATA = 32,
    parameter DW_ROW = 5,
    parameter DW_CTRL = 4,
    parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL,
    //
    parameter NUM_IN = 2
) (
    input clk,
    input [NUM_IN*DW_LINE-1:0] in,
    output [2*DW_LINE-1:0] out
);
    integer i;
    reg [DW_DATA-1:0] reg_in_data [NUM_IN-1:0];
    reg [DW_ROW-1:0] reg_in_row [NUM_IN-1:0];
    reg [DW_CTRL-1:0] reg_in_ctrl [NUM_IN-1:0];
    reg [DW_DATA-1:0] reg_adder_in_data [1:0];
    reg [DW_ROW-1:0] reg_adder_in_row [1:0];
    reg [DW_CTRL-1:0] reg_adder_in_ctrl [1:0];
    reg [DW_LINE-1:0] reg_out [1:0];
    reg [DW_LINE-1:0] reg_out_add;

    always @(*) begin
        for (i=0; i<NUM_IN; i=i+1) begin
            reg_in_data[i] <= in[i*DW_LINE +:DW_DATA];
            reg_in_row[i] <= in[i*DW_LINE+DW_DATA +:DW_ROW];
            reg_in_ctrl[i] <= in[i*DW_LINE+DW_DATA+DW_ROW +:DW_CTRL];
        end
    end

    // REDUCTION_MUX
    generate 
    if (NUM_IN == 2) begin: basic_ver
        always @(*) begin
            // choose left in
            reg_adder_in_data[0] <= reg_in_data[0];
            reg_adder_in_row[0] <= reg_in_row[0];
            reg_adder_in_ctrl[0] <= reg_in_ctrl[0];
            // choose right in
            reg_adder_in_data[1] <= reg_in_data[1];
            reg_adder_in_row[1] <= reg_in_row[1];
            reg_adder_in_ctrl[1] <= reg_in_ctrl[1];
        end
    end
    else if (NUM_IN == 4) begin: mux_2to1
        always @(*) begin
            // choose left in
            if (reg_in_ctrl[0][DW_CTRL-1] == 1) begin
                reg_adder_in_data[0] <= reg_in_data[0];
                reg_adder_in_row[0] <= reg_in_row[0];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[0];
            end
            else begin
                reg_adder_in_data[0] <= reg_in_data[1];
                reg_adder_in_row[0] <= reg_in_row[1];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[1];
            end
            // choose right in
            if (reg_in_ctrl[3][DW_CTRL-1] == 1) begin
                reg_adder_in_data[1] <= reg_in_data[3];
                reg_adder_in_row[1] <= reg_in_row[3];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[3];
            end
            else begin
                reg_adder_in_data[1] <= reg_in_data[2];
                reg_adder_in_row[1] <= reg_in_row[2];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[2];
            end
        end
    end
    else if (NUM_IN == 6) begin: mux_3to1
        always @(*) begin
            // choose left in
            if (reg_in_ctrl[0][DW_CTRL-1] == 1) begin
                reg_adder_in_data[0] <= reg_in_data[0];
                reg_adder_in_row[0] <= reg_in_row[0];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[0];
            end
            else if (reg_in_ctrl[1][DW_CTRL-1] == 1) begin
                reg_adder_in_data[0] <= reg_in_data[1];
                reg_adder_in_row[0] <= reg_in_row[1];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[1];
            end
            else begin
                reg_adder_in_data[0] <= reg_in_data[2];
                reg_adder_in_row[0] <= reg_in_row[2];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[2];
            end
            // choose right in
            if (reg_in_ctrl[5][DW_CTRL-1] == 1) begin
                reg_adder_in_data[1] <= reg_in_data[5];
                reg_adder_in_row[1] <= reg_in_row[5];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[5];
            end
            else if (reg_in_ctrl[4][DW_CTRL-1] == 1) begin
                reg_adder_in_data[1] <= reg_in_data[4];
                reg_adder_in_row[1] <= reg_in_row[4];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[4];
            end
            else begin
                reg_adder_in_data[1] <= reg_in_data[3];
                reg_adder_in_row[1] <= reg_in_row[3];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[3];
            end
        end
    end
    else if (NUM_IN == 8) begin: mux_4to1
        always @(*) begin
            // choose left in
            if (reg_in_ctrl[0][DW_CTRL-1] == 1) begin
                reg_adder_in_data[0] <= reg_in_data[0];
                reg_adder_in_row[0] <= reg_in_row[0];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[0];
            end
            else if (reg_in_ctrl[1][DW_CTRL-1] == 1) begin
                reg_adder_in_data[0] <= reg_in_data[1];
                reg_adder_in_row[0] <= reg_in_row[1];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[1];
            end
            else if (reg_in_ctrl[2][DW_CTRL-1] == 1) begin
                reg_adder_in_data[0] <= reg_in_data[2];
                reg_adder_in_row[0] <= reg_in_row[2];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[2];
            end
            else begin
                reg_adder_in_data[0] <= reg_in_data[3];
                reg_adder_in_row[0] <= reg_in_row[3];
                reg_adder_in_ctrl[0] <= reg_in_ctrl[3];
            end
            // choose right in
            if (reg_in_ctrl[7][DW_CTRL-1] == 1) begin
                reg_adder_in_data[1] <= reg_in_data[7];
                reg_adder_in_row[1] <= reg_in_row[7];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[7];
            end
            else if (reg_in_ctrl[6][DW_CTRL-1] == 1) begin
                reg_adder_in_data[1] <= reg_in_data[6];
                reg_adder_in_row[1] <= reg_in_row[6];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[6];
            end
            else if (reg_in_ctrl[5][DW_CTRL-1] == 1) begin
                reg_adder_in_data[1] <= reg_in_data[5];
                reg_adder_in_row[1] <= reg_in_row[5];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[5];
            end
            else begin
                reg_adder_in_data[1] <= reg_in_data[4];
                reg_adder_in_row[1] <= reg_in_row[4];
                reg_adder_in_ctrl[1] <= reg_in_ctrl[4];
            end
        end
    end
    endgenerate

    // ADDER
    always @(posedge clk) begin
        if (reg_adder_in_row[0] == reg_adder_in_row[1]) begin // add mode
            // compute data
            reg_out_add[0 +:DW_DATA] <= reg_adder_in_data[0] + reg_adder_in_data[1];
            // set row
            reg_out_add[DW_DATA +:DW_ROW] <= reg_adder_in_row[0];
            // set edge & valid/active
            if (reg_adder_in_ctrl[0][1:0] == 2'b01 && reg_adder_in_ctrl[1][1:0] == 2'b10) begin
                reg_out_add[DW_DATA+DW_ROW +:DW_CTRL] <= 4'b0111;
            end
            else if (reg_adder_in_ctrl[0][1:0] == 2'b01) begin
                reg_out_add[DW_DATA+DW_ROW +:DW_CTRL] <= 4'b1001;
            end
            else if (reg_adder_in_ctrl[1][1:0] == 2'b10) begin
                reg_out_add[DW_DATA+DW_ROW +:DW_CTRL] <= 4'b1010;
            end
            else begin
                reg_out_add[DW_DATA+DW_ROW +:DW_CTRL] <= 4'b1000;
            end
            if (reg_out_add[DW_DATA+DW_ROW +:1]== 2'b01) begin// is start
                reg_out[0] <= 0;
                reg_out[1] <= reg_out_add;
            end
            else if (reg_out_add[DW_DATA+DW_ROW +:1]== 2'b10) begin// is end
                reg_out[0] <= reg_out_add;
                reg_out[1] <= 0;
            end 
            else begin// is end
                reg_out[0] <= reg_out_add;
                reg_out[1] <= reg_out_add;
            end
        end
        else begin
            reg_out[0] <= {reg_adder_in_ctrl[0], reg_adder_in_row[0], reg_adder_in_data[0]};
            reg_out[1] <= {reg_adder_in_ctrl[1], reg_adder_in_row[1], reg_adder_in_data[1]};
//            reg_out[0] <= {17'b1};
//            reg_out[1] <= {17'b1};
        end
    end

    assign out = {reg_out[1], reg_out[0]};

endmodule