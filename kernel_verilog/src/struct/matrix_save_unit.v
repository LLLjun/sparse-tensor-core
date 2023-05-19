module matrix_save_unit #(
  parameter M_TILE = 4, N_TILE = 4,
  parameter M_EXPAND = 4,
  parameter N_SECTION = 4,
  parameter DW_DATA = 32, DW_MEM_WRITE = M_TILE*N_TILE*M_EXPAND*DW_DATA) 
(
  input                             clk,
  input                             rst,
  input                             en,
  /* ------- controller ------- */
  input                             sel_acc_buf,
  input [3:0]                       col_buf,
  input [1:0]                        row_buf,
  // valid number per M_EXPAND
  input [2:0]                       block_type,
  /* ------- data ------- */
  input signed [M_TILE*M_EXPAND*N_TILE*DW_DATA-1:0] in,
  output signed [DW_MEM_WRITE-1:0]    out,
  output reg                              out_valid,
  // 
  output reg                              out_state
);

    localparam LOCAL_BUFFER_SIZE = M_EXPAND*M_TILE*N_TILE;
    localparam       IDLE = 3'd0;
    localparam       W0R1 = 3'd1;
    localparam       W1R0 = 3'd2;
    integer i, j, k;

    wire [LOCAL_BUFFER_SIZE*DW_DATA-1:0]    wire_write;
    reg [LOCAL_BUFFER_SIZE*DW_DATA-1:0]    reg_read;
    wire [LOCAL_BUFFER_SIZE*DW_DATA-1:0] wire_read [1:0];

    reg [2:0] state, next_state; // 0 for state0, 1 for state1
    reg signed [7:0] input_cnt, output_cnt;
    reg [1:0] write_en, read_en;

    // FSM
    always @(posedge clk) begin
        if (rst) begin
            next_state <= IDLE;
        end
        else if (state == W0R1) begin
            if (input_cnt == 0 && output_cnt == 0) begin
                next_state <= W1R0;
            end
        end
        else if (state == W1R0) begin
            if (input_cnt == 0 && output_cnt == 0) begin
                next_state <= W0R1;
            end
        end
    end

    // state transfer
    always @(posedge clk) begin
        state <= next_state;
    end

    // set wire_write
    always @(posedge clk) begin
        if (state == IDLE || state != next_state) begin
            input_cnt <= 40;
            output_cnt <= 40;
        end
        else begin
            output_cnt <= output_cnt - 4;
            if (block_type == 1) begin
                input_cnt <= input_cnt - 4;
            end
            else if (block_type == 2) begin
                input_cnt <= input_cnt - 2;
            end
            else if (block_type == 4) begin
                input_cnt <= input_cnt - 1;
            end
            else begin
                input_cnt <= input_cnt - 4;
            end
        end
    end

    // set reg_read
    always @(posedge clk) begin
        if (state == W0R1)
            reg_read <= wire_read[1];
            // reg_read <= 1;
        else if (state == W1R0)
            reg_read <= wire_read[0];
            // reg_read <= 0;
        else
            reg_read <= 0;
    end
    assign out = reg_read;

    // set signals
    always @(posedge clk) begin
        if (input_cnt == 0)
            out_state <= 0;
        else 
            out_state <= 1;
        if (output_cnt == 0)
            out_valid <= 0;
        else
            out_valid <= 1;
    end

    always @(posedge clk) begin
        if (state == W0R1) begin
            write_en <= 2'b01;
            read_en <= 2'b10;
        end
        else if (state == W1R0) begin
            write_en <= 2'b10;
            read_en <= 2'b01;
        end
        else begin
            write_en <= 2'b00;
            read_en <= 2'b00;
        end
    end

    //assign wire_read[0] = state;
    //assign wire_read[1] = next_state;

align_mux #(
    .M_TILE(M_TILE),
    .N_TILE(N_TILE),
    .M_EXPAND(M_EXPAND),
    .DW_DATA(DW_DATA)
) u_mux (
    .block_type(block_type),
    .row(row_buf),
    .data_in(in),
    .data_out(wire_write)
);

data_buffer #(
    .ROW(M_EXPAND),
    .COL(N_SECTION),
    .NUM_BLOCK(M_TILE*N_TILE),
    .DW_DATA(DW_DATA)
) buffer0 (
    .clk(clk),
    .reset(rst),
    .write_en(write_en[0]),
    .read_en(read_en[0]),
    .col(col_buf),
    .data_in(wire_write),
    .data_out(wire_read[0])
);

data_buffer #(
    .ROW(M_EXPAND),
    .COL(N_SECTION),
    .NUM_BLOCK(M_TILE*N_TILE),
    .DW_DATA(DW_DATA)
) buffer1 (
    .clk(clk),
    .reset(rst),
    .write_en(write_en[1]),
    .read_en(read_en[1]),
    .col(col_buf),
    .data_in(wire_write),
    .data_out(wire_read[1])
);

endmodule