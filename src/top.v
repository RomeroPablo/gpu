`timescale 1ns/1ps

/*
what do we do?
we want to draw lines on the screen
let us define some points
then, we shall programatically create lines between points <- done on the fpga

points described as 1x10 bit width, 1x9 bit height
*/

module top( input wire clk, input wire btn, input wire [15:0] sw, output wire [15:0] led,
            output wire [11:0] outCol, output wire Hsync, output wire Vsync);

    sw_pwm(clk, sw, led);
    display(clk, btn, outCol, Hsync, Vsync);

endmodule
