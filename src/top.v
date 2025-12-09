`timescale 1ns/1ps

module top(
    input  wire clk,
    output wire [7:0] led
);
    reg [25:0] counter = 0;

    always @(posedge clk)
        counter <= counter + 1;

    assign led = counter[25:10];
endmodule
