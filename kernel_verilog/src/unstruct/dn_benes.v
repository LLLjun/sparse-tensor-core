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
    input [1:0] route_signals [(N_LEVELS-1)*N/2-1:0],
    input [DW_DATA-1:0] in [N-1:0],
    output [DW_DATA-1:0] out [N-1:0]
);

    wire [DW_DATA-1:0] wire_in [N_LEVELS*N-1:0];
    wire [DW_DATA-1:0] wire_out [N_LEVELS*N-1:0];

    integer i, j, mid, l;

    // set input connections
    i = 0
    for (j=0; j<N; j++) begin
        assign wire_in[i*N+j] = in[j];
    end

    // set output connections
    i = N_LEVELS - 1;
    for (j=0; j<N; j++) begin
        assign out[j] = wire_out[i*N+j];
    end

    // set inter connections
    mid = N_LEVELS/2;
    for (i=0; i<N_LEVELS/2; i++) begin
        // set the left part
        l = mid - i - 1;
        for (j=0; j<N; j++) begin
            assign wire_in[(l+1)*N + j] = wire_out[l*N + (j+2**i)%2**(i+1) + j/(2**(i+1))*(2**(i+1))];
        end
        // set the right part
        l = mid + i;
        for (j=0; j<N; j++) begin
            assign wire_in[(l+1)*N + j] = wire_out[l*N + (j+2**i)%2**(i+1) + j/(2**(i+1))*(2**(i+1))];
        end
    end

    // generate router layers 
    genvar x, y;
    generate
        for (x=0; x<N_LEVELS; x++) begin
            for (y=0; y<N; y++) begin
                dn_router #(
                    .DW_DATA(DW_DATA)
                ) u_dn_router(
                    .clk(clk),
                    .reset(reset),
                    .set_en(set_en),
                    .route_en(route_en),
                    .route_signal(route_signals[l*N/2+j]),
                    .in('{wire_in[x*N+y], wire_in[x*N+y+1]}),
                    .out('{wire_out[x*N+y], wire_out[x*N+y+1]})
                )
            end
        end
    endgenerate

endmodule
