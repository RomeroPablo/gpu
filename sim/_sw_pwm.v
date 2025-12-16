`timescale 1ns/1ps
// Testbench for sw_pwm
// Dev notes:
//  - Shrink ON_TIME via parameter override so we can see the PWM window in a few cycles.
//  - Keep switches at a static pattern; LED output should mirror that pattern only while
//    sec_counter < ON_TIME, then drop to 0 afterward.
//  - Run a short simulation (20 cycles) and check the expected on/off behavior with
//    simple assertions and $display diagnostics.

module tb_sw_pwm;
    // 100 MHz clock: 10 ns period
    reg clk = 0;
    always #5 clk = ~clk;

    // Drive a recognizable switch pattern
    reg [15:0] sw = 16'hA5A5;
    wire [15:0] led;

    // Use a small ON_TIME so the LED toggles within a handful of cycles
    localparam int TB_ON_TIME = 5;

    sw_pwm #(.ON_TIME(TB_ON_TIME)) dut (
        .clk(clk),
        .sw(sw),
        .led(led)
    );

    // Track cycles for readable prints
    integer cycle = 0;
    always @(posedge clk) cycle <= cycle + 1;

    // Assertions: LED should mirror switches while sec_counter < ON_TIME,
    // then drop to 0 once sec_counter >= ON_TIME (no wrap tested here).
    always @(posedge clk) begin
        // On window
        if (dut.sec_counter < TB_ON_TIME)
            assert(led == sw) else $fatal("LED not following switches during on window at cycle %0d", cycle);
        else
            assert(led == 16'h0000) else $fatal("LED not off after on window at cycle %0d", cycle);
    end

    initial begin
        $display("Starting sw_pwm smoke test with ON_TIME=%0d", TB_ON_TIME);
        repeat (20) @(posedge clk);
        $display("Completed sw_pwm smoke test after %0d cycles", cycle);
        $finish;
    end
endmodule
