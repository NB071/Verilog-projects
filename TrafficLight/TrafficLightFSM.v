`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/23/2024
// Design Name: Traffic Light FSM in Verilog
// Module Name: TrafficLightFSM
// Description: 
//     This module implements a Traffic Light FSM. It generates sequential light transitions 
//     (RED, YELLOW, GREEN) based on a configurable timer provided as a single 18-bit input. 
//     Each state duration is extracted from this input and used to control state transitions. 
//     The FSM transitions states based on the timer and reset conditions.
// 
// Usage:
//     - Use this module to manage traffic light sequencing.
//     - Provide a single 18-bit input where each 6 bits defines the duration of RED, YELLOW, and GREEN states.
// 
// Dependencies: None
// 
// Additional Comments:
//     - Ensure the 18-bit timer input is properly configured for desired durations.
//     - Designed for easy integration into larger traffic management systems.
//////////////////////////////////////////////////////////////////////////////////

module TrafficLightFSM (
    input clk,                              // Clock signal
    input reset,                            // Reset signal
    input [17:0] timer_config,              // 18-bit Timer input: RRRRRR | YYYYYY | GGGGGG
    output reg [2:0] light                  // 3-bit output for traffic light (RED, YELLOW, GREEN)
);

    // State encoding
    parameter RED = 3'b100;
    parameter GREEN = 3'b001;
    parameter YELLOW = 3'b010;

    // Registers (+ timer)
    reg [2:0] current_state, next_state;
    reg [5:0] timer;                         // Timer to count clock cycles for each state

    // Extract state durations from timer_config
    wire [5:0] RED_TIME, YELLOW_TIME, GREEN_TIME;
    assign {RED_TIME, YELLOW_TIME, GREEN_TIME} = timer_config;

    // State transition block + timer
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RED;
            timer <= 0;
        end else if (timer == 0) begin
            current_state <= next_state;
            case (next_state)
                RED: timer <= RED_TIME;
                GREEN: timer <= GREEN_TIME;
                YELLOW: timer <= YELLOW_TIME;
            endcase
        end else begin
            timer <= timer - 1;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            RED: begin
                next_state = GREEN; // Transition from RED => GREEN
            end
            GREEN: begin
                next_state = YELLOW; // Transition from GREEN => YELLOW
            end
            YELLOW: begin
                next_state = RED; // Transition from YELLOW => RED
            end
            default: begin
                next_state = RED; // Default state => RED
            end
        endcase
    end

     // Output logic
    always @(*) begin
        case (current_state)
            RED: light = RED;
            GREEN: light = GREEN;
            YELLOW: light = YELLOW;
            default: light = RED;
        endcase
    end

endmodule