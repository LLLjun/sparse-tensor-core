`timescale 1ns / 1ps

module fan_tree 
#(
   parameter N = 32,
   parameter DW_DATA = 32,
   parameter N_LEVELS = $clog2(N),
   parameter N_ADDERS = N - 1,
   parameter ADDER_IN = 2*(N_LEVELS-1)
)
(
   input clk,
   input [N_ADDERS-1:0] add_en,
   input [N_ADDERS-1:0] bypass_en,
   input [6*N_ADDERS-1:0] sel,
   input [DW_DATA*N-1:0] in,
   input [2*N-1:0] edge_tag_in,
   output [2*N_ADDERS-1:0] out_valid,
   output [DW_DATA*2*N_ADDERS-1:0] out
);

   reg [DW_DATA-1:0] reg_in [N_ADDERS-1:0][ADDER_IN-1:0];
   reg [1:0] reg_edge_tag_in [N_ADDERS-1:0][ADDER_IN-1:0];
   wire [DW_DATA-1:0] wire_out [N_ADDERS-1:0][1:0];
   wire [1:0] wire_edge_tag_out [N_ADDERS-1:0][1:0];
   reg [DW_DATA*2*N_ADDERS-1:0] reg_out;
   integer i;

   always @(*) begin
      reg_in[0][0] <= in[0 +:DW_DATA];
      reg_in[0][1] <= in[32 +:DW_DATA];
      reg_edge_tag_in[0][0] <= edge_tag_in[0 +:2];
      reg_edge_tag_in[0][1] <= edge_tag_in[2 +:2];
      reg_in[1][0] <= wire_out[0][1];
      reg_edge_tag_in[1][0] <= wire_edge_tag_out[0][1];
      reg_in[1][1] <= wire_out[2][0];
      reg_edge_tag_in[1][1] <= wire_edge_tag_out[2][0];
      reg_in[2][0] <= in[64 +:DW_DATA];
      reg_in[2][1] <= in[96 +:DW_DATA];
      reg_edge_tag_in[2][0] <= edge_tag_in[4 +:2];
      reg_edge_tag_in[2][1] <= edge_tag_in[6 +:2];
      reg_in[3][0] <= wire_out[2][1];
      reg_edge_tag_in[3][0] <= wire_edge_tag_out[2][1];
      reg_in[3][1] <= wire_out[4][0];
      reg_edge_tag_in[3][1] <= wire_edge_tag_out[4][0];
      reg_in[3][2] <= wire_out[1][1];
      reg_edge_tag_in[3][2] <= wire_edge_tag_out[1][1];
      reg_in[3][3] <= wire_out[5][0];
      reg_edge_tag_in[3][3] <= wire_edge_tag_out[5][0];
      reg_in[4][0] <= in[128 +:DW_DATA];
      reg_in[4][1] <= in[160 +:DW_DATA];
      reg_edge_tag_in[4][0] <= edge_tag_in[8 +:2];
      reg_edge_tag_in[4][1] <= edge_tag_in[10 +:2];
      reg_in[5][0] <= wire_out[4][1];
      reg_edge_tag_in[5][0] <= wire_edge_tag_out[4][1];
      reg_in[5][1] <= wire_out[6][0];
      reg_edge_tag_in[5][1] <= wire_edge_tag_out[6][0];
      reg_in[6][0] <= in[192 +:DW_DATA];
      reg_in[6][1] <= in[224 +:DW_DATA];
      reg_edge_tag_in[6][0] <= edge_tag_in[12 +:2];
      reg_edge_tag_in[6][1] <= edge_tag_in[14 +:2];
      reg_in[7][0] <= wire_out[6][1];
      reg_edge_tag_in[7][0] <= wire_edge_tag_out[6][1];
      reg_in[7][1] <= wire_out[8][0];
      reg_edge_tag_in[7][1] <= wire_edge_tag_out[8][0];
      reg_in[7][2] <= wire_out[5][1];
      reg_edge_tag_in[7][2] <= wire_edge_tag_out[5][1];
      reg_in[7][3] <= wire_out[9][0];
      reg_edge_tag_in[7][3] <= wire_edge_tag_out[9][0];
      reg_in[7][4] <= wire_out[3][1];
      reg_edge_tag_in[7][4] <= wire_edge_tag_out[3][1];
      reg_in[7][5] <= wire_out[11][0];
      reg_edge_tag_in[7][5] <= wire_edge_tag_out[11][0];
      reg_in[8][0] <= in[256 +:DW_DATA];
      reg_in[8][1] <= in[288 +:DW_DATA];
      reg_edge_tag_in[8][0] <= edge_tag_in[16 +:2];
      reg_edge_tag_in[8][1] <= edge_tag_in[18 +:2];
      reg_in[9][0] <= wire_out[8][1];
      reg_edge_tag_in[9][0] <= wire_edge_tag_out[8][1];
      reg_in[9][1] <= wire_out[10][0];
      reg_edge_tag_in[9][1] <= wire_edge_tag_out[10][0];
      reg_in[10][0] <= in[320 +:DW_DATA];
      reg_in[10][1] <= in[352 +:DW_DATA];
      reg_edge_tag_in[10][0] <= edge_tag_in[20 +:2];
      reg_edge_tag_in[10][1] <= edge_tag_in[22 +:2];
      reg_in[11][0] <= wire_out[10][1];
      reg_edge_tag_in[11][0] <= wire_edge_tag_out[10][1];
      reg_in[11][1] <= wire_out[12][0];
      reg_edge_tag_in[11][1] <= wire_edge_tag_out[12][0];
      reg_in[11][2] <= wire_out[9][1];
      reg_edge_tag_in[11][2] <= wire_edge_tag_out[9][1];
      reg_in[11][3] <= wire_out[13][0];
      reg_edge_tag_in[11][3] <= wire_edge_tag_out[13][0];
      reg_in[12][0] <= in[384 +:DW_DATA];
      reg_in[12][1] <= in[416 +:DW_DATA];
      reg_edge_tag_in[12][0] <= edge_tag_in[24 +:2];
      reg_edge_tag_in[12][1] <= edge_tag_in[26 +:2];
      reg_in[13][0] <= wire_out[12][1];
      reg_edge_tag_in[13][0] <= wire_edge_tag_out[12][1];
      reg_in[13][1] <= wire_out[14][0];
      reg_edge_tag_in[13][1] <= wire_edge_tag_out[14][0];
      reg_in[14][0] <= in[448 +:DW_DATA];
      reg_in[14][1] <= in[480 +:DW_DATA];
      reg_edge_tag_in[14][0] <= edge_tag_in[28 +:2];
      reg_edge_tag_in[14][1] <= edge_tag_in[30 +:2];
      reg_in[15][0] <= wire_out[14][1];
      reg_edge_tag_in[15][0] <= wire_edge_tag_out[14][1];
      reg_in[15][1] <= wire_out[16][0];
      reg_edge_tag_in[15][1] <= wire_edge_tag_out[16][0];
      reg_in[15][2] <= wire_out[13][1];
      reg_edge_tag_in[15][2] <= wire_edge_tag_out[13][1];
      reg_in[15][3] <= wire_out[17][0];
      reg_edge_tag_in[15][3] <= wire_edge_tag_out[17][0];
      reg_in[15][4] <= wire_out[11][1];
      reg_edge_tag_in[15][4] <= wire_edge_tag_out[11][1];
      reg_in[15][5] <= wire_out[19][0];
      reg_edge_tag_in[15][5] <= wire_edge_tag_out[19][0];
      reg_in[15][6] <= wire_out[7][1];
      reg_edge_tag_in[15][6] <= wire_edge_tag_out[7][1];
      reg_in[15][7] <= wire_out[23][0];
      reg_edge_tag_in[15][7] <= wire_edge_tag_out[23][0];
      reg_in[16][0] <= in[512 +:DW_DATA];
      reg_in[16][1] <= in[544 +:DW_DATA];
      reg_edge_tag_in[16][0] <= edge_tag_in[32 +:2];
      reg_edge_tag_in[16][1] <= edge_tag_in[34 +:2];
      reg_in[17][0] <= wire_out[16][1];
      reg_edge_tag_in[17][0] <= wire_edge_tag_out[16][1];
      reg_in[17][1] <= wire_out[18][0];
      reg_edge_tag_in[17][1] <= wire_edge_tag_out[18][0];
      reg_in[18][0] <= in[576 +:DW_DATA];
      reg_in[18][1] <= in[608 +:DW_DATA];
      reg_edge_tag_in[18][0] <= edge_tag_in[36 +:2];
      reg_edge_tag_in[18][1] <= edge_tag_in[38 +:2];
      reg_in[19][0] <= wire_out[18][1];
      reg_edge_tag_in[19][0] <= wire_edge_tag_out[18][1];
      reg_in[19][1] <= wire_out[20][0];
      reg_edge_tag_in[19][1] <= wire_edge_tag_out[20][0];
      reg_in[19][2] <= wire_out[17][1];
      reg_edge_tag_in[19][2] <= wire_edge_tag_out[17][1];
      reg_in[19][3] <= wire_out[21][0];
      reg_edge_tag_in[19][3] <= wire_edge_tag_out[21][0];
      reg_in[20][0] <= in[640 +:DW_DATA];
      reg_in[20][1] <= in[672 +:DW_DATA];
      reg_edge_tag_in[20][0] <= edge_tag_in[40 +:2];
      reg_edge_tag_in[20][1] <= edge_tag_in[42 +:2];
      reg_in[21][0] <= wire_out[20][1];
      reg_edge_tag_in[21][0] <= wire_edge_tag_out[20][1];
      reg_in[21][1] <= wire_out[22][0];
      reg_edge_tag_in[21][1] <= wire_edge_tag_out[22][0];
      reg_in[22][0] <= in[704 +:DW_DATA];
      reg_in[22][1] <= in[736 +:DW_DATA];
      reg_edge_tag_in[22][0] <= edge_tag_in[44 +:2];
      reg_edge_tag_in[22][1] <= edge_tag_in[46 +:2];
      reg_in[23][0] <= wire_out[22][1];
      reg_edge_tag_in[23][0] <= wire_edge_tag_out[22][1];
      reg_in[23][1] <= wire_out[24][0];
      reg_edge_tag_in[23][1] <= wire_edge_tag_out[24][0];
      reg_in[23][2] <= wire_out[21][1];
      reg_edge_tag_in[23][2] <= wire_edge_tag_out[21][1];
      reg_in[23][3] <= wire_out[25][0];
      reg_edge_tag_in[23][3] <= wire_edge_tag_out[25][0];
      reg_in[23][4] <= wire_out[19][1];
      reg_edge_tag_in[23][4] <= wire_edge_tag_out[19][1];
      reg_in[23][5] <= wire_out[27][0];
      reg_edge_tag_in[23][5] <= wire_edge_tag_out[27][0];
      reg_in[24][0] <= in[768 +:DW_DATA];
      reg_in[24][1] <= in[800 +:DW_DATA];
      reg_edge_tag_in[24][0] <= edge_tag_in[48 +:2];
      reg_edge_tag_in[24][1] <= edge_tag_in[50 +:2];
      reg_in[25][0] <= wire_out[24][1];
      reg_edge_tag_in[25][0] <= wire_edge_tag_out[24][1];
      reg_in[25][1] <= wire_out[26][0];
      reg_edge_tag_in[25][1] <= wire_edge_tag_out[26][0];
      reg_in[26][0] <= in[832 +:DW_DATA];
      reg_in[26][1] <= in[864 +:DW_DATA];
      reg_edge_tag_in[26][0] <= edge_tag_in[52 +:2];
      reg_edge_tag_in[26][1] <= edge_tag_in[54 +:2];
      reg_in[27][0] <= wire_out[26][1];
      reg_edge_tag_in[27][0] <= wire_edge_tag_out[26][1];
      reg_in[27][1] <= wire_out[28][0];
      reg_edge_tag_in[27][1] <= wire_edge_tag_out[28][0];
      reg_in[27][2] <= wire_out[25][1];
      reg_edge_tag_in[27][2] <= wire_edge_tag_out[25][1];
      reg_in[27][3] <= wire_out[29][0];
      reg_edge_tag_in[27][3] <= wire_edge_tag_out[29][0];
      reg_in[28][0] <= in[896 +:DW_DATA];
      reg_in[28][1] <= in[928 +:DW_DATA];
      reg_edge_tag_in[28][0] <= edge_tag_in[56 +:2];
      reg_edge_tag_in[28][1] <= edge_tag_in[58 +:2];
      reg_in[29][0] <= wire_out[28][1];
      reg_edge_tag_in[29][0] <= wire_edge_tag_out[28][1];
      reg_in[29][1] <= wire_out[30][0];
      reg_edge_tag_in[29][1] <= wire_edge_tag_out[30][0];
      reg_in[30][0] <= in[960 +:DW_DATA];
      reg_in[30][1] <= in[992 +:DW_DATA];
      reg_edge_tag_in[30][0] <= edge_tag_in[60 +:2];
      reg_edge_tag_in[30][1] <= edge_tag_in[62 +:2];

      for (i=0; i<N_ADDERS; i=i+1) begin
         reg_out[i*2*DW_DATA +:DW_DATA] <= wire_out[i][0];
         reg_out[(i*2+1)*DW_DATA +:DW_DATA] <= wire_out[i][1];
      end
   end
   
   assign out = reg_out;

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_0 (
   .clk(clk),
   .add_en(add_en[0]),
   .bypass_en(bypass_en[0]),
   .in({reg_in[0][1], reg_in[0][0]}),
   .edge_tag_in({reg_edge_tag_in[0][1], reg_edge_tag_in[0][0]}),
   .sel({sel[3 +:1],sel[0 +:1]}),
   .out_valid({out_valid[0 +:2]}),
   .edge_tag_out({wire_edge_tag_out[0][1], wire_edge_tag_out[0][0]}),
   .out({wire_out[0][1], wire_out[0][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_1 (
   .clk(clk),
   .add_en(add_en[1]),
   .bypass_en(bypass_en[1]),
   .in({reg_in[1][1], reg_in[1][0]}),
   .edge_tag_in({reg_edge_tag_in[1][1], reg_edge_tag_in[1][0]}),
   .sel({sel[9 +:1],sel[6 +:1]}),
   .out_valid({out_valid[2 +:2]}),
   .edge_tag_out({wire_edge_tag_out[1][1], wire_edge_tag_out[1][0]}),
   .out({wire_out[1][1], wire_out[1][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_2 (
   .clk(clk),
   .add_en(add_en[2]),
   .bypass_en(bypass_en[2]),
   .in({reg_in[2][1], reg_in[2][0]}),
   .edge_tag_in({reg_edge_tag_in[2][1], reg_edge_tag_in[2][0]}),
   .sel({sel[15 +:1],sel[12 +:1]}),
   .out_valid({out_valid[4 +:2]}),
   .edge_tag_out({wire_edge_tag_out[2][1], wire_edge_tag_out[2][0]}),
   .out({wire_out[2][1], wire_out[2][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(4),
   .SEL_IN(2)
) u_fan_adder_3 (
   .clk(clk),
   .add_en(add_en[3]),
   .bypass_en(bypass_en[3]),
   .in({reg_in[3][3], reg_in[3][2], reg_in[3][1], reg_in[3][0]}),
   .edge_tag_in({reg_edge_tag_in[3][3], reg_edge_tag_in[3][2], reg_edge_tag_in[3][1], reg_edge_tag_in[3][0]}),
   .sel({sel[21 +:2],sel[18 +:2]}),
   .out_valid({out_valid[6 +:2]}),
   .edge_tag_out({wire_edge_tag_out[3][1], wire_edge_tag_out[3][0]}),
   .out({wire_out[3][1], wire_out[3][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_4 (
   .clk(clk),
   .add_en(add_en[4]),
   .bypass_en(bypass_en[4]),
   .in({reg_in[4][1], reg_in[4][0]}),
   .edge_tag_in({reg_edge_tag_in[4][1], reg_edge_tag_in[4][0]}),
   .sel({sel[27 +:1],sel[24 +:1]}),
   .out_valid({out_valid[8 +:2]}),
   .edge_tag_out({wire_edge_tag_out[4][1], wire_edge_tag_out[4][0]}),
   .out({wire_out[4][1], wire_out[4][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_5 (
   .clk(clk),
   .add_en(add_en[5]),
   .bypass_en(bypass_en[5]),
   .in({reg_in[5][1], reg_in[5][0]}),
   .edge_tag_in({reg_edge_tag_in[5][1], reg_edge_tag_in[5][0]}),
   .sel({sel[33 +:1],sel[30 +:1]}),
   .out_valid({out_valid[10 +:2]}),
   .edge_tag_out({wire_edge_tag_out[5][1], wire_edge_tag_out[5][0]}),
   .out({wire_out[5][1], wire_out[5][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_6 (
   .clk(clk),
   .add_en(add_en[6]),
   .bypass_en(bypass_en[6]),
   .in({reg_in[6][1], reg_in[6][0]}),
   .edge_tag_in({reg_edge_tag_in[6][1], reg_edge_tag_in[6][0]}),
   .sel({sel[39 +:1],sel[36 +:1]}),
   .out_valid({out_valid[12 +:2]}),
   .edge_tag_out({wire_edge_tag_out[6][1], wire_edge_tag_out[6][0]}),
   .out({wire_out[6][1], wire_out[6][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(6),
   .SEL_IN(3)
) u_fan_adder_7 (
   .clk(clk),
   .add_en(add_en[7]),
   .bypass_en(bypass_en[7]),
   .in({reg_in[7][5], reg_in[7][4], reg_in[7][3], reg_in[7][2], reg_in[7][1], reg_in[7][0]}),
   .edge_tag_in({reg_edge_tag_in[7][5], reg_edge_tag_in[7][4], reg_edge_tag_in[7][3], reg_edge_tag_in[7][2], reg_edge_tag_in[7][1], reg_edge_tag_in[7][0]}),
   .sel({sel[45 +:3],sel[42 +:3]}),
   .out_valid({out_valid[14 +:2]}),
   .edge_tag_out({wire_edge_tag_out[7][1], wire_edge_tag_out[7][0]}),
   .out({wire_out[7][1], wire_out[7][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_8 (
   .clk(clk),
   .add_en(add_en[8]),
   .bypass_en(bypass_en[8]),
   .in({reg_in[8][1], reg_in[8][0]}),
   .edge_tag_in({reg_edge_tag_in[8][1], reg_edge_tag_in[8][0]}),
   .sel({sel[51 +:1],sel[48 +:1]}),
   .out_valid({out_valid[16 +:2]}),
   .edge_tag_out({wire_edge_tag_out[8][1], wire_edge_tag_out[8][0]}),
   .out({wire_out[8][1], wire_out[8][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_9 (
   .clk(clk),
   .add_en(add_en[9]),
   .bypass_en(bypass_en[9]),
   .in({reg_in[9][1], reg_in[9][0]}),
   .edge_tag_in({reg_edge_tag_in[9][1], reg_edge_tag_in[9][0]}),
   .sel({sel[57 +:1],sel[54 +:1]}),
   .out_valid({out_valid[18 +:2]}),
   .edge_tag_out({wire_edge_tag_out[9][1], wire_edge_tag_out[9][0]}),
   .out({wire_out[9][1], wire_out[9][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_10 (
   .clk(clk),
   .add_en(add_en[10]),
   .bypass_en(bypass_en[10]),
   .in({reg_in[10][1], reg_in[10][0]}),
   .edge_tag_in({reg_edge_tag_in[10][1], reg_edge_tag_in[10][0]}),
   .sel({sel[63 +:1],sel[60 +:1]}),
   .out_valid({out_valid[20 +:2]}),
   .edge_tag_out({wire_edge_tag_out[10][1], wire_edge_tag_out[10][0]}),
   .out({wire_out[10][1], wire_out[10][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(4),
   .SEL_IN(2)
) u_fan_adder_11 (
   .clk(clk),
   .add_en(add_en[11]),
   .bypass_en(bypass_en[11]),
   .in({reg_in[11][3], reg_in[11][2], reg_in[11][1], reg_in[11][0]}),
   .edge_tag_in({reg_edge_tag_in[11][3], reg_edge_tag_in[11][2], reg_edge_tag_in[11][1], reg_edge_tag_in[11][0]}),
   .sel({sel[69 +:2],sel[66 +:2]}),
   .out_valid({out_valid[22 +:2]}),
   .edge_tag_out({wire_edge_tag_out[11][1], wire_edge_tag_out[11][0]}),
   .out({wire_out[11][1], wire_out[11][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_12 (
   .clk(clk),
   .add_en(add_en[12]),
   .bypass_en(bypass_en[12]),
   .in({reg_in[12][1], reg_in[12][0]}),
   .edge_tag_in({reg_edge_tag_in[12][1], reg_edge_tag_in[12][0]}),
   .sel({sel[75 +:1],sel[72 +:1]}),
   .out_valid({out_valid[24 +:2]}),
   .edge_tag_out({wire_edge_tag_out[12][1], wire_edge_tag_out[12][0]}),
   .out({wire_out[12][1], wire_out[12][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_13 (
   .clk(clk),
   .add_en(add_en[13]),
   .bypass_en(bypass_en[13]),
   .in({reg_in[13][1], reg_in[13][0]}),
   .edge_tag_in({reg_edge_tag_in[13][1], reg_edge_tag_in[13][0]}),
   .sel({sel[81 +:1],sel[78 +:1]}),
   .out_valid({out_valid[26 +:2]}),
   .edge_tag_out({wire_edge_tag_out[13][1], wire_edge_tag_out[13][0]}),
   .out({wire_out[13][1], wire_out[13][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_14 (
   .clk(clk),
   .add_en(add_en[14]),
   .bypass_en(bypass_en[14]),
   .in({reg_in[14][1], reg_in[14][0]}),
   .edge_tag_in({reg_edge_tag_in[14][1], reg_edge_tag_in[14][0]}),
   .sel({sel[87 +:1],sel[84 +:1]}),
   .out_valid({out_valid[28 +:2]}),
   .edge_tag_out({wire_edge_tag_out[14][1], wire_edge_tag_out[14][0]}),
   .out({wire_out[14][1], wire_out[14][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(8),
   .SEL_IN(3)
) u_fan_adder_15 (
   .clk(clk),
   .add_en(add_en[15]),
   .bypass_en(bypass_en[15]),
   .in({reg_in[15][7], reg_in[15][6], reg_in[15][5], reg_in[15][4], reg_in[15][3], reg_in[15][2], reg_in[15][1], reg_in[15][0]}),
   .edge_tag_in({reg_edge_tag_in[15][7], reg_edge_tag_in[15][6], reg_edge_tag_in[15][5], reg_edge_tag_in[15][4], reg_edge_tag_in[15][3], reg_edge_tag_in[15][2], reg_edge_tag_in[15][1], reg_edge_tag_in[15][0]}),
   .sel({sel[93 +:3],sel[90 +:3]}),
   .out_valid({out_valid[30 +:2]}),
   .edge_tag_out({wire_edge_tag_out[15][1], wire_edge_tag_out[15][0]}),
   .out({wire_out[15][1], wire_out[15][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_16 (
   .clk(clk),
   .add_en(add_en[16]),
   .bypass_en(bypass_en[16]),
   .in({reg_in[16][1], reg_in[16][0]}),
   .edge_tag_in({reg_edge_tag_in[16][1], reg_edge_tag_in[16][0]}),
   .sel({sel[99 +:1],sel[96 +:1]}),
   .out_valid({out_valid[32 +:2]}),
   .edge_tag_out({wire_edge_tag_out[16][1], wire_edge_tag_out[16][0]}),
   .out({wire_out[16][1], wire_out[16][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_17 (
   .clk(clk),
   .add_en(add_en[17]),
   .bypass_en(bypass_en[17]),
   .in({reg_in[17][1], reg_in[17][0]}),
   .edge_tag_in({reg_edge_tag_in[17][1], reg_edge_tag_in[17][0]}),
   .sel({sel[105 +:1],sel[102 +:1]}),
   .out_valid({out_valid[34 +:2]}),
   .edge_tag_out({wire_edge_tag_out[17][1], wire_edge_tag_out[17][0]}),
   .out({wire_out[17][1], wire_out[17][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_18 (
   .clk(clk),
   .add_en(add_en[18]),
   .bypass_en(bypass_en[18]),
   .in({reg_in[18][1], reg_in[18][0]}),
   .edge_tag_in({reg_edge_tag_in[18][1], reg_edge_tag_in[18][0]}),
   .sel({sel[111 +:1],sel[108 +:1]}),
   .out_valid({out_valid[36 +:2]}),
   .edge_tag_out({wire_edge_tag_out[18][1], wire_edge_tag_out[18][0]}),
   .out({wire_out[18][1], wire_out[18][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(4),
   .SEL_IN(2)
) u_fan_adder_19 (
   .clk(clk),
   .add_en(add_en[19]),
   .bypass_en(bypass_en[19]),
   .in({reg_in[19][3], reg_in[19][2], reg_in[19][1], reg_in[19][0]}),
   .edge_tag_in({reg_edge_tag_in[19][3], reg_edge_tag_in[19][2], reg_edge_tag_in[19][1], reg_edge_tag_in[19][0]}),
   .sel({sel[117 +:2],sel[114 +:2]}),
   .out_valid({out_valid[38 +:2]}),
   .edge_tag_out({wire_edge_tag_out[19][1], wire_edge_tag_out[19][0]}),
   .out({wire_out[19][1], wire_out[19][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_20 (
   .clk(clk),
   .add_en(add_en[20]),
   .bypass_en(bypass_en[20]),
   .in({reg_in[20][1], reg_in[20][0]}),
   .edge_tag_in({reg_edge_tag_in[20][1], reg_edge_tag_in[20][0]}),
   .sel({sel[123 +:1],sel[120 +:1]}),
   .out_valid({out_valid[40 +:2]}),
   .edge_tag_out({wire_edge_tag_out[20][1], wire_edge_tag_out[20][0]}),
   .out({wire_out[20][1], wire_out[20][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_21 (
   .clk(clk),
   .add_en(add_en[21]),
   .bypass_en(bypass_en[21]),
   .in({reg_in[21][1], reg_in[21][0]}),
   .edge_tag_in({reg_edge_tag_in[21][1], reg_edge_tag_in[21][0]}),
   .sel({sel[129 +:1],sel[126 +:1]}),
   .out_valid({out_valid[42 +:2]}),
   .edge_tag_out({wire_edge_tag_out[21][1], wire_edge_tag_out[21][0]}),
   .out({wire_out[21][1], wire_out[21][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_22 (
   .clk(clk),
   .add_en(add_en[22]),
   .bypass_en(bypass_en[22]),
   .in({reg_in[22][1], reg_in[22][0]}),
   .edge_tag_in({reg_edge_tag_in[22][1], reg_edge_tag_in[22][0]}),
   .sel({sel[135 +:1],sel[132 +:1]}),
   .out_valid({out_valid[44 +:2]}),
   .edge_tag_out({wire_edge_tag_out[22][1], wire_edge_tag_out[22][0]}),
   .out({wire_out[22][1], wire_out[22][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(6),
   .SEL_IN(3)
) u_fan_adder_23 (
   .clk(clk),
   .add_en(add_en[23]),
   .bypass_en(bypass_en[23]),
   .in({reg_in[23][5], reg_in[23][4], reg_in[23][3], reg_in[23][2], reg_in[23][1], reg_in[23][0]}),
   .edge_tag_in({reg_edge_tag_in[23][5], reg_edge_tag_in[23][4], reg_edge_tag_in[23][3], reg_edge_tag_in[23][2], reg_edge_tag_in[23][1], reg_edge_tag_in[23][0]}),
   .sel({sel[141 +:3],sel[138 +:3]}),
   .out_valid({out_valid[46 +:2]}),
   .edge_tag_out({wire_edge_tag_out[23][1], wire_edge_tag_out[23][0]}),
   .out({wire_out[23][1], wire_out[23][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_24 (
   .clk(clk),
   .add_en(add_en[24]),
   .bypass_en(bypass_en[24]),
   .in({reg_in[24][1], reg_in[24][0]}),
   .edge_tag_in({reg_edge_tag_in[24][1], reg_edge_tag_in[24][0]}),
   .sel({sel[147 +:1],sel[144 +:1]}),
   .out_valid({out_valid[48 +:2]}),
   .edge_tag_out({wire_edge_tag_out[24][1], wire_edge_tag_out[24][0]}),
   .out({wire_out[24][1], wire_out[24][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_25 (
   .clk(clk),
   .add_en(add_en[25]),
   .bypass_en(bypass_en[25]),
   .in({reg_in[25][1], reg_in[25][0]}),
   .edge_tag_in({reg_edge_tag_in[25][1], reg_edge_tag_in[25][0]}),
   .sel({sel[153 +:1],sel[150 +:1]}),
   .out_valid({out_valid[50 +:2]}),
   .edge_tag_out({wire_edge_tag_out[25][1], wire_edge_tag_out[25][0]}),
   .out({wire_out[25][1], wire_out[25][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_26 (
   .clk(clk),
   .add_en(add_en[26]),
   .bypass_en(bypass_en[26]),
   .in({reg_in[26][1], reg_in[26][0]}),
   .edge_tag_in({reg_edge_tag_in[26][1], reg_edge_tag_in[26][0]}),
   .sel({sel[159 +:1],sel[156 +:1]}),
   .out_valid({out_valid[52 +:2]}),
   .edge_tag_out({wire_edge_tag_out[26][1], wire_edge_tag_out[26][0]}),
   .out({wire_out[26][1], wire_out[26][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(4),
   .SEL_IN(2)
) u_fan_adder_27 (
   .clk(clk),
   .add_en(add_en[27]),
   .bypass_en(bypass_en[27]),
   .in({reg_in[27][3], reg_in[27][2], reg_in[27][1], reg_in[27][0]}),
   .edge_tag_in({reg_edge_tag_in[27][3], reg_edge_tag_in[27][2], reg_edge_tag_in[27][1], reg_edge_tag_in[27][0]}),
   .sel({sel[165 +:2],sel[162 +:2]}),
   .out_valid({out_valid[54 +:2]}),
   .edge_tag_out({wire_edge_tag_out[27][1], wire_edge_tag_out[27][0]}),
   .out({wire_out[27][1], wire_out[27][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_28 (
   .clk(clk),
   .add_en(add_en[28]),
   .bypass_en(bypass_en[28]),
   .in({reg_in[28][1], reg_in[28][0]}),
   .edge_tag_in({reg_edge_tag_in[28][1], reg_edge_tag_in[28][0]}),
   .sel({sel[171 +:1],sel[168 +:1]}),
   .out_valid({out_valid[56 +:2]}),
   .edge_tag_out({wire_edge_tag_out[28][1], wire_edge_tag_out[28][0]}),
   .out({wire_out[28][1], wire_out[28][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_29 (
   .clk(clk),
   .add_en(add_en[29]),
   .bypass_en(bypass_en[29]),
   .in({reg_in[29][1], reg_in[29][0]}),
   .edge_tag_in({reg_edge_tag_in[29][1], reg_edge_tag_in[29][0]}),
   .sel({sel[177 +:1],sel[174 +:1]}),
   .out_valid({out_valid[58 +:2]}),
   .edge_tag_out({wire_edge_tag_out[29][1], wire_edge_tag_out[29][0]}),
   .out({wire_out[29][1], wire_out[29][0]})
);

fan_adder #(
   .DW_DATA(DW_DATA),
   .NUM_IN(2),
   .SEL_IN(1)
) u_fan_adder_30 (
   .clk(clk),
   .add_en(add_en[30]),
   .bypass_en(bypass_en[30]),
   .in({reg_in[30][1], reg_in[30][0]}),
   .edge_tag_in({reg_edge_tag_in[30][1], reg_edge_tag_in[30][0]}),
   .sel({sel[183 +:1],sel[180 +:1]}),
   .out_valid({out_valid[60 +:2]}),
   .edge_tag_out({wire_edge_tag_out[30][1], wire_edge_tag_out[30][0]}),
   .out({wire_out[30][1], wire_out[30][0]})
);


endmodule