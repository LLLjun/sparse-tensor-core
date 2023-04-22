`timescale 1ns / 1ps

module moduleName 
#(
    parameter N = 64,
    parameter DW_DATA = 8,
    parameter N_LEVELS = 2*$clog2(N)+1) 
(
    input clk,
    input reset,
    input route_en,
    input compute_en,
    input [(N_LEVELS-1)*N-1:0] route_signals,
    input [DW_DATA-1:0] in [N-1:0],
    output [DW_DATA-1:0] out [N-1:0]
);

    reg [DW_DATA-1:0] reg_nodes [N_LEVELS-1:0][N-1:0];
    integer i, j;
    
    for (j=0; j<N; j++) begin
        reg_nodes[0][j] <= in[j];
        out[j] <= reg_nodes[N_LEVELS-1][j];
    end

    always @(posedge clk) begin
        if (reset) begin: init_block
            for (i=1; i<N_LEVELS; i++) begin
                for (j=0; j<N; j++) begin
                    if (route_signals[i*N+j])
                        reg_nodes[i][j]
                        
    
endmodule