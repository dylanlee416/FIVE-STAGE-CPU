`timescale 1ns / 1ps

module x7seg_top_ego1(
  input wire clk, clr,
  input wire [15:0] pc, data,

  output [6:0] a_to_g_0, a_to_g_1,
  output [7:0] an
);

  x7seg X1(
    .x(data),
    .clk_100M(clk),
    .clr(clr),
    .a_to_g(a_to_g_0),
    .an(an[3:0])
    );

  x7seg X2(
    .x(pc),
    .clk_100M(clk),
    .clr(clr),
    .a_to_g(a_to_g_1),
    .an(an[7:4])
    );
    
endmodule
