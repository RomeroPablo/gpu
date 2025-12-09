`timescale 1ns/1ps

module top_tb;
    reg clk = 0;
    wire [7:0] led;

    // generate clock (100 MHz)
    always #5 clk = ~clk;  // 10 ns period

    // instantiate DUT (Design Under Test)
    top dut (
        .clk(clk),
        .led(led)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);

        // run for some time
        #100000;
        $finish;
    end
endmodule
