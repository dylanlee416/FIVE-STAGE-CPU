`timescale 1ns / 1ps
`include "define.v"

module sign_extend_imm (
    input wire [11:0] imm,         
      
    output reg [31:0] sign_extend_imm
);

    always @(*) begin
        sign_extend_imm <= {{20{imm[11]}}, imm};
    end
endmodule
