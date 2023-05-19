module crossbar_switch #(
    parameter DW_DATA = 4
) (
    input clk,
    input ctrl,
    input [2*DW_DATA-1:0] in,
    output reg [2*DW_DATA-1:0] out
);

    always @(posedge clk) begin
        if (ctrl) begin
            out <= {in[0 +:DW_DATA], in[DW_DATA +:DW_DATA]};
        end
        else begin
            out <= in;
        end
    end

endmodule