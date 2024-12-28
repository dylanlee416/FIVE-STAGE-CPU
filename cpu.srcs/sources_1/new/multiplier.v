`timescale 1ns / 1ps
`include "define.v"

module multiplier(
    input wire clk,
    input wire [9:0] opcode_MULin,
    input wire [31:0] multiplier_MULin,
    input wire [31:0] multiplicand_MULin,

    output reg done_signal_MULTIPLIERout,
    output reg [31:0] result_MULTIPLIERout
);

    reg [33:0] N;
    reg [4:0] cnt;
    reg [4:0] shift_num;
    reg [63:0] result_MULTIPLIERout_tmp;
    reg [63:0] M, M_nagative, M2, M2_nagative;

    reg operating;
    initial begin
        operating <= 1'b0;
    end
    
    // 处理开始信号的标志
    always@(posedge clk) begin
        if (!operating) begin
            if (opcode_MULin == `MUL) begin
                operating <= 1'b1;
                done_signal_MULTIPLIERout <= 1'b0;
                // 初始化
                result_MULTIPLIERout_tmp <= 64'd0;

                M  <= {{32{multiplicand_MULin[31]}}, multiplicand_MULin};
                M2 <= {{32{multiplicand_MULin[31]}}, multiplicand_MULin << 1};
                M_nagative <= {{32{~multiplicand_MULin[31]}}, ~multiplicand_MULin + 1};
                M2_nagative <= {{32{~multiplicand_MULin[31]}}, (~multiplicand_MULin + 1) << 1};
                
                N <= {multiplier_MULin, 1'b0};
                shift_num <= 5'd0;
                cnt <= 15;
            end
            else begin
                result_MULTIPLIERout <= 32'b0;
                done_signal_MULTIPLIERout <= 1'b1;
            end
        end
        else begin
            // Booth算法的步骤，简化了重复代码
            if (N[2:0] == 3'b001 || N[2:0] == 3'b010)
                result_MULTIPLIERout_tmp <= result_MULTIPLIERout_tmp + (M << shift_num);
            else if (N[2:0] == 3'b011)
                result_MULTIPLIERout_tmp <= result_MULTIPLIERout_tmp + (M2 << shift_num);
            else if (N[2:0] == 3'b100)
                result_MULTIPLIERout_tmp <= result_MULTIPLIERout_tmp + (M2_nagative << shift_num);
            else if (N[2:0] == 3'b101 || N[2:0] == 3'b110)
                result_MULTIPLIERout_tmp <= result_MULTIPLIERout_tmp + (M_nagative << shift_num);
            
            if(cnt == 1) begin
                // 输出完成信号，停止乘法器运行
                result_MULTIPLIERout <= result_MULTIPLIERout_tmp[31:0];
                done_signal_MULTIPLIERout <= 1'b1;
                operating <= 1'b0;
            end
            else begin
                shift_num <= shift_num + 2'd2;
                N <= N >> 2;
                cnt <= cnt - 1'b1;
            end
        end
    end

endmodule
