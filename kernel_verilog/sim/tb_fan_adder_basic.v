`timescale 1ns / 1ps

module tb_fan_adder_basic();
parameter DW_DATA = 8;
parameter DW_ROW = 5;
parameter DW_CTRL = 4;
parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL;
//
parameter NUM_IN = 2;

reg clk;
reg [NUM_IN*DW_LINE-1:0] in;
wire [DW_LINE-1:0] out;

initial begin
    clk = 1'b1;
end
always #5 clk = ~clk;

initial begin
    #10
    in = {17'b1010_00000_00000001, 17'b1001_00000_00000010};
    #10
    in = {17'b1010_00001_00000001, 17'b1000_00001_00000010};
    #20 $finish;
end

fan_adder #(
    .DW_DATA(DW_DATA),
    .DW_ROW(DW_ROW),
    .DW_CTRL(DW_CTRL),
    .DW_LINE(DW_LINE),
    .NUM_IN(NUM_IN)
) u_adder (
    .clk(clk),
    .in(in),
    .out(out)
);

endmodule   