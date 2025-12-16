`timescale 1ns/1ps

module sw_pwm(input wire clk, input wire [15:0] sw, output wire [15:0] led);
    parameter HALF_PERIOD = 27'd50_000_000;
    parameter MAX_COUNT = 27'd99_999_999;

    reg [26:0] sec_counter =  27'd0;
    reg [26:0] on_time     = HALF_PERIOD;

    always @(posedge clk) begin
        if (sec_counter == MAX_COUNT)
            sec_counter <= 0;
        else
            sec_counter <= sec_counter + 1;
    end

    wire [15:0] p = {16{sec_counter < on_time}};
    assign led = p & sw;
endmodule
