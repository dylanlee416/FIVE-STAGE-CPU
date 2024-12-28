`timescale 1ns / 1ps
`include "define.v"

module complement (
    input wire [31:0] in_COMPLEMENTin,

    output reg [31:0] out_COMPLEMENTout
);

    always@(*) begin
        if (in_COMPLEMENTin[31] == 1'b1)
            out_COMPLEMENTout <= ~in_COMPLEMENTin + 1;
        else
            out_COMPLEMENTout <= in_COMPLEMENTin;
    end

endmodule