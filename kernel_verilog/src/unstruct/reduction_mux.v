`timescale 1ns / 1ps

module reduction_mux
#(
    parameter DW_DATA = 8,
    parameter NUM_IN = 4,
    parameter SEL_IN = 2
)
(
    input [DW_DATA*NUM_IN-1:0] in,
    input [SEL_IN*2-1:0] sel,
    output [DW_DATA*2-1:0] out
);

    reg [SEL_IN-1:0] SEL_LEFT, SEL_RIGHT;
    always @(*) begin
        SEL_RIGHT <= sel[2*SEL_IN-1 -:SEL_IN];
        SEL_LEFT <= sel[SEL_IN-1 -:SEL_IN]; 
    end
    
    assign out = {in[(SEL_RIGHT+1)*DW_DATA-1 -:DW_DATA], in[(SEL_LEFT+1)*DW_DATA-1 -:DW_DATA]};

endmodule