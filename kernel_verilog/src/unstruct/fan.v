`timescale 1ns / 1ps

module fan_tree 
#(
   parameter N = 8,
   parameter DW_DATA = 8,
   parameter N_LEVELS = $clog2(N),
   parameter N_ADDERS = N - 1,
   parameter ADDER_IN = 2*(N_LEVELS-1)
)
(
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
      reg_in[0][1] <= in[8 +:DW_DATA];
      reg_edge_tag_in[0][0] <= edge_tag_in[0 +:2];
      reg_edge_tag_in[0][1] <= edge_tag_in[2 +:2];
      reg_in[1][0] <= wire_out[0][1];
      reg_edge_tag_in[1][0] <= wire_edge_tag_out[0][1];
      reg_in[1][1] <= wire_out[2][0];
      reg_edge_tag_in[1][1] <= wire_edge_tag_out[2][0];
      reg_in[2][0] <= in[16 +:DW_DATA];
      reg_in[2][1] <= in[24 +:DW_DATA];
      reg_edge_tag_in[2][0] <= edge_tag_in[4 +:2];
      reg_edge_tag_in[2][1] <= edge_tag_in[6 +:2];
      reg_in[3][0] <= wire_out[1][1];
      reg_edge_tag_in[3][0] <= wire_edge_tag_out[1][1];
      reg_in[3][1] <= wire_out[2][1];
      reg_edge_tag_in[3][1] <= wire_edge_tag_out[2][1];
      reg_in[3][2] <= wire_out[4][0];
      reg_edge_tag_in[3][2] <= wire_edge_tag_out[4][0];
      reg_in[3][3] <= wire_out[5][0];
      reg_edge_tag_in[3][3] <= wire_edge_tag_out[5][0];
      reg_in[4][0] <= in[32 +:DW_DATA];
      reg_in[4][1] <= in[40 +:DW_DATA];
      reg_edge_tag_in[4][0] <= edge_tag_in[8 +:2];
      reg_edge_tag_in[4][1] <= edge_tag_in[10 +:2];
      reg_in[5][0] <= wire_out[4][1];
      reg_edge_tag_in[5][0] <= wire_edge_tag_out[4][1];
      reg_in[5][1] <= wire_out[6][0];
      reg_edge_tag_in[5][1] <= wire_edge_tag_out[6][0];
      reg_in[6][0] <= in[48 +:DW_DATA];
      reg_in[6][1] <= in[56 +:DW_DATA];
      reg_edge_tag_in[6][0] <= edge_tag_in[12 +:2];
      reg_edge_tag_in[6][1] <= edge_tag_in[14 +:2];

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
   .add_en(add_en[6]),
   .bypass_en(bypass_en[6]),
   .in({reg_in[6][1], reg_in[6][0]}),
   .edge_tag_in({reg_edge_tag_in[6][1], reg_edge_tag_in[6][0]}),
   .sel({sel[39 +:1],sel[36 +:1]}),
   .out_valid({out_valid[12 +:2]}),
   .edge_tag_out({wire_edge_tag_out[6][1], wire_edge_tag_out[6][0]}),
   .out({wire_out[6][1], wire_out[6][0]})
);


endmodule