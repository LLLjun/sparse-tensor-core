`timescale 1ns / 1ps

module ustc_core #(
    parameter M = 16,
    parameter N = 16,
    parameter K = 16,
    parameter tileN = 1,
    parameter tileK = 8,
    parameter iterN = 16,
    parameter iterK = 2,
    parameter N_UNIT = 32,
    parameter DW_DATA = 8,
    parameter DW_ROW = 4,
    parameter DW_COL = 4,
    parameter DW_CTRL = 4,
    parameter DW_A = DW_DATA+DW_ROW+DW_COL,
    parameter DW_B = DW_DATA
) (
    input clk,
    input reset,
    input load_en,
    input compute_en,
    input [M*K*DW_A-1:0] in_a,
    input [M*K*DW_CTRL-1:0] in_a_ctrl,
    input [K*N*DW_B-1:0] in_b,
    input [3:0] num_blocks,
    output [N*DW_DATA-1:0] out
);

    parameter IDLE = 2'd0;
    parameter LOAD = 2'd1;
    parameter COMPUTE = 2'd2;
    
    reg [1:0] state, next_state;

    reg [M*K*DW_A-1:0] reg_a; //[M-1:0][K-1:0];
    reg [K*N*DW_B-1:0] reg_b; //[K-1:0][N-1:0];
    reg [3:0] n_blocks, ptr_m, ptr_n, ptr_k;
    wire [3:0] col_n;
    reg [N_UNIT*DW_DATA-1:0] reg_tile_a;
    reg [N_UNIT*DW_COL-1:0] reg_tile_a_col;
    reg [N_UNIT*DW_ROW-1:0] reg_tile_a_row;
    reg [N_UNIT*DW_CTRL-1:0] reg_tile_a_ctrl;
    reg [tileK*tileN*DW_DATA-1:0] reg_tile_b;
    wire [7:0] wire_k;
    wire [N_UNIT*DW_A-1:0] wire_compute_result;
    reg out_en;
    wire out_valid, col_valid;

    // state transfer and control
    always @(posedge clk) begin
        if (reset) begin
            next_state <= IDLE;
            out_en <= 0;
        end
        else begin
            if (load_en != 0)
                next_state <= 1;
            else if (compute_en)
                next_state <= COMPUTE;
            if (state==LOAD) begin
                reg_a <= in_a;
                reg_b <= in_b;
                n_blocks <= num_blocks;
                ptr_m <= 0;
                ptr_n <= 0;
                ptr_k <= 0;
            end
            else if (state==COMPUTE) begin
                if (ptr_n == 4'd15) begin
                    if (ptr_m == n_blocks-1) begin
                        next_state <= IDLE;
                    end
                    else begin
                        ptr_m <= ptr_m + 1;
                        ptr_k <= wire_k[ptr_m+1];
                        ptr_n <= 4'd0;
                    end
                end
                else begin
                    ptr_n <= ptr_n + 1;
                end
            end
        end
    end

    genvar gi;
    generate
        for (gi=0; gi<8; gi=gi+1) begin
            assign wire_k[gi] = reg_a[gi*N_UNIT*DW_A + DW_DATA + DW_COL -1];
        end
    endgenerate

    integer i;
    // select tile
    always @(posedge clk) begin
        for (i=0; i<N_UNIT; i=i+1) begin
            reg_tile_a[i*DW_DATA +:DW_DATA] <= reg_a[ptr_m*N_UNIT*DW_A + i*DW_A +:DW_DATA];
            reg_tile_a_col[i*DW_COL +:DW_COL] <= reg_a[ptr_m*N_UNIT*DW_A + i*DW_A+DW_DATA +:DW_COL];
            reg_tile_a_row[i*DW_ROW +:DW_ROW] <= reg_a[ptr_m*N_UNIT*DW_A + i*DW_A+DW_DATA+DW_COL +:DW_ROW];
            reg_tile_a_ctrl[i*DW_CTRL +:DW_CTRL] <= in_a_ctrl[ptr_m*N_UNIT*DW_CTRL+i*DW_CTRL +:DW_CTRL];
        end
        reg_tile_b <= reg_b[(ptr_n*K+ptr_k*8)*DW_B +:tileK*tileN*DW_B];
    end

    always @(posedge clk) begin
        state <= next_state;
    end

delay_unit #(
    .DW_DATA(DW_COL),
    .W_SHIFT(9)
) u_delay_in_a (
    .clk(clk),
    .reset(reset),
    .enable(1),
    .in(ptr_n),
    .out_valid(col_valid),
    .out(col_n)
);

ustc_array u_ustc_array (
    .clk(clk),
    .reset(reset),
    .in_a(reg_tile_a),
    .in_b(reg_tile_b),
    .in_a_col(reg_tile_a_col),
    .in_a_row(reg_tile_a_row),
    .in_a_ctrl(reg_tile_a_ctrl),
    .out(wire_compute_result)
);

ustc_psum u_ustc_psum(
    .clk(clk),
    .rst(reset),
    .col(col_n),
    .in(wire_compute_result),
    .out_en(out_en),
    .out_valid(out_valid),
    .out(out)
);

endmodule