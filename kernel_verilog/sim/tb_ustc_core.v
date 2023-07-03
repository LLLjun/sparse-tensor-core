`timescale 1ns / 1ps

module tb_ustc_core();
parameter M = 16;
parameter N = 16;
parameter K = 16;
parameter tileN = 1;
parameter tileK = 8;
parameter iterN = 16;
parameter iterK = 2;
parameter N_UNIT = 32;
parameter DW_DATA = 8;
parameter DW_ROW = 4;
parameter DW_COL = 4;
parameter DW_CTRL = 4;
parameter DW_A = DW_DATA+DW_ROW+DW_COL;
parameter DW_B = DW_DATA;

reg clk;
reg reset;
// input 
reg load_en;
reg compute_en;
reg [DW_A-1:0] in_a [M*K-1:0];
reg [DW_CTRL-1:0] in_a_ctrl [M*K-1:0];
reg [DW_B-1:0] in_b [N*K-1:0];
wire [M*K*DW_A-1:0] wire_in_a;
wire [M*K*DW_CTRL-1:0] wire_in_a_ctrl;
wire [K*N*DW_B-1:0] wire_in_b;
reg [3:0] num_blocks;
wire [N*DW_DATA-1:0] out;

always #5 clk = ~clk;

genvar gi, gj;

generate
    for (gi=0; gi<M; gi=gi+1) begin
        for (gj=0; gj<K; gj=gj+1) begin
            assign wire_in_a[(gi*K+gj)*DW_A +:DW_A] = in_a[gi*K+gj];
        end
    end
    for (gi=0; gi<M; gi=gi+1) begin
        for (gj=0; gj<K; gj=gj+1) begin
            assign wire_in_a_ctrl[(gi*K+gj)*DW_CTRL +:DW_CTRL] = in_a_ctrl[gi*K+gj];
        end
    end
    for (gi=0; gi<N; gi=gi+1) begin
        for (gj=0; gj<K; gj=gj+1) begin
            assign wire_in_b[(gi*K+gj)*DW_B +:DW_B] = in_b[gi*K+gj];
        end
    end
endgenerate

initial begin
    clk = 1;
    reset = 1;
    $readmemh("D:/Project/Verilog/tensorcore/new ustc/sparse-tensor-core/in_a.txt",in_a);
    $readmemh("D:/Project/Verilog/tensorcore/new ustc/sparse-tensor-core/in_a_ctrl.txt",in_a_ctrl);
    $readmemh("D:/Project/Verilog/tensorcore/new ustc/sparse-tensor-core/in_b.txt",in_b);
    num_blocks = 4'd4;
    load_en = 0;
    compute_en = 0;
    #10
    reset = 0;
    #10
    load_en = 1;
    #20
    load_en = 0;
    compute_en = 1;
    #2000 $finish;
end

ustc_core u_ustc_core (
    .clk(clk),
    .reset(reset),
    .load_en(load_en),
    .compute_en(compute_en),
    .in_a(wire_in_a),
    .in_a_ctrl(wire_in_a_ctrl),
    .in_b(wire_in_b),
    .num_blocks(num_blocks),
    .out(out)
);

endmodule