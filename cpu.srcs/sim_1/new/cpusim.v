`timescale 1ns / 1ps

module simcpu(
    );
    
    reg clk, rst;
    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;
    end

    always begin
        #5 clk = ~clk;
        if ($time >= 1000) $stop;
    end
    
    top top(
        .clk(clk),
        .rst(rst)
    );
endmodule