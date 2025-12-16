module display( input clk, input reset, input wire [11:0] sw,
                output wire [3:0] vgaRed, output wire [3:0] vgaBlue, output wire [3:0] vgaGreen,
                output wire Hsync, output wire Vsync );

    parameter HD = 640;
    parameter HF = 48;
    parameter HB = 16;
    parameter HR = 96;
    parameter HMAX = HD+HF+HB+HR-1;

    parameter VD = 480;
    parameter VF = 10;
    parameter VB = 33;
    parameter VR = 2;
    parameter VMAX = VD+VF+VB+VR-1;

    reg [1:0] subClk;
    wire pixel_tick;
    always @(posedge clk or posedge reset)
        if (reset)
            subClk <= 0;
        else
            subClk <= subClk + 1;

    assign pixel_tick = (subClk == 0);

    reg  h_sync_reg,  v_sync_reg;
    reg  h_sync_next, v_sync_next;

    reg [9:0] h_count_reg, h_count_next;
    reg [9:0] v_count_reg, v_count_next;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            v_count_reg <= 0;
            h_count_reg <= 0;
            h_sync_reg  <= 1'b0;
            v_sync_reg  <= 1'b0;
        end else begin
            v_count_reg <= v_count_next;
            h_count_reg <= h_count_next;
            h_sync_reg  <= h_sync_next;
            v_sync_reg  <= v_sync_next;
        end
    end

    always @* begin
        h_count_next = h_count_reg;
        v_count_next = v_count_reg;
        h_sync_next  = h_sync_reg;
        v_sync_next  = v_sync_reg;

        if (pixel_tick) begin
            if (h_count_reg == HMAX) begin
                h_count_next = 0;
                if (v_count_reg == VMAX)
                    v_count_next = 0;
                else
                    v_count_next = v_count_reg + 1;
            end else begin
                h_count_next = h_count_reg + 1;
            end

            h_sync_next = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
            v_sync_next = (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));
        end
    end

    wire video_on = (h_count_reg < HD) && (v_count_reg < VD);

    reg [11:0] rgb_reg;
    always @(posedge clk or posedge reset)
        if (reset)
            rgb_reg <= 0;
        else
            rgb_reg <= sw;

    assign Hsync = h_sync_reg;
    assign Vsync = v_sync_reg;
    assign vgaRed   = video_on ? rgb_reg[11:8] : 4'b0000;
    assign vgaBlue  = video_on ? rgb_reg[3:0]  : 4'b0000;
    assign vgaGreen = video_on ? rgb_reg[7:4]  : 4'b0000;
endmodule 
