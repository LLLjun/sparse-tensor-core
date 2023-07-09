`timescale 1ns / 1ps

module tc_core #(
    parameter M = 16,
    parameter N = 16,
    parameter K = 16,
    parameter tileM = 4,
    parameter tileN = 1,
    parameter tileK = 8,
    parameter iterM = 4,
    parameter iterN = 16,
    parameter iterK = 2,
    parameter N_UNIT = 32,
    parameter DW_DATA = 8,
    parameter DW_POS = 4
) (
    input clk,
    input reset,
    input load_en,
    input compute_en,
    input [M*K*DW_DATA-1:0] in_a,
    input [K*N*DW_DATA-1:0] in_b,
    output [N*DW_DATA-1:0] out
);

    parameter IDLE = 2'd0;
    parameter LOAD = 2'd1;
    parameter COMPUTE = 2'd2;
    
    reg [1:0] state, next_state;

    reg [M*K*DW_DATA-1:0] reg_a; //[M-1:0][K-1:0];
    reg [K*N*DW_DATA-1:0] reg_b; //[K-1:0][N-1:0];
    reg [3:0]  ptr_m, ptr_n, ptr_k;
    wire [3:0] col_n, row_m;
    reg [N_UNIT*DW_DATA-1:0] reg_tile_a;
    reg [tileK*tileN*DW_DATA-1:0] reg_tile_b;
    wire [tileM*DW_DATA-1:0] wire_compute_result;
    reg out_en, input_en;
    wire out_valid, col_valid, row_valid, psum_input_en, psum_input_en_valid;

    // state transfer and control
    always @(posedge clk) begin
        if (reset) begin
            next_state <= IDLE;
            out_en <= 0;
            input_en <= 0;
        end
        else begin
            if (load_en != 0)
                next_state <= 1;
            else if (compute_en) begin
                next_state <= COMPUTE;
                input_en <= 1;
            end
            if (state==LOAD) begin
                reg_a <= in_a;
                reg_b <= in_b;
                ptr_m <= 0;
                ptr_n <= 0;
                ptr_k <= 0;
            end
            else if (state==COMPUTE) begin
                if (ptr_n == 4'd15) begin
                    if (ptr_m == 4'd12) begin
                        if (ptr_k == 4'd1)
                            next_state <= IDLE;
                        else begin
                            ptr_m <= 0;
                            ptr_n <= 0;
                            ptr_k <= ptr_k+1;
                        end
                    end
                    else begin
                        ptr_m <= ptr_m + 4;
                        ptr_n <= 4'd0;
                    end
                end
                else begin
                    ptr_n <= ptr_n + 1;
                end
            end
        end
    end


    integer i,j;
    // select tile
    always @(posedge clk) begin: a1
        for (i=0; i<tileM; i=i+1) begin
            for (j=0; j<tileK; j=j+1) begin
                reg_tile_a[(i*tileK+j)*DW_DATA +:DW_DATA] <= reg_a[((ptr_m+i)*K + ptr_k*8+j)*DW_DATA +:DW_DATA];
            end
        end
        reg_tile_b <= reg_b[(ptr_n*K+ptr_k*8)*DW_DATA +:tileK*tileN*DW_DATA];
    end

    always @(posedge clk) begin
        state <= next_state;
    end

    // integer i;
    // // select tile
    // always @(posedge clk) begin
    //     for (i=0; i<N_UNIT; i=i+1) begin
    //         reg_tile_a[i*DW_DATA +:DW_DATA] <= reg_a[ptr_m*N_UNIT*DW_DATA + i*DW_DATA +:DW_DATA];
    //     end
    //     reg_tile_b <= reg_b[(ptr_n*K+ptr_k*8)*DW_DATA +:tileK*tileN*DW_DATA];
    // end

delay_unit #(
    .DW_DATA(DW_POS),
    .W_SHIFT(6)
) u_delay_col (
    .clk(clk),
    .reset(reset),
    .enable(1),
    .in(ptr_n),
    .out_valid(col_valid),
    .out(col_n)
);
delay_unit #(
    .DW_DATA(DW_POS),
    .W_SHIFT(6)
) u_delay_row (
    .clk(clk),
    .reset(reset),
    .enable(1),
    .in(ptr_m),
    .out_valid(row_valid),
    .out(row_m)
);
delay_unit #(
    .DW_DATA(1),
    .W_SHIFT(6)
) u_delay_input_en (
    .clk(clk),
    .reset(reset),
    .enable(1),
    .in(input_en),
    .out_valid(psum_input_en_valid),
    .out(psum_input_en)
);

tc_array u_tc_array (
    .clk(clk),
    .reset(reset),
    .in_a(reg_tile_a),
    .in_b(reg_tile_b),
    .out(wire_compute_result)
);

tc_psum #(
    .DW_DATA(DW_DATA)
) u_tc_psum(
    .clk(clk),
    .rst(reset),
    .col(col_n),
    .row(row_m),
    .in(wire_compute_result),
    .input_en(psum_input_en),
    .out_en(out_en),
    .out_valid(out_valid),
    .out(out)
);

endmodule