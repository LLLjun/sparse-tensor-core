`timescale 1ns / 1ps

module ustc_fan #(
    // can't change
    parameter NUM_IN = 32,
    parameter N_LEVELS = 5,
    // for data width
    parameter DW_DATA = 32,
    parameter DW_ROW = 5,
    parameter DW_CTRL = 5,
    parameter DW_LINE = DW_DATA + DW_ROW + DW_CTRL
) (
    input clk,
    input [NUM_IN*DW_LINE-1:0] in,
    output [NUM_IN*DW_LINE-1:0] out
);

    integer i;
    genvar gi;
    reg [DW_LINE-1:0] reg_line [N_LEVELS:0][NUM_IN-1:0];
    wire [DW_LINE-1:0] wire_out [NUM_IN-2:0][1:0];

    always @(*) begin
        for (i=0; i<NUM_IN; i=i+1) begin
            reg_line[0][i] <= in[i*DW_LINE +:DW_LINE];
        end
    end

    generate begin
        for (gi=0; gi<NUM_IN; gi=gi+1)
            assign out = reg_line[N_LEVELS][gi];
    end
    endgenerate

    always @(posedge clk) begin
        // set reg layer 1
        if (reg_line[0][0][DW_LINE-2] == 1)
            reg_line[1][0] <= reg_line[0][0];
        else
            reg_line[1][0] <= wire_out[0][0];
        if (reg_line[0][1][DW_LINE-2] == 1)
            reg_line[1][1] <= reg_line[0][1];
        else
            reg_line[1][1] <= wire_out[0][1];
        if (reg_line[0][2][DW_LINE-2] == 1)
            reg_line[1][2] <= reg_line[0][2];
        else
            reg_line[1][2] <= wire_out[2][0];
        if (reg_line[0][3][DW_LINE-2] == 1)
            reg_line[1][3] <= reg_line[0][3];
        else
            reg_line[1][3] <= wire_out[2][1];
        if (reg_line[0][4][DW_LINE-2] == 1)
            reg_line[1][4] <= reg_line[0][4];
        else
            reg_line[1][4] <= wire_out[4][0];
        if (reg_line[0][5][DW_LINE-2] == 1)
            reg_line[1][5] <= reg_line[0][5];
        else
            reg_line[1][5] <= wire_out[4][1];
        if (reg_line[0][6][DW_LINE-2] == 1)
            reg_line[1][6] <= reg_line[0][6];
        else
            reg_line[1][6] <= wire_out[6][0];
        if (reg_line[0][7][DW_LINE-2] == 1)
            reg_line[1][7] <= reg_line[0][7];
        else
            reg_line[1][7] <= wire_out[6][1];
        if (reg_line[0][8][DW_LINE-2] == 1)
            reg_line[1][8] <= reg_line[0][8];
        else
            reg_line[1][8] <= wire_out[8][0];
        if (reg_line[0][9][DW_LINE-2] == 1)
            reg_line[1][9] <= reg_line[0][9];
        else
            reg_line[1][9] <= wire_out[8][1];
        if (reg_line[0][10][DW_LINE-2] == 1)
            reg_line[1][10] <= reg_line[0][10];
        else
            reg_line[1][10] <= wire_out[10][0];
        if (reg_line[0][11][DW_LINE-2] == 1)
            reg_line[1][11] <= reg_line[0][11];
        else
            reg_line[1][11] <= wire_out[10][1];
        if (reg_line[0][12][DW_LINE-2] == 1)
            reg_line[1][12] <= reg_line[0][12];
        else
            reg_line[1][12] <= wire_out[12][0];
        if (reg_line[0][13][DW_LINE-2] == 1)
            reg_line[1][13] <= reg_line[0][13];
        else
            reg_line[1][13] <= wire_out[12][1];
        if (reg_line[0][14][DW_LINE-2] == 1)
            reg_line[1][14] <= reg_line[0][14];
        else
            reg_line[1][14] <= wire_out[14][0];
        if (reg_line[0][15][DW_LINE-2] == 1)
            reg_line[1][15] <= reg_line[0][15];
        else
            reg_line[1][15] <= wire_out[14][1];
        if (reg_line[0][16][DW_LINE-2] == 1)
            reg_line[1][16] <= reg_line[0][16];
        else
            reg_line[1][16] <= wire_out[16][0];
        if (reg_line[0][17][DW_LINE-2] == 1)
            reg_line[1][17] <= reg_line[0][17];
        else
            reg_line[1][17] <= wire_out[16][1];
        if (reg_line[0][18][DW_LINE-2] == 1)
            reg_line[1][18] <= reg_line[0][18];
        else
            reg_line[1][18] <= wire_out[18][0];
        if (reg_line[0][19][DW_LINE-2] == 1)
            reg_line[1][19] <= reg_line[0][19];
        else
            reg_line[1][19] <= wire_out[18][1];
        if (reg_line[0][20][DW_LINE-2] == 1)
            reg_line[1][20] <= reg_line[0][20];
        else
            reg_line[1][20] <= wire_out[20][0];
        if (reg_line[0][21][DW_LINE-2] == 1)
            reg_line[1][21] <= reg_line[0][21];
        else
            reg_line[1][21] <= wire_out[20][1];
        if (reg_line[0][22][DW_LINE-2] == 1)
            reg_line[1][22] <= reg_line[0][22];
        else
            reg_line[1][22] <= wire_out[22][0];
        if (reg_line[0][23][DW_LINE-2] == 1)
            reg_line[1][23] <= reg_line[0][23];
        else
            reg_line[1][23] <= wire_out[22][1];
        if (reg_line[0][24][DW_LINE-2] == 1)
            reg_line[1][24] <= reg_line[0][24];
        else
            reg_line[1][24] <= wire_out[24][0];
        if (reg_line[0][25][DW_LINE-2] == 1)
            reg_line[1][25] <= reg_line[0][25];
        else
            reg_line[1][25] <= wire_out[24][1];
        if (reg_line[0][26][DW_LINE-2] == 1)
            reg_line[1][26] <= reg_line[0][26];
        else
            reg_line[1][26] <= wire_out[26][0];
        if (reg_line[0][27][DW_LINE-2] == 1)
            reg_line[1][27] <= reg_line[0][27];
        else
            reg_line[1][27] <= wire_out[26][1];
        if (reg_line[0][28][DW_LINE-2] == 1)
            reg_line[1][28] <= reg_line[0][28];
        else
            reg_line[1][28] <= wire_out[28][0];
        if (reg_line[0][29][DW_LINE-2] == 1)
            reg_line[1][29] <= reg_line[0][29];
        else
            reg_line[1][29] <= wire_out[28][1];
        if (reg_line[0][30][DW_LINE-2] == 1)
            reg_line[1][30] <= reg_line[0][30];
        else
            reg_line[1][30] <= wire_out[30][0];
        if (reg_line[0][31][DW_LINE-2] == 1)
            reg_line[1][31] <= reg_line[0][31];
        else
            reg_line[1][31] <= wire_out[30][1];
        // set reg layer 2
        reg_line[2][0] <= reg_line[1][0];
        reg_line[2][1] <= reg_line[1][1];
        if (reg_line[2][2][DW_LINE-2] == 1)
            reg_line[2][2] <= reg_line[1][2];
        else
            reg_line[2][2] <= wire_out[1][0];
        reg_line[2][3] <= reg_line[1][3];
        reg_line[2][4] <= reg_line[1][4];
        if (reg_line[2][5][DW_LINE-2] == 1)
            reg_line[2][5] <= reg_line[1][5];
        else
            reg_line[2][5] <= wire_out[5][0];
        if (reg_line[1][6][DW_LINE-2] == 1)
            reg_line[2][6] <= reg_line[1][6];
        else
            reg_line[2][6] <= wire_out[5][0];
        reg_line[2][7] <= reg_line[1][7];
        reg_line[2][8] <= reg_line[1][8];
        if (reg_line[1][9][DW_LINE-2] == 1)
            reg_line[2][9] <= reg_line[1][9];
        else
            reg_line[2][9] <= wire_out[9][0];
        if (reg_line[1][10][DW_LINE-2] == 1)
            reg_line[2][10] <= reg_line[1][10];
        else
            reg_line[2][10] <= wire_out[9][0];
        reg_line[2][11] <= reg_line[1][11];
        reg_line[2][12] <= reg_line[1][12];
        if (reg_line[1][13][DW_LINE-2] == 1)
            reg_line[2][13] <= reg_line[1][13];
        else
            reg_line[2][13] <= wire_out[13][0];
        if (reg_line[1][14][DW_LINE-2] == 1)
            reg_line[2][14] <= reg_line[1][14];
        else
            reg_line[2][14] <= wire_out[13][0];
        reg_line[2][15] <= reg_line[1][15];
        reg_line[2][16] <= reg_line[1][16];
        if (reg_line[1][17][DW_LINE-2] == 1)
            reg_line[2][17] <= reg_line[1][17];
        else
            reg_line[2][17] <= wire_out[17][0];
        if (reg_line[1][18][DW_LINE-2] == 1)
            reg_line[2][18] <= reg_line[1][18];
        else
            reg_line[2][18] <= wire_out[17][0];
        reg_line[2][19] <= reg_line[1][19];
        reg_line[2][20] <= reg_line[1][20];
        if (reg_line[1][21][DW_LINE-2] == 1)
            reg_line[2][21] <= reg_line[1][21];
        else
            reg_line[2][21] <= wire_out[21][0];
        if (reg_line[1][22][DW_LINE-2] == 1)
            reg_line[2][22] <= reg_line[1][22];
        else
            reg_line[2][22] <= wire_out[21][0];
        reg_line[2][23] <= reg_line[1][23];
        reg_line[2][24] <= reg_line[1][24];
        if (reg_line[1][25][DW_LINE-2] == 1)
            reg_line[2][25] <= reg_line[1][25];
        else
            reg_line[2][25] <= wire_out[25][0];
        if (reg_line[1][26][DW_LINE-2] == 1)
            reg_line[2][26] <= reg_line[1][26];
        else
            reg_line[2][26] <= wire_out[25][0];
        reg_line[2][27] <= reg_line[1][27];
        reg_line[2][28] <= reg_line[1][28];
        if (reg_line[1][29][DW_LINE-2] == 1)
            reg_line[2][29] <= reg_line[1][29];
        else
            reg_line[2][29] <= wire_out[29][0];
        reg_line[2][30] <= reg_line[1][30];
        reg_line[2][31] <= reg_line[1][31];
        // set reg layer 3
        reg_line[3][0] <= reg_line[2][0];
        reg_line[3][1] <= reg_line[2][1];
        reg_line[3][2] <= reg_line[2][2];
        reg_line[3][3] <= reg_line[2][3];
        reg_line[3][4] <= reg_line[2][4];
        if (reg_line[2][5][DW_LINE-2] == 1)
            reg_line[3][5] <= reg_line[2][5];
        else
            reg_line[3][5] <= wire_out[3][0];
        reg_line[3][6] <= reg_line[2][6];
        reg_line[3][7] <= reg_line[2][7];
        reg_line[3][8] <= reg_line[2][8];
        reg_line[3][9] <= reg_line[2][9];
        if (reg_line[2][10][DW_LINE-2] == 1)
            reg_line[3][10] <= reg_line[2][10];
        else
            reg_line[3][10] <= wire_out[11][0];
        reg_line[3][11] <= reg_line[2][11];
        reg_line[3][12] <= reg_line[2][12];
        if (reg_line[2][13][DW_LINE-2] == 1)
            reg_line[3][13] <= reg_line[2][13];
        else
            reg_line[3][13] <= wire_out[11][0];
        reg_line[3][14] <= reg_line[2][14];
        reg_line[3][15] <= reg_line[2][15];
        reg_line[3][16] <= reg_line[2][16];
        reg_line[3][17] <= reg_line[2][17];
        if (reg_line[2][18][DW_LINE-2] == 1)
            reg_line[3][18] <= reg_line[2][18];
        else
            reg_line[3][18] <= wire_out[19][0];
        reg_line[3][19] <= reg_line[2][19];
        reg_line[3][20] <= reg_line[2][20];
        if (reg_line[2][21][DW_LINE-2] == 1)
            reg_line[3][21] <= reg_line[2][21];
        else
            reg_line[3][21] <= wire_out[19][0];
        reg_line[3][22] <= reg_line[2][22];
        reg_line[3][23] <= reg_line[2][23];
        reg_line[3][24] <= reg_line[2][24];
        reg_line[3][25] <= reg_line[2][25];
        if (reg_line[2][26][DW_LINE-2] == 1)
            reg_line[3][26] <= reg_line[2][26];
        else
            reg_line[3][26] <= wire_out[27][0];
        reg_line[3][27] <= reg_line[2][27];
        reg_line[3][28] <= reg_line[2][28];
        reg_line[3][29] <= reg_line[2][29];
        reg_line[3][30] <= reg_line[2][30];
        reg_line[3][31] <= reg_line[2][31];
        // set for layer 4
        reg_line[4][0] <= reg_line[3][0];
        reg_line[4][1] <= reg_line[3][1];
        reg_line[4][2] <= reg_line[3][2];
        reg_line[4][3] <= reg_line[3][3];
        reg_line[4][4] <= reg_line[3][4];
        reg_line[4][5] <= reg_line[3][5];
        reg_line[4][6] <= reg_line[3][6];
        reg_line[4][7] <= reg_line[3][7];
        reg_line[4][8] <= reg_line[3][8];
        reg_line[4][9] <= reg_line[3][9];
        if (reg_line[3][10][DW_LINE-2] == 1)
            reg_line[4][10] <= reg_line[3][10];
        else
            reg_line[4][10] <= wire_out[7][0];
        reg_line[4][11] <= reg_line[3][11];
        reg_line[4][12] <= reg_line[3][12];
        reg_line[4][13] <= reg_line[3][13];
        reg_line[4][14] <= reg_line[3][14];
        reg_line[4][15] <= reg_line[3][15];
        reg_line[4][16] <= reg_line[3][16];
        reg_line[4][17] <= reg_line[3][17];
        reg_line[4][18] <= reg_line[3][18];
        reg_line[4][19] <= reg_line[3][19];
        reg_line[4][20] <= reg_line[3][20];
        if (reg_line[3][21][DW_LINE-2] == 1)
            reg_line[4][21] <= reg_line[3][21];
        else
            reg_line[4][21] <= wire_out[23][0];
        reg_line[4][22] <= reg_line[3][22];
        reg_line[4][23] <= reg_line[3][23];
        reg_line[4][24] <= reg_line[3][24];
        reg_line[4][25] <= reg_line[3][25];
        reg_line[4][26] <= reg_line[3][26];
        reg_line[4][27] <= reg_line[3][27];
        reg_line[4][28] <= reg_line[3][28];
        reg_line[4][29] <= reg_line[3][29];
        reg_line[4][30] <= reg_line[3][30];
        reg_line[4][31] <= reg_line[3][31];
        // set reg layer 5
        reg_line[5][0] <= reg_line[4][0];
        reg_line[5][1] <= reg_line[4][1];
        reg_line[5][2] <= reg_line[4][2];
        reg_line[5][3] <= reg_line[4][3];
        reg_line[5][4] <= reg_line[4][4];
        reg_line[5][5] <= reg_line[4][5];
        reg_line[5][6] <= reg_line[4][6];
        reg_line[5][7] <= reg_line[4][7];
        reg_line[5][8] <= reg_line[4][8];
        reg_line[5][9] <= reg_line[4][9];
        reg_line[5][10] <= reg_line[4][10];
        reg_line[5][11] <= reg_line[4][11];
        reg_line[5][12] <= reg_line[4][12];
        reg_line[5][13] <= reg_line[4][13];
        reg_line[5][14] <= reg_line[4][14];
        if (reg_line[4][15][DW_LINE-2] == 1)
            reg_line[5][15] <= reg_line[4][15];
        else
            reg_line[5][15] <= wire_out[15][0];
        reg_line[5][16] <= reg_line[4][16];
        reg_line[5][17] <= reg_line[4][17];
        reg_line[5][18] <= reg_line[4][18];
        reg_line[5][19] <= reg_line[4][19];
        reg_line[5][20] <= reg_line[4][20];
        reg_line[5][21] <= reg_line[4][21];
        reg_line[5][22] <= reg_line[4][22];
        reg_line[5][23] <= reg_line[4][23];
        reg_line[5][24] <= reg_line[4][24];
        reg_line[5][25] <= reg_line[4][25];
        reg_line[5][26] <= reg_line[4][26];
        reg_line[5][27] <= reg_line[4][27];
        reg_line[5][28] <= reg_line[4][28];
        reg_line[5][29] <= reg_line[4][29];
        reg_line[5][30] <= reg_line[4][30];
        reg_line[5][31] <= reg_line[4][31];
    end

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_0 (
   .clk(clk),
   .in({reg_line[0][1], reg_line[0][0]}),
   .out({wire_out[0][1], wire_out[0][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_1 (
   .clk(clk),
   .in({reg_line[1][2], reg_line[1][1]}),
   .out({wire_out[1][1], wire_out[1][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_2 (
   .clk(clk),
   .in({reg_line[0][3], reg_line[0][2]}),
   .out({wire_out[2][1], wire_out[2][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(4)
) u_fan_adder_3 (
   .clk(clk),
   .in({reg_line[2][5], reg_line[2][4], reg_line[2][3], reg_line[2][2]}),
   .out({wire_out[3][1], wire_out[3][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_4 (
   .clk(clk),
   .in({reg_line[0][5], reg_line[0][4]}),
   .out({wire_out[4][1], wire_out[4][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_5 (
   .clk(clk),
   .in({reg_line[1][6], reg_line[1][5]}),
   .out({wire_out[5][1], wire_out[5][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_6 (
   .clk(clk),
   .in({reg_line[0][7], reg_line[0][6]}),
   .out({wire_out[6][1], wire_out[6][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(6)
) u_fan_adder_7 (
   .clk(clk),
   .in({reg_line[3][10], reg_line[3][9], reg_line[3][8], reg_line[3][7], reg_line[3][6], reg_line[3][5]}),
   .out({wire_out[7][1], wire_out[7][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_8 (
   .clk(clk),
   .in({reg_line[0][9], reg_line[0][8]}),
   .out({wire_out[8][1], wire_out[8][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_9 (
   .clk(clk),
   .in({reg_line[1][10], reg_line[1][9]}),
   .out({wire_out[9][1], wire_out[9][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_10 (
   .clk(clk),
   .in({reg_line[0][11], reg_line[0][10]}),
   .out({wire_out[10][1], wire_out[10][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(4)
) u_fan_adder_11 (
   .clk(clk),
   .in({reg_line[2][13], reg_line[2][12], reg_line[2][11], reg_line[2][10]}),
   .out({wire_out[11][1], wire_out[11][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_12 (
   .clk(clk),
   .in({reg_line[0][13], reg_line[0][12]}),
   .out({wire_out[12][1], wire_out[12][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_13 (
   .clk(clk),
   .in({reg_line[1][14], reg_line[1][13]}),
   .out({wire_out[13][1], wire_out[13][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_14 (
   .clk(clk),
   .in({reg_line[0][15], reg_line[0][14]}),
   .out({wire_out[14][1], wire_out[14][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(8)
) u_fan_adder_15 (
   .clk(clk),
   .in({reg_line[4][21], reg_line[4][18], reg_line[4][17], reg_line[4][16], reg_line[4][15], reg_line[4][14], reg_line[4][13], reg_line[4][10]}),
   .out({wire_out[15][1], wire_out[15][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_16 (
   .clk(clk),
   .in({reg_line[0][17], reg_line[0][16]}),
   .out({wire_out[16][1], wire_out[16][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_17 (
   .clk(clk),
   .in({reg_line[1][18], reg_line[1][17]}),
   .out({wire_out[17][1], wire_out[17][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_18 (
   .clk(clk),
   .in({reg_line[0][19], reg_line[0][18]}),
   .out({wire_out[18][1], wire_out[18][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(4)
) u_fan_adder_19 (
   .clk(clk),
   .in({reg_line[2][21], reg_line[2][20], reg_line[2][19], reg_line[2][18]}),
   .out({wire_out[19][1], wire_out[19][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_20 (
   .clk(clk),
   .in({reg_line[0][21], reg_line[0][20]}),
   .out({wire_out[20][1], wire_out[20][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_21 (
   .clk(clk),
   .in({reg_line[1][22], reg_line[1][21]}),
   .out({wire_out[21][1], wire_out[21][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_22 (
   .clk(clk),
   .in({reg_line[0][23], reg_line[0][22]}),
   .out({wire_out[22][1], wire_out[22][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(6)
) u_fan_adder_23 (
   .clk(clk),
   .in({reg_line[3][26], reg_line[3][25], reg_line[3][24], reg_line[3][23], reg_line[3][22], reg_line[3][21]}),
   .out({wire_out[23][1], wire_out[23][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_24 (
   .clk(clk),
   .in({reg_line[0][25], reg_line[0][24]}),
   .out({wire_out[24][1], wire_out[24][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_25 (
   .clk(clk),
   .in({reg_line[1][26], reg_line[1][25]}),
   .out({wire_out[25][1], wire_out[25][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_26 (
   .clk(clk),
   .in({reg_line[0][27], reg_line[0][26]}),
   .out({wire_out[26][1], wire_out[26][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(4)
) u_fan_adder_27 (
   .clk(clk),
   .in({reg_line[2][29], reg_line[2][28], reg_line[2][27], reg_line[2][26]}),
   .out({wire_out[27][1], wire_out[27][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_28 (
   .clk(clk),
   .in({reg_line[0][29], reg_line[0][28]}),
   .out({wire_out[28][1], wire_out[28][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_29 (
   .clk(clk),
   .in({reg_line[1][30], reg_line[1][29]}),
   .out({wire_out[29][1], wire_out[29][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .DW_ROW(DW_ROW),
   .DW_CTRL(DW_CTRL),
   .NUM_IN(2)
) u_fan_adder_30 (
   .clk(clk),
   .in({reg_line[0][31], reg_line[0][30]}),
   .out({wire_out[30][1], wire_out[30][0]})
);

endmodule