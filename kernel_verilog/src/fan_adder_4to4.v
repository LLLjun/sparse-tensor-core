`timescale 1ns / 1ps

module fan_adder_4to4 #(
    // for data width
    parameter DW_DATA = 8,
    parameter DW_ROW = 4,
    parameter DW_CTRL = 4,
    parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL
) (
    input clk,
    input rst,
    input [4*DW_LINE-1:0] in,
    output [4*DW_LINE-1:0] out
);
    genvar gi;
    wire [DW_LINE-1:0] in_line [3:0];
    wire [DW_DATA-1:0] in_data [3:0];
    wire [DW_ROW-1:0] in_row [3:0];
    wire [DW_CTRL-1:0] in_ctrl [3:0];
    reg [DW_LINE-1:0] reg_out [3:0];

    generate
        for (gi=0; gi<4; gi=gi+1) begin
            assign in_line[gi] = in[gi*DW_LINE +:DW_LINE];
            assign in_data[gi] = in[gi*DW_LINE +:DW_DATA];
            assign in_row[gi] = in[gi*DW_LINE+DW_DATA +:DW_ROW];
            assign in_ctrl[gi] = in[gi*DW_LINE+DW_DATA+DW_ROW +:DW_CTRL];
        end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin: reset
            reg_out[0] <= 0;
            reg_out[1] <= 0;
            reg_out[2] <= 0;
            reg_out[3] <= 0;
        end
        else if (in[1*DW_LINE+DW_DATA +:DW_ROW] != in[2*DW_LINE+DW_DATA +:DW_ROW]) begin: bypass
            reg_out[0] <= in_line[0];
            reg_out[1] <= in_line[1];
            reg_out[2] <= in_line[2];
            reg_out[3] <= in_line[3];
        end
        else begin: add
            // 0 + x
            if (in_ctrl[0][DW_CTRL-1] == 1) begin
                // 0 + 3
                if (in_ctrl[3][DW_CTRL-1] == 1) begin
                    if (in_ctrl[0][0 +:2]==2'b01 && in_ctrl[3][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b0111, in_row[0], in_data[0]+in_data[3]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[0][0 +:2]==2'b01) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= 0;
                        reg_out[2] <= {4'b1001, in_row[0], in_data[0]+in_data[3]};
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[3][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[0], in_data[0]+in_data[3]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[0], in_data[0]+in_data[3]};
                        reg_out[2] <= {4'b1010, in_row[0], in_data[0]+in_data[3]};
                        reg_out[3] <= 0;
                    end
                end
                // 0 + 2
                else begin
                    if (in_ctrl[0][0 +:2]==2'b01 && in_ctrl[2][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b0111, in_row[0], in_data[0]+in_data[2]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[0][0 +:2]==2'b01) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= 0;
                        reg_out[2] <= {4'b1001, in_row[0], in_data[0]+in_data[2]};
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[2][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[0], in_data[0]+in_data[2]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[0], in_data[0]+in_data[2]};
                        reg_out[2] <= {4'b1010, in_row[0], in_data[0]+in_data[2]};
                        reg_out[3] <= 0;
                    end
                end
            end
            // 1 + x
            else begin
                // 1 + 3
                if (in_ctrl[3][DW_CTRL-1] == 1) begin
                    if (in_ctrl[1][0 +:2]==2'b01 && in_ctrl[3][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b0111, in_row[1], in_data[1]+in_data[3]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[1][0 +:2]==2'b01) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= 0;
                        reg_out[2] <= {4'b1001, in_row[1], in_data[1]+in_data[3]};
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[3][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[1], in_data[1]+in_data[3]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[1], in_data[1]+in_data[3]};
                        reg_out[2] <= {4'b1010, in_row[1], in_data[1]+in_data[3]};
                        reg_out[3] <= 0;
                    end
                end
                // 1 + 2
                else begin
                    if (in_ctrl[1][0 +:2]==2'b01 && in_ctrl[2][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b0111, in_row[1], in_data[1]+in_data[2]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[1][0 +:2]==2'b01) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= 0;
                        reg_out[2] <= {4'b1001, in_row[1], in_data[1]+in_data[2]};
                        reg_out[3] <= 0;
                    end
                    else if (in_ctrl[2][0 +:2]==2'b10) begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[1], in_data[1]+in_data[2]};
                        reg_out[2] <= 0;
                        reg_out[3] <= 0;
                    end
                    else begin
                        reg_out[0] <= 0;
                        reg_out[1] <= {4'b1010, in_row[1], in_data[1]+in_data[2]};
                        reg_out[2] <= {4'b1010, in_row[1], in_data[1]+in_data[2]};
                        reg_out[3] <= 0;
                    end
                end
            end
        end
    end


    assign out[0*DW_LINE +:DW_LINE] = reg_out[0];
    assign out[1*DW_LINE +:DW_LINE] = reg_out[1];
    assign out[2*DW_LINE +:DW_LINE] = reg_out[2];
    assign out[3*DW_LINE +:DW_LINE] = reg_out[3];

endmodule