`timescale 1ns / 1ps
`include "define.v"

module insMem(
    input wire [31:0] pc_INSMEMin, 

    output reg [31:0] ins_INSMEMout 
);

    reg [7:0] rom [127:0];

    initial begin
        $readmemb("./ins_file.dat", rom);
    end

    always @(*) begin
        ins_INSMEMout <= {rom[pc_INSMEMin], rom[pc_INSMEMin+1], rom[pc_INSMEMin+2], rom[pc_INSMEMin+3]};
    end
endmodule
