module TrafficLightFSM (
    input clk,                              // Clock signal
    input reset,                            // Reset signal
    output reg [2:0] light                  // 3-bit output for traffic light (RED, YELLOW, GREEN)
);

    // State encoding
    parameter RED = 3'b100;
    parameter GREEN = 3'b001;
    parameter YELLOW = 3'b010;

    // Registers
    reg [2:0] current_state, next_state;

    // State transition block
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= RED;
        else
            current_state <= next_state;
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