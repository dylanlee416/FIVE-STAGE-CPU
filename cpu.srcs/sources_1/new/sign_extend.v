`timescale 1ns / 1ps
`include "define.v"

module sign_extend (
    input wire [31:0] dataIn,      
    input wire [2:0] data_size,   
      
    output reg [31:0] sign_extend_data  
);

    always @(*) begin
        case (data_size)
            `ONE_BYTE:  sign_extend_data <= {{24{dataIn[7]}}, dataIn[7:0]};  
            `HALF_WORD: sign_extend_data <= {{16{dataIn[15]}}, dataIn[15:0]}; 
            `ONE_WORD:  sign_extend_data <= dataIn;                             
            default: sign_extend_data <= 32'b0;                            
        endcase
    end
endmodule
