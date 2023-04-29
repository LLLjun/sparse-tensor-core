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

    wire [DW_DATA-1:0] wire_conn [(N_LEVELS+1)*N-1:0];

    integer k;
    for (k=0; k<N; k++) begin
        wire_conn[k] <= in[k];
        out[k] <= wire_conn[N_LEVELS*N+k];
    end

    genvar i, j;
    integer mid = N_LEVELS / 2, l;
    generate
        l = mid;
        for (j=0; j<N/2; j++) begin: u_dn_router
            dn_router #(
                .DW_DATA(DW_DATA)
            ) dp_router_inst_up (
                .clk(clk),
                .reset(reset),
                .set_en(set_en),
                .route_en(route_en),
                .route_signal(route_signals[l*N/2+j]),
                .in('{wire_conn[l*N+i], wire_conn[l*N+(i/2)*2+i%2]}),
                .out('{wire_conn[(l+1)*N+i], wire_conn[(l+1)*N+(i/2)*2+i%2]})
            );
        end
        for (i=1; i<=N_LEVELS/2; i++) begin: each_level
            for (j=0; j<N/2; j++) begin: u_dn_router
                l = mid - i;
                dn_router #(
                    .DW_DATA(DW_DATA)
                ) dp_router_inst_up (
                    .clk(clk),
                    .reset(reset),
                    .set_en(set_en),
                    .route_en(route_en),
                    .route_signal(route_signals[l*N/2+j]),
                    .in('{wire_conn[l*N+i], wire_conn[l*N+((i/2**l)*2**l+(i+2**(l-1))%2**l)]}),
                    .out('{wire_conn[(l+1)*N+i], wire_conn[(l+1)*N+((i/2**(l+1)))*2**(l+1)+(i+2**l)%2**(l+1))]}) 
                );
                // might be bug for the edge
                l = mid + i;
                dn_router #(
                    .DW_DATA(DW_DATA)
                ) dp_router_inst_up (
                    .clk(clk),
                    .reset(reset),
                    .set_en(set_en),
                    .route_en(route_en),
                    .route_signal(route_signals[l*N/2+j]),
                    .in('{wire_conn[(l+1)*N+i], wire_conn[(l+1)*N+((i/2**(l+1)))*2**(l+1)+(i+2**l)%2**(l+1))]}),
                    .out('{wire_conn[l*N+i], wire_conn[l*N+((i/2**l)*2**l+(i+2**(l-1))%2**l)]})
                );
            end
        end
    endgenerate
endmodule
