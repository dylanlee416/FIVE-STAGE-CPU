`timescale 1ns / 1ps
`include "define.v"

// --------------------------- simple simulation segment --------------------------------- // 
module top (
   input wire clk,
   input wire rst,
   output wire [31:0] PC_DISPLAY, 
   output wire [31:0] DATA_DISPLAY
);

// --------------------------- simple simulation segment --------------------------------- //

// --------------------------- on board segment --------------------------------- // 
//  module top (
//     input wire btn_raw,     // 原始按钮信号
//     input wire clk_100M, rst,
//     output [6:0] a_to_g_0, a_to_g_1,
//     output [7:0] an,
//     output [15:0]led_pin
//  );

//     reg [15:0] counter;      // 计数�?????
//     reg btn_last;            // 上一个按钮状�?????
//     parameter MAX_COUNT = 16'd50000; // 根据时钟频率设置计数值，调整时间
//     reg clk;
    
//     always @(posedge clk_100M) begin
//          // �?????测按钮状态变�?????
//         if (btn_raw != btn_last) begin
//             counter <= 0; // 状�?�变化时重置计数�?????
//         end else if (counter < MAX_COUNT) begin
//             counter <= counter + 1; // 状�?�稳定时增加计数�?????
//         end

//         // 如果计数器达到最大�?�，更新稳定信号
//         if (counter == MAX_COUNT) begin
//             clk <= btn_raw; // 确认按钮状�?�作为clk
//         end

//         btn_last <= btn_raw; // 更新上一个状�?????
//     end

//     wire [31:0] PC_DISPLAY;
//     wire [31:0] DATA_DISPLAY;
//     x7seg_top_ego1 X7SEG_TOP_EGO1(
//         .clk(clk_100M), //
//         .clr(rst),
//         .pc(PC_DISPLAY[15:0]),
//         .data(DATA_DISPLAY[15:0]),
//         .a_to_g_0(a_to_g_0),
//         .a_to_g_1(a_to_g_1),
//         .an(an)
//     );
//     led LED(
//         .clk(clk),
//         .stall_LEDin(stall_HJout),
//         .flush_pipeline_LEDin(flush_pipeline_EXEout),
//         .alu_operating_LEDin(alu_operating_EXEout),
//         .opcode_LEDin(opcode_DISPLAY),
//         .LED_pin(led_pin)
//     );  

// --------------------------- on board segment --------------------------------- //

    wire stall_HJout, flush_pipeline_EXEout, alu_operating_EXEout;
    wire [31:0] pc_IFout, pc_prediction_TBSCout, branch_target_EXEout;    

    pc PC (
        .clk(clk),
        .rst(rst),
        .stall_PCin(stall_HJout),
        .alu_operating_PCin(alu_operating_EXEout),
        .pc_prediction_PCin(pc_prediction_TBSCout),
        .is_branch_ins_PCin(ins_INSMEMout[6:0] == `BRANCH_TYPE),
        
        .branch_target_PCin(branch_target_EXEout),
        .flush_pipeline_PCin(flush_pipeline_EXEout),

        .pc_IFout(pc_IFout)
    );

    wire [31:0] ins_INSMEMout;
    insMem INSMEM (
        .pc_INSMEMin(pc_IFout),

        // output
        .ins_INSMEMout(ins_INSMEMout)
    );

    wire jmp_signal_EXEout, branch_taken_EXEout;
    two_bit_predictor TWO_BIT_PREDICTOR (
        .clk(clk),
        .pc_TBSCin(pc_IFout),
        .pc_branch_TBSCin(pc_EXEout),
        .is_taken_TBSCin(branch_taken_EXEout),
        .jmp_signal_TBSCin(jmp_signal_EXEout),
        .correct_pc_target_TBSCin(branch_target_EXEout),

        .pc_prediction_TBSCout(pc_prediction_TBSCout)
    );

    wire [31:0] pc_IDout, imm_IDout, data_WBout, ins_IDout;
    wire [4:0] rs1_IDout, rs2_IDout, rd_IDout, rd_WBout, rd_forward;
    wire [6:0] opcode_IDout;

    decoder_stage ID (
        .clk(clk),
        .pc_IDin(pc_IFout),          
        .stall_IDin(stall_HJout),       
        .ins_IDin(ins_INSMEMout),   
        .alu_operating_IDin(alu_operating_EXEout),
        .flush_pipeline_IDin(flush_pipeline_EXEout),   

        // output  
        .pc_IDout(pc_IDout),
        .imm_IDout(imm_IDout), 

        .rd_IDout(rd_IDout),      
        .rs1_IDout(rs1_IDout),
        .rs2_IDout(rs2_IDout),
        .ins_IDout(ins_IDout),
        .opcode_IDout(opcode_IDout) 
    );

    hazard_judge HAZARD_JUDGE (    
        .clk(clk),
        .ld_HJin(ld_EXEout),
        .rd_HJin(rd_EXEout),
        .rs1_HJin(rs1_IDout),
        .rs2_HJin(rs2_IDout),
        .opcode_HJin(opcode_IDout),

        // output
        .stall_HJout(stall_HJout)
    );    

    wire [9:0] alu_op_CUout; 
    wire [2:0] mem_size_CUout;   
    wire beq_CUout, bne_CUout, blt_CUout, bge_CUout, bltu_CUout, ld_CUout, st_CUout, we_CUout;
    wire alu_sel_CUout, reg_sel_CUout, we_WBout_CUout;

    cu CU (
        .ins_CUin(ins_IDout),

        .we_CUout(we_CUout),            
        .ld_CUout(ld_CUout),          
        .st_CUout(st_CUout), 
        .beq_CUout(beq_CUout),           
        .bne_CUout(bne_CUout), 
        .blt_CUout(blt_CUout),
        .bge_CUout(bge_CUout),    
        .bltu_CUout(bltu_CUout),    
        .alu_op_CUout(alu_op_CUout),           
        .alu_sel_CUout(alu_sel_CUout),      
        .reg_sel_CUout(reg_sel_CUout),      
        .mem_size_CUout(mem_size_CUout)
    );


    wire [31:0] rs1_data_REGSout, rs2_data_REGSout, data_RAMout;
    regbank REGS (
        // input
        .clk(clk),
        .rs1_REGSin(rs1_IDout),
        .rs2_REGSin(rs2_IDout),
        
        .we_REGSin(we_WBout),
        .rd_REGSin(rd_WBout),
        .data_REGSin(data_WBout),

        // output
        .rs1_data_REGSout(rs1_data_REGSout),
        .rs2_data_REGSout(rs2_data_REGSout)
    ); 

    wire [31:0] rs1_data_DFout, rs2_data_DFout;
    data_foward DATA_FOWARD (
        // input
        .clk(clk),
        .rs1_DFin(rs1_IDout),
        .rs2_DFin(rs2_IDout),        
        .rs1_data_DFin(rs1_data_REGSout),
        .rs2_data_DFin(rs2_data_REGSout),
        
        .ld_MEMout_DFin(ld_MEMout),
        .we_MEMout_DFin(we_MEMout),
        .rd_MEMout_DFin(rd_MEMout),
        .data_RAMout_DFin(data_RAMout),
        .data_MEMout_DFin(alu_result_MEMout),
        
        .we_EXEout_DFin(we_EXEout),
        .rd_EXEout_DFin(rd_EXEout),
        .data_EXEout_DFin(alu_result_EXEout),

        // output
        .rs1_data_DFout(rs1_data_DFout),
        .rs2_data_DFout(rs2_data_DFout)
    ); 

    wire [6:0] opcode_DISPLAY;

    wire [4:0] rd_EXEout;    
    wire [2:0] mem_size_EXEout;
    wire [31:0] alu_result_EXEout, store_data_EXEout, pc_EXEout; 
    wire ld_EXEout, st_EXEout, we_EXEout, reg_sel_EXEout;

    execute_stage EXE (    
        .clk(clk),        
        .stall_EXEin(stall_HJout), 
        .pc_prediction_EXEin(pc_IFout),
        .opcode_EXEin(opcode_IDout),

        .pc_EXEin(pc_IDout),
        .rd_EXEin(rd_IDout),  
        .imm_EXEin(imm_IDout),

        .ld_EXEin(ld_CUout),  
        .st_EXEin(st_CUout),  
        .we_EXEin(we_CUout),  
        .beq_EXEin(beq_CUout),  
        .bne_EXEin(bne_CUout),  
        .blt_EXEin(blt_CUout),  
        .bge_EXEin(bge_CUout),  
        .bltu_EXEin(bltu_CUout),  
        .alu_op_EXEin(alu_op_CUout),  
        .alu_sel_EXEin(alu_sel_CUout),  
        .reg_sel_EXEin(reg_sel_CUout),  
        .mem_size_EXEin(mem_size_CUout),  
        .rs1_data_EXEin(rs1_data_DFout),
        .rs2_data_EXEin(rs2_data_DFout),

        .pc_EXEout(pc_EXEout),
        .rd_EXEout(rd_EXEout),
        .we_EXEout(we_EXEout),
        .ld_EXEout(ld_EXEout),
        .st_EXEout(st_EXEout),
        .reg_sel_EXEout(reg_sel_EXEout),
        .mem_size_EXEout(mem_size_EXEout),
        .jmp_signal_EXEout(jmp_signal_EXEout),
        .store_data_EXEout(store_data_EXEout),
        .alu_result_EXEout(alu_result_EXEout),
        .branch_taken_EXEout(branch_taken_EXEout),
        .alu_operating_EXEout(alu_operating_EXEout),
        .branch_target_EXEout(branch_target_EXEout),
        .flush_pipeline_EXEout(flush_pipeline_EXEout),
        .DATA_DISPLAY(DATA_DISPLAY),
        .PC_DISPLAY(PC_DISPLAY),
        .opcode_EXEout(opcode_DISPLAY)
    );


    wire [4:0] rd_MEMout;
    wire [2:0] mem_size_MEMout;
    wire [31:0] alu_result_MEMout, store_data_MEMout;
    wire ld_MEMout, st_MEMout, we_MEMout, reg_sel_MEMout;
    

    mem_stage MEM ( 
        .clk(clk),
        .ld_MEMin(ld_EXEout),
        .we_MEMin(we_EXEout),
        .st_MEMin(st_EXEout),
        .rd_MEMin(rd_EXEout),
        .data_MEMin(store_data_EXEout),
        .alu_result_MEMin(alu_result_EXEout),
        .reg_sel_MEMin(reg_sel_EXEout),
        .mem_size_MEMin(mem_size_EXEout),
        
        .rd_MEMout(rd_MEMout),
        .we_MEMout(we_MEMout),
        .ld_MEMout(ld_MEMout),
        .st_MEMout(st_MEMout),
        .reg_sel_MEMout(reg_sel_MEMout),
        .mem_size_MEMout(mem_size_MEMout),
        .store_data_MEMout(store_data_MEMout),
        .alu_result_MEMout(alu_result_MEMout)
    );
    
    dataMem RAM (
        .clk(clk),
        .ld_RAMin(ld_MEMout),
        .st_RAMin(st_MEMout),
        .data_RAMin(store_data_MEMout),
        .address_RAMin(alu_result_MEMout),
        .mem_size_RAMin(mem_size_MEMout), 
     
        .data_RAMout(data_RAMout)
    );

    write_back_stage WB (
        .clk(clk),
        .rd_WBin(rd_MEMout),
        .we_WBin(we_MEMout),
        .dataIn_WBin(data_RAMout),
        .reg_sel_WBin(reg_sel_MEMout),
        .alu_result_WBin(alu_result_MEMout),

        .rd_WBout(rd_WBout),
        .we_WBout(we_WBout),
        .data_WBout(data_WBout)
    );

endmodule
