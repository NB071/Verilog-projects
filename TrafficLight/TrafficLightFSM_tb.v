`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/25/2024
// Design Name: Traffic Light FSM Testbench in Verilog
// Module Name: TrafficLightFSM_tb
// Description: 
//     This testbench verifies the functionality of the Traffic Light FSM module. 
//     It provides clock and reset signals, and stimulates the TrafficLightFSM with 
//     various configurations of timer inputs, including both valid and invalid scenarios.
// 
// Usage:
//     - Use this testbench to validate the TrafficLightFSM module behavior.
//     - Includes scenarios for reset, enable, invalid timer input, and light transitions.
//     - Outputs the current state of light and error status to verify correctness.
// 
// Dependencies:
//     - TrafficLightFSM module
// 
//////////////////////////////////////////////////////////////////////////////////

module TrafficLightFSM_tb();

    // Inputs
    reg clk;
    reg reset;
    reg [17:0] timer_config;
    reg enable;

    // Outputs
    wire [2:0] light;
    wire error_status;

    // String for light state
    reg [8*6:1] light_state;

    // Instantiate the TrafficLightFSM module
    TrafficLightFSM uut (
        .clk(clk),
        .reset(reset),
        .timer_config(timer_config),
        .enable(enable),
        .light(light),
        .error_status(error_status)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10 ns clock period

     // Assign light state string based on light value
    always @(light) begin
        case (light)
            3'b100: light_state = "RED   ";
            3'b010: light_state = "YELLOW";
            3'b001: light_state = "GREEN ";
            default: light_state = "ERROR ";
        endcase
    end

    // Test stimulus
    initial begin
        $dumpfile("TrafficLightFSM_tb.vcd");
        $dumpvars(0, TrafficLightFSM_tb);

        $display("\033[1;34mStarting testbench...\033[0m");

        // Initialize inputs
        reset = 0;
        enable = 0;
        timer_config = 18'b000001_000001_000001; // Default timer configuration

        // Apply reset
        $display("\033[1;33mApplying reset...\033[0m");
        reset = 1;
        #20;
        reset = 0;

        // Enable the FSM and test normal operation
        $display("\033[1;32mTesting normal operation...\033[0m");
        enable = 1;
        timer_config = 18'b000010_000011_000100; // RED = 2, YELLOW = 3, GREEN = 4
        #100;

        // Test error detection
        $display("\033[1;31mTesting error detection with invalid timer...\033[0m");
        timer_config = 18'b000000_000011_000100; // RED = 0, YELLOW = 3, GREEN = 4 (invalid)
        #20;

        // Test recovery from error
        $display("\033[1;36mTesting recovery from error...\033[0m");
        timer_config = 18'b000010_000011_000100; // Valid configuration
        #50;

        // Test pause/resume functionality
        $display("\033[1;35mTesting pause functionality...\033[0m");
        enable = 0; // Pause FSM
        #50;
        enable = 1; // Resume FSM
        #50;

        // Test edge case with minimum valid timer configuration
        $display("\033[1;33mTesting edge case with minimum valid timer...\033[0m");
        timer_config = 18'b000001_000001_000001; // All states = 1
        #50;

        // Test maximum timer configuration
        $display("\033[1;32mTesting maximum timer configuration...\033[0m");
        timer_config = 18'b111111_111111_111111; // All states = 63
        #100;

        $display("\033[1;34mTestbench completed.\033[0m");
        $stop;
    end

    // Monitor outputs
    initial begin
        $monitor("\033[1;37mTime = %0dns | clk = %b | reset = %b | enable = %b | timer_config = %b | light = %s | error_status = %b\033[0m",
                 $time, clk, reset, enable, timer_config, light_state, error_status);
    end

endmodule
