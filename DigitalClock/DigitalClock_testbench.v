`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/23/2024
// Design Name: Digital Clock Testbench
// Module Name: clock_testbench
// Description: 
//     This is the testbench for the `DigitalClock` module. It verifies the 
//     functionality of the digital clock by providing a simulated clock signal 
//     and observing the behavior of the clock outputs (hours, minutes, and seconds).
//
// Testbench Features:
//     - Generates a 1.2 MHz clock signal with a 416 ns period.
//     - Simulates an active-high reset condition to initialize the clock.
//     - Monitors the clock output (`hour_tens`, `hour_ones`, `min_tens`, 
//       `min_ones`, `sec_tens`, `sec_ones`) every second based on the 
//       `one_sec_pulse` signal.
//
// Dependencies:
//     - DigitalClock.v: The digital clock module under test (UUT).
//
//////////////////////////////////////////////////////////////////////////////////

module clock_testbench;
    reg clk = 0;                            // Clock signal
    reg reset = 0;                          // Reset signal
    wire [3:0] sec_ones, sec_tens;          // Seconds (1s and 10s place)
    wire [3:0] min_ones, min_tens;          // Minutes (1s and 10s place)
    wire [3:0] hour_ones, hour_tens;        // Hours (1s and 10s place)
    reg [31:0] clock_frequency = 1_200_000; // Dynamic clock frequency (e.g., 1.2 MHz)

    // Instantiate the DigitalClock module
    DigitalClock uut (
        .clk(clk),
        .reset(reset),
        .clock_frequency(clock_frequency), 
        .sec_ones(sec_ones),
        .sec_tens(sec_tens),
        .min_ones(min_ones),
        .min_tens(min_tens),
        .hour_ones(hour_ones),
        .hour_tens(hour_tens)
    );

    // Generate clock signal
    always #416 clk = ~clk;                 // Toggle every 416 ns for 1.2 MHz clock

    initial begin
        // Test start
        $display("Simulation started at time: %0t ns", $time);

        // Apply reset
        reset = 1;
        $display("Applying reset at time: %0t ns", $time);
        #200; 
        reset = 0;
        $display("Releasing reset at time: %0t ns", $time);

        // Monitor outputs every second based on one_sec_pulse
        $display("Monitoring clock every simulated second...");
        forever begin
            @(posedge uut.one_sec_pulse); // Wait for one_sec_pulse signal
            $display("Time: %0t ns | Clock: %0d%0d:%0d%0d:%0d%0d",
                $time,
                uut.hour_tens, uut.hour_ones, // Hours in 10s and 1s place
                uut.min_tens, uut.min_ones,  // Minutes in 10s and 1s place
                uut.sec_tens, uut.sec_ones   // Seconds in 10s and 1s place
            );
        end
    end
endmodule