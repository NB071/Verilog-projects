`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/23/2024
// Design Name: Clock Divider in Verilog
// Module Name: ClockDivider
// Description: 
//     This module implements a configurable clock divider. It generates a pulse 
//     output (`pulse_out`) at a frequency determined by the input parameter 
//     `divide_by`. The counter increments on every clock cycle and resets once 
//     it reaches the value of `divide_by`, producing a high pulse at that moment.
//
//     This module is designed to be reusable across various designs where a 
//     lower-frequency pulse or timing signal is needed.
//
// Usage:
//     - Connect the `clk` signal to the input clock of the desired frequency.
//     - Set the `divide_by` input to the number of clock cycles required for one 
//       pulse (e.g., for a 1 Hz output pulse, `divide_by` = input clock frequency - 1).
//     - Use the `pulse_out` signal as the divided output pulse.
//
// Dependencies: None
//
// Additional Comments:
//     - Ensure `divide_by` is set correctly based on the input clock frequency.
//     - The module is edge-sensitive to the `clk` signal and works with active-high 
//       reset (`reset`).
//
//     Lessons Learned: Please refer to `Lessons-Learned.pdf` to explore 
//     the concepts applied in this design.
//////////////////////////////////////////////////////////////////////////////////

module ClockDivider(
    input clk,                                          // Input clock signal
    input reset,                                        // Active-high reset signal
    input [31:0] divide_by,                             // Number of cycles for pulse generation
    output reg pulse_out                                // Pulse signal generated after `divide_by` cycles
);

    // Internal counter
    reg [31:0] count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;                                 // Reset the counter
            pulse_out <= 0;                             // Clear pulse output
        end else if (count == divide_by) begin
            count <= 0;                                 // Reset counter after reaching `divide_by`
            pulse_out <= 1;                             // Generate a pulse
        end else begin
            count <= count + 1;                         // Increment the counter
            pulse_out <= 0;                             // Keep pulse low
        end
    end
endmodule