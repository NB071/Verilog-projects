`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Author: Nima Bargestan
// 
// Create Date: 12/24/2024
// Design Name: Traffic Light FSM in Verilog
// Module Name: TrafficLightFSM
// Description: 
//     This module implements a Traffic Light FSM. It generates sequential light transitions 
//     (RED, YELLOW, GREEN) based on a configurable timer provided as a single 18-bit input. 
//     Each state duration is extracted from this input and used to control state transitions. 
//     The FSM transitions states based on the timer and reset conditions, with support for 
//     a pedestrian request signal to extend the RED state duration or handle GREEN completion.
// 
// Usage:
//     - Use this module to manage traffic light sequencing.
//     - Provide a single 18-bit input where each 6 bits defines the duration of RED, YELLOW, and GREEN states.
//     - Use the pedestrian request signal to extend the RED light duration when required.
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
    input ped_request                       // Pedestrian crossing request
    input [5:0] ped_extension,              // 6-bit configurable pedestrian extension
    output reg [2:0] light                  // 3-bit output for traffic light (RED, YELLOW, GREEN)
);

    // State encoding
    parameter RED = 3'b100;
    parameter GREEN = 3'b001;
    parameter YELLOW = 3'b010;
    parameter ERROR = 3'b111;

    // Registers 
    reg [2:0] current_state, next_state;
    reg [5:0] timer;
    reg ped_request_pending;

    // Extract state durations from timer_config
    wire [5:0] RED_TIME, YELLOW_TIME, GREEN_TIME;
    assign {RED_TIME, YELLOW_TIME, GREEN_TIME} = timer_config;

    // State transition block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= RED;
            timer <= 0;
            ped_request_pending <= 0;
        end else if (timer == 0) begin
             if (current_state == GREEN && ped_request) begin
                ped_request_pending <= 1;   // Set pedestrian request as pending
            end
            if (current_state == RED && ped_request_pending) begin
                timer <= RED_TIME + ped_extension;  // RED time extension
                ped_request_pending <= 0;   // Unset pedestrian request as pending
            end else begin
                current_state <= next_state;
                case (next_state)
                    RED: timer <= RED_TIME;
                    GREEN: timer <= GREEN_TIME;
                    YELLOW: timer <= YELLOW_TIME;
                    default: current_state <= ERROR; 
                endcase
            end
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
            default: next_state = ERROR; 
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