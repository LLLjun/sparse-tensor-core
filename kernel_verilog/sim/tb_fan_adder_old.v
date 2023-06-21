`timescale 1ns / 1ps

module tb_fan_adder();
parameter DW_DATA = 8;
parameter NUM_IN = 4;
parameter SEL_IN = 2;

reg add_en;
reg bypass_en;
reg [DW_DATA*NUM_IN-1:0] in;
reg [SEL_IN*2-1:0] sel;
wire [DW_DATA*2-1:0] out;

initial begin
    add_en = 1'b0;
    bypass_en = 1'b0;
    in = {8'd1, 8'd2, 8'd3, 8'd4};
    sel = {2'b00, 2'b00};
end

initial begin
    #10
    bypass_en = 1'b1;
    #10
    add_en = 1'b1;
    bypass_en = 1'b0;
    #10
    sel = {2'd3, 2'd1};
    #10
    add_en = 1'b0;
    bypass_en = 1'b1;
    #60 $finish;
end

fan_adder #(
    .DW_DATA(DW_DATA),
    .NUM_IN(NUM_IN),
    .SEL_IN(SEL_IN)
) u_fan_adder (
    .add_en(add_en),
    .bypass_en(bypass_en),
    .in(in),
    .sel(sel),
    .out(out)
);

endmodule