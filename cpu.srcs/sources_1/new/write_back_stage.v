`timescale 1ns / 1ps
`include "define.v"

module write_back_stage (
    input wire clk, we_WBin, reg_sel_WBin,
    input wire [4:0] rd_WBin,
    input wire [31:0] dataIn_WBin, alu_result_WBin,

    output reg we_WBout, 
    output reg [4:0] rd_WBout,
    output reg [31:0] data_WBout
);

    always @(posedge clk) begin
        we_WBout <= we_WBin;
        rd_WBout <= rd_WBin;
        data_WBout <= data_WB;
    end

    wire [31:0] data_WB;
    mux WB_MUX(
        .src1(dataIn_WBin),
        .src2(alu_result_WBin),
        .select(reg_sel_WBin),
        .outsrc(data_WB)
    );
    

endmodule
