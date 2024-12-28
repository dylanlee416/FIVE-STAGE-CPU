`timescale 1ns / 1ps
`include "define.v"

module mux(
    input wire select,
    input wire [31:0] src1, src2,
    
    output reg [31:0] outsrc
);

    always @(*) begin
        outsrc <= select == 0 ? src1 : src2;
    end 
endmodule
