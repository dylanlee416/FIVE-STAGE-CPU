`timescale 1ns / 1ps
`include "define.v"

module two_bit_predictor(
    input wire clk, is_taken_TBSCin, jmp_signal_TBSCin,
    input wire [31:0] pc_TBSCin, correct_pc_target_TBSCin, pc_branch_TBSCin,

    output reg [31:0] pc_prediction_TBSCout
);

    reg [1:0] state_table [0:63];  
    reg [31:0] target_table [0:63];
    
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            state_table[i] <= `STRONG_NOT_TAKEN; 
            target_table[i] <= 32'b0;
        end
    end

    always @(posedge clk) begin
        if (jmp_signal_TBSCin !== 1'bx && jmp_signal_TBSCin == 1'b1) begin
            if (is_taken_TBSCin) begin
                if (state_table[pc_branch_TBSCin[7:2]] != `STRONG_TAKEN)
                    state_table[pc_branch_TBSCin[7:2]] <= state_table[pc_branch_TBSCin[7:2]] + 1;
                target_table[pc_branch_TBSCin[7:2]] <= correct_pc_target_TBSCin;
            end else begin
                if (state_table[pc_branch_TBSCin[7:2]] != `STRONG_NOT_TAKEN)
                    state_table[pc_branch_TBSCin[7:2]] <= state_table[pc_branch_TBSCin[7:2]] - 1;
            end
        end
    end

    always @(negedge clk) begin
        if (state_table[pc_TBSCin[7:2]] >= `WEAK_TAKEN) begin 
            pc_prediction_TBSCout <= target_table[pc_TBSCin[7:2]];
        end
        else begin
            pc_prediction_TBSCout <= pc_TBSCin + 4;
        end
    end
endmodule
