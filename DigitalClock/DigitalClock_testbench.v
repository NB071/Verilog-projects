`timescale 1ns / 1ps

module clock_testbench;
    reg clk = 0;                            // Clock signal
    reg reset = 0;                          // Reset signal
    wire [3:0] sec_ones, sec_tens;          // Seconds (1s and 10s place)
    wire [3:0] min_ones, min_tens;          // Minutes (1s and 10s place)
    wire [3:0] hour_ones, hour_tens;        // Hours (1s and 10s place)

    // Instantiate the DigitalClock module
    DigitalClock uut (
        .clk(clk),
        .reset(reset),
        .sec_ones(sec_ones),
        .sec_tens(sec_tens),
        .min_ones(min_ones),
        .min_tens(min_tens),
        .hour_ones(hour_ones),
        .hour_tens(hour_tens)
    );

    // Generate a 5 MHz clock signal (200 ns period)
    always #100 clk = ~clk;             // Toggle every 100 ns for 5 MHz clock

    initial begin
        // Test start
        $display("Simulation started at time: %0t ns", $time);

        // Apply reset
        reset = 1;
        $display("Applying reset at time: %0t ns", $time);
        #500; 
        reset = 0;
        $display("Releasing reset at time: %0t ns", $time);

        // Monitor outputs every second based on one_sec_pulse
        $display("Monitoring clock every simulated second...");
        forever begin
            @(posedge uut.one_sec_pulse); // Wait for one_sec_pulse signal
            $display("Time: %0t ns | Clock: %0d%0d:%0d%0d:%0d%0d",
                $time,
                uut.hour_tens, uut.hour_ones,
                uut.min_tens, uut.min_ones,
                uut.sec_tens, uut.sec_ones
            );
        end
    end
endmodule