`timescale 1ns / 1ps

module tb_reduction_mux();
parameter DW_DATA = 8;
parameter NUM_IN = 4;
parameter SEL_IN = 2;

reg [DW_DATA*NUM_IN-1:0] in;
reg [SEL_IN*2-1:0] sel;
wire [DW_DATA*2-1:0] out;

initial begin
    in = {8'd1, 8'd2, 8'd3, 8'd4};
    sel = {2'b00, 2'b00};
end

initial begin
    #10
    sel = {2'd3, 2'd1};
    #60 $finish;
end

reduction_mux #(
    .DW_DATA(DW_DATA),
    .NUM_IN(NUM_IN),
    .SEL_IN(SEL_IN)
) u_reduction_mux (
    .in(in),
    .sel(sel),
    .out(out)
);

endmodule