`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/25/2024
// Design Name: Traffic Light FSM in Verilog
// Module Name: TrafficLightFSM
// Description: 
//     This module implements a Traffic Light FSM. It generates sequential light transitions 
//     (RED, YELLOW, GREEN) based on a configurable timer provided as a single 18-bit input. 
//     Each state duration is extracted from this input and used to control state transitions. 
// 
// Usage:
//     - Use this module to manage traffic light sequencing.
//     - Provide a single 18-bit input where each 6 bits defines the duration of RED, YELLOW, and GREEN states.
//     - Ensure the 18-bit timer input is properly configured for desired durations.
// 
// Dependencies: None
// 
//////////////////////////////////////////////////////////////////////////////////

module TrafficLightFSM (
    input clk,                              // Clock signal
    input reset,                            // Reset signal
    input [17:0] timer_config,              // 18-bit Timer input: RRRRRR | YYYYYY | GGGGGG
    input enable,                           // Enable signal to pause/resume FSM
    output reg [2:0] light,                 // 3-bit output for traffic light (RED, YELLOW, GREEN)
    output reg error_status                 // Error flag for invalid timer configuration
);

    // State encoding
    parameter RED = 3'b100;
    parameter GREEN = 3'b001;
    parameter YELLOW = 3'b010;
    parameter ERROR = 3'b111;

    // Registers and wires
    reg [2:0] current_state, next_state;
    reg [5:0] timer;
    wire [5:0] RED_TIME, YELLOW_TIME, GREEN_TIME;

    // Extract durations from timer_config
    assign {RED_TIME, YELLOW_TIME, GREEN_TIME} = timer_config;

    // Error detection
    wire timer_invalid = (RED_TIME == 0 || YELLOW_TIME == 0 || GREEN_TIME == 0);

    // Power-On Default Configuration
    initial begin
        current_state = RED;
        timer = 0;
        error_status = 0;
    end

    
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RED;
            timer <= RED_TIME;
            error_status <= 0;
        end else if (!enable) begin
            current_state <= current_state;
        end else if (timer_invalid) begin
            current_state <= ERROR;
            error_status <= 1;
        end else if (current_state == ERROR && !timer_invalid) begin
            current_state <= RED;
            timer <= RED_TIME;
            error_status <= 0;
        end else if (timer == 0) begin
            current_state <= next_state;
            case (next_state)
                RED: timer <= RED_TIME;
                GREEN: timer <= GREEN_TIME;
                YELLOW: timer <= YELLOW_TIME;
                default: current_state <= ERROR;
            endcase
        end else begin
            timer <= timer - 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            RED: next_state = GREEN;
            GREEN: next_state = YELLOW;
            YELLOW: next_state = RED;
            default: next_state = ERROR;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            RED: light = RED;
            GREEN: light = GREEN;
            YELLOW: light = YELLOW;
            default: light = ERROR;
        endcase
    end

endmodule