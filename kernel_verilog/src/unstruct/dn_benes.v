`timescale 1ns / 1ps

module dn_benes 
#(
    parameter N = 64,
    parameter DW_DATA = 8,
    parameter N_LEVELS = 2*$clog2(N)-1) 
(
    input clk,
    input reset,
    input set_en,
    input route_en,
    input [2*(N_LEVELS-1)*N/2-1:0] route_signals,
    input [DW_DATA*N-1:0] in,
    output [DW_DATA*N-1:0] out
);

    reg [DW_DATA*N_LEVELS*N-1:0] reg_in;
    wire [DW_DATA*N_LEVELS*N-1:0] wire_out;

    integer i, j, mid, l, pos1, pos2;
    
    // set output connections
    assign out = wire_out[DW_DATA*N_LEVELS*N-1 -:DW_DATA*N];

    always @(*) begin
    // set input connections
    i = 0;
    for (j=0; j<N; j=j+1) begin
        pos1 = i*N+j;
        pos2 = j;
        reg_in[(pos1+1)*DW_DATA-1 -:DW_DATA] <= in[(pos2+1)*DW_DATA-1 -:DW_DATA];
    end

    // set inter connections
    mid = N_LEVELS/2;
    for (i=0; i<N_LEVELS/2; i=i+1) begin
        // set the left part
        l = mid - i - 1;
        for (j=0; j<N; j=j+1) begin
            pos1 = (l+1)*N + j;
            pos2 = l*N + (j+2**i)%2**(i+1) + j/(2**(i+1))*(2**(i+1));
            reg_in[(pos1+1)*DW_DATA-1 -:DW_DATA] <= wire_out[(pos2+1)*DW_DATA-1 -:DW_DATA];
        end
        // set the right part
        l = mid + i;
        for (j=0; j<N; j=j+1) begin
            pos1 = (l+1)*N + j;
            pos2 = l*N + (j+2**i)%2**(i+1) + j/(2**(i+1))*(2**(i+1));
            reg_in[(pos1+1)*DW_DATA-1 -:DW_DATA] <= wire_out[(pos2+1)*DW_DATA-1 -:DW_DATA];
        end
    end
    end

    // generate router layers 
    genvar level, pos;
    generate
        for (level=0; level<N_LEVELS; level=level+1) begin
            for (pos=0; pos<N/2; pos=pos+1) begin
                dn_router #(
                    .DW_DATA(DW_DATA)
                ) u_dn_router(
                    .clk(clk),
                    .reset(reset),
                    .set_en(set_en),
                    .route_en(route_en),
                    .route_signal(route_signals[l*N/2+j]),
                    .in({reg_in[(level*N+2*pos+1)*DW_DATA-1 -:DW_DATA], reg_in[(level*N+2*pos+2)*DW_DATA-1 -:DW_DATA]}),
                    .out({wire_out[(level*N+2*pos+1)*DW_DATA-1 -:DW_DATA], wire_out[(level*N+2*pos+2)*DW_DATA-1 -:DW_DATA]})
                );
            end
        end
    endgenerate

endmodule
