`timescale 1ns / 1ps

module fan_adder
#(
    parameter DW_DATA = 8,
    parameter NUM_IN = 2,
    parameter SEL_IN = 2
)
(
    input add_en,
    input bypass_en,
    input [DW_DATA*NUM_IN-1:0] in,
    input [2*NUM_IN-1:0] edge_tag_in,
    input [SEL_IN*2-1:0] sel,
    output [1:0] out_valid,
    output [DW_DATA*2-1:0] out,
    output [3:0] edge_tag_out
);

    wire [DW_DATA*2-1:0] reg_in;
    wire [3:0] reg_edge_tag_in;
    reg [DW_DATA*2-1:0] reg_out;
    reg [3:0] reg_edge_tag_out;
    reg [1:0] reg_out_valid;

    reduction_mux #(
        .DW_DATA(DW_DATA),
        .NUM_IN(NUM_IN),
        .SEL_IN(SEL_IN)
    ) u_reduction_mux (
        .in(in),
        .sel(sel),
        .edge_tag_in(edge_tag_in),
        .out(reg_in),
        .edge_tag_out(reg_edge_tag_in)
    );

    always @(*) begin
        if (add_en && ~bypass_en) begin
            reg_out <= {reg_in[DW_DATA-1:0] + reg_in[2*DW_DATA-1 -:DW_DATA], reg_in[DW_DATA-1:0] + reg_in[2*DW_DATA-1 -:DW_DATA]};
            if (reg_edge_tag_in[1:0] == 'b01) begin
                reg_edge_tag_out <= 'b0101;
            end
            else if (reg_edge_tag_in[3:2] == 'b10) begin
                reg_edge_tag_out <= 'b1010;
            end
        end
        else if (bypass_en && ~add_en) begin
            reg_out <= reg_in;
            reg_edge_tag_out <= reg_edge_tag_in;
        end
        else begin
            reg_out <= 0;
        end
    end

    always @(*) begin
        if (reg_edge_tag_in == 'b1111) begin
            reg_out_valid <= 'b11;
        end
        else if (reg_edge_tag_in == 'b1001) begin
            reg_out_valid <= 'b01;
        end
        else if (reg_edge_tag_in == 'b0111) begin
            reg_out_valid <= 'b01;
        end
        else if (reg_edge_tag_in == 'b1110) begin
            reg_out_valid <= 'b10;
        end
        else begin
            reg_out_valid <= 'b00;
        end
    end
    
    assign out = reg_out;
    assign edge_tag_out = reg_edge_tag_out;
    assign out_valid = reg_out_valid;
    
endmodule