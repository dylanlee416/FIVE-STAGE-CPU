`timescale 1ns / 1ps
`include "define.v"

module cu(
    input wire [31:0] ins_CUin,

    output reg beq_CUout, bne_CUout, blt_CUout, bge_CUout,  bltu_CUout,
    output reg ld_CUout, st_CUout, we_CUout, 
    output reg alu_sel_CUout, reg_sel_CUout,
    output reg [2:0] mem_size_CUout,
    output reg [9:0] alu_op_CUout
);

    wire [2:0] funct3_CU;
    wire [6:0] opcode_CU;

    assign opcode_CU = ins_CUin[6:0];
    assign funct3_CU = ins_CUin[14:12];

    always @(*) begin      
        case (opcode_CU)
            `LOGICAL_TYPE: begin
                beq_CUout <= 1'b0;
                bne_CUout <= 1'b0; 
                blt_CUout <= 1'b0; 
                bge_CUout <= 1'b0; 
                bltu_CUout <= 1'b0;
                
                alu_sel_CUout <= 1'b1;
                reg_sel_CUout <= 1'b1;
                we_CUout <= 1'b1;
                ld_CUout <= 1'b0;
                st_CUout <= 1'b0;

                mem_size_CUout <= `ONE_WORD;
                alu_op_CUout <= {ins_CUin[31:25], ins_CUin[14:12]};
            end
            `LOAD_TYPE: begin
                beq_CUout <= 1'b0;
                bne_CUout <= 1'b0; 
                blt_CUout <= 1'b0; 
                bge_CUout <= 1'b0; 
                bltu_CUout <= 1'b0;

                alu_sel_CUout <= 1'b0;
                reg_sel_CUout <= 1'b0;
                
                we_CUout <= 1'b0;
                ld_CUout <= 1'b1;
                st_CUout <= 1'b0;
                alu_op_CUout <= `ADD;
                case (funct3_CU)
                    `LB: begin
                        mem_size_CUout <= `ONE_BYTE;
                    end
                    `LH: begin
                        mem_size_CUout <= `HALF_WORD;
                    end
                    `LW: begin
                        mem_size_CUout <= `ONE_WORD;
                    end
                endcase
            end
            `STORE_TYPE: begin
                beq_CUout <= 1'b0;
                bne_CUout <= 1'b0; 
                blt_CUout <= 1'b0; 
                bge_CUout <= 1'b0; 
                bltu_CUout <= 1'b0;

                alu_sel_CUout <= 1'b0;
                reg_sel_CUout <= 1'b0;
                
                we_CUout <= 1'b0;
                ld_CUout <= 1'b0;
                st_CUout <= 1'b1;
                alu_op_CUout <= `ADD;  
                case (funct3_CU)
                    `SB: begin
                        mem_size_CUout <= `ONE_BYTE;
                    end
                    `SH: begin
                        mem_size_CUout <= `HALF_WORD;
                    end
                    `SW: begin
                        mem_size_CUout <= `ONE_WORD;
                    end
                endcase       
            end
            `BRANCH_TYPE: begin
                case (funct3_CU)
                    `BEQ: begin
                        beq_CUout <= 1'b1;
                        bne_CUout <= 1'b0; 
                        blt_CUout <= 1'b0; 
                        bge_CUout <= 1'b0; 
                        bltu_CUout <= 1'b0;
                    end
                    `BNE: begin
                        beq_CUout <= 1'b0;
                        bne_CUout <= 1'b1; 
                        blt_CUout <= 1'b0; 
                        bge_CUout <= 1'b0;  
                        bltu_CUout <= 1'b0;               
                    end
                    `BLT: begin
                        beq_CUout <= 1'b0;
                        bne_CUout <= 1'b0; 
                        blt_CUout <= 1'b1; 
                        bge_CUout <= 1'b0; 
                        bltu_CUout <= 1'b0;
                    end
                    `BGE: begin
                        beq_CUout <= 1'b0;
                        bne_CUout <= 1'b0; 
                        blt_CUout <= 1'b0; 
                        bge_CUout <= 1'b1; 
                        bltu_CUout <= 1'b0;
                    end
                    `BLTU: begin
                        beq_CUout <= 1'b0;
                        bne_CUout <= 1'b0; 
                        blt_CUout <= 1'b0; 
                        bge_CUout <= 1'b0; 
                        bltu_CUout <= 1'b1;
                    end
                endcase

                alu_sel_CUout <= 1'b1;
                reg_sel_CUout <= 1'b0;
                
                mem_size_CUout <= `ONE_WORD;
                we_CUout <= 1'b0;
                ld_CUout <= 1'b0;
                st_CUout <= 1'b0;
                alu_op_CUout <= `SUB;
            end
            `IMM_TYPE: begin
                beq_CUout <= 1'b0;
                bne_CUout <= 1'b0; 
                blt_CUout <= 1'b0; 
                bge_CUout <= 1'b0; 
                bltu_CUout <= 1'b0;

                alu_sel_CUout <= 1'b0;
                reg_sel_CUout <= 1'b1;
                
                mem_size_CUout <= `ONE_WORD;
                we_CUout <= 1'b1;
                ld_CUout <= 1'b0;
                st_CUout <= 1'b0;
                case (funct3_CU)
                    `ADDI: begin
                        alu_op_CUout <= `ADD;
                    end
                    `ANDI: begin
                        alu_op_CUout <= `AND;
                    end
                    `XORI: begin
                        alu_op_CUout <= `XOR;
                    end
                    `ORI: begin
                        alu_op_CUout <= `OR;
                    end
                endcase   
            end
            `JUMP_TYPE: begin
                
            end
        endcase
    end
endmodule
