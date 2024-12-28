`timescale 1ns / 1ps

module x7seg(
  input wire clk_100M,
  input wire clr,
  input wire [15:0] x,
  output reg [6:0] a_to_g,
  output reg [3:0] an
);

  wire [1:0] s;
  reg [3:0] digit;
  reg [20:0] clkdiv;

  always@(posedge clk_100M or posedge clr) begin
    if(clr == 1) begin
      clkdiv <=0;
    end
    else begin
      clkdiv <= clkdiv + 1;
    end
  end

  assign s = clkdiv[20:19];

  always@(*) begin
      an <= 4'b0000;
      an[s] <= 1;
  end

  always@(*) begin
    case(s)
      0: digit <= x[3:0];
      1: digit <= x[7:4];
      2: digit <= x[11:8];
      3: digit <= x[15:12];
      default:;
    endcase
  end

  always@(*) begin
    case(digit)
        0: a_to_g <= 7'b1111110;
        1: a_to_g <= 7'b0110000;
        2: a_to_g <= 7'b1101101;
        3: a_to_g <= 7'b1111001;
        4: a_to_g <= 7'b0110011;
        5: a_to_g <= 7'b1011011;
        6: a_to_g <= 7'b1011111;
        7: a_to_g <= 7'b1110000;
        8: a_to_g <= 7'b1111111;
        9: a_to_g <= 7'b1111011;
      'hA: a_to_g <= 7'b1110111;
      'hB: a_to_g <= 7'b0011111;
      'hC: a_to_g <= 7'b1001110;
      'hD: a_to_g <= 7'b0111101;
      'hE: a_to_g <= 7'b1001111;
      'hF: a_to_g <= 7'b1000111;
      default: ;
    endcase
  end
endmodule