module TrafficLightFSM (
    input clk,                              // Clock signal
    input reset,                            // Reset signal
    output reg [2:0] light                  // 3-bit output for traffic light (RED, YELLOW, GREEN)
);

    // State encoding
    parameter RED = 3'b100;
    parameter GREEN = 3'b001;
    parameter YELLOW = 3'b010;

    // State duration parameters (in CC)
    parameter RED_TIME = 10;
    parameter GREEN_TIME = 10;
    parameter YELLOW_TIME = 5;

    // Registers (+ timer)
    reg [2:0] current_state, next_state;
    reg [3:0] timer;                         // Timer to count clock cycles for each state

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