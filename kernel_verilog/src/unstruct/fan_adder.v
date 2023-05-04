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
    input [SEL_IN*2-1:0] sel,
    output [DW_DATA*2-1:0] out
);

    wire [DW_DATA*2-1:0] reg_in;
    reg [DW_DATA*2-1:0] reg_out;
    integer i;

    reduction_mux #(
        .DW_DATA(DW_DATA),
        .NUM_IN(NUM_IN),
        .SEL_IN(SEL_IN)
    ) u_reduction_mux (
        .in(in),
        .sel(sel),
        .out(reg_in)
    );

    always @(*) begin
        if (add_en && ~bypass_en) begin
            reg_out <= {reg_in[DW_DATA-1:0] + reg_in[2*DW_DATA-1 -:DW_DATA], reg_in[DW_DATA-1:0] + reg_in[2*DW_DATA-1 -:DW_DATA]};
        end
        else if (bypass_en && ~add_en) begin
            reg_out <= reg_in;
        end
        else begin
            reg_out <= 0;
        end
    end
    
    assign out = reg_out;
    
endmodule