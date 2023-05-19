module data_buffer #(
    parameter ROW = 4,
    parameter COL = 4,
    parameter NUM_BLOCK = 16,
    parameter DW_DATA = 32
) (
    input clk,
    input reset,
    input write_en,
    input read_en,
    input [3:0] col,
    input [NUM_BLOCK*ROW*DW_DATA-1:0] data_in,
    output reg [NUM_BLOCK*ROW*DW_DATA-1:0] data_out
);

    reg [NUM_BLOCK*ROW*DW_DATA-1:0] data [COL-1:0];
    integer i;

    always @(posedge clk) begin
        if (reset)
            for (i=0; i<COL; i=i+1)
                data[i] <= 0;
        else if (write_en) begin
            data[col] <= data[col] + data_in;
        end
        else if (read_en) begin
            data_out <= data[col];
        end
        else begin
            data_out <= 0;
        end
    end

endmodule