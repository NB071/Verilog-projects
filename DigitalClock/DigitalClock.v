`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/23/2024
// Design Name: Digital Clock in Verilog
// Module Name: DigitalClock
// Description: 
//     This module implements a digital clock that counts hours, minutes, 
//     and seconds. The module uses a dynamically configurable clock 
//     frequency (input as `clock_frequency`) to divide the clock signal 
//     and generate a one-second pulse. The counters for seconds, minutes, 
//     and hours are updated accordingly and displayed in a BCD format 
//     across multiple outputs.
//
//     This project was inspired by the course EECS 2021, where I learned 
//     the basics of Verilog and digital design. This passion project builds 
//     upon those foundations to create a functional and flexible digital clock.
//
// Additional Comments:
//     - Ensure `clock_frequency` is provided accurately for the correct 
//       generation of the one-second pulse.
//     - The module assumes a constant `clock_frequency` during operation.
//     - The module has been tested with `DigitalClock_testbench.v`.
//
//     Lessons Learned: Please refer to `Lessons-Learned.pdf` to explore 
//     the concepts applied in this design, such as clock division, 
//     modular design, and counter-based timekeeping.
//////////////////////////////////////////////////////////////////////////////////

module DigitalClock(
    input clk,                                          // Input clock
    input reset,                                        // Reset signal
    input [31:0] clock_frequency,                       // Clock frequency in Hz
    output reg [3:0] sec_ones,                          // Sec (1s place)
    output reg [3:0] sec_tens,                          // Sec (10s place)
    output reg [3:0] min_ones,                          // Min (1s place)
    output reg [3:0] min_tens,                          // Min (10s place)
    output reg [3:0] hour_ones,                         // Hrs (1s place)
    output reg [3:0] hour_tens                          // Hrs (10s place)
);

    // Parameters defining the ranges for counters
    parameter MAX_SECONDS = 59;                         // Maximum value for seconds counter
    parameter MAX_MINUTES = 59;                         // Maximum value for minutes counter
    parameter MAX_HOURS = 23;                           // Maximum value for hours counter

    // Internal registers for clock counting and timekeeping
    reg [31:0] clk_count = 0;                           // Tracks clock cycles to generate 1-second pulse
    reg [31:0] one_sec_count = 0;                       // Number of clock cycles for 1 second

    // Counters for seconds, minutes, and hours
    reg [5:0] seconds = 0;                              // Range: 0-59
    reg [5:0] minutes = 0;                              // Range: 0-59
    reg [4:0] hours = 0;                                // Range: 0-23

    // One-second pulse signal
    wire one_sec_pulse;

    // Instantiate ClockDivider to generate one-second pulse
    ClockDivider clk_divider (
        .clk(clk),
        .reset(reset),
        .divide_by(clock_frequency - 1),
        .pulse_out(one_sec_pulse)                       
    );

    // Initialization of `one_sec_count`:
    // This calculates the number of clock cycles required to generate a one-second pulse.
    // It assumes a constant `clock_frequency`.
    always @(posedge reset or posedge clk) begin
        if (reset) begin
            one_sec_count <= clock_frequency - 1;
        end
    end

    // Timekeeping counters:
    // Updates `seconds`, `minutes`, and `hours` based on the `one_sec_pulse`.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        end else if (one_sec_pulse) begin
            if (seconds == MAX_SECONDS) begin
                seconds <= 0;
                if (minutes == MAX_MINUTES) begin
                    minutes <= 0;
                    if (hours == MAX_HOURS) begin
                        hours <= 0;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    // BCD Output Decoding
    always @(*) begin
        sec_ones = seconds % 10;                        // 1s place of seconds
        sec_tens = seconds / 10;                        // 10s place of seconds

        min_ones = minutes % 10;                        // 1s place of minutes
        min_tens = minutes / 10;                        // 10s place of minutes

        hour_ones = hours % 10;                         // 1s place of hours
        hour_tens = hours / 10;                         // 10s place of hours
    end
endmodule