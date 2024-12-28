`timescale 1ns / 1ps
`include "define.v"

module mem_stage (
    input wire clk,
    input wire ld_MEMin, st_MEMin, we_MEMin, reg_sel_MEMin,
    input wire [4:0] rd_MEMin,
    input wire [2:0] mem_size_MEMin,
    input wire [31:0] data_MEMin, alu_result_MEMin,

    output reg [4:0] rd_MEMout, 
    output reg [2:0] mem_size_MEMout,
    output reg ld_MEMout, st_MEMout, we_MEMout, reg_sel_MEMout, 
    output reg [31:0] store_data_MEMout, alu_result_MEMout
);

    always @(posedge clk) begin
        rd_MEMout <= rd_MEMin;
        ld_MEMout <= ld_MEMin;
        st_MEMout <= st_MEMin;
        we_MEMout <= (we_MEMin | ld_MEMin);
        store_data_MEMout <= data_MEMin;
        reg_sel_MEMout <= reg_sel_MEMin;
        mem_size_MEMout <= mem_size_MEMin;
        alu_result_MEMout <= alu_result_MEMin;
    end

endmodule
