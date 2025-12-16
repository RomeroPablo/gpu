`timescale 1ns/1ps
module tb_sw_pwm;
    reg clk;
    reg [15:0] sw;
    reg [15:0] led;
    integer i;

    sw_pwm #(.HALF_PERIOD(5), .MAX_COUNT(9)) dut ( clk, sw, led );

    always #1 clk = ~clk;
    initial begin
        clk = 0;
        sw  = 16'h0000;

        for (i = 0; i < 16; i = i + 1) begin
            sw = 16'b1<< i;
            #40;
        end

        $finish;
    end

endmodule
