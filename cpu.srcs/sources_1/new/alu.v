`timescale 1ns / 1ps
`include "define.v"

module alu (
    input wire [9:0] alu_op, 
    input wire [31:0] dataIn1, dataIn2,
    
    output reg [31:0] alu_result
);

    always @(*) begin
        case(alu_op)
            `AND: alu_result <= dataIn1 & dataIn2;
            `OR:  alu_result <= dataIn1 | dataIn2;
            `XOR: alu_result <= dataIn1 ^ dataIn2;
            `SLL: alu_result <= dataIn1 << dataIn2;
            `SRA: alu_result <= dataIn1 >>> 1;
            `SRL: alu_result <= dataIn1 >> 1;

            `ADD: alu_result <= dataIn1 + dataIn2;
            `SUB: alu_result <= dataIn1 - dataIn2;
            default: alu_result <= 32'b0;
        endcase
    end
endmodule
