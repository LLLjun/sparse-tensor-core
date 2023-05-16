`timescale 1ns / 1ps

// dealy exists!
module dp_unit #(
    parameter DW_DATA = 32
) (
    input clk,
    input reset,
    input enable,
    input signed [DW_DATA-1:0] in_a,
    input signed [DW_DATA-1:0] in_b,
    input [1:0] in_valid,
    output signed [DW_DATA-1:0] out
);

    reg signed [DW_DATA-1:0] reg_multiplier_ia;
    reg signed [DW_DATA-1:0] reg_multiplier_ib;
    wire signed [DW_DATA-1:0] wire_multiplier_o;
    wire s_axis_a_tready, s_axis_b_tready, m_axis_result_tvalid;

    always @(posedge clk) begin
        if (reset) begin
            reg_multiplier_ia <= 0;
            reg_multiplier_ib <= 0;
            // reg_multiplier_o <= 0;
        end
        else if (enable) begin
            // reg_multiplier_o <= reg_multiplier_ia * reg_multiplier_ib;

            if (in_valid[1] == 1'b1) begin : write_ia_block
                reg_multiplier_ia <= in_a;
            end
            if (in_valid[0] == 1'b1) begin : write_ib_block
                reg_multiplier_ib <= in_b;
            end
        end
    end

    floating_point_0 u_floating_point (
        .aclk(clk),                                  // input wire aclk
      //  .aresetn(aresetn),                            // input wire aresetn(active low)
        .s_axis_a_tvalid(1'b1),            // input wire s_axis_a_tvalid
        .s_axis_a_tready(s_axis_a_tready),
        .s_axis_a_tdata(reg_multiplier_ia),              // input wire [31 : 0] s_axis_a_tdata
      
        .s_axis_b_tvalid(1'b1),            // input wire s_axis_b_tvalid
        .s_axis_b_tready(s_axis_b_tready),
        .s_axis_b_tdata(reg_multiplier_ib),              // input wire [31 : 0] s_axis_b_tdata
      
        .m_axis_result_tready(1'b1),            // input wire s_axis_c_tvalid
        .m_axis_result_tvalid(m_axis_result_tvalid),
        .m_axis_result_tdata(wire_multiplier_o)           // input wire [31 : 0] s_axis_c_tdata
    );

    assign out = wire_multiplier_o;

endmodule