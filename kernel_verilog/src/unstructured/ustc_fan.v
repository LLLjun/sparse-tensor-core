`timescale 1ns / 1ps

module ustc_fan #(
    // can't change
    parameter NUM_IN = 32,
    parameter N_LEVELS = 5,
    // for data width
    parameter N_STACK = 4,
    parameter DW_DATA = 32,
    parameter DW_ROW = 4,
    parameter DW_CTRL = 4,
    parameter DW_LINE = N_STACK*DW_DATA + DW_ROW + DW_CTRL
) (
    input clk,
    input rst,
    input [NUM_IN*DW_LINE-1:0] in,
    output [NUM_IN*DW_LINE-1:0] out
);

    integer i;
    genvar gi;  
    wire [DW_LINE-1:0] in_line [NUM_IN-1:0];
    wire [DW_LINE-1:0] wire_out_2 [23:0][1:0];
    wire [DW_LINE-1:0] wire_out_4 [3:0][3:0];
    wire [DW_LINE-1:0] wire_out_6 [1:0][5:0];
    wire [DW_LINE-1:0] wire_out_8 [7:0];
    reg [DW_LINE-1:0] reg_lv2 [15:0];
    reg [DW_LINE-1:0] reg_lv3 [15:0];
    reg [DW_LINE-1:0] reg_lv4 [19:0];
    reg [DW_LINE-1:0] reg_lv5 [23:0];

    generate begin
        for (gi=0; gi<NUM_IN; gi=gi+1)
            assign in_line[gi] = in[gi*DW_LINE +:DW_LINE];
    end
    endgenerate

    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<16; i=i+1)
                reg_lv2[i] <= 0;
            for (i=0; i<16; i=i+1)
                reg_lv3[i] <= 0;
            for (i=0; i<20; i=i+1)
                reg_lv4[i] <= 0;
            for (i=0; i<24; i=i+1)
                reg_lv5[5] <= 0;
        end
        else begin
            // lv2
            reg_lv2[0] <= wire_out_2[0][0];
            reg_lv2[1] <= wire_out_2[1][1];
            reg_lv2[2] <= wire_out_2[2][0];
            reg_lv2[3] <= wire_out_2[3][1];
            reg_lv2[4] <= wire_out_2[4][0];
            reg_lv2[5] <= wire_out_2[5][1];
            reg_lv2[6] <= wire_out_2[6][0];
            reg_lv2[7] <= wire_out_2[7][1];
            reg_lv2[8] <= wire_out_2[8][0];
            reg_lv2[9] <= wire_out_2[9][1];
            reg_lv2[10] <= wire_out_2[10][0];
            reg_lv2[11] <= wire_out_2[11][1];
            reg_lv2[12] <= wire_out_2[12][0];
            reg_lv2[13] <= wire_out_2[13][1];
            reg_lv2[14] <= wire_out_2[14][0];
            reg_lv2[15] <= wire_out_2[15][1];
            // lv3
            reg_lv3[0] <= reg_lv2[0];
            reg_lv3[1] <= wire_out_2[16][0];
            reg_lv3[2] <= wire_out_2[17][1];
            reg_lv3[3] <= reg_lv2[3];
            reg_lv3[4] <= reg_lv2[4];
            reg_lv3[5] <= wire_out_2[18][0];
            reg_lv3[6] <= wire_out_2[19][1];
            reg_lv3[7] <= reg_lv2[7];
            reg_lv3[8] <= reg_lv2[8];
            reg_lv3[9] <= wire_out_2[20][0];
            reg_lv3[10] <= wire_out_2[21][1];
            reg_lv3[11] <= reg_lv2[11];
            reg_lv3[12] <= reg_lv2[12];
            reg_lv3[13] <= wire_out_2[22][0];
            reg_lv3[14] <= wire_out_2[23][1];
            reg_lv3[15] <= reg_lv2[15];
            // lv4
            reg_lv4[0] <= reg_lv3[0];
            reg_lv4[1] <= reg_lv3[1];
            reg_lv4[2] <= wire_out_4[0][0];
            reg_lv4[3] <= wire_out_4[0][1];
            reg_lv4[4] <= wire_out_4[0][3];
            reg_lv4[5] <= wire_out_4[1][0];
            reg_lv4[6] <= wire_out_4[1][2];
            reg_lv4[7] <= wire_out_4[1][3];
            reg_lv4[8] <= reg_lv3[6];
            reg_lv4[9] <= reg_lv3[7];
            reg_lv4[10] <= reg_lv3[8];
            reg_lv4[11] <= reg_lv3[9];
            reg_lv4[12] <= wire_out_4[2][0];
            reg_lv4[13] <= wire_out_4[2][1];
            reg_lv4[14] <= wire_out_4[2][3];
            reg_lv4[15] <= wire_out_4[3][0];
            reg_lv4[16] <= wire_out_4[3][2];
            reg_lv4[17] <= wire_out_4[3][3];
            reg_lv4[18] <= reg_lv3[14];
            reg_lv4[19] <= reg_lv3[15];
            // lv4
            reg_lv5[0] <= reg_lv4[0];
            reg_lv5[1] <= reg_lv4[1];
            reg_lv5[2] <= reg_lv4[2];
            reg_lv5[3] <= reg_lv4[3];
            reg_lv5[4] <= wire_out_6[0][0];
            reg_lv5[5] <= reg_lv4[4];
            reg_lv5[6] <= wire_out_6[0][1];
            reg_lv5[7] <= wire_out_6[0][2];
            reg_lv5[8] <= wire_out_6[0][4];
            reg_lv5[9] <= reg_lv4[5];
            reg_lv5[10] <= wire_out_6[0][5];
            reg_lv5[11] <= reg_lv4[7];
            reg_lv5[12] <= reg_lv4[12];
            reg_lv5[13] <= wire_out_6[1][0];
            reg_lv5[14] <= reg_lv4[14];
            reg_lv5[15] <= wire_out_6[1][1];
            reg_lv5[16] <= wire_out_6[1][3];
            reg_lv5[17] <= wire_out_6[1][4];
            reg_lv5[18] <= reg_lv4[15];
            reg_lv5[19] <= wire_out_6[1][5];
            reg_lv5[20] <= reg_lv4[16];
            reg_lv5[21] <= reg_lv4[17];
            reg_lv5[22] <= reg_lv4[18];
            reg_lv5[23] <= reg_lv4[19];
        end
    end

    assign out[0*DW_LINE +:DW_LINE] = reg_lv5[0];
    assign out[1*DW_LINE +:DW_LINE] = reg_lv5[1];
    assign out[2*DW_LINE +:DW_LINE] = reg_lv5[2];
    assign out[3*DW_LINE +:DW_LINE] = reg_lv5[3];
    assign out[4*DW_LINE +:DW_LINE] = reg_lv5[4];
    assign out[5*DW_LINE +:DW_LINE] = reg_lv5[5];
    assign out[6*DW_LINE +:DW_LINE] = reg_lv5[6];
    assign out[7*DW_LINE +:DW_LINE] = reg_lv5[7];
    assign out[8*DW_LINE +:DW_LINE] = wire_out_8[0];
    assign out[9*DW_LINE +:DW_LINE] = reg_lv5[8];
    assign out[10*DW_LINE +:DW_LINE] = reg_lv5[9];
    assign out[11*DW_LINE +:DW_LINE] = reg_lv5[10];
    assign out[12*DW_LINE +:DW_LINE] = wire_out_8[1];
    assign out[13*DW_LINE +:DW_LINE] = reg_lv5[11];
    assign out[14*DW_LINE +:DW_LINE] = wire_out_8[2];
    assign out[15*DW_LINE +:DW_LINE] = wire_out_8[3];
    assign out[16*DW_LINE +:DW_LINE] = wire_out_8[4];
    assign out[17*DW_LINE +:DW_LINE] = wire_out_8[5];
    assign out[18*DW_LINE +:DW_LINE] = reg_lv5[12];
    assign out[19*DW_LINE +:DW_LINE] = wire_out_8[6];
    assign out[20*DW_LINE +:DW_LINE] = reg_lv5[13];
    assign out[21*DW_LINE +:DW_LINE] = reg_lv5[14];
    assign out[22*DW_LINE +:DW_LINE] = reg_lv5[15];
    assign out[23*DW_LINE +:DW_LINE] = wire_out_8[7];
    assign out[24*DW_LINE +:DW_LINE] = reg_lv5[16];
    assign out[25*DW_LINE +:DW_LINE] = reg_lv5[17];
    assign out[26*DW_LINE +:DW_LINE] = reg_lv5[18];
    assign out[27*DW_LINE +:DW_LINE] = reg_lv5[19];
    assign out[28*DW_LINE +:DW_LINE] = reg_lv5[20];
    assign out[29*DW_LINE +:DW_LINE] = reg_lv5[21];
    assign out[30*DW_LINE +:DW_LINE] = reg_lv5[22];
    assign out[31*DW_LINE +:DW_LINE] = reg_lv5[23];

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_0 (
   .clk(clk),
   .rst(rst),
   .in({in_line[1], in_line[0]}),
   .out({wire_out_2[0][1], wire_out_2[0][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_1 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[1][0], wire_out_2[0][1]}),
   .out({wire_out_2[16][1], wire_out_2[16][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_2 (
   .clk(clk),
   .rst(rst),
   .in({in_line[3], in_line[2]}),
   .out({wire_out_2[1][1], wire_out_2[1][0]})
);

fan_adder_4to4 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_3 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[17][0], reg_lv2[2], reg_lv2[1], wire_out_2[16][1]}),
   .out({wire_out_4[0][3], wire_out_4[0][2], wire_out_4[0][1], wire_out_4[0][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_4 (
   .clk(clk),
   .rst(rst),
   .in({in_line[5], in_line[4]}),
   .out({wire_out_2[2][1], wire_out_2[2][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_5 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[3][0], wire_out_2[2][1]}),
   .out({wire_out_2[17][1], wire_out_2[17][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_6 (
   .clk(clk),
   .rst(rst),
   .in({in_line[7], in_line[6]}),
   .out({wire_out_2[3][1], wire_out_2[3][0]})
);

fan_adder_6to6 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_7 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_4[1][1], reg_lv3[5], reg_lv3[4], reg_lv3[3], reg_lv3[2], wire_out_4[0][2]}),
   .out({wire_out_6[0][5], wire_out_6[0][4], wire_out_6[0][3], wire_out_6[0][2], wire_out_6[0][1], wire_out_6[0][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_8 (
   .clk(clk),
   .rst(rst),
   .in({in_line[9], in_line[8]}),
   .out({wire_out_2[4][1], wire_out_2[4][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_9 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[5][0], wire_out_2[4][1]}),
   .out({wire_out_2[18][1], wire_out_2[18][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_10 (
   .clk(clk),
   .rst(rst),
   .in({in_line[11], in_line[10]}),
   .out({wire_out_2[5][1], wire_out_2[5][0]})
);

fan_adder_4to4 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_11 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[19][0], reg_lv2[6], reg_lv2[5], wire_out_2[18][1]}),
   .out({wire_out_4[1][3], wire_out_4[1][2], wire_out_4[1][1], wire_out_4[1][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_12 (
   .clk(clk),
   .rst(rst),
   .in({in_line[13], in_line[12]}),
   .out({wire_out_2[6][1], wire_out_2[6][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_13 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[7][0], wire_out_2[6][1]}),
   .out({wire_out_2[19][1], wire_out_2[19][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_14 (
   .clk(clk),
   .rst(rst),
   .in({in_line[15], in_line[14]}),
   .out({wire_out_2[7][1], wire_out_2[7][0]})
);

fan_adder_8to8 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_15 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_6[1][2], reg_lv4[13], reg_lv4[11], reg_lv4[10], reg_lv4[9], reg_lv4[8], reg_lv4[6], wire_out_6[0][3]}),
   .out({wire_out_8[7], wire_out_8[6], wire_out_8[5], wire_out_8[4], wire_out_8[3], wire_out_8[2], wire_out_8[1], wire_out_8[0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_16 (
   .clk(clk),
   .rst(rst),
   .in({in_line[17], in_line[16]}),
   .out({wire_out_2[8][1], wire_out_2[8][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_17 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[9][0], wire_out_2[8][1]}),
   .out({wire_out_2[20][1], wire_out_2[20][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_18 (
   .clk(clk),
   .rst(rst),
   .in({in_line[19], in_line[18]}),
   .out({wire_out_2[9][1], wire_out_2[9][0]})
);

fan_adder_4to4 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_19 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[21][0], reg_lv2[10], reg_lv2[9], wire_out_2[20][1]}),
   .out({wire_out_4[2][3], wire_out_4[2][2], wire_out_4[2][1], wire_out_4[2][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_20 (
   .clk(clk),
   .rst(rst),
   .in({in_line[21], in_line[20]}),
   .out({wire_out_2[10][1], wire_out_2[10][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_21 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[11][0], wire_out_2[10][1]}),
   .out({wire_out_2[21][1], wire_out_2[21][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_22 (
   .clk(clk),
   .rst(rst),
   .in({in_line[23], in_line[22]}),
   .out({wire_out_2[11][1], wire_out_2[11][0]})
);

fan_adder_6to6 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_23 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_4[3][1], reg_lv3[13], reg_lv3[12], reg_lv3[11], reg_lv3[10], wire_out_4[2][2]}),
   .out({wire_out_6[1][5], wire_out_6[1][4], wire_out_6[1][3], wire_out_6[1][2], wire_out_6[1][1], wire_out_6[1][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_24 (
   .clk(clk),
   .rst(rst),
   .in({in_line[25], in_line[24]}),
   .out({wire_out_2[12][1], wire_out_2[12][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_25 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[13][0], wire_out_2[12][1]}),
   .out({wire_out_2[22][1], wire_out_2[22][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_26 (
   .clk(clk),
   .rst(rst),
   .in({in_line[27], in_line[26]}),
   .out({wire_out_2[13][1], wire_out_2[13][0]})
);

fan_adder_4to4 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_27 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[23][0], reg_lv2[14], reg_lv2[13], wire_out_2[22][1]}),
   .out({wire_out_4[3][3], wire_out_4[3][2], wire_out_4[3][1], wire_out_4[3][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(1)
) u_fan_adder_28 (
   .clk(clk),
   .rst(rst),
   .in({in_line[29], in_line[28]}),
   .out({wire_out_2[14][1], wire_out_2[14][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_29 (
   .clk(clk),
   .rst(rst),
   .in({wire_out_2[15][0], wire_out_2[14][1]}),
   .out({wire_out_2[23][1], wire_out_2[23][0]})
);

fan_adder_2to2 #(
   .N_STACK(N_STACK),
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .SYMMETRY(0)
) u_fan_adder_30 (
   .clk(clk),
   .rst(rst),
   .in({in_line[31], in_line[30]}),
   .out({wire_out_2[15][1], wire_out_2[15][0]})
);

endmodule