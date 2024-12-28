`timescale 1ns / 1ps
`include "define.v"

module pc(
    input wire clk, rst, stall_PCin, is_branch_ins_PCin, flush_pipeline_PCin, alu_operating_PCin,         
    input wire [31:0] pc_prediction_PCin, branch_target_PCin,     
      
    output reg [31:0] pc_IFout        
);

    reg [31:0] cur_pc;

    always @(posedge clk) begin
        if (rst == 1'b1) begin      
            pc_IFout <= 32'h0;    
            cur_pc <= 32'h4;   
        end 
        else if (flush_pipeline_PCin !== 1'bx && flush_pipeline_PCin == 1'b1) begin
            pc_IFout <= branch_target_PCin; 
            cur_pc <= branch_target_PCin + 4;   
        end
        else if ((stall_PCin !== 1'bx && stall_PCin == 1'b0) && alu_operating_PCin == 1'b0) begin
            if (is_branch_ins_PCin == 1'b1) begin
                pc_IFout <= pc_prediction_PCin; 
                cur_pc <= pc_prediction_PCin + 4;   
            end
            else begin
                pc_IFout <= cur_pc; 
                cur_pc <= cur_pc + 4;  
            end
        end
    end
endmodule
