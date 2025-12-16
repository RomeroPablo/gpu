`timescale 1ns/1ps

module top( input wire clk, input wire btn, input wire [15:0] sw, output wire [15:0] led,
            output wire [3:0] vgaRed,  output wire [3:0] vgaBlue,  output wire [3:0] vgaGreen,
            output wire Hsync, output wire Vsync);

    wire [11:0] col;
    assign col = 12'b0000_1111_0000;

    sw_pwm(clk, sw, led);
    display(clk, btn, col, vgaRed, vgaBlue, vgaGreen, Hsync, Vsync);

endmodule
