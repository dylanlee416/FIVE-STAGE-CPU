`timescale 1ns / 1ps
`include "define.v"

module sign_extend_offset (
    input wire [12:0] offset,         
      
    output reg [31:0] sign_extend_offset
);

    always @(*) begin
        sign_extend_offset <= {{19{offset[12]}}, offset};
    end
endmodule
