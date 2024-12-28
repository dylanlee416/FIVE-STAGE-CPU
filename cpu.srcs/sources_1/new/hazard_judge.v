`timescale 1ns / 1ps
`include "define.v"

module hazard_judge(
    input wire clk, ld_HJin,  
    input wire [4:0] rd_HJin, rs1_HJin, rs2_HJin,
    input wire [6:0] opcode_HJin,

    output reg stall_HJout
);

    always @(negedge clk) begin
        if (ld_HJin !== 1'bx && ld_HJin == 1'b1) begin
            case (opcode_HJin)
                `IMM_TYPE: begin
                    stall_HJout <= rd_HJin == rs1_HJin ? 1'b1 : 1'b0;
                end
                `STORE_TYPE: begin
                    stall_HJout <= rd_HJin == rs1_HJin ? 1'b1 : 1'b0;
                end
                `BRANCH_TYPE: begin
                    stall_HJout <= rd_HJin == rs1_HJin ? 1'b1 : rd_HJin == rs2_HJin ? 1'b1 : 1'b0;
                end
                `LOGICAL_TYPE: begin
                    stall_HJout <= rd_HJin == rs1_HJin ? 1'b1 : rd_HJin == rs2_HJin ? 1'b1 : 1'b0;
                end
                default: stall_HJout <= 1'b0;
            endcase
        end
        else begin
            stall_HJout <= 1'b0;
        end
    end

endmodule
