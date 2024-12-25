module TrafficLightFSM_tb;

    // Testbench signals
    reg clk;
    reg reset;
    wire [2:0] light;

    // Instantiate the TrafficLightFSM module
    TrafficLightFSM uut (
        .clk(clk),
        .reset(reset),
        .light(light)
    );

    // Clock generator
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // Test sequence
    initial begin
        // simulation dump file 
        $dumpfile("TrafficLightFSM_tb.vcd");
        $dumpvars(0, TrafficLightFSM_tb);

        // Apply reset
        $display("Starting simulation...");
        reset = 1;
        #10;
        reset = 0;

        // Light transitions
        $display("Time(ns) | Reset | Light State");
        $monitor("%0dns | %b     | %b", $time, reset, light);

        // Run for a few clock cycles
        #1000;

        // Test with reset during operation
        $display("Applying reset during operation...");
        reset = 1;
        #10;
        reset = 0;

        // Run for a few clock cycles
        #1000;

        // End simulation
        $display("Ending simulation.");
        $finish;
    end

     // Debugging aid
    initial begin
        forever begin
            #5;
            if (light == 3'b100) $display("Time: %0dns - RED State", $time);
            else if (light == 3'b001) $display("Time: %0dns - GREEN State", $time);
            else if (light == 3'b010) $display("Time: %0dns - YELLOW State", $time);
        end
    end

endmodule