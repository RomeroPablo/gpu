`timescale 1ns/1ps

module io_pwm(input wire clk, input wire [15:0] sw, output wire [15:0] led);
    reg [26:0] sec_counter =  27'd0;
    reg [26:0] on_time     = `ON_TIME;

    parameter ON_TIME = 27'd50_000_000;

    always @(posedge clk) begin
        if (sec_counter == 27'd99_999_999)
            sec_counter <= 0;
        else
            sec_counter <= sec_counter + 1;
    end

    wire [15:0] temp = {16{sec_counter < on_time}};
    assign led = temp & sw;
endmodule
