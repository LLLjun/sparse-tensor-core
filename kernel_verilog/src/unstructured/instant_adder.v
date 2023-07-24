module instant_adder #(
    parameter N_STACK = 4,
    parameter DW_DATA = 32
) (
    input [N_STACK*DW_DATA-1:0] in_a,
    input [N_STACK*DW_DATA-1:0] in_b,
    output [N_STACK*DW_DATA-1:0] out
);

    genvar gi;
    generate
        for (gi=0; gi<N_STACK; gi=gi+1) begin
            assign out[gi*DW_DATA +:DW_DATA] = in_a[gi*DW_DATA +:DW_DATA] + in_b[gi*DW_DATA +:DW_DATA];
        end
    endgenerate

endmodule