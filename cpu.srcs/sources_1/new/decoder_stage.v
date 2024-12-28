`timescale 1ns / 1ps
`include "define.v"

module decoder_stage (
    input wire clk, stall_IDin, flush_pipeline_IDin, alu_operating_IDin,    
    input wire [31:0] pc_IDin, ins_IDin, 

    output reg [4:0] rs1_IDout, rs2_IDout, rd_IDout,
    output reg [31:0] imm_IDout, pc_IDout, ins_IDout,
    output reg [6:0] opcode_IDout
);

    reg [31:0] ins_ID;
    wire [6:0] opcode_ID;
    assign opcode_ID = ins_ID[6:0];

    always @(*) begin
        rd_IDout  <= ins_ID[11:7];  
        rs1_IDout <= ins_ID[19:15]; 
        rs2_IDout <= ins_ID[24:20];
    end

    always @(posedge clk) begin
        if (stall_IDin == 1'b1 || alu_operating_IDin == 1'b1) begin
            // do nothing for stall or alu operating
        end
        else if (flush_pipeline_IDin !== 1'bx && flush_pipeline_IDin == 1'b1) begin
            ins_ID <= `NOP;
            ins_IDout <= `NOP;

            opcode_IDout <= `NOP_TYPE;
            pc_IDout <= `NOP_PC;
        end
        else begin
            opcode_IDout <= ins_IDin[6:0];
            pc_IDout <= pc_IDin;

            ins_ID <= ins_IDin;
            ins_IDout <= ins_IDin;
        end
    end

    wire [31:0] data_to_extend_imm_ID, sign_extended_data_imm_ID;
    wire [31:0] data_to_extend_load_ID, sign_extended_data_load_ID;
    wire [31:0] data_to_extend_store_ID, sign_extended_data_store_ID;
    wire [31:0] data_to_extend_branch_ID, sign_extended_data_branch_ID;

    assign data_to_extend_imm_ID = ins_ID[31:20];
    assign data_to_extend_load_ID = ins_ID[31:20];    
    assign data_to_extend_store_ID = {ins_ID[31:25], ins_ID[11:7]};   
    assign data_to_extend_branch_ID = {ins_ID[31], ins_ID[7], ins_ID[30:25], ins_ID[11:8]};

    sign_extend_imm SIGN_EXT_IMM (
        .imm(data_to_extend_imm_ID),
        .sign_extend_imm(sign_extended_data_imm_ID)
    );

    sign_extend_imm SIGN_EXT_LOAD (
        .imm(data_to_extend_load_ID),
        .sign_extend_imm(sign_extended_data_load_ID)
    );

    sign_extend_imm SIGN_EXT_STORE (
        .imm(data_to_extend_store_ID),
        .sign_extend_imm(sign_extended_data_store_ID)
    );
    
    sign_extend_offset SIGN_EXT_BRANCH (
        .offset(data_to_extend_branch_ID << 1),
        .sign_extend_offset(sign_extended_data_branch_ID)
    );

    always @(negedge clk) begin
        case (opcode_ID)
            `LOAD_TYPE: begin
                imm_IDout <= sign_extended_data_load_ID;
            end
            `STORE_TYPE: begin
                imm_IDout <= sign_extended_data_store_ID;  
            end
            `BRANCH_TYPE: begin
                imm_IDout <= sign_extended_data_branch_ID;  
            end
            `IMM_TYPE: begin
                imm_IDout <= sign_extended_data_imm_ID;
            end
            default: imm_IDout <= 32'b0;  
        endcase
    end

endmodule
