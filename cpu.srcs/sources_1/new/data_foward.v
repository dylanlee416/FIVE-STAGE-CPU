`timescale 1ns / 1ps
`include "define.v"

module data_foward (
    input wire clk, we_EXEout_DFin, ld_MEMout_DFin, we_MEMout_DFin,                
    input wire [4:0] rs1_DFin, rs2_DFin, 
    input wire [4:0] rd_EXEout_DFin, rd_MEMout_DFin,  
    input wire [31:0] data_EXEout_DFin, data_RAMout_DFin, data_MEMout_DFin, rs1_data_DFin, rs2_data_DFin, 

    output reg [31:0] rs1_data_DFout, rs2_data_DFout   
);


    always @(*) begin
        rs1_data_DFout <= (we_EXEout_DFin !== 1'bx) && (we_EXEout_DFin == 1'b1) && (rs1_DFin == rd_EXEout_DFin) ? data_EXEout_DFin :  
                          (ld_MEMout_DFin !== 1'bx) && (ld_MEMout_DFin == 1'b1) && (rs1_DFin == rd_MEMout_DFin) ? data_RAMout_DFin : 
                          (we_MEMout_DFin !== 1'bx) && (we_MEMout_DFin == 1'b1) && (rs1_DFin == rd_MEMout_DFin) ? data_MEMout_DFin : 
                          rs1_data_DFin;

        rs2_data_DFout <= (we_EXEout_DFin !== 1'bx) && (we_EXEout_DFin == 1'b1) && (rs2_DFin == rd_EXEout_DFin) ? data_EXEout_DFin :  
                          (ld_MEMout_DFin !== 1'bx) && (ld_MEMout_DFin == 1'b1) && (rs2_DFin == rd_MEMout_DFin) ? data_RAMout_DFin : 
                          (we_MEMout_DFin !== 1'bx) && (we_MEMout_DFin == 1'b1) && (rs2_DFin == rd_MEMout_DFin) ? data_MEMout_DFin : 
                          rs2_data_DFin;
    end

endmodule