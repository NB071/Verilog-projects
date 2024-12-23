`timescale 1ns / 1ps

module DigitalClock(
    input clk,                                          // Input clock
    input reset,                                        // Reset signal
    output reg [3:0] sec_ones,                          // Sec (1s place)
    output reg [3:0] sec_tens,                          // Sec (10s place)
    output reg [3:0] min_ones,                          // Min (1s place)
    output reg [3:0] min_tens,                          // Min (10s place)
    output reg [3:0] hour_ones,                         // Hrs (1s place)
    output reg [3:0] hour_tens                          // Hrs (10s place)
);

    parameter CLOCK_FREQ = 1_200_000;                   // 1.2MHz clock
    parameter ONE_SEC_COUNT = CLOCK_FREQ - 1;           // Total cycles needed for 1 second (50,000,000 - 1)

    // Registers
    reg [31:0] clk_count = 0;
    reg one_sec_pulse = 0;

    // Counters for seconds, minutes, and hours
    reg [5:0] seconds = 0;  // Range: 0-59
    reg [5:0] minutes = 0;  // Range: 0-59
    reg [4:0] hours = 0;    // Range: 0-23

    // Clock divider for 1 Hz
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_count <= 0;
            one_sec_pulse <= 0;
        end else if (clk_count == ONE_SEC_COUNT) begin
            clk_count <= 0;
            one_sec_pulse <= 1;
        end else begin
            clk_count <= clk_count + 1;
            one_sec_pulse <= 0;
        end
    end

    // Seconds counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seconds <= 0;
        end else if (one_sec_pulse) begin
            if (seconds == 59) begin
                seconds <= 0;
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // Minutes counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin   
            minutes <= 0;
        end else if (one_sec_pulse && seconds == 59) begin
            if (minutes == 59) begin
                minutes <= 0;
            end else begin
                minutes <= minutes + 1;
            end
        end
    end

    // Hours counter
    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            hours <= 0;
        end else if (one_sec_pulse && seconds == 59 && minutes == 59) begin
            if (hours == 23) begin
                hours <= 0;
            end else begin
                hours <= hours + 1;
            end
        end
    end

     // Output decoding for display
    always @(*) begin
        sec_ones = seconds % 10;
        sec_tens = seconds / 10;

        min_ones = minutes % 10;
        min_tens = minutes / 10;

        hour_ones = hours % 10;
        hour_tens = hours / 10;
    end

endmodule