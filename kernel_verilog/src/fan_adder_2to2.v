`timescale 1ns / 1ps

module fan_adder_2to2 #(
    // for data width
    parameter DW_DATA = 8,
    parameter DW_ROW = 4,
    parameter DW_CTRL = 4,
    parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL
) (
    input clk,
    input rst,
    input [2*DW_LINE-1:0] in,
    output [2*DW_LINE-1:0] out
);
    genvar gi;
    wire [DW_DATA-1:0] reg_adder_in_data [1:0];
    wire [DW_ROW-1:0] reg_adder_in_row [1:0];
    wire [DW_CTRL-1:0] reg_adder_in_ctrl [1:0];
    reg [DW_LINE-1:0] reg_out [1:0];
    reg [DW_LINE-1:0] reg_out_add;

    generate
        for (gi=0; gi<2; gi=gi+1) begin
            assign reg_adder_in_data[gi] = in[gi*DW_LINE +:DW_DATA];
            assign reg_adder_in_row[gi] = in[gi*DW_LINE+DW_DATA +:DW_ROW];
            assign reg_adder_in_ctrl[gi] = in[gi*DW_LINE+DW_DATA+DW_ROW +:DW_CTRL];
        end
    endgenerate


    // ADDER
    always @(posedge clk) begin
        if (rst) begin
            reg_out[0] <= 0;
            reg_out[1] <= 0;
        end
        else begin
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
                if (reg_out_add[DW_DATA+DW_ROW +:2]== 2'b01) begin// is start
                    reg_out[0] <= 0;
                    reg_out[1] <= reg_out_add;
                end
                else if (reg_out_add[DW_DATA+DW_ROW +:2]== 2'b10) begin// is end
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
            end
        end
    end

    assign out = {reg_out[1], reg_out[0]};

endmodule