`timescale 1ns/1ps

module display( input clk, input rst,
                output wire [11:0] outCol, output wire Hsync, output wire Vsync );

    // vga boundaries
    parameter HD = 640, HF = 16, HR = 96, HB = 48, HMAX = HD+HF+HB+HR-1;
    parameter VD = 480, VF = 10, VR = 2,  VB = 29, VMAX = VD+VF+VB+VR-1;

    // outputs
    assign outCol = cursor_valid ? rgb_reg : 12'h000;
    assign Hsync = h_sync_reg;
    assign Vsync = v_sync_reg;

    reg [11:0] rgb_reg;
    reg [0:0] h_sync_reg, h_sync_nxt;
    reg [0:0] v_sync_reg, v_sync_nxt;
    reg [9:0] h_count_reg, h_count_nxt;
    reg [9:0] v_count_reg, v_count_nxt;
    reg [1:0] q_reg;

    wire pixel_tick = (q_reg == 0); 
    wire cursor_valid = (h_count_reg < HD) && (v_count_reg < VD);

    wire [3:0] red_base   = (h_count_reg < HD) ? (h_count_reg / 40) : 4'h0;
    wire [3:0] green_base = (v_count_reg < VD) ? (v_count_reg / 30) : 4'h0;
    wire [3:0] blue_base  = 4'hF;

    wire [2:0] bayer = h_count_reg[1:0] + v_count_reg[1:0];
    wire [3:0] red   = red_base   + (red_base   != 4'hF && bayer > 2);
    wire [3:0] green = green_base + (green_base != 4'hF && bayer > 2);
    wire [3:0] blue  = blue_base;

    // 25 Mhz clock
    always @(posedge clk or posedge rst)
        q_reg <= rst ? 2'b00 : q_reg + 1;

    // set color at 100 Mhz
    always @(posedge clk or posedge rst)
        rgb_reg <= rst ? 12'h000 : {red, green, blue};

    always @(posedge clk or posedge rst) begin
        h_count_reg <= rst ? 0 : h_count_nxt;
        v_count_reg <= rst ? 0 : v_count_nxt;

        h_sync_reg <= rst ? 1'b0 : h_sync_nxt;
        v_sync_reg <= rst ? 1'b0 : v_sync_nxt;
    end

    always @* begin
        h_sync_nxt  = h_sync_reg;
        v_sync_nxt  = v_sync_reg;

        h_count_nxt = h_count_reg;
        v_count_nxt = v_count_reg;

        if (pixel_tick) begin
            if (h_count_reg == HMAX) begin
                h_count_nxt = 0;
                if (v_count_reg == VMAX)
                    v_count_nxt = 0;
                else
                    v_count_nxt = v_count_reg + 1;
            end else begin
                h_count_nxt = h_count_reg + 1;
            end

            h_sync_nxt = (h_count_reg >= (HD+HF) && h_count_reg <= (HD+HF+HR-1)); // in the hsync pulse phase
            v_sync_nxt = (v_count_reg >= (VD+VF) && v_count_reg <= (VD+VF+VR-1)); // in the vsync pulse phase
        end
    end

endmodule
