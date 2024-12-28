`timescale 1ns / 1ps
`include "define.v"

module led(
    input wire clk,
    input wire stall_LEDin,
    input wire flush_pipeline_LEDin,
    input wire alu_operating_LEDin,
    input wire[6:0] opcode_LEDin,

    output reg[15:0] LED_pin
    );

    reg[3:0] nop_pin;
    reg[2:0] flag_pin;
    reg[7:0] opcode_pin;
    initial begin
      flag_pin = 3'b000;
      nop_pin = 4'b0000;
      LED_pin = 16'h0000;
      opcode_pin = 8'b0000_0000;
    end

    //处理�??要点亮的led
    always @(negedge clk) begin
        flag_pin<={flush_pipeline_LEDin,stall_LEDin,alu_operating_LEDin};
        opcode_pin <= (opcode_LEDin == `NOP_TYPE)?8'b1000_0000:
                      (opcode_LEDin == `LOGICAL_TYPE)?8'b0000_0001:
                      (opcode_LEDin == `IMM_TYPE)?8'b0000_0010:
                      (opcode_LEDin == `LOAD_TYPE)?8'b0000_0100:
                      (opcode_LEDin == `STORE_TYPE)?8'b0000_1000:
                      (opcode_LEDin == `BRANCH_TYPE)?8'b0001_0000:
                      (opcode_LEDin == `JUMP_TYPE)?8'b0010_0000:
                      8'b0000_0000;
        //如果出现load�??要加空泡
        if(stall_LEDin !== 1'bx && stall_LEDin == 1'b1) begin
            nop_pin <= (nop_pin>>1)|4'b0100;
        end
        //如果分支预测失败，需要冲刷流水线
        else if (flush_pipeline_LEDin !== 1'bx && flush_pipeline_LEDin == 1'b1) begin
            nop_pin <= (nop_pin>>1)|4'b1100;
        end
        else if(alu_operating_LEDin !== 1'bx && alu_operating_LEDin == 1'b1 )begin
            nop_pin <= {nop_pin[3:2],{nop_pin[1:0]>>1}};
        end
        else begin
            nop_pin <= nop_pin>>1;
        end 
    end
    
    //点亮led
    always @(*)begin
        LED_pin <= {flag_pin,1'b0,nop_pin,opcode_pin};
    end
endmodule
