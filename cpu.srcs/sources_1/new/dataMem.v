`timescale 1ns / 1ps
`include "define.v"

module dataMem (
    input wire clk,
    input wire ld_RAMin, st_RAMin,
    input wire [2:0] mem_size_RAMin,
    input wire [31:0] address_RAMin, data_RAMin,

    output reg [31:0] data_RAMout
);

    reg [7:0] ram [63:0]; 

    initial begin
        $readmemb("./data_file.dat", ram);  
    end

    reg [31:0] data_RAM;
    wire [31:0] sign_extend_data_RAM;
    always @(*) begin  
        if (ld_RAMin !== 1'bx && ld_RAMin == 1'b1) begin
            case (mem_size_RAMin)
                `ONE_BYTE: begin 
                    data_RAM <= {24'b0, 
                                ram[address_RAMin]};   
                end
                `HALF_WORD: begin 
                    data_RAM <= {16'b0, 
                                ram[address_RAMin],      ram[address_RAMin + 1]};   
                end
                `ONE_WORD: begin 
                    data_RAM <= {ram[address_RAMin],      ram[address_RAMin + 1], 
                                 ram[address_RAMin + 2],  ram[address_RAMin + 3]};  
                end 
                default: begin
                end
            endcase   
        end
    end

    sign_extend SIGN_EXT_DATA (
        .data_size(mem_size_RAMin), 
        .dataIn(data_RAM),
        .sign_extend_data(sign_extend_data_RAM)
    );

    always @(negedge clk) begin
        if (st_RAMin !== 1'bx && st_RAMin == 1'b1) begin
            case (mem_size_RAMin)
                `ONE_BYTE: begin 
                    ram[address_RAMin]        <= data_RAMin[7:0];  
                end
                `HALF_WORD: begin 
                    ram[address_RAMin]        <= data_RAMin[15:8];    
                    ram[address_RAMin + 1]    <= data_RAMin[7:0]; 
                end
                `ONE_WORD: begin 
                    ram[address_RAMin]        <= data_RAMin[31:24];
                    ram[address_RAMin + 1]    <= data_RAMin[23:16];
                    ram[address_RAMin + 2]    <= data_RAMin[15:8];
                    ram[address_RAMin + 3]    <= data_RAMin[7:0];
                end 
                default: begin
                end
            endcase
        end
    end

    always @(*) begin  
        data_RAMout <= data_RAM;
    end

endmodule
