`timescale 1ns / 1ps
`include "define.v"

module SignedDivider (
    input wire clk,                                     // 时钟信号
    input wire [9:0] opcode_DIVin,                      // 操作码
    input wire [31:0] dividend_DIVin,                   // 被除数（补码）
    input wire [31:0] divisor_DIVin,                    // 除数（补码）
    
    output reg [31:0] quotient_SIGNEDDIVIDERout,        // 商（补码）
    output reg done_signal_SIGNEDDIVIDERout             // 完成信号
);

    // 内部寄存器
    reg sign;                                           // 结果符号位
    reg [5:0] count;                                    // 计数器，用于记录位移次数
    reg [31:0] temp_remainder;
    reg [31:0] temp_quotient;
    reg [31:0] abs_dividend, abs_divisor;

    reg operating;
    initial begin
        operating <= 1'b0;
    end

    // 计算绝对值函数
    function [31:0] abs;
        input [31:0] value;
        abs = value[31] ? (~value + 1) : value;
    endfunction

    always@(posedge clk)begin
        if (!operating) begin
            if (opcode_DIVin == `DIV) begin
                // 初始化操作数
                abs_dividend = abs(dividend_DIVin);
                abs_divisor = abs(divisor_DIVin);
                
                temp_remainder = abs_dividend[31];
                // 移位操作
                if (temp_remainder >= abs_divisor) begin
                    temp_remainder = temp_remainder - abs_divisor;
                    temp_quotient = (temp_quotient << 1) | 1'b1;
                end 
                else begin
                    temp_quotient = (temp_quotient << 1);
                end   

                count <= 30;

                sign <= dividend_DIVin[31] ^ divisor_DIVin[31];     // 结果符号
                operating<=1'b1;
                done_signal_SIGNEDDIVIDERout <= 1'b0;
            end
            else begin
                done_signal_SIGNEDDIVIDERout <= 1'b1;
                quotient_SIGNEDDIVIDERout <= 0;
            end
        end
        else begin
            temp_remainder = (temp_remainder << 1) | abs_dividend[count];
            // 移位操作
            if (temp_remainder >= abs_divisor) begin
                temp_remainder = temp_remainder - abs_divisor;
                temp_quotient = (temp_quotient << 1) | 1'b1;
            end 
            else begin
                temp_quotient = (temp_quotient << 1);
            end

            if (count == 0) begin
                // 处理结果符号
                quotient_SIGNEDDIVIDERout = sign ? (~temp_quotient + 1) : temp_quotient;
                // 输出完成信号，停止乘法器运行
                done_signal_SIGNEDDIVIDERout = 1'b1;
                operating = 1'b0;  
            end
            else count = count - 1;
        end
    end

endmodule
